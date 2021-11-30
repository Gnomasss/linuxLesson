#!/bin/bash

unset fl_h
unset N
unset minsize
unset fl_opt

unset dir

while test $# -gt 0
do
    arg=$1
    shift
    if [[ "${arg:0:1}" == "-" && -z "$fl_opt" ]]
    then
        if [[ "$arg" == "--" ]]; then
            fl_opt=1
            break
        elif [[ "$arg" == "--help" ]]; then
            echo -e "--help help -h human format -N number of files (-10) -s minimum size \ntopsize [--help][-h][-N][-s minsize][--][dir]";
            exit 0
        elif [[ "$arg" == "-h" ]]; then
            fl_h=1
        elif [[ "$arg" == "-s" ]]; then
            minsize=$1
            shift
        elif [[ ${arg:1} == ?(-)+([0-9]) ]]; then
            N="${arg:1}"
        else
            echo "incorrect option $arg" >&2
    	    exit 2 
        fi   
    fi
done

unset fl_dir

for arg in "$@"
do
    if [[ "${arg:0:1}" != "-" ||  "$fl_opt" ]]
    then
        fl_dir=1
        if [[ ! -e "$arg" ]]; then
            echo "dir does not exist" >&2
            exit 2
        fi
        if [[ -n "$N"]]
        then
            if [[ -n "$fl_h" ]]; then
                find $arg -depth -size +$minsize  -type f -exec ls -s -h -1 {} \; | sort -r -h | head -$N 
            else
                find $arg -depth -size +$minsize  -type f -exec ls -s -1 {} \; | sort -r | head -$N
            fi

        else
            if [[ -n "$fl_h" ]]; then
                find $arg -depth -size +$minsize  -type f -exec ls -s -h -1 {} \; | sort -r -h 
            else
                find $arg -depth -size +$minsize  -type f -exec ls -s -1 {} \; | sort -r 
            fi

        fi

    fi

done

if [[ -z "$fl_dir" ]]; then
    echo "specify the direcory" >&2
    exit 2
fi

exit 0