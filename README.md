# Learning ASM trougth remote shells

## Refernces

-   NASM vs AS https://developer.ibm.com/articles/l-gas-nasm/
-

## Arhitecture calling convetnion

Calling conventions are a set of rules that dictate how function arguments are passed and how the return value is returned when a function is called in a program. On the AArch64 architecture, the following calling conventions are commonly used:

-   The "System V" calling convention, also known as the "Procedure Call Standard for the ARM 64-bit Architecture" (AArch64 PCS), is the default calling convention for AArch64 Linux systems and many other operating systems. It is also the calling convention used by the GNU Compiler Collection (GCC) and other compilers.

In the System V AArch64 calling convention, the first eight integer or floating-point arguments are passed in registers x0 through x7, and additional arguments are passed on the stack. The return value is typically passed in x0.

-   The "Microsoft" calling convention is used by Windows on AArch64 and by Visual C++ on AArch64. It is similar to the System V calling convention, with some differences in the way arguments are passed and the return value is returned.

In the Microsoft AArch64 calling convention, the first four integer or floating-point arguments are passed in registers x0 through x3, and additional arguments are passed on the stack. The return value is passed in x0 for integer types, and d0 for floating-point types.

It's important to note that these are just a few examples of calling conventions that are commonly used on AArch64. Other calling conventions may be used depending on the specific platform and ABI (Application Binary Interface) you are working with. You should consult the documentation for the specific platform and ABI you are working with for more information.

## return values

In assembly language, the way you get the return value of a function depends on the calling convention being used.

In many calling conventions, the return value is stored in a register, typically either eax or rax on x86 and x86-64 architectures, respectively. For example, in the case of the socket syscall you mentioned, the return value (a socket descriptor) is typically stored in eax or rax upon return.

You can use the mov instruction to move the return value from the register into a memory location if you need to store it for later use.

Here's an example of how you might call the socket syscall and store the return value in a variable using NASM syntax:

```
mov eax, SYS_SOCKET
mov ebx, domain
mov ecx, type
mov edx, protocol
int 0x80
mov [socket_descriptor], eax
```

In this example, SYS_SOCKET is a constant that holds the number of the socket syscall (e.g., 41 on x86), and domain, type, and protocol are the values passed as arguments to the syscall. The return value is stored in eax after the syscall is invoked with the int instruction, and then moved into the socket_descriptor variable using the mov instruction.

It's important to note that different architectures and operating systems may use different calling conventions, and the specific details of how return values are passed can vary. You should consult the documentation for the specific platform and ABI (Application Binary Interface) you are working with for more information.
