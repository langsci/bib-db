#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Usage: add_bibfile.sh BIBFILE ...">&2
    echo "Description: This script adds BIBFILES(s) to langsci.bib using BibTool.">&2
    exit 1
fi

if [[ -f $1 ]]; then
	bibtool -r bibtool-config.rsc -i langsci.bib $1 -o langsci.bib 2> bibtool.log
	>&2 echo "$(<bibtool.log)"
else
	echo "File $1 not found!">&2
	exit 1
fi


