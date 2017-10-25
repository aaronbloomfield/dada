DADA: HW 7: SQL Injection & XSS
===============================

[Go up to the main DADA homeworks page](index.html) ([md](index.md))


### Introduction

There are three parts to this assignment.  As part of this assignment, you will have to create a document, called websecurity.pdf, and submit that file.  We aren't looking for any fancy write-up - just an explanation of what you did, and the results you got.  That being said, it should be legible.  So make sure you indicate what answers are for what questions, etc.

Your final report should be a PDF file.  It need not be long, but it must answer the questions posed below.


### Part 1: SQL Injection Attack

First, you should be familiar with SQL and SQL injection attacks.  For review, look at the first half of the [SQL & XSS slide set](..//slides/10-sql-and-xss.html#/).


View the page at [https://libra.cs.virginia.edu/~insecure/sqlinjection.php](https://libra.cs.virginia.edu/~insecure/sqlinjection.php) - note that you will have to log in via Netbadge to view this page.  From this page, you will need to execute an SQL injection attack.  Note that the only confidential data in that database is the names and userids of the participants, and all of that information is considered "public" knowledge to the participants of the course (FERPA allows release of names; all students in this course are in the [UVa LDAP server](http://www.virginia.edu/cgi-local/ldapweb?asb2t), and the ID numbers were randomly generated).

Your task is to execute at least two SQL injection attacks using this page.  The first is a read-only attack, and from it you must obtain a piece of 'secret' information that is not otherwise displayed from the script.  For the second, you must make a modification to **your entry** in the table.  What modification you make is up to you.  However, the grade listed in the DB after this assignment is completed will be the grade you receive on this part of the assignment.

In your report, you should list the following:

- The exact 'userid' that you entered for each of the attacks
- The 'secret' information that you obtained
- The modification that you made to the database
- The **exact** time stamp for each of the attacks.  This allows us to verify it against the log file.  The time stamp is listed at the bottom of the page, and is the time stamp of the page that was served in response to your attack.

__YOU MAY NOT EXECUTE A DROP TABLE OR TRUNCATE TABLE OR DELETE COMMAND__.  Doing so is an honor violation.  Or any other command that interferes with other students completing their assignment.  This includes updating anybody else's grade.  I don't want to have to go and repair the database because somebody executed this command.

Honor pledge details: you are given permission to execute an SQL injection attack against particular URL for this assignment, as long as the attack does NOT contain a 'drop table', 'truncate', or 'delete' command, or a command that intentionally interferes with other students completing their assignment, or a command that updates another student's grade.

Lastly, please note that all entries are logged (and are not logged in the DB!).  Thus, if the DB is later erased, we can verify that you did (or did not!) properly execute the SQL injection attack.

### Part 2: Cross-site Scripting (XSS) Attack

**NOTE:** Some modern browsers have anti-XSS capability built in that prevents this type of attack.  So if things are working, try a different browser.  Chrome, in particular, does not work well with this type of attack, but Firefox is fine.

First, you should be familiar with Javascript and cross-site scripting attacks.  For review, look at the second half of the [SQL & XSS slide set](..//slides/10-sql-and-xss.html#/).

View the page at https://libra.cs.virginia.edu/~insecure/xss.php - again, you will have to log in via Netbadge to view that page.  From this page, you will need to execute multiple XSS attacks, described below.  Also note that the the account number (which you will need to obtain) is a randomly set number - it is set the first time you access the page, stored in a cookie, and not changed again.  But if you try it from a different computer, you will see a separate account number.

There are six XSS attacks that you must do against this page.  While it seems like a lot, it's really only three separate XSS attacks, and one of them is exactly from the slide set.  So, really, you just have two XSS attacks to perform.

- Perform an XSS attack that will change the account balance to a sufficient enough quantity to make the purchase.  This should be done via a posting to the web form
- Perform the same XSS attack as above, but via a GET variable (i.e. via a URL).
- Perform an XSS attack that will display the account number to the screen.  This must read the Javascript variable and display it, and should be done via a posting to the web form.
- Perform the same XSS attack as above, but via a GET variable (i.e. via a URL).
- Perform an XSS attack that will display the account number to the screen.  This must read via a cookie from the web browser, and display it, and should be done via a posting to the web form.
#- Note that a sophisticated XSS attack would send that account number somewhere over the network - we are just displaying it to the screen
- Perform the same XSS attack as above, but via a GET variable (i.e. via a URL).

In your report, you should list the following:

- The data used in your XSS attack, and whether it was a GET or POST attack
- The 'secret' information that you obtained for the last two attacks
- The **exact** time stamp for each of the attacks.  This allows us to verify it against the log file.  The time stamp is listed at the bottom of the page, and is the time stamp of the page that was served in response to your attack.

A few notes:

- You can use the script at http://www.xav.com/encode.pl to encode your Javascript into URL-encoded text
- When submitting an XSS attack via the submission of the form, you should enter `\n` to represent returns.  When submitting it via  GET variable (i.e. in the URL), you should enter '%0a' for a return.  Note that the conversion script (above) may not convert the returns properly - you may have to do that manually
- To write some text from Javascript to the web page, use 'document.write("foo");'
- To read a cookie in Javascript, print out the document.cookie variable
- Typically, once you have the form posting, you will encode that using the encoder URL, and put that onto the XSS script URL setting the 'userid' variable to the URL-encoded text
- Do not use the plus sign inside your script!  This includes in the document.write() call.  The server sees them as separating GET variables, when you want it to all bee one variable.

Honor pledge details: you are given permission to execute XSS attacks against this particular URL for this assignment.

### Part 3: Packet Sniffing

For this part, we are going to 'listen' to network traffic, and see what interesting information we can find.  We will use a UNIX utility called tcpdump.  This utility will print out all the network traffic on a given interface.  tcpdump must be run as root; thus, you probably cannot run it on any UVa server.  You can download the tcpdump.zip file from Collab's resources -- that file is NOT in this repo due to it's size.  This file contains a dump of a tcpdump session.  We will be analyzing this file.

This file contains my password, so I wanted to ensure that it was properly protected, and I used a 6-character ZIP file password on it.  It's your job to crack that password.  While you can use any ZIP file password cracker that is out there (and there are lots!), we recommend [fcrackzip](http://www.ubuntugeek.com/howto-crack-zip-files-password.html), which you can install on your Linux VirtualBox image via `sudo apt-get install fcrackzip`.  Note that you will need to understand what it does - just running it with very few parameters will just spew out gibberish to the screen.

A packet sniffing utility would run tcpdump, and parse the contents in real-time.  We can do this using something as simple as lex, although more advanced programs (including parsers like yacc or bison) would be more effective.  For this assignment, you won't need to write a program, but can instead just search for the data using any text-search mechanism (including opening it up in your favorite editor and searching the data).  The data was collected using the following command:

```
tcpdump -A -l -s 10000 -i eth0
```

The command line switches do the following:

- `-A` causes the packets to be printed in ASCII (as opposed to binary or hex, which are other command-line switches)
- `-s 10000` causes the maximum printed packet to be 10,000 bytes - if not set, it will only print the first 64 bytes of each packet
- `-i eth0` causes it to 'listen' to the first (and, in this case, only) Ethernet connection.  If you have multiple network connections, this will allow you to monitor only one.  You could set this to listen to the wireless connection, or to all connections.

Many of the pages returned by tcpdump are compressed to save network bandwidth.  This is particularly relevant for popular sites that send a lot of data, such as Facebook or CNN.  You can see this in the packet by the 'Content-Encoding: gzip' header.  One can easily write the data to file, reverse the base-64 encoding, and the un-gzip it (and there are programs that do just that).  For this assignment, we'll be looking just at the non-compressed data.

You will need to analyze the tcpdump.txt file.  Download the tcpdump.zip file from Collab's resources -- that file is NOT in this repo due to it's size.  In your report, you need to answer the following questions:

- What websites were visited that encoded the data using gzip?  We are looking for the domain names (domain.tld), not the exact URL (foo.bar.baz.domain.tld).
- What types of files were transferred?  This is encoded in the 'Content-Type' header.
- What network ports were accessed?  A network port corresponds to an application-level protocol, such as http and https.  This is encoded as `gemini.http-alt` (here `http-alt` means an alternative to http) - see the example packet explanation, below.  The `http-alt` port is 8080 -- you can find this out by looking in `/etc/services`, which maps port names (such as `http-alt`) to port numbers.  We aren't interested in port numbers above 10,000.
- What is the username(s) and password(s) were used when logging in?  Where were they used to log in to?  Not surprisingly, all passwords were changed for this file.  (There is only one that can be sniffed)
- Can you determine my ebay password?  Why or why not?
- What other network-level and transport-level protocols were used, other than TCP?  TCP is used quite frequently (so much so that TCP packets are not labeled as TCP).  You can find a listing of the protocols at http://www.wildpackets.com/resources/compendium/tcp_ip/overview.

A given packet could look like the following.

```
10:31:35.293018 IP gemini.http-alt > pegasus.58878: Flags [P.], seq 4642:4790, ack 2176, win 80, options [nop,nop,TS val 43850520 ecr 38675081], length 148
E`....@.9.....E..........O.........P.......
.....N".st">
  <p>Please enter your UVa userid to obtain your balance: <input type="text" name="userid"
></p>
<input type="submit">
</form>
<hr>
</html>
```

This packet was sent at 10:31:35 from gemini (aka gemini.cs.virginia.edu) to pegasus (my home computer).  It was a http connection (the 'http-alt' means the alternative http port that gemini uses) - so it was sending data.  In fact, this is the last half of the SQL injection attack web page that you used above in part 2.

The uncompressed tcpdump file is 16 Mb.  Thus, it may have problems opening in Notepad.  And just doing Notepad-style searches for all the answers to the above questions will not get you very far - you certainly aren't going to be able to find out all the protocols via searching through Notepad for each packet header (some of the questions may be answered via that type of search, though).  The UNIX utility grep will be your friend here.  Consider the following, which you type from the UNIX command line.

```
grep gemini tcpdump.txt
```

This will search the tcpdump.txt file for all occurrences of gemini.  While it returns 375 lines, that is still only 8% of the entire length of the tcpdump.txt file.  You can also use 'egrep', which allows you to enter a regular expression.  Consider the following.

```
egrep "\[a-z\]\[4\]\[4\]+" tcpdump.txt
```

This takes in the regular expression \[a-z\]\[4\]\[4\]+, and searches for all occurrences of it in the file (there are 20).  Make sure you put your double quotes around the regular expression.

Lastly, note that 'sextans' is the name of one of my routers (all my machines are named after constellations).  So when you see data being transfered between sextans and another host, that's between my computer and said host.

Honor pledge details: you are given permission to search the tcpdump.txt file to answer the above questions for this assignment.  After that, you will need to delete the file.

### Submission

You should submit a file called websecurity.pdf.  Answers to all the above questions should be in that file.
