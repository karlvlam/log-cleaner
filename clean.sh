#!/bin/bash
# Script to truncate the container logs
# 1. list log sym links in /var/log/containers ($LOG_BASE)
# 2. check file size in MB of each symlink file
# 3. for each file, truncate the file if file size >= $FILE_LIMIT
# 4. Wait for $SLEEP_TIME seconds 

SLEEP_TIME=67
LOG_BASE=/var/log/containers # container logs location
FILE_LIMIT=10 # file size to be truncated (MB)

# make sure directory exists
if [ ! -d "$LOG_BASE" ]; then
    echo "Error: Directory does not exist: ${LOG_BASE}"
    exit 76
fi

# loop it
while true
do
    TIME=`date +"%Y-%m-%d_%H:%M:%S"`
    cd $LOG_BASE
    for LOG_FILE in `ls *.log`
    do
        SIZE=`du -L -BM ${LOG_FILE} | awk -F 'M' '{ print $1 }'`
        MESSAGE="${TIME} SIZE:${SIZE} FILE:${LOG_FILE}"

        # truncate file
        if [ "$SIZE" -ge "$FILE_LIMIT" ]
        then
            echo > $LOG_BASE/$LOG_FILE
            MESSAGE="${MESSAGE} [Truncated]"
        fi
        echo "${MESSAGE}"
    done
    sleep ${SLEEP_TIME}
done


