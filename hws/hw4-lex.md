DADA: HW 4: Lex
===============

[Go up to the main DADA homeworks page](index.html) ([md](index.md))

### Introduction

This assignment will teach you to recognize assembly language code patterns unique to viruses using regular expressions.  The regular expressions will be defined using flex, a modern version of the well known utility lex. The assignment will serve as a basis for expansion in future assignments.

The reference platform for this project is the 64-bit Linux VirtualBox image.  Although most viruses are for the Windows platform, for reasons described in class, we are using the Linux platform to make this assignment easier to perform.  However, we will be examining Windows executable files.

### Virus Code Patterns

This assignment will focus on the recognition of just two assembly language code patterns that are not common in legitimate application code, but are common in the viruses we have studied in recent lectures.

The first suspicious code pattern is the [tricky jump](../docs/tricky-jump.html) ([md](../docs/tricky-jump.md)). A typical example would be: 

```
push offset _virusfunc 
ret 
```

Note that the 'offset' is produced by some variants of x86 assemblers. Although nasm (what we use in Linux) doesn't need it, the output that we are analyzing does use it.

We are not concerned with the particular function name. It would be unusual for a legitimate application to push an offset immediately before returning, and most compilers have no occasion to generate this sequence of instructions. The presence of this sequence probably indicates that a virus has been written in assembly language and has infected the executable.

The second suspicious code pattern is hooking of an interrupt. This is a virus pattern from the DOS era, but similar assembly sequences exist on all modern platforms.  As discussed in the lectures concerning the boot sequence, one of the functions of the code in the boot sector is to load the IVT (interrrupt vector table) into the memory that starts at address zero, where the DOS operating system expects to find it. The IVT is not normally changed after it is loaded; therefore, a user application that writes to these high addresses looks suspiciously like an interrupt-hooking virus. The address 4C in hexadecimal contains a pointer to DOS interrupt 21 (hex), which is often a target of viruses. So, a typical example of the conclusion of an interrupt 21h hook would be:

```
mov eax, 4Ch 
mov dword ptr [eax], edx 
```

In this example, register edx has already been initialized with the address of the virus-supplied interrupt handler, and it is being written into the IVT entry at address 4Ch. We are not concerned with the particular registers used; however, the register initialized with the value 4Ch must be the same register used in the ensuing instruction as the pointer to memory, else this code would not fit the pattern of an interrupt hook.

### Using flex on dumpbin output

1. The code we are looking at is a disassembly of a PE32 file.  The text disassembly of the file is done by a Windows utility called `dumpbin`, which is similar in principle to the `objdump` file on Linux.  Since you may not have a Windows machine, we are providing the output in a [patterns.dumpbin.txt](patterns.dumpbin.txt) file

3. Write a flex pattern file to scan the disassembled code and detect the two virus code patterns discussed above. You should detect any tricky jump pattern regardless of the function name given in the first instruction.  For simplicity, you may restrict your recognition of the interrupt hooking code pattern to those codes that use register eax or register ebx as the pointer into the IVT; however, the same register must be used in both lines of the code in order to qualify as an interrupt hook, as discussed above. Keep track of the line number in the input file as you process the file. When one of the patterns is encountered, print a warning message with the line number and the name of the pattern: "Tricky Jump", "Interrupt Hook using EAX", or "Interrupt Hook using EBX". After the warning message, print the lines of code that matched the pattern, followed by a blank line. Call your flex file patterns.l so that all submissions will be uniform.

4. Compile and link the flex code into an executable. To do this in a Linux environment, use the commands shown below.  Using the provided patterns.dumpbin.txt file, you can develop this program on any platform, as lex is uniform across operating systems.  However, you should test it on Linux prior to submission!  Note that your patterns.l file should __not__ contain a `main()` function - this will be put in automatically by flex, and that will call the tokenizer.  If you look at sample lex programs in the [regular expressions and lex slide set](../slides/05-re-and-lex.html#/), you can run them through the same compilation commands shown below.

5. Run and test your solution. You might want to create a small input file that matches the patterns, and which also has some close misses that you should not match. After testing is successful, run your solution on the disassembled patterns.exe file from the assignment web page. You should get some output of detected patterns.

6. Create a Makefile that will compile your code upon entering 'make'.  The executable should be called 'a.out'.

### Item to Submit

In addition to your Makefile, the one code file is called `patterns.l`.  It should read in the virus file from standard input, and write all output to standard output.  You should be able to compile and run your code with the following commands (which should be in your Makefile):

```
flex patterns.l
gcc lex.yy.c -lfl
```

You are welcome to use g++ instead of gcc.  Or clang++.

You can then run your file via the following (this should NOT be in your Makefile):

```
cat patterns.dumpbin.txt | ./a.out
```
