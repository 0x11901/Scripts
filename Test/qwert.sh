#!/usr/bin/env bash

todo="Todo"
regex="^#include.*"

find . -type f -name "*.h" >> ${todo}
find . -type f -name "*.cpp" >> ${todo}

while read file; do
    flag=0
    while read line; do
        if [[ ${line} =~ ${regex} ]]; then
            flag=1
        elif [ ${flag} -eq 1 ]; then
            flag=0
            echo sex!!!
        fi
    done < ${file}
    flag=0
done < ${todo}

rm -f ${todo}