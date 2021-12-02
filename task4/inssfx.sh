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
            echo -e "-h help -v verbose -d dry run \ninssfx [-h|-v|-d] [--] suffix file dir mask1 [mask2...] ";
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
unset dir
unset fl_mask
ex=0
masks=(find)
for arg in "$@"
do
    if [[ "${arg:0:1}" != "-" ||  "$fl_opt" ]]
    then
        
        if [[ -z "$sfx" ]]; then
            sfx=$arg
            #echo $sfx
        elif [[ -z "$dir" ]]; then
            dir=$arg
            masks+=( $dir -depth  )
            #masks+=( \( )
            #echo $ind
            
            #echo ${masks[$ind]}1
            #echo $ind
        else
            if [[ -z "$fl_mask" ]]; then
                
                fl_mask=1
                masks+=( -name "$arg" -type f )
                masks+=( -print0 )
                #masks+=( -exec ls -s {}  \; )
                #echo ${masks[$ind]}
            else
                
                masks+=( -o -name "$arg" -type f)
                #masks+=( -exec ls -s  {}  \; )
                masks+=( -print0 )
                
            fi
            
        fi

    fi
    #echo $arg" "$ind

done

if [[ -z "$sfx" ]];then
    echo "incorrect input. no sfx" >&2
    exit 2
fi

if [[ -z "$dir" ]];then
    echo "incorrect input. no dir" >&2
    exit 2
fi

if [[ -z "$fl_mask" ]];then
    echo "incorrect input. no mask" >&2
    exit 2
fi


#masks+=(  )
#echo "${masks[@]}"
#"${masks[@]}" 
if [[ -n "$fl_d" ]]; then
    if [[ -n "$fl_v" ]]; then
        "${masks[@]}" | xargs -0 bash ../task1/addsfx.sh -d -v -- $sfx
    else
        "${masks[@]}" | xargs -0 bash ../task1/addsfx.sh -d -- $sfx
    fi
else
    if [[ -n "$fl_v" ]]; then
        "${masks[@]}" | xargs -0 bash ../task1/addsfx.sh -v -- $sfx
    else
        "${masks[@]}" | xargs -0 bash ../task1/addsfx.sh -- $sfx
    fi
fi



exit 0