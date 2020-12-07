#!/bin/bash
base_url='https://raw.githubusercontent.com/langsci/'
file='/master/localbibliography.bib'
found_log=()
notfound_log=()

for var in $(eval echo {$1..$2});
do
    url="$base_url$var$file"
    if  curl -s --head  --request GET ${url} | grep "404" > /dev/null
    then
	echo "Output URL returning 404 ${url}"
	notfound_log+=("$var")
	
    else
	echo "Downloading bibliography for book number $var..."
	curl $url -o "sources/$var.bib"
	found_log+=("$var")
    fi

done
#printf "$s\n" "${notfound_log[@]}" > notfound.log
echo ${found_log[@]} > found.log
echo ${notfound_log[@]} > notfound.log

