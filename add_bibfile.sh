#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Usage: add_bibfile.sh BIBFILE">&2
    echo "Description: This script adds BIBFILE to langsci.bib using BibTool.">&2
    exit 1
fi

for FILE in $@
do
	echo "Processing $FILE"
if [[ -f $FILE ]]; then
	FILENAME="${FILE%%.*}"
	## replace non-ascii symbols by TeX macros 
	echo "... biber"
	biber -q --tool --output_encoding=ascii $FILE
	## first run with BibTool to resolve crossrefs and to add timestamps
	bibtool -r bibtool-config.rsc -r bibtool-timestamp-config -i "$FILENAME"_bibertool.bib -o "$FILENAME"_bibertool.bib 2> bibtool-1st.log
	>&2 echo "$(<bibtool-1st.log)"
	## remove keys  
	perl -pe 's/^(@.*?{).*$/\1,/' "$FILENAME"_bibertool.bib > "$FILENAME"_bibertool_keyless.bib
	## second run with BibTool to merge into langsci.bib 
	bibtool -r bibtool-config.rsc -i langsci.bib "$FILENAME"_bibertool_keyless.bib -o langsci.bib 2> bibtool-2nd.log
	>&2 echo "$(<bibtool-2nd.log)"
	## remove temporary files
	rm "$FILENAME"_bibertool.bib "$FILENAME"_bibertool_keyless.bib
else
	echo "File $FILE not found!">&2
	exit 1
fi
	echo ""
done


