#!/usr/bin/env bash

now=`date "+%Y%m%d%H%M%S"`

baseDir="/Users/wangjingkai/Library/Application Support/ZeroNet/data"
users_json="${baseDir}/users.json"
sites_json="${baseDir}/sites.json"
mutes_json="${baseDir}/mutes.json"

ls "$baseDir"