#!/bin/bash

BIBFILES=sources/*.bib

for bibfile in $BIBFILES
do
add_bibfile.sh $bibfile
done
