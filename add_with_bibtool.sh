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
		TARGETPATH="$( cd "$( dirname "$TARGET" )" && pwd )"    # TARGETPATH=${TARGET%/*}
		TARGETTIME=$(date -Iseconds -r "$TARGET")
else
	echo "Target $TARGET not found!">&2
	exit 1
fi

BT_CONFIG=bibtool/config.rsc

## dump a backup
echo "dumping backup file $TARGET-$TARGETTIME ..."
cp $TARGET "$TARGET"-"$TARGETTIME"

## clean up: remove temporary files
rm "$BIBFILENAME"_bibertool.* 2> /dev/null
rm $TARGETPATH/sc-* 2> /dev/null

## replace non-ascii symbols by TeX macros; creates "$BIBFILENAME"_bibertool.bib
echo "biber ..."
biber -q --tool --output_encoding=ascii $BIBFILE

## first run with BibTool to resolve crossrefs and to add timestamps
echo "bibtool (1st run) ..."
bibtool -r $BT_CONFIG -i "$BIBFILENAME"_bibertool.bib -o "$BIBFILENAME"_bibertool.bib 2> $TARGETPATH/bibtool-1st.log
>&2 echo "$(<$TARGETPATH/bibtool-1st.log)"

echo "preprocessing with perl ..."
## remove keys  
perl -pi -e 's/^(@.*?{).*$/\1,/' "$BIBFILENAME"_bibertool.bib 
## insert \small in von-parts of names
perl -pi -e 's/\{\s*([a-z])([a-z])/\{\\small\{\u\1\}\2/g if m/^\s*author\s*=/' "$BIBFILENAME"_bibertool.bib 
perl -pi -e 's/\{\s*(\047t)\s/\{\\apostrophe\{T\} /g if m/^\s*author\s*=/' "$BIBFILENAME"_bibertool.bib 

## second run with BibTool to merge input into target (entries of target should get priority) 
echo "bibtool (2nd run) ..."
bibtool -r $BT_CONFIG -i $TARGET "$BIBFILENAME"_bibertool.bib -o $TARGET 2> $TARGETPATH/bibtool-2nd.log
>&2 echo "$(<$TARGETPATH/bibtool-2nd.log)" 

## sanity check
echo "sanity check ..."
function sanity-check {
bibtool -- select.non{author} -r $BT_CONFIG $TARGET | bibtool -- select.non{editor} -r $BT_CONFIG | bibtool -- add.field{fixme=authoreditor} -r $BT_CONFIG -o $TARGETPATH/sc-authoreditor.bib

bibtool -- 'select{@collection @proceedings}' -r $BT_CONFIG $TARGET | bibtool -- 'select.non{year editor booktitle address publisher}' -r $BT_CONFIG | bibtool -- add.field{fixme=incomplete} -r $BT_CONFIG -o $TARGETPATH/sc-coll-incomplete.bib
bibtool -- 'select{@collection @proceedings}' -r $BT_CONFIG $TARGET | bibtool -- 'select{author journal pages chapter school type}' -r $BT_CONFIG | bibtool -- add.field{fixme=toomuch} -r $BT_CONFIG -o $TARGETPATH/sc-coll-toomuch.bib

bibtool -- select{@article} -r $BT_CONFIG $TARGET | bibtool -- 'select.non{title year journal volume}' -r $BT_CONFIG | bibtool -- add.field{fixme=incomplete} -r $BT_CONFIG -o $TARGETPATH/sc-article-incomplete.bib
bibtool -- select{@article} -r $BT_CONFIG $TARGET | bibtool -- 'select{booktitle editor edition series chapter address publisher school type}' -r $BT_CONFIG | bibtool -- add.field{fixme=toomuch} -r $BT_CONFIG -o $TARGETPATH/sc-article-toomuch.bib

bibtool -- select{@book} -r $BT_CONFIG $TARGET | bibtool -- 'select.non{title year address publisher}' -r $BT_CONFIG | bibtool -- add.field{fixme=incomplete} -r $BT_CONFIG -o $TARGETPATH/sc-book-incomplete.bib
bibtool -- select{@book} -r $BT_CONFIG $TARGET | bibtool -- 'select{journal pages chapter school type}' -r $BT_CONFIG | bibtool -- add.field{fixme=toomuch} -r $BT_CONFIG -o $TARGETPATH/sc-book-toomuch.bib

bibtool -- 'select{@incollection @inproceedings}' -r $BT_CONFIG $TARGET | bibtool -- 'select.non{author year title booktitle editor pages address publisher }' -r $BT_CONFIG | bibtool -- add.field{fixme=incomplete} -r $BT_CONFIG -o $TARGETPATH/sc-incoll-incomplete.bib
bibtool -- 'select{@incollection @inproceedings}' -r $BT_CONFIG $TARGET | bibtool -- 'select{journal number school type}' -r $BT_CONFIG | bibtool -- add.field{fixme=toomuch} -r $BT_CONFIG -o $TARGETPATH/sc-incoll-toomuch.bib

bibtool -- select{@thesis} -r $BT_CONFIG $TARGET | bibtool -- 'select.non{author year type school publisher}' -r $BT_CONFIG | bibtool -- add.field{fixme=incomplete} -r $BT_CONFIG -o $TARGETPATH/sc-thesis-incomplete.bib
bibtool -- select{@thesis} -r $BT_CONFIG $TARGET | bibtool -- 'select{booktitle editor series journal volume pages chapter}' -r $BT_CONFIG | bibtool -- add.field{fixme=toomuch} -r $BT_CONFIG -o $TARGETPATH/sc-thesis-toomuch.bib

bibtool -- select{@techreport} -r $BT_CONFIG $TARGET | bibtool -- 'select.non{author year address publisher}' -r $BT_CONFIG | bibtool -- add.field{fixme=incomplete} -r $BT_CONFIG -o $TARGETPATH/sc-techreport-incomplete.bib
bibtool -- select{@techreport} -r $BT_CONFIG $TARGET | bibtool -- 'select{booktitle editor edition journal volume pages chapter school type}' -r $BT_CONFIG | bibtool -- add.field{fixme=toomuch} -r $BT_CONFIG -o $TARGETPATH/sc-article-toomuch.bib

bibtool -- select{@unpublished} -r $BT_CONFIG $TARGET | bibtool -- 'select.non{author year note}' -r $BT_CONFIG | bibtool -- add.field{fixme=incomplete} -r $BT_CONFIG -o $TARGETPATH/sc-unpublished-incomplete.bib
bibtool -- select{@unpublished} -r $BT_CONFIG $TARGET | bibtool -- 'select{howpublished booktitle editor edition series journal volume number pages chapter address publisher school type}' -r $BT_CONFIG | bibtool -- add.field{fixme=toomuch} -r $BT_CONFIG -o $TARGETPATH/sc-unpublished-toomuch.bib

if [ ! -z "$(ls $TARGETPATH/sc-*)" ]
then
		for SCFILE in $( ls $TARGETPATH/sc-* ); do
				bibtool -r $BT_CONFIG -- -i $SCFILE $TARGET -o $TARGET   # Entries in $SCIFILE are favored. 
		done
fi 
}
sanity-check # turn off sanity check here

echo "postprocessing with perl ..."
## replace \small in von-parts of names
perl -pi -e 's/\\small\{(.)\}/\l\1/g' $TARGET
perl -pi -e 's/\\apostrophe\{T\}/\047t/g' $TARGET

echo "cleaning up ..."
## clean up: remove temporary files
rm "$BIBFILENAME"_bibertool.* 2> /dev/null
rm $TARGETPATH/sc-* 2> /dev/null

echo "Done. You can use \`git diff\` to see what has changed."	





