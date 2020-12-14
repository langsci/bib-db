#!/bin/bash

#cat sources/* > localbibs.bib

for bibfile in sources/*.bib
do echo $bibfile
   biber --tool $bibfile | grep ERROR
   if ! [[ $(biber --tool $bibfile | grep ERROR | wc -c) -ne 0 ]];
   then mv $bibfile sources/noerrors/;
   fi
done
rm sources/*_bibertool.bib
rm sources/*.blg
