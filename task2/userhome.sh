#!/bin/bash

unset fl_file
unset user
unset file

for arg in "$@"
do
    if [[ "$arg" == "-f" ]]; then
        fl_file=1
    else
        if [[ "$fl_file" && -z "$file" ]]; then
            file=$arg
        else
            user=$arg
        fi
    fi

done

if [[ -z "$file" ]]; then
    file="/etc/passwd" 
fi

if [[ -z "$user" ]]; then
    user=$USER
fi

if [[ ! -e "$file" ]]; then
    echo "file does not exist" >&2
    exit 2
fi

numName="$(cut -d ':' -f 1 $file | grep -w -n -- $user)"

if [[ "$numName" == "" ]]; then
    echo "user does not exist" >&2
    exit 1
fi

num="${numName%:*}"
str=`sed "${num}q;d" $file`



echo $str | cut -d ':' -f 6


