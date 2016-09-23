#!/bin/bash
# Script to truncate the container logs
# 1. list log sym links in /var/log/containers ($LOG_BASE)
# 2. check file size in MB of each symlink file
# 3. for each file, truncate the file if file size >= $FILE_LIMIT
# 4. Wait for $SLEEP_TIME seconds 

while true
do
    SLEEP_TIME=67
    LOG_BASE=/var/log/containers # container logs location
    FILE_LIMIT=10 # file size to be truncated (MB)
    TIME=`date +"%Y-%m-%d_%H:%M:%S"`
    cd $LOG_BASE
    for LOG_FILE in `ls *.log`
    do
        SIZE=`du -L -BM ${LOG_FILE} | awk -F 'M' '{ print $1 }'`
        MESSAGE="${TIME} SIZE:${SIZE} FILE:${LOG_FILE}"
        if [ "$SIZE" -ge "$FILE_LIMIT" ]
        then
            #echo > $LOG_BASE/$LOG_FILE
            MESSAGE="${MESSAGE} [Truncated]"
        fi
        echo "${MESSAGE}"
    done
    sleep ${SLEEP_TIME}
done


