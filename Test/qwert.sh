#!/usr/bin/env bash

todo="Todo"
regex="^#include.*"
namespace="namespace namespace_name {"

find . -type f -name "*.h" >> ${todo}
find . -type f -name "*.cpp" >> ${todo}

while read file; do
    flag=0
    index=0
    replace=0
    no=0
    while read line; do
        ((++index))
        if [[ ${line} =~ ${regex} ]]; then
            flag=1
            elif [ ${flag} -eq 1 ]; then
            flag=0
            replace=1
            no=${index}
        fi
    done < ${file}
    flag=0
    if [ ${replace} -eq 1 ]; then
        sed -i '' "${no}i\\
        ${namespace}" "${file}"
        echo "}" >> "${file}"
    fi
done < ${todo}

rm -f ${todo}