#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Usage: add_bibfile.sh BIBFILES">&2
    echo "Description: This script adds BIBFILES to langsci.bib using BibTool.">&2
    exit 1
fi

for FILE in $@
do
	echo "Processing $FILE"
if [[ -f $FILE ]]; then
	FILENAME="${FILE%%.*}"

	## replace non-ascii symbols by TeX macros 
	echo "biber ..."
	biber -q --tool --output_encoding=ascii $FILE

	## first run with BibTool to resolve crossrefs and to add timestamps
	echo "bibtool (1st run) ..."
	bibtool -r bibtool-config.rsc -r bibtool-timestamp-config -i "$FILENAME"_bibertool.bib -o "$FILENAME"_bibertool.bib 2> bibtool-1st.log
	>&2 echo "$(<bibtool-1st.log)"

	echo "preprocessing with perl ..."
	## remove keys  
	perl -pi -e 's/^(@.*?{).*$/\1,/' "$FILENAME"_bibertool.bib 
	## insert \small in von-parts of names
	perl -pi -e 's/\{\s*([a-z])([a-z])/\{\\small\{\u\1\}\2/g if m/^\s*author\s=/' "$FILENAME"_bibertool.bib 
	perl -pi -e 's/\{\s*(\047t)\s/\{\\apostrophe\{T\} /g if m/^\s*author\s=/' "$FILENAME"_bibertool.bib 

	## second run with BibTool to merge into langsci.bib 
	echo "bibtool (2nd run) ..."
	bibtool -r bibtool-config.rsc -i langsci.bib "$FILENAME"_bibertool.bib -o langsci.bib 2> bibtool-2nd.log
	>&2 echo "$(<bibtool-2nd.log)"

	echo "postprocessing with perl ..."
	## replace \small in von-parts of names
	perl -pi -e 's/\\small\{(.)\}/\l\1/g' langsci.bib
	perl -pi -e 's/\\apostrophe\{T\}/\047t/g' langsci.bib

	## clean up: remove temporary files
	rm "$FILENAME"_bibertool.bib
else
	echo "File $FILE not found!">&2
	exit 1
fi
	echo ""
done


