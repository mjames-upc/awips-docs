---
layout: default
type: guide
title: Logging Users
subtitle: EDEX Admin
---

If you are interested in what clients are connecting to your EDEX server, use this script to scour the `edex-request-thriftSrv*` logs for unique domains and append each daily record to a file that is stored outside of the `/awips2` directory structure (to preserve the files in the case of a full system reinstallation.)

## Bash script

    # !/bin/bash
    TODAY=$(date +%Y%m%d)
    YMD=$(date +%Y%m%d -d "$TODAY - 1 day")
    LOG_PATH=/awips2/edex/logs

    # Print unique CAVE users in this log file
    if [ -f ${LOG_PATH}/edex-request-thriftSrv-${YMD}.log ]; then
      userList=$(cat ${LOG_PATH}/edex-request-thriftSrv-${YMD}.log |grep ":CAVE:"|cut -d "[" -f 3| cut -d ":" -f 1 | |sort | uniq)
      echo " -- EDEX Users ${YMD} --"
      echo "$userList"
      echo ""
    fi
    
## Crontab

    0 1 * * * /home/awips/user_scour.sh >> /home/awips/user_scour.log 2>&1

The thriftSrv logs are rotated at 00 UTC, so the last time written to yesterday's file will be ahead of US time zones.  Make sure you account for system time in your cron entry. For UTC systems, the crontab entry will look like:

