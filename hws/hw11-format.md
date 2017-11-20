DADA: HW 10: Format Print Attack
================================

[Go up to the main DADA homeworks page](index.html) ([md](index.md))

### Introduction

In this assignment, you learn and demonstrate how format string vulnerabilities can be exploited.
Assignment Resources

### Resources

- The [course slides on format string vulnerabilities](../slides/15-exploits.html#/thirdgen)
- [This article](https://www.cs.virginia.edu/~cr4bd/4630/S2017/assignments/format/formatstring-1.2.pdf), "Exploiting Format String Vulnerabilities" by scut / team teso. Beware of the differences between 32 and 64-bit X86 when using this article.
- [This tutorial](http://www.infond.fr/2010/07/tutorial-exploitation-format-string.html). Beware of the differences between 32 and 64-bit X86 when using this article.

### Details

1. Like the buffer overflow assignment, this assignment is likely to be very sensitive to the exact environemnt used. Your exploit must work on the Ubuntu 16.04 LTS environment with the exact executable file we provide.

2. The executable you must exploit is located on Collab in the Resources section. It will ask for your name, then ask you to confirm the name after printing it out. This first printing out will use code like:
```
printf("The name entered was ");
printf(name);
printf(".\n");
```
You will exploit this `printf(name)` call. After asking for the name, and printing it out again, the program will ask to confirm it. If you do not confirm it, then the program will ask again for the input.

3. After inputting a name and confirming your input, the program will output your grade. By default, it will output a recommendation of F. For example if `name.txt` contains:
```
Class-Skipping Wizard
yes
```
then an example run of the program would look like:
```
$ ./format-string-vulnerability <name.txt
Enter name:
The name you entered was Class-Skipping Wizard.
Is this correct? (y/n) Thank you, Class-Skipping Wizard.
I recommend that you get a grade of F on this assignment.
```
(The values supplied by the input file will not be visible.)

4. Your goal is to generate a C program attack-format-string.c that produces an input that will cause the program to output at the end:
```
Thank you, NAME.
I recommend that you get a grade of A on this assignment.
```
With NAME replaced with your name. To do this, the easiest way will be to include an entry of the exploit string, then not confirm it as correct and enter your correct name. Your exploit string can overwrite the stored default letter grade, which is in a global variable called `defaultLetterGrade`.

    Your C file should include comments explaining any unusual values you needed to compute.

5. Because of how the format string vulernability works, it is likely that there will be garbled output before the output with a recommendation of A. For example, a successful attack might look like:
```
$ ./attack-format-string.exe > attack_string.txt
$ ./format-string-vulnerability.exe < attack_string.txt
Enter name: The name you entered was (?0 Tp ` ? ?   ? ? @ ? H  ?d 1073859552 1073856500 1073945512.
Is this correct? (y/n)
Enter name: The name you entered was Ron Weasley.
Is this correct? (y/n) Thank you, Ron Weasley.
I recommend that you get a grade of A on this assignment.
$
```
This garbled output is a normal consequence of the attack and expected in your solution. Your exact garbled output will look different.

6. Using the hints below is strongly recommended.

### Hints

1. The supplied executable contains a global variable called `defaultLetterGrade`. This is, by far, the easiest target for your format string exploit.

1. Since we have not removed the symbol table from the supplied executable, you can get a list of the addresses of global variables and functions with `objdump --syms format-string-vulnerability.exe`.

1. The `printf()` without a format string is one of the ones in `ReadName()`. Fortunately for you, the name is first read into a buffer on the stack. You should take advantage of this in your exploit.

1. You should try to figure out what is on the stack during the offending call to printf in `ReadName()`.

1. You can use a pattern like repeated "%016lx %016lx ..." (or "%lx %lx %lx ..." for a shorter format string) to examine the stack above the call to `printf()`. A good first step is finding out how far down the stack the temporary buffer containing your format string is stored. Note that `printf()` will read values on the stack from the beginning until the end of the buffer on the stack.

1. When examining the stack, you can put a distinctive pattern in your buffer to help you figure out where it is located in the `printf()` output.

1. Recall that on x86-64 Linux, the second through sixth arguments to `printf()` will come from registers, not the stack. You will need to put something in your format string to skip over these.

1. `%c` or `%d` or pretty much any format specifier in a format string will consume one argument. Even though it only looks for a single character or int , according to the x86-64 calling conventions, these arguments use an entire 8 bytes on the stack.

1. Something like `%.100u' will output 100 characters without requiring 100 characters in your format string.

1. Knowing the ASCII code for A will be helpful.

1. Your exploit string will probably contain `\0` characters because most addresses contain 0 bytes. This is fine (`fgets()` can read those characters), but to output it from your C program, you might find it it easier like `fwrite()` instead of something like `printf()`. Note that this means that you likely need to place any addresses at the end of your format string.

1. To see if you're overwriting the correct location, you can try replacing the %n you're using to write a value with something like `%016lx` to see the address you would end up writing to. (Be careful not to change where the address is relative to the start of the string when you do so.)

### Submission

Submit a C file called `attack-format-string.c`, which will produce to stdout an input for the `format-string-vulnerability.exe` that will cause the supplied to output your name and a recommendation for a grade of A.  Also submit a `Makefile` that will compile it to `attack-format-string.exe`.
