DADA: HW 10: Buffer Overflow
============================

[Go up to the main DADA homeworks page](index.html) ([md](index.md))

### Introduction

In this assignment, you learn and demonstrate how buffer overflow vulnerabilities can be exploited.
Assignment Resources

- [The slides about buffer overflows](../slides/14-buffer-overflows.html#/)
- The articles [Detection and Prevention of Stack Buffer Overflow Attacks](http://dl.acm.org/citation.cfm?id=1096000.1096004&coll=portal&dl=ACM) (VPN may be required off-campus) and [Smashing the Stack for Fun and Profit](http://phrack.org/issues/49/14.html)
- The binary to attack: dumbledore.exe, which can be found in the Resources section of Collab
- Please ask any clarifying questions on Piazza.

### Assignment details

1. Your submission on the assignment must work in a 64-bit Ubuntu 16.04 LTS environment like you installed on your VM. This is the environment where we will test your submitted code.

2. Ubuntu (and most current Linux environments) have [ASLR (Address Space Layout Randomization)](https://en.wikipedia.org/wiki/Address_space_layout_randomization) enabled as a mitigation against buffer overflow and similar exploits. For this assignment, you will work with this feature disabled. To turn it off run the command:
```
setarch x86_64 -v -RL bash
```
This will run a shell (i.e. command prompt) with ASLR disabled. It does **not** affect any other shells. We also have provided you a binary without other mitigations that would usually be used these days including non-executable stacks and stack canaries. Later in the semester we will talk about these mitigations and how they can be defeated.

3. Examine the supplied `dumbledore.exe` file. It contains an obvious buffer overrun vulnerability in the `GetGradeFromInput` function, which calls the C standard library function `gets`. `gets`, as its manpage documents, does not check the length of the buffer supplied as an argument as is unsafe.

4. Create a file name data.txt containing your name and run `dumbledore.exe`
```
./dumbledore.exe < data.txt
Thank you, Aaron Bloomfield.
I recommend that you get a grade of F on this assignment.
```
5. Your goal is to produce an input file so that the output of the program execution is as follows:
```
./dumbledore.exe <data.txt
Thank you, Aaron Bloomfield.
I recommend that you get a grade of A on this assignment.
```

6. To do this, you will use the stack smashing technique we discussed in class. There are several strategies to write the machine code run by this attack, which  have extensive hints below:
    1. The first is to call a convenient `PrintGradeAndExit` function in the supplied executable. To do this, you should be careful to set the stack pointer is less than the address of your machine code, so this function does not corrupt your machine code/data when it executes. This is probably the **easiest** solution.
    2. The second is to write code that directly prints out the string, without calling any application functions. We give examples of how to make direct calls to the operating system to print strings and to exit below. A challenge with this approach is that you cannot include the newline character directly in the middle of your attack string.
	3. The third is to use shellcode that actually executes a shell, and then send commands to print out the appropriate strings in from that shell (for example using "echo"). A challenge with this approach is that the supplied application does buffered I/O -- if input is available, it will read in (from the OS) more than just the one line you input, assuming it will be needed later by the application anyways. This means that when the newly executed shell tries to read its input, some bytes after the buffer overflowing line may have already been consumed.

7. Note that the location of the stack pointer can vary slightly when your environment changes. See the section "Variations in the location of the stack pointer" under hints below. Because of this, you should plan on using a [NOP sled](../slides/14-buffer-overflows.html#/nopsled) so you don't have to precisely predict the address of the stack pointer.

8. Rather than submit the input file alone, we'd like you to submit a C program `attack.c`, that will generate the input. This C file can include comments that explain how the exploit works (which might any sort of partial credit/figuring out if our test environment diagrees with your environment/etc. possible). An example file which produces a normal (non-exploit input) is:
```
#include <stdio.h>
int main(void) {
        /* Just have the name */
        printf("Thomas Jefferson\n");
        return 0;
}
```
This would be used to run the program like
```
 $ ./attack-program.exe > data.txt
 $ ./dumbledore.exe < data.txt
 Thank you, Thomas Jefferson.
 I recommend that you get a grade of F on this assignment.
```

### Tips

You will find it ***very confusing*** if you are not running your commands from a shell started with `setarch x86_64 -RL bash`. In particular, the stack will have inconsistent addresses, and your program will just segfault every time.

#### Disassembly and Debugging

1. A useful starting point is using `objdump` to disassemble the executable file.

2. Using the debugger `gdb` can be helpful for debugging and refining your buffer overflow payload. See [this page](http://aaronbloomfield.github.io/pdr/docs/gdb_summary.html) of useful GDB commands. But see the warning below about the debugger's environment slightly changing the location of the stack pointer.

3. In particular, after looking over `objdump` output, a good second step is running the program in GDB to find the address of the stack pointer at a relevant time.

4. Since we tell you the buffer overflow occurs in `gets`, it is helpful to find the call to `gets` and examine the state of the program at that time in the debugger.

5. Drawing a picture of the state of the stack is helpful.

#### Variations in the location of the stack pointer

1. The stack can start at slightly different locations depending on how the program is run. One cause of this is that Linux stores program arguments and "environment variables" on the stack, so the location on the stack pointer on entry to main depends how much space these take up.
  
    Environment variables include things like information about the terminal the program is being run in. You can see a list of environment variables by running printenv. Note that the shell commonly sets environment variables depending on what program is being run like `_=/usr/bin/printenv` or `OLDPWD`.

2. For example, the program
```
int main(void) {
       int x;
       printf("%p\n", &x);
}
```
has different output on my system depending on the environment variables:
```
$ setarch x86_64 -RL bash
$ ./stackloc # run normally
0x7ffffffffe034
$ env - ./stackloc # run with no enviornment variables
0x7ffffffffed84
$ gdb ./stackloc
...
(gdb) run
0x7ffffffffe004
```

3. A particular case where this is a problem is running the program in the debugger versus not. The debugger may set a few environment variables itself, and when you run the program in the debugger, it may set

4. The best way to avoid problems with the stack starting in different locations is to use a [NOP sled](../slides/14-buffer-overflows.html#/nopsled). Please place a large string of NOPs before your exploit code and try to "aim" the return address in the middle of this string. This will prevent you from being sensitive to small differences in the location of the stack. We've made the buffer that is overflowed particularly large to make a NOP sled more reliable.

5. An encoding for a 1-byte NOP instruction on x86 and x64 is 0x90.

6. You could also try to figure out how to keep the debugger from changing the enviornment (likely with some `unset env` commands), but this is less preferable, because it means your exploit is less reliable.

#### Shellcode production

1. You can run `objdump` on `.o` files. I would recommend using `objdump -dr file.o`, which will show disassembly and unresolved relocations, so you can tell if you accidentally generated machine code which needs the linker to complete it. (Recall that relocations are addresses the linker needs to fill in later.)

2. On 64-bit x86, you can use RIP-relative addressing (that is, program counter-relative addressing) to load addresses within your machine code without worrying about the location at which your machine code is placed in memory:
    ```
code:
       movq value(%rip), %rax
       leaq value(%rip), %rbx
       ...
value:
       .quad 42
```
will place the value 42 in %rax and the address of the value 42 in %rax. But, unlike not using (%rip), the resulting machine code will not have any depenencies on the memory addresses eventually assigned to code and value. It will only depend on how far apart code and value are in memory.

	Note that if you choose to do this, nasm will become difficult to use (it doesn't interact well with rip).  You can program in AT&T syntax (shown above) and use `as` to compile the assembly.

    Other techniques for finding the address of your code include using a sequence like:
```
        call next
next: 
        popq %rax
```
to load the current program counter into `%rax`. The `call` instruction uses an address relative to the current program counter, so the resulting machine code does not include hard-coded addresses.

3. Since `gets` reads until a newline, you need to make sure your machine code does not contain newlines.

4. The `objcopy` utility can be used to extract a particular section of an object file. For example
```
objcopy -O binary --only-section=.text compiled_code.o compiled_code.raw
```
will take the `.text` section of the object file `compiled_code.o` and put it in `compiled_code.raw`. (`compiled_code.o` might be a file generated by `gcc -c some_assembly_file.s`.) You might then look at the resulting file with a tool like `ghex` or `od` to extract the machine code in an less cluttered way than looking at the `objdump` output.

#### Running an executable function

1. The executable contains `PrintGradeAndExit` function. To figure out what the arugments mean, figure out what the arguments of its call to `printf` are.

2. A challenge with calling the `PrintGradeAndExit` function is that our machine code and data is on the stack and could be corrupted by our call to `PrintGradeAndExit` if we are not careful. To avoid this, you can explicitly set the stack pointer. For example, you might use
```
leaq label-0x100(%rip), %rsp
```
to set the stack pointer to point 0x100 bytes before a label in your shellcode.  (`label-0x100` is assembly syntax for `0x100` bytes before `label`.)

3. Recall that the `pushq` then `ret` allows you to jump to an location from machine code without worrying about where that machine code ends up relatively in memory.

#### Alternate print/exit

1. If you don't call `PrintGradeAndExit`, you could instead print out the output you want directly, then exit. This is more realistic but a little more challenging.

2. Instead of including a newline in your buffer overflow, you can, instead, include code to compute a newline (e.g., by adding or subtracting from another value) or to copy one from elsewhere in the application.

3. To print something out from your machine code, you could call the `printf@plt` "stub" (hard-coding its address) or make a write() system call directly. An example assembly snippet to make a write system call is:
```
mov $1, %eax /* system call number 1 = write */
mov $1, %edi /* arg 1: file descriptor number 1 = "standard output" */
lea string, %rsi /* arg 2: pointer to string */
mov $length_of_string, %rdx /* arg 3: length of string */
syscall
```

4. If you decide that your attack code should exit directly, you can do this by caling the `exit@plt` "stub" or by making an `exit_group` system call directly. An example assembly snippet to make an `exit_group` system call is:
```
mov $231, %eax /* system call number 231 = exit_group */
xor %rdi, %rdi /* arg 1: exit code = 0 */
syscall
```

#### Executing a shell

1. You can find an example of shellcode that runs runs the `execve` system call to execute `/bin/sh` in [this archive of shellcode](http://shell-storm.org/shellcode/). Note that some of the shellcode you find may make assumptions about the initial contents of registers or location of the stack pointer. If you use prebuilt shellcode like this, you **must** clearly cite its source.

2. On Linux, `execve` ***replaces*** the current program with the executed program. The new program inherits the same input and output as the prior program.

3. Standard I/O functions read ahead in their input. For example, `gets` may read part of the next line, saving it in a buffer for future calls to `gets` or other `<stdio.h>` functions. These buffers are **not** passed to the new program by `execve`. To compensate for this, you may need to include padding in your input.

4. You can print out a string from the shell using the echo command.

5. By default, the shell won't print out a command-prompt when its input is not a terminal.

### Submission

Submit a C file called `attack.c`, which will produce to stdout a data.txt that will cause the supplied program to output your name and a recommendation for a grade of A. Make sure you C file includes comments that describe how it works and any special resources you used.  Also submit a `Makefile` that will compile this program.  The executable that `attack.c` compiles to ***MUST*** be named `attack`!

### Credit

This assignment was adopted from Charles Reiss' fall 2017 assignment, which was adapted from Jack Davidson's fall 2016 assignment, which was adopted from one given previously by Andrew Appel in Princeton's COS 217.
