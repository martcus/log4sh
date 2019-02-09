#!/usr/bin/env bash
#--------------------------------------------------------------------------------------------------
# Makes logging in Bash scripting smart
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------
LOG4SH_APPNAME="log4sh"
LOG4SH_VERSION="2.2.1"

# Internal function for logging
function _log {
    local verb_lvl=${1:-}
    if [ $verb_lvl -le $verbosity ]; then
        local level=${2:-}
        local text=${3:-}

        if [ ! -t 0 ]; then
            text=$(cat)" "${text}
        fi

        # if log date format is not defined, use the format "+%Y-%m-%d %H:%M:%S
        LOG_TIME_FMT=${LOG_TIME_FMT:="+%Y-%m-%d %H:%M:%S"}
        LOG_TIME=$(date "${LOG_TIME_FMT}")

        # if log file is not defined, just echo the output
        if [ -z "$LOG_FILE" ]; then
            _compose "${LOG_TIME}" "${level}" "${context[@]}" "${text}"
        else
            touch "$LOG_FILE"
            if [ ! -f "$LOG_FILE" ]; then
                _compose "${LOG_TIME}" "FATAL" "${context[@]}" "Cannot create log file $LOG_FILE. Exiting."
                exit 1;
            fi
            _compose "${LOG_TIME}" "${level}" "${context[@]}" "${text}" | tee -a "$LOG_FILE";
        fi
    fi
}

# Internal function for compose the log message
function _compose() {
    local ltime=${1:-}
    local level=${2:-}
    local context=${3:-}
    local text=${4:-}

    echo -e "${ltime} ${level} ${context} ${text}";
}

# Log function and verbosity levels
off_lvl=0
fatal_lvl=100
error_lvl=200
warning_lvl=300
info_lvl=400
debug_lvl=500
trace_lvl=600

verbosity=${verbosity:=$info_lvl}

function FATAL()     { _log $fatal_lvl "FATAL" "$@" ;}
function ERROR()     {  _log $error_lvl "ERROR" "$@" ;}
function WARN()      { _log $warning_lvl "WARN " "$@" ;}
function INFO()      { _log $info_lvl "INFO " "$@" ;}
function DEBUG()     { _log $debug_lvl "DEBUG" "$@" ;}
function TRACE()     { _log $trace_lvl "TRACE" "$@" ;}
function SET_LEVEL() { _set_verbosity "$1" ;}

# Options command
function _set_verbosity() {
    case $1 in
        OFF)     verbosity=$off_lvl     ;;
        FATAL)   verbosity=$fatal_lvl   ;;
        ERROR)   verbosity=$error_lvl   ;;
        WARNING) verbosity=$warning_lvl ;;
        INFO)    verbosity=$info_lvl    ;;
        DEBUG)   verbosity=$debug_lvl   ;;
        TRACE)   verbosity=$trace_lvl   ;;
        *)
            echo -e "Error: '$0' invalid option '$1'."
            echo -e "Try '$0 -h' for more information."
            exit 1
    esac
}

function _usage() {
    echo -e ""
    echo -e "$(basename $0) v$LOG4SH_VERSION"
    echo -e "Usage: $(basename $0) [OPTIONS]"
    echo -e " -h , --help                     : Print this help"
    echo -e " -v , --verbosity [LEVEL]        : Define the verbosity level. "
    echo -e "                                   Levels are: FATAL < ERROR < WARNING < INFO < DEBUG < TRACE | OFF"
    echo -e " -d , --dateformat [DATE FORMAT] : Set the date format. Refer to date command (man date)"
    echo -e " -f , --file [FILE NAME]         : Set the log file name"
    echo -e "      --version                  : Print version"
    echo -e ""
    echo -e "Exit status:"
    echo -e " 0  if OK,"
    echo -e " 1  if some problems (e.g., cannot access subdirectory)."
    echo -e ""
}

function _version() {
    echo -e ""
    echo -e "$(basename $0) v$LOG4SH_VERSION"
    echo -e "Makes logging in Bash scripting smart"
    echo -e "Copyright (c) Marco Lovazzano"
    echo -e "Licensed under the GNU General Public License v3.0"
    echo -e "http://github.com/martcus"
    echo -e ""
}

OPTS=$(getopt -o :d:v:f:h --long "help,version,verbosity:,file:,dateformat:" -n $LOG4SH_APPNAME -- "$@")
OPTS_EXITCODE=$?
#Bad arguments, something has gone wrong with the getopt command.
if [ $OPTS_EXITCODE -ne 0 ]; then
    #Option not allowed
    echo -e "Error: '$(basename $0)' invalid option '$1'."
    echo -e "Try '$(basename $0) -h' for more information."
    exit 1
fi

# A little magic, necessary when using getopt.
eval set -- "$OPTS"

while true; do
    case "$1" in
        -h|--help)
            _usage
            shift;;
        --version)
            _version
            shift;;
        -v|--verbosity) #Verbosity
            _set_verbosity "$2"
            shift 2;;
        -d|--dateformat) #Date format
            date "$2" > /dev/null 2>&1
            DATE_EXITCODE=$?
            if [ ! $DATE_EXITCODE -eq 0 ]; then
                echo "Error: '$0' '-d $2' is not a valid date format. Refer to date command (man date)"
                exit 1
            fi
            LOG_TIME_FMT=$2
            shift 2;;
        -f|--file) #Print to file
        LOG_FILE="$2"
            shift 2;;
        --)
            shift
            break;;
    esac
done
