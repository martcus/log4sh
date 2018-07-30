#!/bin/bash
#--------------------------------------------------------------------------------------------------
# write_log - Makes logging in Bash scripting suck less
# LOG_FILE: If log file is not defined, just echo the output
#--------------------------------------------------------------------------------------------------

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
write_log()
{
  while read text
  do
      # if log date is not defined, use the format "+%Y-%m-%d %H:%M:%S
      if [ "$LOG_TIME" == "" ]; then
        LOG_TIME=`date "+%Y-%m-%d %H:%M:%S"`
      fi
      # If log file is not defined, just echo the output
      if [ "$LOG_FILE" == "" ]; then
         if [ "$1" == "" ]; then echo $LOG_TIME": $text";
         else echo $LOG_TIME": [$1] $text"; fi
      else
        LOG=$LOG_FILE.`date +%Y%m%d`
        touch $LOG
        if [ ! -f $LOG ]; then
          echo $LOG_TIME": [ERROR] Cannot create log file $LOG. Exiting.";
          exit 1;
        fi
        echo $LOG_TIME": [$1] $text" | tee -a $LOG;
      fi
  done
}
# End Logging Section
