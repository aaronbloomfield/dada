Program submission guidelines
==============================

[Go up to the main DADA homeworks page](index.html) ([md](index.md))

A few rules MUST be followed for the submission system to recognize your output properly:

- Your program must return an exit code of zero (not returning an exit code in Java or C is the same thing as returning zero).  Exit codes are checked to determine run-time errors, so if you properly exit your program and return specific codes, the system will think you have a run-time error.
    - That being said, C does not require a return value, and the system can handle this
- Unless otherwise directed, your program must read from standard input (`scanf()`, `cin`, `System.in`, etc.), and write to standard output (`printf()`, `cout`, `System.out`, etc.).
- The languages supported are listed below, along with the naming requirements.

Beyond that, a few notes and suggestions:

- If you want to mix `printf()` and `cout` in a C++ program, you have to be careful (they buffer their output in different places), you need to consider [ios_base::sync_with_stdio](http://www.cplusplus.com/reference/iostream/ios_base/sync_with_stdio/).
- Some compilers automatically include certain header files, such as `<stdio.h>` and `<stdlib.h>`.  The version of g++ on the server does not.  If your code compiles fine for you, and does not on the server, then try making sure all your include files are correct.

Language specific information: note that the compilation command is dependent on the file extension of the first submitted file it recognizes.  The execution command is more specific.

- C: typically compiled with `gcc *.c`; thus files can be named anything with a .c extension.  The server has gcc version 5.4.0.
- C++: typically compiled with "g++ *.cpp"; thus files can be named anything with a .cpp extension.  The server has g++ version 5.4.0.
- Java: typically compiled with `javac Main.java`; thus, the primary file must be Main.java.  Java is OpenJDK version 1.8.0.
- Python: no compilation, due to being an interpreted language; tyipcally executed with `python main.py`, so make sure you name your file correctly.  The system has Python version 2.7.12 (run via `python main.py`) and Python version 3.5.2 (run via `python3 main.py`).
- PHP: no compilation, due to being an interpreted language; typically executed with `php main.php`, so make sure you name your file correctly.  The first line in your program should be `<?php` and not `#!/usr/bin/php`.  PHP version 7.0.22.
- Ruby: no compilation, due to being an interpreted language; typically executed with `ruby main.rb`, so make sure you name your file correctly.  The Ruby version installed is ruby 2.3.1.
