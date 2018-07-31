#!/bin/bash
#--------------------------------------------------------------------------------------------------
# write_log - Makes logging in Bash scripting suck less
# LOG_FILE: If log file is not defined, just echo the output
#--------------------------------------------------------------------------------------------------

LOG_APPNAME="log"
LOG_VERSION=0.1.0

# Begin Global variables

# End Global variables

# Begin Help Section
HELP_TEXT=""

# This function is called in the event of an error.
# Scripts which source this script may override by defining their own "usage" function
usage() {
    echo -e "${HELP_TEXT}";
    exit 1;
}
# End Help Section

# Begin Logging Section
function _log
{
    local level=$1
	local text=$2

    if [ ! -t 0 ]
    then
        pipe=$(cat)
    else
        pipe=""
    fi

	# if log date is not defined, use the format "+%Y-%m-%d %H:%M:%S
      if [ "$LOG_TIME" == "" ]; then
        LOG_TIME=`date "+%Y-%m-%d %H:%M:%S"`
      fi
      # If log file is not defined, just echo the output
      if [ "$LOG_FILE" == "" ]; then
         if [ "$1" == "" ]; then echo $LOG_TIME ${level} ${text} ${pipe};
         else echo $LOG_TIME ${level} ${text} ${pipe}; fi
      else
        LOG=$LOG_FILE.`date +%Y%m%d`
        touch $LOG
        if [ ! -f $LOG ]; then
          echo $LOG_TIME" ERROR Cannot create log file $LOG. Exiting.";
          exit 1;
        fi
        echo $LOG_TIME ${level} ${text} ${pipe} | tee -a $LOG;
      fi
}
# End Logging Section

# Begin Log commands
LOG() { _log "$1"; }

FATAL() { _log FATAL "$1"; }
ERROR() { _log ERROR "$1"; }
WARN() { _log WARN "$1"; }
INFO() { _log INFO "$1"; }
DEBUG() { _log DEBUG "$1"; }
# End Log commands
