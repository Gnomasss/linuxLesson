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

str="$(grep $user $file)"

if [[ "$str" == "" ]]; then
    echo "user does not exist" >&2
    exit 1
fi

echo $str | cut -d ':' -f 6


