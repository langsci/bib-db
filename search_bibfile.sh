#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Usage: search_bibfile.sh BIBFILE TEXT">&2
    echo "Description: This script searches BIBFILE for entries with TEXT as a substring using BibTool.">&2
    exit 1
fi


if [[ -f $1 ]]; then
	bibtool -r bibtool-config.rsc -- select{\"$2\"} $1 -o | less
else
	echo "File $1 not found!">&2
	exit 1
fi


