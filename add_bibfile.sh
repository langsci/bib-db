#!/bin/bash

if [ $# -ne 2 ]
  then
    echo "Usage: add_bibfile.sh BIBFILE TARGET">&2
    echo "Description: This script adds BIBFILE to TARGET using BibTool and biber.">&2
    echo "Tested on: TODO.">&2
    exit 1
fi

BIBFILE=$1
if [[ -f $BIBFILE ]]; then
	BIBFILENAME=${BIBFILE%%.*}	# including path
else
	echo "Bibfile $BIBFILE not found!">&2
	exit 1
fi

TARGET=$2
if [[ -f $TARGET ]]; then
		TARGETNAME=${TARGET%%.*}	# including path
		TARGETPATH=${TARGET%/*}
else
	echo "Target $TARGET not found!">&2
	exit 1
fi

## replace non-ascii symbols by TeX macros; creates "$BIBFILENAME"_bibertool.bib
echo "biber ..."
biber -q --tool --output_encoding=ascii $BIBFILE

## first run with BibTool to resolve crossrefs and to add timestamps
echo "bibtool (1st run) ..."
bibtool -r bibtool-config.rsc -r bibtool-timestamp-config -i "$BIBFILENAME"_bibertool.bib -o "$BIBFILENAME"_bibertool.bib 2> $TARGETPATH/bibtool-1st.log
>&2 echo "$(<$TARGETPATH/bibtool-1st.log)"

echo "preprocessing with perl ..."
## remove keys  
perl -pi -e 's/^(@.*?{).*$/\1,/' "$BIBFILENAME"_bibertool.bib 
## insert \small in von-parts of names
perl -pi -e 's/\{\s*([a-z])([a-z])/\{\\small\{\u\1\}\2/g if m/^\s*author\s=/' "$BIBFILENAME"_bibertool.bib 
perl -pi -e 's/\{\s*(\047t)\s/\{\\apostrophe\{T\} /g if m/^\s*author\s=/' "$BIBFILENAME"_bibertool.bib 

## second run with BibTool to merge into target 
echo "bibtool (2nd run) ..."
bibtool -r bibtool-config.rsc -i $TARGET "$BIBFILENAME"_bibertool.bib -o $TARGET 2> $TARGETPATH/bibtool-2nd.log
>&2 echo "$(<$TARGETPATH/bibtool-2nd.log)"

echo "postprocessing with perl ..."
## replace \small in von-parts of names
perl -pi -e 's/\\small\{(.)\}/\l\1/g' $TARGET
perl -pi -e 's/\\apostrophe\{T\}/\047t/g' $TARGET

## clean up: remove temporary files of biber
# rm "$BIBFILENAME"_bibertool.*
	

echo ""


