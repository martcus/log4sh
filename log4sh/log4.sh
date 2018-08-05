#!/usr/bin/env bash
#--------------------------------------------------------------------------------------------------
# Makes logging in Bash scripting simple
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------
APPNAME="log4sh"
VERSION="2.0.0"

# Verbosity levels
fatal_lvl=1
error_lvl=2
warning_lvl=3
info_lvl=4
debug_lvl=5
trace_lvl=6

# Internal function for logging
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

    # if log file is not defined, just echo the output
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

# Internal function for compose the log message
function _compose() {
  local ltime=$1
  local level=$2
  local context=$3
  local text=${4:-}

  if [ ! -z $level ]; then level="${level}"; fi
  echo -e "${ltime} ${level} ${context} ${text}";
}

# Begin Log commands
verb_lvl=${verb_lvl:=$info_lvl}
verbosity=${verbosity:=$info_lvl}

function FATAL() { verb_lvl=$fatal_lvl   _log "FATAL  " "$@" ;}
function ERROR() { verb_lvl=$error_lvl   _log "ERROR  " "$@" ;}
function WARN()  { verb_lvl=$warning_lvl _log "WARNING" "$@" ;}
function INFO()  { verb_lvl=$info_lvl    _log "INFO   " "$@" ;}
function DEBUG() { verb_lvl=$debug_lvl   _log "DEBUG  " "$@" ;}
function TRACE() { verb_lvl=$trace_lvl   _log "TRACE  " "$@" ;}
# End Log commands

# Options command
function _set_verbosity() {
  case $1 in
    FATAL)
      verbosity=$fatal_lvl
      ;;
    ERROR)
      verbosity=$error_lvl
      ;;
    WARNING)
      verbosity=$warning_lvl
      ;;
    INFO)
      verbosity=$info_lvl
      ;;
    DEBUG)
      verbosity=$debug_lvl
      ;;
    TRACE)
      verbosity=$trace_lvl
      ;;
    *)
      echo -e "Error: $0 invalid option '$1'\nTry '$0 --help' for more information.\n"
      exit 1
  esac
}

OPTIND=1
while getopts ":hd:v:f:" opt ; do
  case $opt in
    h)
      echo -e "`basename $0` v$VERSION"
      echo -e "Usage: log4.sh [OPTIONS]"
      echo -e " -h              : Show this help"
      echo -e " -v [LEVEL]      : Define the verbosity level. "
      echo -e "                   Level are: FATAL < ERROR < WARNING < INFO < DEBUG < TRACE"
      echo -e " -d [DATE FORMAT]: Set the date format. Please refer to date command (man date)"
      echo -e " -f [FILE NAME]  : Set the log file name"
      ;;
    v)
      _set_verbosity $OPTARG
      DEBUG "-v specified: $OPTARG mode"
      ;;
    d)
      LOG_TIME_FMT=$OPTARG
      DEBUG "-d specified: $OPTARG date format set"
      ;;
    f)
      LOG_FILE=$OPTARG
      DEBUG "-f specified: $OPTARG log file"
      ;;
    *)
      echo -e "Error: $0 invalid option '$1'."
      echo -e "Try '$0 -h' for more information."
      exit 1
  esac
done

