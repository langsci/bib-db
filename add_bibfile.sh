#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Usage: add_bibfile.sh BIBFILE">&2
    echo "Description: This script adds BIBFILE to langsci.bib using BibTool.">&2
    exit 1
fi

if [[ -f $1 ]]; then
	FILE=$1
	FILENAME="${FILE%%.*}"
	## replace non-ascii symbols by TeX macros 
	biber --tool --output_encoding=ascii $1
	## remove keys  
	perl -pe 's/^(@.*?{).*$/\1,/' "$FILENAME"_bibertool.bib > "$FILENAME"_bibertool_keyless.bib
	## let BibTool do the rest 
	bibtool -r bibtool-config.rsc -i langsci.bib "$FILENAME"_bibertool_keyless.bib -o langsci.bib 2> bibtool.log
	>&2 echo "$(<bibtool.log)"
	## remove temporary files
	rm "$FILENAME"_bibertool.bib "$FILENAME"_bibertool_keyless.bib
else
	echo "File $1 not found!">&2
	exit 1
fi


