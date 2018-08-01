#!/bin/bash
#--------------------------------------------------------------------------------------------------
# Makes logging in Bash scripting smart
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------

LOG_APPNAME="log"
LOG_VERSION=1.0.0

# Begin Global variables
context=() # Nested Diagnostic Context
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

# Begin Context Section
function push() {
  while [ "$1" ]; do
    context+=("$1"); shift
  done
}
function pop() {
  unset context[${#context[@]}-1]
}
function join_by() {
  local IFS="$1"; shift
  echo "$*"
}
# End Context Section

# Begin Logging Section
function _log {
  local level=$1
  local text=$2
  local pipe=

  if [ ! -t 0 ]; then
    pipe=$(cat)
  else
    pipe=""
  fi
  
  # if log date format is not defined, use the format "+%Y-%m-%d %H:%M:%S
  LOG_TIME_FMT=${LOG_TIME_FMT:="+%Y-%m-%d %H:%M:%S"}
    
  LOG_TIME=[$(date "${LOG_TIME_FMT}")]

  # If log file is not defined, just echo the output
  if [ "$LOG_FILE" == "" ]; then
    _compose "${LOG_TIME}" "${level}" "${context[@]}" "${text}" "${pipe}"
  else
    LOG=$LOG_FILE.`date +%Y%m%d`
    touch $LOG
    if [ ! -f $LOG ]; then
      _compose "${LOG_TIME}" "FATAL" "${context[@]}" "Cannot create log file $LOG. Exiting."
      exit 1;
    fi
    _compose "${LOG_TIME}" "${level}" "${context[@]}" "${text}" "${pipe}" | tee -a $LOG;
  fi
}

function _compose() {
  local ltime=$1
  local level=$2
  local context=$3
  local text=$4
  local pipe=$5

  if [ ! -z $level ]; then
    level="[${level}]"
  fi
  echo -e "$(join_by ' ' ${ltime} ${level} ${context} ${text} ${pipe})";
}
# End Logging Section

# Begin Log commands
LOG() { _log "" "$1"; }
FATAL() { _log FATAL "$1"; }
ERROR() { _log ERROR "$1"; }
WARN() { _log WARN "$1"; }
INFO() { _log INFO "$1"; }
DEBUG() { _log DEBUG "$1"; }
TRACE() { _log TRACE "$1"; }
# End Log commands
