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

code_snippets="CodeSnippets"
font_and_color_themes="FontAndColorThemes"
key_bindings="KeyBindings"

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

# zip files
cd "${xcode_dir}"
zip -r "${cloud_backup_dir}/XcodeBackup+${now}.zip" "${code_snippets}" "${font_and_color_themes}" "${key_bindings}" &
zip -r "${local_backup_dir}/XcodeBackup+${now}.zip" "${code_snippets}" "${font_and_color_themes}" "${key_bindings}" &

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