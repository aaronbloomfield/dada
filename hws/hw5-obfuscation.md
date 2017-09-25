DADA: HW 5: Obfuscating x64 assembly code
=========================================

[Go up to the main DADA homeworks page](index.html) ([md](index.md))

In the last homework, we saw how to recognize a virus pattern.  While the patterns we found were very common patterns (a tricky jump and an interrupt hook), longer patterns can recognize a specific virus.  This homework will write an obfuscator, which will take x64 code and modify it so that it can *not* be recognized in such a manner.  Your program will read in an x64 assembly file, add obfuscation to the program, and print the output.


### Program requirements

The program can be written in any language that you would like, with the following restrictions:

- It must be a language that can be run on a Linux machine; thus C# is not viable
- It must be a language that the submission system is configured to be able to compile and execute.  Currently, those languages are: Java, C, C++, Python, PHP, and Ruby.
    - If you would like to use a different language, you will need to speak to me about it - depending on how difficult it is to implement in the submission system, I may allow it.  But this is a process that will take a day or two, so I absolutely will not consider this the day before the assignment is due.
- You must read the [Program submission guidelines](program-submission-guidelines.html) ([md](program-submission-guidelines.md)), especially the language-specific section.  __IF YOU DON'T READ THAT SECTION, AND YOUR PROGRAM DOESN'T COMPILE, DON'T BOTHER US WITH YOUR PROBLEMS!!!__

We provide a Makefile at the bottom that will ensure proper compilation.  If you are not using C++, you will have to modify it, as described below.  Specifically, there is a `run` target, so that calling `make run` will run your program.

Your program will read in an x64 assembly from standard input, and write the output to standard output.  Thus, you can run your program as such:

```
cat vecsum.s | make run > vecsum-obfuscated.s
```

While testing, you may want to replace `make run` with whatever command you use to run your program.

The assembly files will follow a very strict format, intended to make parsing the file viable without a full fledged parser:

- All assembly will be in the NASM format that we all programmed in during CS 2150.  Remember that?
- Since this is NASM format, there are two keywords that we will use: `global` and `section`; those keywords will be the first (non-whitespace) token on a line, and those lines are to be reproduced exactly in the output (we don't care about white space, of course).  There might be multiple `section` or `global` lines in a file.
- All comments will begin with a semi-colon, and this semi-colon will only occur as the FIRST character in a line.  Thus, no comments will be allowed after the x64 commands.
- Lines may be blank (possibly with white space), and may have leading or trailing white space (as above, comments will not have leading whitespace).
- There may be both tabs and spaces in the file as white space
- The only time a colon (`:`) will appear is after a label; no colons will appear in the comments or the x64 code.  This should allow for easy identification of jump targets.
- Any x64 command will have zero, one, or two targets.  Consider the commands `ret`, `pop rsi`, and `cmp rcx, 0`; they have zero, one, and two targets, respectively.  There will be no spaces within a target (so `[rax + 4*rbx + rcx]` will not appear; instead it would appear as `[rax+4*rbx+rcx]`).  This means that there will never white space before a comma, only afterward.  The opcode and any target(s) will separated by one or more spaces.

These restrictions should allow for easy reading of the x64 assembly input.  The intent here is not for you to have to spend all your time writing a complicated lexer and/or parser to read in the file.  If there are other restrictions on the x64 assembly input that will make the parsing job easier, feel free to chat with me about it.

The output of your program should be an obfuscated x64 program __THAT COMPUTES THE EXACT SAME RESULT__.  Comments should not be output, and you are free to output blank lines or not (it's probably easier to not output them).  We are going to run the output of your code through NASM, so it needs to compile.  Furthermore, your output should conform to the x64 formatting guidelines above, as we will try to run your code through your program a second time.


### Sample execution

You can start with the sample code provided in [CS 2150 lab 8 (x64, part 1)](http://aaronbloomfield.github.io/pdr/labs/lab08-64bit/index.html): Makefile, main.cpp, and vecsum.s.  However, the vecsum.s has to be modified to conform to the above guidelines (reformatting of comments and removal of colons; all x64 opcodes stayed the same).  Below is the vecsum.s file properly formatted, but without any comments:

```
global vecsum
section .text
vecsum:
	xor	rax, rax
	xor	r10, r10
start:
	cmp	r10, rsi
	je	done
	add	rax, [rdi+8*r10]
	inc	r10
	jmp	start
done:	
	ret
```

Running it through a VERY simple obfuscator might yield the following code.  Note that the formatting (i.e. leading spaces) is optional, and is only included here for ease of reading.  The NOPs are indicated in the program below.  This intentionally uses very simple obfuscations; details on obfuscation complexity is detailed below.

```
global vecsum
section .text
vecsum:
   xor rax, rax
; the following line is a nop obfuscation
   imul rdx, 1
   xor r10, r10
start:
   cmp r10, rsi
   je done
; the following line is a nop obfuscation
   add r11, 0
   add rax, [rdi+8*r10]
   inc r10
; the following line is a nop obfuscation
   nop
   jmp start
done:	
	ret
```

Note that in the above program the obfuscations are clearly labeled.  Not only are you *not* expected to do that, but it will be impractical when you are doing more advanced obfuscations.  We did it here for clarity in understanding the program that resulted.

### Tips and Tricks

- To deal with leading and trailing white space on a line, use `trim()` (or the equivalent in your language of choice).
- To easily parse the parts of a line that contains an x64 opcode, use `split()` or `explode()` (or the equivalent in your language of choice).
- You can use a regular expression replacement subroutine to replace all occurrences of white space with a single space - depending on your language, this may make calling `split()` (or equivalent) easier.
- Quality is more important than quantity.  Putting in thousands of NOPs will just make us cranky when trying to grade your program.
- To tell if it's a jump target, you just have to check if a single colon is in the line.
- Note that you should not put any obfuscation opcodes between a cmp and it's respective jump command, as that may interfere with the conditional jump.
- Using randomization is going to be necessary, otherwise it will just create another x64 program pattern to match exactly.

### Types of obfuscations

The program above has as simple obfuscations as there can be: there are three types of NOPs: `nop` itself, adding zero, and multiplying by 1.  You can imagine a bunch of other NOPs: subtracting 0, exchanging (`xchg` opcode) a register with itself, etc.  In each one, a random register can be chosen, which could be any of the x64 registers.  One option would be to have a percentage chance to put such a nop after each line (that is not a `ret` or `cmp`).

Implementing this will get you 2 points (out of 10) - it was done by a 40 line Java program.  This type of obfuscation doesn't get us very far - the NOPs are easily detectable as NOPs, and can be easily removed by lex (or anything more powerful).

Your job is to implement more complicated obfuscation.  In the program above, there is a `dec` opcode - perhaps multiple operations to yield the same result.  As these command would not, individually, be NOPs, they are harder to detect and remove.  Consider the various obfuscation techniques that we discussed in lecture.

It is likely that you will need to generate more complicated assembly routines to demonstrate your code obfuscation - you will be submitting these as well.

### How to run assembly

There are three different platforms that people are using: Windows, Mac OS X, and Linux.  As a result, there are differences in how to compile and run x64 assembly.

__YOUR SUBMITTED PROGRAM MUST RUN ON A 64 BIT LINUX MACHINE!__ And must be compiled using the -m64 flag (which compiles it into 64 bit assembly).

You can look at [CS 2150 lab 8 (x64, part 1)](http://aaronbloomfield.github.io/pdr/labs/lab08-64bit/index.html), which discusses the various ways to compile x64 for the various platforms.


### Submission requirements

You should submit the following files.  __BE SURE TO NAME THEM PROPERLY__, including capitalization - otherwise, can can't call our testing scripts on your code, and we'll just give you a zero.  For example, we will assume that your assembly file is called `x64.s`, your C++ file `main.cpp`.  Your sample C++/assembly file needs to compile to an `x64` executable (not `a.out`!).  The submission system will call `make` to compile everything.

- Your program, written in the language of your choice.  The name will depend on the language that you are using.  Did you read the [Program submission guidelines](program-submission-guidelines.html) ([md](program-submission-guidelines.md)) page?
- `x64.s`: assembly code for us to obfuscate.  In particular, you should generate some assembly routines that demonstrate the various obfuscations that your code can produce.  However, this file should be the *non*-obfuscated version.  You can have multiple assembly routines in a single file - just have multiple 'global' lines, one for each.  To start with, use the vecsum.s file (but rename it to x64.s).  This file should compute something - what, we don't care, but it should need many opcodes to compute some numerical result.  __IT MUST CONFORM TO 64-BIT X64 ASSEMBLY__.  See above for details.
- `main.cpp`: the driver file that will call your sample assembly code.  This is not the program that you can select the language for!  You are welcome to use the CS 2150 lab 8 main.cpp file verbatim, if you would like.  It should not take in any input.
- `Makefile`: this should compile BOTH the main.cpp/x64.s program (into an executable named 'x64') and, if necessary, your obfuscation program (only C, C++, and Java need to do this compilation step; Python, Ruby, and PHP do not).  When you submit it, it __MUST CALL g++ WITH THE -m64 FLAG__.  See above for details, and see below for a sample Makefile.
- `readme.pdf`: this file should describe the obfuscation techniques that you use, and where we would find them in the file.  We realize that you can't specify exactly where (due to the fact that your program will have randomization), but give us as good an idea as you can.  And see [How to create a PDF file].  Note that we will not know about an obfuscation technique unless it is listed here!

### Grading guidelines

Obfuscations types will yield the following points:

- trivial obfuscations (such as the x64 example given above): 2 points.  A trivial obfuscation is one that can be removed via a simple lexical analyzer.  You need to have multiple trivial obfuscations (5-10 different types) for the 2 points.
- simple algorithmic obfuscations (such as replacing a `dec` command with multiple computations to yield the same result, and likewise with `inc`): 2 points for each type.
- more complicated algorithmic obfuscations: 2 points for each type.

Note that these obfuscations need to be general.  So implementing just a `dec` replacement is not worth 2 points by itself, but replacing `dec` and `inc` (and similar commands) with replacements can yield 2 points for that part.  And replacing it with the same pattern of opcodes is not much of an obfuscation, as that becomes an easy pattern to match and thus remove.  Obviously, the quality of the implementation of each obfuscation will be on a scale of that amount (so poorly implementing dec/inc may only yield 1/2 points for that one).

Restrictions:

- no more than 2 points of trivial obfuscations
- no more than 4 points of simple algorithmic obfuscations
- no limit on complicated algorithmic obfuscations

This has the net effect of requiring at least two complicated algorithmic implementation for more than 6/10 on this homework.

### Makefile

Below is a sample Makefile for an obfuscator written in C++.  You are certainly welcome to use a more complicated Makefile; this is the minimum required for this assignment.

```
main:
     g++ -Wall obfuscator.cpp
     nasm -f elf64 -o x64.o x64.s
     g++ -m64 -Wall -c -o main.o main.cpp
     g++ -m64 -Wall -o x64 x64.o main.o

run:
     ./a.out
```

Note that if you cut-and-paste this into a Makefile for you to use, you will have to replace the leading 5 spaces on those lines with a single tab.  And the -Wall flag is there for your sanity (it turns on all warnings), but it is certainly not required.

This Makefile does a number of things:

- it only defines only two targets (`main` and `run`) - and no macros - as this is a simple Makefile.  You can define all the targets and macros that you would like.  We are going to call `make` to compile it, and `make run` to run it.
- It compiles your obfuscator.cpp into an executable called `a.out` (since we don't specify the executable name, that's what it defaults to).  We don't care what your obfuscator source code file is called (as long as it's something reasonable, follows the [Program submission guidelines](program-submission-guidelines.html) ([md](program-submission-guidelines.md)), and is not called main.cpp).  This line will be one of the only two lines that changes depending on your choice of implementation language (see below).
- it compiles the sample assembly file into a .o file; the NASM flags listed MUST be present (in particular, `-f elf64`).  The assembly file MUST be called x64.s.
- it compiles the main.cpp file (which must be called main.cpp) using 64-bit x64 executable format
- it links the main.cpp/main.o and x64.s/x64.o files together (in 64-bit x64 executable format) into an executable called `x64` - and the executable MUST be called `x64`.

The second line of the Makefile (`g++ -Wall obfuscator.cpp`) will change depending on your choice of implementation language:

- C: `gcc -Wall obfuscator.c`
- Java: `javac Main.java`
- PHP, Python, Ruby: no compilation line required, but the program naming requirement is quite strict; see [Program submission guidelines](program-submission-guidelines.html) ([md](program-submission-guidelines.md)) for details.

The second target is what will run your obfuscator.  Here are some sample lines for various languages:

- C/C++: `./a.out1`
- Java: `java Obfuscator`
- Python 2: `python obfuscator.py`
- Python 3: `python3 obfuscator.py`
- PHP: `php main.php`
- Ruby: `ruby main.rb`
