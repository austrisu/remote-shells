# Code

Syscalls

x7 = syscall nr
arg0 = x0
arg1 = x1
arg2 = x2

### int socket(int domain, int type, int protocol)

x8 = 0x6c / 198 (syscall nr)
x0 = int domain AF_INET = 2 (IPv4 Internet protocols, protocol family)
x1 = int type SOCK_STREAM = 1 (Provides sequenced, reliable, two-way, connection-based byte streams.)
x2 = int protocol 0 (deafault value)

return value x0

### int connect(int sockfd, const struct sockaddr \*addr,socklen_t addrlen)

x8 = 0xcb / 203 (syscall nr)
x0 = int sockfd (int socket(int domain, int type, int protocol))
x1 = struct sockaddr \*
x2 = int addrlen

struct sockaddr\* = {
AF_INET
port
IP

}

## dup2()

## execve()

# aarch64 syntax

## Return value

In the "System V" calling convention, also known as the "Procedure Call Standard for the ARM 64-bit Architecture" (AArch64 PCS), the return value is typically passed in the x0 register.

For example, if a function has a return type of int, the return value will be passed in x0. If the function has a return type of float, the return value will be passed in the s0 register (which corresponds to the lower 32 bits of x0). If the function has a return type of double, the return value will be passed in the d0 register (which corresponds to the lower 64 bits of x0).

Here's an example of how you might call a function that returns an int value in AArch64 assembly using the System V calling convention:

```
mov x0, arg1
mov x1, arg2
bl function_name
mov w0, [return_value]
```

In this example, arg1 and arg2 are the values passed as arguments to the function, and function_name is the name of the function being called. The bl instruction is used to call the function, and the return value is passed in x0 upon return. The mov w0, [return_value] instruction moves the lower 32 bits of x0 (i.e., the w0 register) into the return_value variable.

It's important to note that the specifics of how return values are passed can vary depending on the specific platform and ABI (Application Binary Interface) you are working with. You should consult the documentation for the specific platform and ABI you are working with for more information.

## what does # mean in that code?

In ARM64 assembly language, the # symbol is used to indicate an immediate value. In other words, it tells the assembler to treat the value following the # symbol as a literal value rather than a memory address.

For example, in the instruction mov x0, #1, the value 1 is an immediate value that is stored in the X0 register. Similarly, in the instruction mov w8, #64, the value 64 is an immediate value that is stored in the W8 register.

Immediate values are often used to specify constants or other fixed values that do not change during the execution of a program. They can also be used to specify parameters or arguments for certain instructions or functions.

In ARM64 assembly language, immediate values can be expressed in decimal or hexadecimal notation. Decimal notation uses the standard base-10 digits (0, 1, 2, 3, 4, 5, 6, 7, 8, and 9), while hexadecimal notation uses base-16 digits (0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, and F).

In the code you provided, all of the immediate values are expressed in decimal notation. For example, the value 1 in the instruction mov x0, #1 is a decimal value, and the value 64 in the instruction mov w8, #64 is also a decimal value.

To specify a hexadecimal value in ARM64 assembly language, you can use the 0x prefix followed by the hexadecimal digits. For example, to specify the value 0xFF (255 in decimal) in an instruction, you would write mov x0, #0xFF.

## directives and data structures

Here is a list of some common AArch64 assembly language directives:

-   .align: Aligns the location counter to a specified boundary.
-   .ascii: Specifies a string of ASCII characters.
-   .asciz: Specifies a string of ASCII characters, including a terminating null character.
-   .balign: Aligns the location counter to a specified boundary, filling any gap with a specified fill value.
-   .byte: Specifies one or more bytes of data.
-   .comm: Declares a common symbol (a symbol that may be defined multiple times).
-   .data: Specifies that the following instructions should be assembled into the data section of the program.
-   .double: Specifies one or more double-precision floating point values.
-   .end: Indicates the end of the assembly language source file.
-   .float: Specifies one or more single-precision floating point values.
-   .globl: Declares a global symbol (a symbol that is visible to other object files).
-   .half: Specifies one or more half-precision floating point values.
-   .int: Specifies one or more integers.
-   .long: Specifies one or more long integers.
-   .org: Sets the location counter to a specified address.
-   .set: Sets the value of a symbol.
-   .short: Specifies one or more short integers.
-   .string: Specifies a string of ASCII characters, including a terminating null character.
-   .text: Specifies that the following instructions should be assembled into the text section of the program.
-   .type: Associates a type with a symbol.

# Compilation

THis is a bit tricky. To compile ARM assembly code on a machine with an x64 architecture, you will need to use an ARM cross-compiler. A cross-compiler is a compiler that runs on one platform (in this case, x64) but generates code for another platform (in this case, ARM).

One option for obtaining an ARM cross-compiler is to install a toolchain such as Linaro or GNU Arm Embedded Toolchain. These toolchains include a set of tools, including a compiler, assembler, linker, and other utilities, that are necessary for building software for ARM platforms.

Once you have installed a toolchain, you can compile ARM assembly code using the as assembler. For example, to compile the example reverse shell code above, you could use the following command:

```
aarch64-linux-gnu-as reverse_shell.s -o reverse_shell.o
```

This will create an object file reverse_shell.o containing the compiled ARM assembly code. You can then link this object file with other object files or libraries to create an executable file.

For example, to create an executable file called reverse_shell from the object file, you could use the following command:

```
aarch64-linux-gnu-ld reverse_shell.o -o reverse_shell
```

This will create an executable file called reverse_shell that you can run on an ARM platform.

# runing ARM binary with QEMU

## Installing QEMU

To install QEMU on Ubuntu, you can use the following steps:

Update the package manager's list of available packages by running the following command:

```
sudo apt update
```

Install QEMU and its dependencies by running the following command:

```
sudo apt install qemu qemu-kvm qemu-system
```

This will install the QEMU emulator and the required packages for running QEMU on Ubuntu.

To install QEMU for aarch64 (ARM 64-bit) support, you can also install the qemu-system-aarch64 package:

```
sudo apt install qemu-system-aarch64
```

This will allow you to use QEMU to run aarch64 programs on an x64 machine.

After installing QEMU, you should be able to use the qemu-aarch64 command to start the emulator and run aarch64 programs.

## RUnning binaries

If binary is dinamicaly linked then

```
 qemu-aarch64 -L /usr/aarch64-linux-gnu rev_c.bin
```

where -L points to libraries and `/usr/aarch64-linux-gnu` should be installed after installation steps. THis owrks for user applicamtion emulation

```
qemu-aarch64-static rev.bin
```

This works for static binaries.

# References

-   https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
-   ARM croscompilation https://jensd.be/1126/linux/cross-compiling-for-arm-or-aarch64-on-debian-or-ubuntu
-   arm compilation: https://azeria-labs.com/arm-on-x86-qemu-user/
-   https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md
-   configureing rpi if want to test on it https://0x434b.dev/misc-study-notes-about-arm-aarch64-assembly-and-the-arm-trusted-execution-environment-tee/
-   aarch64 shellcode example: https://packetstormsecurity.com/files/153464/Linux-ARM64-Reverse-TCP-Shell-Null-Free-Shellcode.html
-
