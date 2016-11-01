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
perl -pi -e 's/\{\s*([a-z])([a-z])/\{\\small\{\u\1\}\2/g if m/^\s*author\s*=/' "$BIBFILENAME"_bibertool.bib 
perl -pi -e 's/\{\s*(\047t)\s/\{\\apostrophe\{T\} /g if m/^\s*author\s*=/' "$BIBFILENAME"_bibertool.bib 

## second run with BibTool to merge input into target (entries of target should get priority) 
echo "bibtool (2nd run) ..."
bibtool -r bibtool-config.rsc -i $TARGET "$BIBFILENAME"_bibertool.bib -o $TARGET 2> $TARGETPATH/bibtool-2nd.log
>&2 echo "$(<$TARGETPATH/bibtool-2nd.log)" 


echo "sanity check ..."
bibtool -- select.non{author} $TARGET | bibtool -- select.non{editor} | bibtool -- add.field{fixme=authoreditor} -o $TARGETPATH/sc-authoreditor.bib

bibtool -- 'select{@collection @proceedings}' $TARGET | bibtool -- 'select.non{year editor booktitle address publisher}' | bibtool -- add.field{fixme=missing} -o $TARGETPATH/sc-coll-missing.bib
bibtool -- 'select{@collection @proceedings}' $TARGET | bibtool -- 'select{author journal pages chapter school type}' | bibtool -- add.field{fixme=toomuch} -o $TARGETPATH/sc-coll-toomuch.bib

bibtool -- select{@article} $TARGET | bibtool -- 'select.non{title year journal volume}' | bibtool -- add.field{fixme=missing} -o $TARGETPATH/sc-article-missing.bib
bibtool -- select{@article} $TARGET | bibtool -- 'select{booktitle editor edition series chapter address publisher school type}' | bibtool -- add.field{fixme=toomuch} -o $TARGETPATH/sc-article-toomuch.bib

bibtool -- select{@book} $TARGET | bibtool -- 'select.non{title year address publisher}' | bibtool -- add.field{fixme=missing} -o $TARGETPATH/sc-book-missing.bib
bibtool -- select{@book} $TARGET | bibtool -- 'select{journal pages chapter school type}' | bibtool -- add.field{fixme=toomuch} -o $TARGETPATH/sc-book-toomuch.bib

bibtool -- 'select{@incollection @inproceedings}' $TARGET | bibtool -- 'select.non{author year title booktitle editor pages address publisher }' | bibtool -- add.field{fixme=missing} -o $TARGETPATH/sc-incoll-missing.bib
bibtool -- 'select{@incollection @inproceedings}' $TARGET | bibtool -- 'select{journal number school type}' | bibtool -- add.field{fixme=toomuch} -o $TARGETPATH/sc-incoll-toomuch.bib

bibtool -- select{@thesis} $TARGET | bibtool -- 'select.non{author year type school publisher}' | bibtool -- add.field{fixme=missing} -o $TARGETPATH/sc-thesis-missing.bib
bibtool -- select{@thesis} $TARGET | bibtool -- 'select{booktitle editor series journal volume pages chapter}' | bibtool -- add.field{fixme=toomuch} -o $TARGETPATH/sc-thesis-toomuch.bib

bibtool -- select{@techreport} $TARGET | bibtool -- 'select.non{author year address publisher}' | bibtool -- add.field{fixme=missing} -o $TARGETPATH/sc-techreport-missing.bib
bibtool -- select{@techreport} $TARGET | bibtool -- 'select{booktitle editor edition journal volume pages chapter school type}' | bibtool -- add.field{fixme=toomuch} -o $TARGETPATH/sc-article-toomuch.bib

bibtool -- select{@unpublished} $TARGET | bibtool -- 'select.non{author year note}' | bibtool -- add.field{fixme=missing} -o $TARGETPATH/sc-unpublished-missing.bib
bibtool -- select{@unpublished} $TARGET | bibtool -- 'select{howpublished booktitle editor edition series journal volume number pages chapter address publisher school type}' | bibtool -- add.field{fixme=toomuch} -o $TARGETPATH/sc-unpublished-toomuch.bib

# TODO: merge sc-files with $TARGET

echo "postprocessing with perl ..."
## replace \small in von-parts of names
perl -pi -e 's/\\small\{(.)\}/\l\1/g' $TARGET
perl -pi -e 's/\\apostrophe\{T\}/\047t/g' $TARGET

## clean up: remove temporary files of biber
rm "$BIBFILENAME"_bibertool.*
rm $TARGETPATH/sc-*
	

echo ""


