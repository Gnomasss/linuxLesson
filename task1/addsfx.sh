#!/bin/bash

unset fl_opt
unset fl_v
unset fl_d

for arg in "$@"
do
    if [[ "${arg:0:1}" == "-" && -z "$fl_opt" ]]
    then
        if [[ "$arg" == "--" ]]; then
            fl_opt=1
            break
        elif [[ "$arg" == "-h" ]]; then
            echo -e "-h help -v verbose -d dry run \naddsfx [-h|-v|-d] [--] suffix file... ";
            exit 0
        elif [[ "$arg" == "-v" ]]; then
            fl_v=1
        elif [[ "$arg" == "-d" ]]; then
            fl_d=1
        else
            echo "incorrect option" >&2
    	    exit 2 
        fi   
    fi
done

unset sfx
unset fl_opt
unset fl_file
ex=0
for arg in "$@"
do
    if [[ "${arg:0:1}" != "-" ||  "$fl_opt" ]]
    then
        
        if [[ -z "$sfx" ]]; then
            sfx=$arg
            #echo $sfx

        else
            fl_file=1
            name="${arg%.*}"
            ext="${arg#$name}"

            #echo "$HOME/test/$arg"
            if [[ ! -e "$arg" ]]; then
                echo "file $arg does not exist" >&2
                exit 2
            fi
            

            if [[ "$fl_d" || "$fl_v" ]]; then
                echo "'$arg' -> '$name$sfx$ext'"
            fi

            

            if [[ -z "$fl_d" ]]; then
                if ! mv -- "$arg" "$name$sfx$ext"; then
                    echo "can't rename file $arg" >&2
                    ex=1
                fi
            fi
        fi


    elif [[ "$arg" == "--" ]]; then
        fl_opt=1
    fi

done

if [[ -z "$sfx" ]]; then
    echo "incorrect input. no suffix" >&2
    exit 2
fi

if [[ -z "$fl_file" ]]; then
    echo "incorrect input. no files" >&2
    exit 2
fi



exit $ex