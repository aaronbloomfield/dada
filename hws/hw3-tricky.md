DADA: HW 3: Tricky Jump
=======================

[Go up to the main DADA homeworks page](index.html) ([md](index.md))

### Introduction

This assignment will explore what it takes to create a stealthy virus that employs a "tricky jump." A tricky jump is a form of hijacking in which a jump is inserted to call some virus code. The jump is inserted in such a way that after the virus code runs, the program continues normal execution, thereby maintaining stealth.

This program ***MUST*** run on the [VirtualBox image](../docs/virtualbox-image-details.html) ([md](../docs/virtualbox-image-details.md)) provided for this course.  You have to write it in either C or C++.

This homework was taken, with permission, from [a homework created by Charles Reiss](https://www.cs.virginia.edu/~cr4bd/4630/S2017/assignments/tricky.html)

### Task
A "tricky jump" can be efficiently implemented (only six bytes) as:
```
pushq $AddressOfVirusFunction
ret
```
This can be encoded on x86-64 using only six bytes, and the encoding does not change based on where the push instruction is placed. This makes it easy to compute the machine code seperately from inserting it somewhere, and so has been commonly seen in viruses.

One could also implement a "tricky jump" by inserting a conventional jump instruction:
```
jmp AddressOfVirusFunction
```

However, a `jmp` instruction uses *relative* addresses (whereas `pushq` uses *absolute* addresses), so the resulting machine code will change based on where the jump is inserted.

When either sequence is executed, control is diverted to the virus code. When the virus code returns, control returns to the function that called the function the at contained the tricky jump. If the virus writer inserts the tricky jump at the end of an application function (i.e, to replace the `ret`), then the program, after the virus code executes, will continue to run as if nothing happened. For example, one might see code like like:
```
400661:       c3                      retq       
400662:       66 66 66 66 66 2e 0f    data32 data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)
400669:       1f 84 00 00 00 00 00
```
`data32 data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)` is objdump's representation of a 14-byte long nop instruction. This is padding added at the end of the function. This is a "cavity" that gives a virus writer some room to work. If we insert a "tricky jump" starting where the retq instruction is located (address 0x400661), then the virus code will be invoked. When the virus code returns, control will be returned to the function that invoked this function.

For this assignment, you will write a C program that infects a particular Linux executable and causes some virus code to be executed.

The Linux executable you want to infect is called [target.exe](hw3-tricky/target.exe). Alternatively, you can download the [target.c](hw3-tricky/target.c) source code and compile it with: `gcc -falign-functions=16 -o target.exe target-novirus.c`.

`target.exe` produces the following output:

```
Initialize application.
Begin application execution.
Terminate application.
```
(After downloading `target.exe`, you may need to mark it as executable with a command like `chmod +x target.exe`. Then you should be able to run it using `./target.exe`.)

Your program should modify `target.exe` into a `target-infected.exe` which will produce the following output:
```
Initialize application.
You have been infected with a virus!
Begin application execution.
Terminate application.
```

Note: add the second line *exactly* as is, as the auto-grading scripts will be looking for that line.  If you add extra spaces, speling mistakes, different punctionation, etc., you will lose points!

You will use the "tricky jump" method of infection. The push version is probably the easiest to use, but you may use any technique. To simplify this assignment:

- The executable has a large "hole" (unused space filled with nops) in which to place the non-malicious "virus code", and we will supply working "virus code" for you.
- You only need to handle infecting this particular executable, but we expect your infection program to be fairly easy to port to new executables. (For example, you should not just have a copy of the output file inside your C file.)

The "virus" code we want you to insert is the following (also available as a .s file or a .o file):
```
    leal string(%rip), %edi
    pushq $0x4004e0 /* address of puts in target executable */
    retq
string: 
    .asciz "You have been infected with a virus!"
```
You can copy the resulting machine code into the large cavity in the executable. This assembly code is carefully written to not require changes to the machine code depending on where in the executable it is. (This is why it does not call `puts` with a `jmp` or `call` instruction or use `mov $string, %edi`.) It will, however, not work in other executables because it hard-codes the address of `puts` in this executable. (The simplest way to avoid this problem would be to replace the call to `puts` with a direct use of the system call used to implement `puts`.)

Submit a C program that when compiled an executed reads a C executable called `target.exe` and produces an executable called `target-infected.exe`. `target-infected.exe` must be the same length as `target.exe`.

Also, answer the following questions:

1. How did you identify the file offsets in `target.exe` to overwrite?

2. How did you produce the machine code to insert for the tricky jump to the virus code?

3. If your infect.c has a hard-coded offset or something similar, how would you automate finding the location in `target.exe` to overwrite with a tricky jump so that it would work on other target programs? (For this question, ignore the problem of fixing the inserted "virus" code to work in other executables.)

### Submission
Submit the following files:

- Your `infect.c` or `infect.cpp` (we don't care if you do it in C or C++, but it must be in one of those)
- A `Makefile` that will compile your file into an executable named `a.out`
- A file `answers.txt` containing the answers to the above questions

The names matter, as the autograder will mark points off if they are not what is expected.

When we run your program, we will put the specified `target.exe` in the same directory as the `a.out` executable, and we will expect the result to be a file named `target-infected.exe`.

### Methodology and Hints

1. You should use the utility objdump to examine the executable `target.exe`. The option `--disassemble` is useful. In particular, you need to determine the starting address of the virus code. The dissasembly will also help you determine the opcodes of the instructions that you need to insert (i.e., a `push` instruction and a `ret` instruction). You may wish to consult the objdump manual (`man objdump`).

2. Identify where the constant stings "Initialize appliation" and "Begin application execution" are referenced to locate relevant parts of the application code.

3. Look for a large area of `nop` opcodes in the disassembly to determine where to insert the virus code. Record the address of this location in memory to generate the "tricky jump" code you will insert elsewhere in the executable.

4. To insert both the virus code and the tricky jump itself, the trick is that you must map the address of the location in the executable to the offset of the proper byte in the file. You need to do this mapping because the file offset where you want to write is not the same as the address of the instruction when the program is loaded in memory (which is what objdump usually shows you).
	* One option is to figure out what options you can pass to objdump to get it to display the offset of code *within* the executable file.
	* Another option is to get a hexadecimal dump of the raw file and look for bytes shown in objdump output in the actual executable file to find their location.
	* Yet another option would be for your infect.c to search for particular bytes in the executable file itself.

5. A `push` of a 32-bit constant (on 32- or 64-bit x86) can be encoded as an `0x68` byte followed by the (little-endian) constant. A `ret` is encoded as `c3`. A jump can be encoded as an `0xe8` byte followed by a 32-bit offset from the address of the following instruction.

6. A very useful program to examine the file is a hex editor such as ghex. You can install `ghex` using `sudo apt-get install ghex`.

7. To simplify the assignment, you can hardcode the input and output file names in your infect program. That is, infect.c opens and reads `target.exe` and opens and writes `target-infected.exe`. After you produce `target-infected.exe` you will probably need to set the execute permissions on the file (your program does not have to set those itself; that can be done manually).

8. To read from and write to a binary file in C, you can use `fopen`, `fread`, and `fwrite`. You can run `man fopen`, `man fread`, etc., to get documentation for how these functions are called, or search online. An example usage of a program that copies "input.dat" to "output.dat" is the following:

```
 #include <stdio.h> 
 #include <stdlib.h>

 int main(void) { 
     FILE *in;
     FILE *out;
     char *buffer;
     int size;
     in = fopen("input.dat", "rb");
     /* get size of input.dat, by 
        moving to the end of the file */
     fseek(in, 0, SEEK_END);
     size = ftell(in);
     /* then, return to the
        beginning of the file */
     fseek(in, 0, SEEK_SET);
     buffer = malloc(size);
     fread(buffer, 1, size, in);
     fclose(in);
     out = fopen("output.dat", "wb");
     fwrite(buffer, 1, size, out);
     fclose(in);
 }
```

9. The hard part is figuring out what locations in the file need to be changed and what they should be changed to. The code to do the infection is small.

10. We are reading and writing binary files, not text files. You may need to open files in binary mode, next text mode.

11. The virus code we've given finishes by returning with a `ret` instruction. (This is actually by returning from `puts()`.) So whereever you insert the virus function needs to be a place where it is safe to return from. If you are experiencing a segfault after the virus code prints out its message, this is the most likely reason why.
