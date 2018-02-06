#!/usr/bin/env bash

################# variable define##########
now=`date "+%Y%m%d%H%M%S"`

baseDir="/Users/wangjingkai/Library/Application Support/ZeroNet/data"
users_json="./users.json"
sites_json="./sites.json"
mutes_json="./mutes.json"

cloud_backup_dir="/Users/wangjingkai/Library/Mobile\ Documents/com~apple~CloudDocs/ZoreNet"
local_backup_dir="/Users/wangjingkai/资源/归档/ZoreNet"

###########MAIN##################
# check directory exist
if [ ! -d "${cloud_backup_dir}" ]; then
    mkdir -p "${cloud_backup_dir}"
fi
if [ ! -d "$local_backup_dir" ]; then
    mkdir -p "$local_backup_dir"
fi

# tar and gzip
cd "${baseDir}"
tar -zcvf "${cloud_backup_dir}/zeroNetBackup+${now}.tar.gz" "${users_json}" "${sites_json}" "${mutes_json}"
# tar -zcvf "${local_backup_dir}/zeroNetBackup+${now}.tar.gz" "${users_json}" "${sites_json}" "${mutes_json}"

num=`ls -l "${cloud_backup_dir}" |grep "^-"|wc -l`
if [ ${num} -gt 5 ]; then
    num=`expr ${num} - 5`
    ls -tr "${cloud_backup_dir}" | head -${num} | xargs
fi

echo `ls -l "${cloud_backup_dir}" |grep "^-"|wc -l`
