#!/usr/bin/env bash

set -euo pipefail

################# variable define ##########
now=`date "+%Y%m%d%H%M%S"`

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

xcode_dir="${HOME}/Library/Developer/Xcode/UserData"
cloud_backup_dir="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/XcodeBackup"
local_backup_dir="${HOME}/资源/归档/XcodeBackup"

xcode_backup_database="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/BackupDatabase"

code_snippets="CodeSnippets"
font_and_color_themes="FontAndColorThemes"
key_bindings="KeyBindings"

temp="DoNotModify"
database="${xcode_backup_database}/${temp}"

########### MAIN ##################
# check directory exist
if [ ! -d "${cloud_backup_dir}" ]; then
    echo "${red}iCloud Drive备份路径不存在！${reset}"
    mkdir -p "${cloud_backup_dir}"
    echo "${green}自动创建iCloud Drive备份路径：${reset}${cloud_backup_dir}"
else
    echo "${green}iCloud Drive备份路径:${reset}${cloud_backup_dir}"
fi

if [ ! -d "${local_backup_dir}" ]; then
    echo "${red}本地备份路径不存在！${reset}"
    mkdir -p "${local_backup_dir}"
    echo "${green}自动创建本地备份路径：${reset}${local_backup_dir}"
else
    echo "${green}本地备份路径:${reset}${cloud_backup_dir}"
fi

if [ ! -d "${xcode_backup_database}" ]; then
    echo "${red}同步数据库路径不存在！${reset}"
    mkdir -p "${xcode_backup_database}"
    echo "${green}自动创建数据库路径：${reset}${local_backup_dir}"
else
    echo "${green}数据库路径:${reset}${cloud_backup_dir}"
fi

sqlite3 "${database}" 'create table if not exists backupXcode(id integer primary key not NULL,key integer unique not NULL,value integer not NULL);'

#获取最后修改时间
cd "${xcode_dir}"
find "./${code_snippets}" "./${font_and_color_themes}" "./${key_bindings}" -type f >> ${temp}

while read path; do
    key=`md5 -q -s "${path}"`
    value=`stat -f "%m" "${path}"`
    isModify=`sqlite3 "${database}" "select value from backupXcode where key == '${key}';"`
    if [ -z ${isModify} ]; then
        echo "${yellow}本地Xcode配置尚未同步${reset}！"
        num=`ls -l "${cloud_backup_dir}" |grep "^-"|wc -l`
        if [ ${num} -ge 1 ]; then
            echo "${green}找到最新的Xcode配置，开始自动替换${reset}！"
            
            cd "${xcode_dir}"
            ## backup before
            zip -r "XcodeBackup.zip" "${code_snippets}" "${font_and_color_themes}" "${key_bindings}"
            
            cd ${cloud_backup_dir}
            newBackup=`ls -t | head -1`
            unzip -u "${newBackup}" -d "${xcode_dir}"
            
            cd "${xcode_dir}"
            rm ${temp}
            find "./${code_snippets}" "./${font_and_color_themes}" "./${key_bindings}" -type f >> ${temp}
            echo 更新数据库...
            while read path; do
                key=`md5 -q -s "${path}"`
                value=`stat -f "%m" "${path}"`
                sqlite3 "${database}" "insert or replace into backupXcode values(NULL,'${key}',${value});" &
            done < ${temp}
        fi
        break
    fi
    if [ ${isModify} != ${value} ]; then
        echo "${yellow}本地Xcode配置已经过期${reset}！"
        num=`ls -l "${cloud_backup_dir}" |grep "^-"|wc -l`
        if [ ${num} -ge 1 ]; then
            echo "${green}找到最新的Xcode配置，开始自动替换${reset}！"
            
            cd "${xcode_dir}"
            ## backup before
            zip -r "XcodeBackup.zip" "${code_snippets}" "${font_and_color_themes}" "${key_bindings}"
            
            cd ${cloud_backup_dir}
            newBackup=`ls -t | head -1`
            unzip -u "${newBackup}" -d "${xcode_dir}"
            
            cd "${xcode_dir}"
            rm ${temp}
            find "./${code_snippets}" "./${font_and_color_themes}" "./${key_bindings}" -type f >> ${temp}
            echo 更新数据库...
            while read path; do
                key=`md5 -q -s "${path}"`
                value=`stat -f "%m" "${path}"`
                sqlite3 "${database}" "insert or replace into backupXcode values(NULL,'${key}',${value});" &
            done < ${temp}
        fi
        break
    fi
done < ${temp}

wait
rm ${temp}

# zip files
#cd "${xcode_dir}"
#zip -r "${cloud_backup_dir}/XcodeBackup+${now}.zip" "${code_snippets}" "${font_and_color_themes}" "${key_bindings}" &
#zip -r "${local_backup_dir}/XcodeBackup+${now}.zip" "${code_snippets}" "${font_and_color_themes}" "${key_bindings}" &

wait

# delete unnecessary backup files
num=`ls -l "${cloud_backup_dir}" |grep "^-"|wc -l`
if [ ${num} -gt 5 ]; then
    num=`expr ${num} - 5`
    cd "${cloud_backup_dir}"
    ls -tr "${cloud_backup_dir}" | head -${num} | xargs rm
fi

num=`ls -l "${local_backup_dir}" |grep "^-"|wc -l`
if [ ${num} -gt 5 ]; then
    num=`expr ${num} - 5`
    cd "${local_backup_dir}"
    ls -tr "${local_backup_dir}" | head -${num} | xargs rm
fi