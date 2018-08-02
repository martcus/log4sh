#!/bin/bash
#--------------------------------------------------------------------------------------------------
# Makes logging in Bash scripting simple
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------
APPNAME="log"
VERSION="1.1.0"

# Begin Help Section
HELP_TEXT=""

# This function is called in the event of an error.
# Scripts which source this script may override by defining their own "usage" function
usage() {
    echo -e "${HELP_TEXT}";
    exit 1;
}
# End Help Section


# verbosity levels
fatal_lvl=1
error_lvl=2
warning_lvl=3
info_lvl=4
debug_lvl=5
trace_lvl=6

# Begin Context Section
context=() # Nested Diagnostic Context

function PUSH() {
  while [ "$1" ]; do
    context+=("$1"); shift
  done
}
function POP() {
  unset context[${#context[@]}-1]
}
function _join_by() {
  local IFS="$1"; shift
  echo "$*"
}
# End Context Section

# Begin Logging Section
function _log {
  if [ $verb_lvl -le $verbosity ]; then

    local level=$1
    local text=$2
    local pipe=

    if [ ! -t 0 ]; then
      text=$(cat)
    fi

    # if log date format is not defined, use the format "+%Y-%m-%d %H:%M:%S
    LOG_TIME_FMT=${LOG_TIME_FMT:="+%Y-%m-%d %H:%M:%S"}
    LOG_FILE=${LOG_FILE:=""}
    LOG_TIME=$(date "${LOG_TIME_FMT}")

    # If log file is not defined, just echo the output
    if [ "$LOG_FILE" == "" ]; then
      _compose "${LOG_TIME}" "${level}" "${context[@]}" "${text}"
    else
      LOG=$LOG_FILE.`date +%Y%m%d`
      touch $LOG
      if [ ! -f $LOG ]; then
        _compose "${LOG_TIME}" "FATAL" "${context[@]}" "Cannot create log file $LOG. Exiting."
        exit 1;
      fi
      _compose "${LOG_TIME}" "${level}" "${context[@]}" "${text}" | tee -a $LOG;
    fi

  fi
}

function _compose() {
  local ltime=$1
  local level=$2
  local context=$3
  local text=$4

  if [ ! -z $level ]; then level="${level}"; fi
#  echo -e "$(_join_by ' ' ${ltime} ${level} ${context} ${text})";
  echo -e "${ltime} ${level} ${context} ${text}";
}
# End Logging Section

# Begin Log commands
verb_lvl=${verb_lvl:=$info_lvl}
verbosity=${verbosity:="6"}

function LOG()   { _log "" "$@"; }
function FATAL() { verb_lvl=$fatal_lvl   _log "FATAL  " "$@" ;}
function ERROR() { verb_lvl=$error_lvl   _log "ERROR  " "$@" ;}
function WARN()  { verb_lvl=$warning_lvl _log "WARNING" "$@" ;}
function INFO()  { verb_lvl=$info_lvl    _log "INFO   " "$@" ;}
function DEBUG() { verb_lvl=$debug_lvl   _log "DEBUG  " "$@" ;}
function TRACE() { verb_lvl=$trace_lvl   _log "TRACE  " "$@" ;}
# End Log commands
