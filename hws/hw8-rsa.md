DADA: HW 8: RSA 
===============

[Go up to the main DADA homeworks page](index.html) ([md](index.md))

### Purpose 

This assignment will focus on the implementation and the vulnerabilities of the RSA algorithm. Specifically, you will have to implement RSA key generation, RSA encryption and decryption, a man‐in‐the‐middle attack, and cracking of RSA messages. 

The intent is to implement this in Java, since the JDK provides the functionality to handle the necessary math.  You must speak to me first if you want to use another language!

As Java is meant to be cross-platform, there is no specific reference platform for this assignment.  We will be using Java 1.8 to compile and run your program.

### Prerequisites to Review 

You should be familiar with both how the RSA algorithm works, as well as the man‐in‐the‐middle attack. These were both discussed in [the encryption lecture](../slides/11-encryption.html#/), and more details are available online (see the [Wikipedia article on RSA](http://en.wikipedia.org/wiki/RSA). Keep in mind, however, that the Wikipedia page uses different variable names than what the lecture used. For the man‐in‐the‐middle attack, see [here](http://en.wikipedia.org/wiki/Man_in_the_middle_attack).  You will also want to reference the [Java SDK documentation](https://docs.oracle.com/javase/8/docs/api/), specifically the [java.math.BigInteger class](https://docs.oracle.com/javase/8/docs/api/java/math/BigInteger.html).

This assignment uses the MD5 hashing algorithm.  We realize that it is not cryptographically secure, but we will continue to use it for this assignment, as it will be easier to use than the more secure algorithms for the purposes of the work herein.

### Assignment Details 

For this assignment, you must implement five aspects of the RSA algorithm. This assignment is to be done in Java, as you will need to use the BigInteger class. Your class should be called RSA, and should be in a file called RSA.java. All other necessary classes should be in that file (you can have multiple classes in a single Java file, but only one public class). 

Your assignment must provide the following functionality. While we suggest method names, that is only to help explain what is required - you can name the methods (and change the parameters) to be anything that you want. We refer to an `RSAKey` class, which holds the values for a RSA key (d, e, and n). 

1. RSA key generation: given a bit length, you will need to generate a set of RSA keys. There are a number of Java method to handle the mathematical heavy lifting here, so it should not be very difficult: one of the BigInteger constructors can create a probable prime, and the `modInverse()` and `modPow()` methods will be needed as well. The [encryption lecture set](../slides/11-encryption.html#/) shows the use of this code, and provides examples. One way to do this could be through a Java method called `RSAKey generateRSAKey(int bitLength)` that will return a new RSA key of the supplied bit length. The number of bits provided is for *p* (as well as *q*); *n* is twice as many bits.
2. RSA encryption and decryption: also based on the lecture notes. The BigInteger methods should do the complex mathematical work for this. Keep in mind that the algorithm to encrypt and decrypt is the same; only the parameters are different. One option is to create two Java methods: `encryptDecrypt (String m, BigInteger n, BigInteger dOrE)` that does pretty much what you would expect it to do (the last parameter is “d or e”, for the other part of the public or private key). RSA is a block cipher, so you should formulate your messages into blocks to encode. See below (in the 'Notes' section) for how to figure out your block size.  You can assume that *n* will be big enough to hold at least 2 characters. You do not need to pad the last block to *b* characters - you can just leave it unpadded.
3. Signing of a message (and verification of a signed message): the MD5 hash of a message should be computed (via the `java.security.MessageDigest` class), and this should be encrypted with the private key. For simplicity, we can save that signature in another file. Verifying the message should read in the sign (and the public key), and verify that the MD5 sum matches the message. For checking a signature, the program should just print out a single line stating that the signature does not match (if it does, nothing is output).
4. Implement a RSA and a man‐in‐the‐middle attack: this is implemented as a shell script. Below we provide a shell script for normal communication (without a 'man' in the middle); you will need to implement a new shell script that will perform the man‐in‐the‐middle attack.
5. RSA key cracking: Given a ciphertext *c*, and the public key (i.e. *n* and *e*, encapsulated into a `RSAKey`), you must crack a message, as per the algorithm discussed in lecture. Obviously, cracking a message with large keys will not be feasible, so use small keys. One option is to write a Java method `String crackRSA(String c, RSAKey n)`, which will return the plaintext message. The `RSAKey` parameter obviously contains the private key, *d*, as well, but you can't use that in this function, obviously. You can NOT assume that the value of *n* will fit in a Java numerical data type (such as long).  We are not looking for an efficient algorithm here...

The `main()` method should call the appropriate methods as indicated by the command line parameters, which are listed below. In almost all cases, output (progress, status messages, etc.) should ONLY be printed to the standard output if the `-verbose` option is set, and should be enough that we can understand what is happening.  The only time output should be printed to the terminal is when (1) a signature does not match, and (2) an error condition is encountered (which, in theory, should not happen with our tests on properly implemented code).

For this homework, we are focusing on the RSA algorithmic implementations, and not network issues. Thus, your communicating parties will store their data (keys, messages, etc.) in files. The communication between the communicating parties will be by writing to, and then reading from, the given files. While the other part of the key is easily available (the files are all in the same directory), you obviously can't use the private key for cracking the message.


### Command line parameters 

The program will take in a number of command‐line parameters.  Note that the command-line parameters are parsed __in order__ - this means that if you call `java RSA -keygen 10 -verbose`, you will not get any verbosity, as that parameter was specified *after* the `-keygen` parameter was given.  We provide a sample `main()` method, below, that provides skeleton code to handle these parameters.

Note that normal operation (i.e. without the `-verbose` flag) is for it to print *nothing* - the only exception is the `-checksign` flag.

- `-keygen <bitsize>`: this will generate RSA public/private keys of the specified bit size. The base name for the file to store the keys in will be specified by the `-key` parameter; see details below as to the file names and file format. You can divide by 3.321928, which is roughly log(10)/log(2), to get the number of decimal digits. The number of bits provided is for *p* (as well as *q*); *n* is roughly twice as many bits.  Note that *d* and *e* need to be roughly the same bit size (i.e. you can't have *e* be about the size of *p* and *q*, and *d* be about the size of *n*).  See the *-key* parameter, below, for how to write the key to a file.
- `-output <filename>`: this specifies the file name to save the results in. It can be the output from an encryption or decryption. A key file consists of two lines: the first line is *d* or *e* (as appropriate), and the second line is *n*.  A encrypted message file will follow the format described below.  All values are in decimal (i.e. what BigInteger's `toString()` produces).  For cracking a message, your computed private key should be written to \<foo\>-private-cracked.key, where \<foo\> is what was specified by the `-key` parameter.  If not specified, it should default to `output.txt`.
- `-input <filename>`: the input file to be used to encrypt, decrypt, sign, check the sign of, or crack. This input file is specifically the plaintext, cipher text, or the signature, depending on what function is being called - the key is specified by the `-key` parameter.  If not specified, it should default to "input.txt".
- `-showpandq`: this flag will cause the key generation to print out (to the screen only!) the values for the prime numbers *p* and *q* during the key generation phase - this is done for debugging purposes, and so we can check your code. 
- `-key <keyfile>`: the key file.  For encryption, this is the public key file; for decryption, this is the private key file; for key generation, the file name to write the keys to; for cracking a message, this specifies the public key file. Note that this only specifies the key prefix name (such as 'alice' or 'bob') - to get the full key name, `-private.key`, `-public.key`, or `-private-cracked.key` is appended to the name.  If not specified, it should default to `key`.
- `-encrypt`: this will use the public key (specified by the `-key` parameter) and encrypt the plaintext file (specified by the `-input` parameter), writing the ciphertext to another file (specified by the `-output` parameter). 
- `-decrypt`: this will use the private key (specified by the `-key` parameter) and encrypt the ciphertext file (specified by the `-input` parameter), writing the plaintext to another file (specified by the `-output` parameter). 
- `-verbose`: this flag need not do anything, but is used for debugging: a normal execution should not output anything (unless the signature doesn't match with `-checksign`); with this option, you can output all the status and debugging information that you would like. 
- `-crack`: this will take the public key (specified by the `-key` parameter) and proceed to crack the RSA encryption by factoring *n* into *p* and *q*.  The output key (*d*,*n*) is written to \<foo\>-private-cracked.key, where \<foo\> is specified by the `-key` parameter.
- `-sign`: this will sign a message; given the message (specified by `-input`) and the private key (specified by `-key`), it will write the RSA‐encrypted MD5 hash to the output file. We assume it writes the sign to a file called \<filename\>.sign, where \<filename\> is the name given to the `-input` parameter - this can overwrite the existing \<filename\>.sign, if it exists.  A signature is just an encryption of the MD5 hash.  See the `java.security.MessageDigest` class for easy computation of MD5 hashes.  Also see the supplied Java code, below.
- `-checksign`: this will check a signed message; given the message (specified by `-input`) and the public key (specified by `-key`), it will verify the RSA encrypted MD5 hash to the signature file. Similar to the `-sign` parameter, the key is assumed to be in the \<filename\>.sign file.  This will print "signatures do not match" (or similar) ONLY if the signatures do not match; if they do match, then nothing is printed.

You may assume (and, in fact, should) that you will only receive one of `-encrypt`, `-decrypt`, `-sign`, `-checksign`, or `-keygen`; this specifies what the program is going to do. The program should not output any messages on normal execution (it should output error messages, as appropriate -- but we won't be giving any invalid combination of parameters). With the `-showpandq` option, it will of course output *p* and *q*. And with the `-verbose` option, it can output a lot of informational messages. 

Furthermore, you may assume that we will not give you invalid input, either in the files we provide, or for the command-line parameters.

A sample usage of the program, in which is Alice and Bob are sending messages, is shown below.  This code can be cut‐and‐pasted as a shell script, which we'll call `sample-usage.sh`. Note that this is not a complete test suite!  Just a quick check to see if the basics work.  But if your program does not work with this, then it's incomplete, and will receive a low grade.

This file requires there to be two existing files: message1.txt and message2.txt.  Might we suggest some [great speeches](http://www.historyplace.com/speeches/previous.htm)?  However, make ***SURE*** that the text is all ASCII, since your program will likely not be able to handle UTF-8 characters -- and when you cut-and-paste, characters like the dash and quotes often do not cut-and-paste into their ASCII equivalents.

Assuming you don't have any extraneous output (which you shouldn't), the only command that should output anything is step 12.

```
#!/bin/bash
# 1: create keys alice-public.key and alice-private.key
java RSA -key alice -keygen 200
# 2: create keys bob-public.key and bob-private.key
java RSA -key bob -keygen 200
# 3: alice is going to encrypt a message for bob
java RSA -key bob -input message1.txt -output encrypted1.txt -encrypt
# 4: bob will decrypt the message
java RSA -key bob -input encrypted1.txt -output message1b.txt -decrypt
# 5: are they the same?
diff message1.txt message1b.txt
# 6: bob now sends a message to alice
java RSA -key alice -input message2.txt -output encrypted2.txt -encrypt
# 7: alice will decrypt the message
java RSA -key alice -input encrypted2.txt -output message2b.txt -decrypt
# 8: are they the same?
diff message2.txt message2b.txt
# 9: alice signs her message1.txt
java RSA -key alice -input message1.txt -sign
# 10: bob checks that sign; they should match
java RSA -key alice -input message1.txt -checksign
# 11: modify message1.txt
/bin/mv -f message1.txt message1.txt.bak
echo hi >> message1.txt
# 12: bob checks that sign; they should NOT match
java RSA -key alice -input message1.txt -checksign
# 13: restore message1.txt
/bin/mv -f message1.txt.bak message1.txt
java RSA -key alice -input message1.txt -checksign
# 14: charlie generates an easy-to-crack key
java RSA -key charlie -keygen 10
# eve tries to crack alice's key
java RSA -key charlie -crack
# 15: is the cracked key the same as the original key?
diff charlie-private-cracked.key charlie-private.key
# 16: clean up files (comment out by default)
#/bin/rm -f alice*.key bob*.key charlie*.key message*.sign message?b.txt encrypted?.txt
```
 
If you are new to shells scripts, you can see [here](http://www.freeos.com/guides/lsst/). Note that you will have to set the permissions on your shell script properly before you can run it: 

```
chmod 755 sample-usage.sh
```

While we are not going to try to break your program with strange combinations of command line parameters (trying to decrypt but not specifying a key), we would encourage you to put some sanity error‐checking code in there for your own sanity while developing the program.

### Some Java code

We are providing two methods for you to use in your homework.

The first provided method we are supplying will take a byte array (which is returned by Java's MessageDigest routines), and convert it to the familiar String representation that we are familiar with when viewing MD5 hashes.

```
static String convertHash (byte hash[]) {
  char chash[] = new char[32];
  for ( int i = 0; i < 16; i++ ) {
    int hashValue = hash[i];
    if ( hashValue < 0 )
      hashValue += 256;
    if ( hashValue/16 < 10 )
      chash[2*i] = (char) ('0' + hashValue/16);
    else
      chash[2*i] = (char) ('a' + hashValue/16 - 10);
    if ( hashValue%16 < 10 )
      chash[2*i+1] = (char) ('0' + hashValue%16);
    else
      chash[2*i+1] = (char) ('a' + hashValue%16 - 10);
  }
  return new String(chash);
}
```

If you want to see if a string has the same MD5 as a file, make sure they are EXACTLY the same.  If the file has a ending newline (`\n`) character, and the string does not, then the MD5 sums will not match!  You can find the MD5 hash of a file via the `md5` or `md5sum` command:

```
$ md5sum message1.txt 
afe68f753a65f773a591bcf6f9ce3c63  message1.txt
```

The other method being provided is our `main()` method.  Note that a number of static variables need to be defined for this to compile (`outputFile`, `keyFile`, etc.).  And the parameters we passed into our methods may very well differ from the parameters that your method use.  A number of the SDK methods we call throw exceptions (the file input and output routines, in particular).  So rather than catching them, we just declared everything else to throw that exception back up to `main()`, which is also declared to throw exceptions.  Note that we will not provide your program with invalid input (either a bad combination of command line parameters, or bad input file contents).

```
public static void main (String[] args) throws Exception {
  for ( int i = 0; i < args.length; i++ ) {
    if ( args[i].equals("-verbose") )
      verbose = !verbose;
    if ( args[i].equals("-output") )
      outputFile = args[++i];
    if ( args[i].equals("-input") )
      inputFile = args[++i];
    if ( args[i].equals("-key") )
      keyFile = args[++i];
    if ( args[i].equals("-showpandq") )
      showPandQ = true;
    if ( args[i].equals("-keygen") )
      generateKeys(Integer.parseInt(args[++i]));
    if ( args[i].equals("-encrypt") )
      encrypt(keyFile + "-public.key", inputFile, outputFile);
    if ( args[i].equals("-decrypt") )
      decrypt(keyFile + "-private.key", inputFile, outputFile);
    if ( args[i].equals("-crack") )
      crack();
    if ( args[i].equals("-sign") )
      sign(false);
    if ( args[i].equals("-checksign") )
      checksign();
  }
}

```

Some notes on this `main()` method:

- Note that, given an input file, your MD5 hash computation should print out the *exact* same result as the `md5` (or `md5sum`) command on your favorite Unix system.  But see the warning, above the `main()` method, about making sure the contents are the exact same.
- When converting a series of characters to a number, you should first convert it to a byte array (the `String getBytes()` method does this).  At this point, you have a numerical representation for each character in the string.  Multiply the current value by 256, and add the byte value of the next character; repeat until you have encoded the right number of characters (as determined by your block size).  Your number will need to be in a `BigInteger`.
- To figure out your block size (which we'll call *b*) -- which is the number of characters you can encode in one block -- let *x* be the number of bits in *n* (found via the BigInteger `bitLength() method)`.  Divide *x-1* by 8 (the minus one is important here to prevent rounding issues).  The 8 is equivalent to log<sub>2</sub>*n*/8, which is equivalent to log<sub>2</sub>*n*/log<sub>2</sub>256, the latter of which is what was mentioned in class.  As mentioned below, you can assume that we will always use keys that support a block size of at least 2.

### Interoperability

We want to be sure that we can all encode and decode each other's messages.  To that extent, we have a few requirements for the files produced.

__Keys and key files:__ The public key file and the private key file formats are the same: the first line is the value for *d* or *e* (as appropriate), and the second is the value for *n*. Thus, the file should have only two lines, and each line should just have the numerical value of that part of the key.  Both lines in this type of file will have the number in decimal format (via `BigInteger.toString()`).

__Block size:__ Each block will be a whole number of 8-bit characters, so we will not be splitting characters between blocks.  Thus, if your keys can hold up to 31 bits per block (if 2^^31^^ > *n* > 2^^32^^), we will only encode 24 bits (3 characters) in that block, not 31 bits.  That being said, you can assume that all blocks we will use will allow for at least 2 characters per block.  Note that the number passed in via `-keygen` is the bit size for *p* and *q*; *n* is roughly twice that size.

__Encrypted files:__ An encrypted message should have two numbers on the first line: the block size, and the file size (yes, the block size can be determined from *n*, but we'll put it here for simplicity in the decoding).  Each successive line has each encrypted number (the *c* of *c* = *m^^e^^* mod *n*) written on a separate line in the file. The last line in the file should always be a 0, as that will be an (easy) way to delineate when the file input is finished. 

__File names:__ The key filenames will be named \<foo\>-public.key, \<foo\>-private.key, and \<foo\>-private-cracked.key, where \<foo\> is specified by the `-key` parameter. Recall that the value specified by that parameter is only the prefix for the key file names. 

__Other:__ All files (messages, keys, ciphertext, what‐not) will have only printable ASCII characters, so you need not worry about binary files.   But there may be whitespace as well: newlines, tabs, linefeeds, etc.  Make sure that your code does not have UTF-8 characters in it!  Given a file, you can tell what type of characters it has via the `file foo.txt` command.

### Examples

Here is a private key generated via the above requirements; you can name this file `test-private.key`:

```
2224703882376084886028249
2483289780073148545978469
```

And here is a message encrypted with the public key that is paired with the above private key; you can name this `ciphertext.txt`:

```
10 72
470320827850321971802656
958643106130296859805722
747668051997350735836948
449085120843845288570602
1123893666046436696854183
127102589242098018583314
1177302764288216426332997
1997554226513953080629974
0
```

If your code follows these conventions, then you should be able to properly decrypt that message with the following command:

```
java RSA -key test -input ciphertext.txt -output plaintext.txt -decrypt
```

### Submission requirements

You should submit two files: `RSA.java`, which contains all your Java code, and a shell script named `man‐in‐the‐middle‐attack.sh`.  The compilation command will be `javac *.java`, so your RSA.java should have only one public class called `RSA`, and not be in a package.

