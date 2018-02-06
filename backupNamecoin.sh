#!/usr/bin/env bash

################# variable define##########
now=`date "+%Y%m%d%H%M%S"`

baseDir="/Users/wangjingkai/Library/Application Support/Namecoin"
wallet_dat="./wallet.dat"

cloud_backup_dir="/Users/wangjingkai/Library/Mobile Documents/com~apple~CloudDocs/Namecoin"
local_backup_dir="/Users/wangjingkai/资源/归档/Namecoin"

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
tar -zcvf "${cloud_backup_dir}/namecoinBackup+${now}.tar.gz" "${wallet_dat}"
tar -zcvf "${local_backup_dir}/namecoinBackup+${now}.tar.gz" "${wallet_dat}"

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