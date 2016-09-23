#!/bin/sh
# Script to truncate the container logs
# 1. list log sym links in /var/log/containers ($LOG_BASE)
# 2. check file size in MB of each symlink file
# 3. for each file, truncate the file if file size >= $FILE_LIMIT
# 4. Wait for $SLEEP_TIME seconds 
##########################################################
### !!!Alpine Linux only have POSIX shell installed!!! ###
### !!!Alpine Linux only have POSIX shell installed!!! ###
### !!!Alpine Linux only have POSIX shell installed!!! ###
##########################################################
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
    ls *.log > /dev/null
    if [ "$?" -ne 0 ]
    then
        echo "${TIME} Error: files not found! Retry after ${SLEEP_TIME} seconds..."
    else
        for LOG_FILE in `ls *.log`
        do
            SIZE=`du -L -m ${LOG_FILE} | awk '{ print $1 }'`
            MESSAGE="${TIME} SIZE:${SIZE} FILE:${LOG_FILE}"

            # truncate file
            if [ "$SIZE" -ge "$FILE_LIMIT" ]
            then
                > $LOG_BASE/$LOG_FILE
                MESSAGE="${MESSAGE} [Truncated]"
            fi
            echo "${MESSAGE}"
        done
    fi
    sleep ${SLEEP_TIME}
done


