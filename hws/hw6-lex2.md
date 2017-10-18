DADA: HW 6: "Binary" Lex
========================

[Go up to the main DADA homeworks page](index.html) ([md](index.md))


### Introduction

This assignment is an extension of [HW 4: Lex](hw4-lex.md) ([html](hw4-lex.html)).  You will write a Lex pattern to recognize the same patterns in HW 4, plus two more, but this time in "binary" form.

The reference platform for this project is the 64-bit Linux VirtualBox image.  Although most viruses are for the Windows platform, for reasons described in class, we are using the Linux platform to make this assignment easier to perform.


### Part 1: Binary Code

One can certainly write a program to analyze binary code.  However, this is very time consuming -- and can be quite frustrating.  Instead, we will recognize the virus patterns from a stream of ASCII hex digits.  This part of the assignment is to be able to produce that stream.

You are to write a program (in C or C++) that will compile to the `filter` executable.  It will read in a single command line parameter, and print out the hex digits of every byte in the file to standard output, followed by a single newline.  Hexadecimal digits 0xa to 0xf should be written in lower case.

Here is an example run of the `filter` executable (the values shown are just for illustration).

```
$ ./filter a.out
7f454c46010101000000000000000000020003000100000030 .......
```

No other characters, other than the hex digits and the terminating newline, should be output.  In case you want to check the accuracy of your output, you can ensure that the hex digits match the output of `hexdump -C` (although that program prints the address and white space).

The program filter is small. You should be able to implement it in fewer than 25 lines of C/C++ code.  Note, however, that the file may be arbitrarily large, so do not buffer the input before outputting it.

The next programs will analyze this stream of data, which is not true binary, but a representation of the binary code -- hence why the word binary was expressed in quotes above.

You will submit filter.c or filter.cpp for this part.


### Part 2: Writing some x64 code

Write some x64 code that has five assembly patterns to search for.  You can take the main.cpp and x64.s from [HW 5: obfuscation](hw5-obfuscation.md) ([html](hw5-obfuscation.html)).  Your program doesn't have to do anything, really, but must not take in any input.  The goal here is for you to be able to specify the exact assembly opcodes in your x64.s file.  You can just have your main.ccp print out "hello world" or similar, as long as it is linked (via the Makefile) with x64.s.  You should include the three patterns from [HW 4: Lex](hw4-lex.md) ([html](hw4-lex.html)) (interrupt hook with eax, interrupt hook with ebx, and a tricky jump), as well as the two others that you are going to create in part 3.

You may want to read ahead to part 3 to determine the other two patterns (or you can come back to this part to put them in).

You will submit main.cpp and x64.s for this part.  The Makefile, described below, will compile these into a executable called `x64`.


### Part 3: Determining the patterns to find

The next step is to figure out which *hex* patterns you will need to scan for.  In other words, you will need to determine what the hex patterns are for the three provided patterns that you want to search for, plus two more.  The three known patterns are the ones from [HW 4: Lex](hw4-lex.md) ([html](hw4-lex.html)): an interrupt hook with eax, an interrupt hook with ebx, and a tricky jump.

You will need to determine two more patterns that you will search for.  Pick a set of (at least two) assembly opcodes that might seem suspicious -- you can look in the [advanced virus coding techniques lecture set](../slides/09-adv-code-tech.html#/) slide set for some ideas.  Whatever additional patterns your program can search for must also be in your x64.s file from part 2.

Thus, you are looking for a total of five patterns: three from HW 4, and two more that you are to determine.

To find the binary code for a set of assembly opcodes, you can just use `objdump -sRrd <filename>`.  When it disassembles the executable, it prints out the machine code for those instructions on the same line.

You will need to put these patterns in a patterns.txt file for us to look at.  Please also include the nasm opcodes so that we know what hex digits go with which opcode patterns.

You will submit patterns.txt for this part.


### Part 4: "Binary" Lex scanner

Using flex, you will write a scanner to detect the a total of five patterns in the provided input stream.  Your code will be in a scanner.l flex file, which will be compiled into a `scanner` executable in the same manner as in [HW 4: Lex](hw4-lex.md) ([html](hw4-lex.html)) (specifically, don't include a `main()`, compile with `flex scanner.l` and then `gcc -o scanner lex.yy.c -lfl`).  Your program will be run as follows:

```
$ ./filter x64 | ./scanner
WARNING! Tricky Jump: byte number: 2057
68f0144100c3
```

Thus, make sure your filter program from part 1 works!  When a pattern is found, you should print out which pattern, the byte number (from the beginning of the file), and the particular hex pattern that was matched.

You will submit scanner.l for this part.


### Part 5: Makefile

You will need to include a Makefile, which will compile your three programs.  Part 1 should compile into an executable named `filter`, part 2 into an executable named `x64`, and part 4 into an executable named `scanner` (there is no program to compile for part 3).  Please ensure that the executable names are correct, as those are the programs we are going to run!  You can look at the Makefile from [HW 5: obfuscation](hw5-obfuscation.md) ([html](hw5-obfuscation.html)) for some ideas (but you don't need a `make run` target for this homework).

You will submit a Makefile for this part.


### Items to submit

The files you should submit are:

- filter.c or filter.cpp from part 1
- main.cpp and x64.s from part 2
- patterns.txt from part 3 (make sure it's a text file!)
- scanner.l from part 4
- Makefile from part 5
