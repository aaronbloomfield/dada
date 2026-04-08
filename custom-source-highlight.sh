#!/bin/bash

# this will call source-highlight on the files provided as command line
# parameters.  It then updates the resulting .html files for the
# accessibility requirements.

# sed operates differently on different systems
SED="sed -i"
if [ x`uname` == x"Darwin" ]; then
	SED="sed -i .todel"
fi

# go through each file passed as a command-line parameter
for file in "$@"
do

	# source-highlight does not know about Solidity files, and they should be
	# formatted like C++ files
	extension=${file: -4}
	if [ x$extension == x.sol ]; then
		source-highlight -d -s cpp $file
	else
		source-highlight -d $file
	fi

	# ensure that the <html> tag has a lang='en' attribute
	$SED s/"<html>"/"<html lang='en'>"/ $file.html

	# ensure that the page content, which is already enclosed in a <pre> tag,
	# is enclosed in a <main> tag as well
	$SED s/"<pre>"/"<main><pre>"/ $file.html
	$SED s_"</pre>"_"</pre></main>"_ $file.html
	$SED s/'\"#FF0000\"'/'\"#EF0000\"'/g $file.html
	$SED s/'\"#009900\"'/'\"#008A00\"'/g $file.html

	# the Mac (Darwin) version of sed makes backup files, so delete them
	/bin/rm -f *.todel
done
