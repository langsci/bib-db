#!/bin/bash

BIBFILES=sources/*.bib

for bibfile in $BIBFILES
do
bash add_bibfile.sh $bibfile localbibs.bib
done
