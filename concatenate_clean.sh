#!/bin/bash

#remove comments. This messes up any inline comments at this point.
sed -i '/^\s*%/d' sources/noerrors/*.bib
sed -i '/^\s*$/d' sources/noerrors/*.bib

# concatenate, hopefully deduplicate
bibtool -s -d sources/noerrors/*.bib > localbibs.bib
