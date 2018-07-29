#!/bin/bash
#--------------------------------------------------------------------------------------------------
# write_log - Makes logging in Bash scripting suck less

# LOG_DATE: if log date is not defined, use the format "+%Y-%m-%d %H:%M:%S
# LOG_FILE: If log file is not defined, just echo the output
#--------------------------------------------------------------------------------------------------

#
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
         else  echo $LOG_TIME": $1 $text"; fi
      else
        LOG=$LOG_FILE.`date +%Y%m%d`
        touch $LOG
        if [ ! -f $LOG ]; then
          echo $LOG_TIME": [ERROR] Cannot create log file $LOG. Exiting.";
          exit 1;
        fi
        echo $LOG_TIME": $text" | tee -a $LOG;
      fi
  done
}
