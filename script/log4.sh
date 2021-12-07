#!/usr/bin/env sh
#--------------------------------------------------------------------------------------------------
# Makes logging in Bash scripting smart
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------
LOG4SH_APPNAME="log4sh"
LOG4SH_VERSION="2.4.2"
LOG4SH_BASENAME=$(basename "$0")

readonly LOG4SH_VERSION
readonly LOG4SH_APPNAME
readonly LOG4SH_BASENAME

LOG_TIME_FMT=""
LOG_FILE=""

# internal function - logging
# params:
# [1] verbosity level
# [2] level description
# [3+] log text
_log() {
    log_verb_lvl=${1:-}; shift
    if [ "$log_verb_lvl" -le "$verbosity" ]; then
        log_level=${1:-}; shift
        # build log text from params
        log_text="";
        for var in "$@"; do
            log_text=$log_text" "$var
        done

        # enable pipe use
        if [ ! -t 0 ]; then
            log_text=$(cat)" "${log_text}
        fi

        # if log date format is not defined, use the format "+%Y-%m-%d %H:%M:%S
        if [ -z "$LOG_TIME_FMT" ]; then
            LOG_TIME_FMT=${LOG_TIME_FMT:="+%Y-%m-%d %H:%M:%S"}
        fi
        log_time=$(date "${LOG_TIME_FMT}")

        # if log file is not defined, just echo the output
        if [ -z "$LOG_FILE" ]; then
            _compose "${log_time}" "${log_level}" "${log_text}"
        else
            touch "$LOG_FILE"
            if [ ! -f "$LOG_FILE" ]; then
                _compose "${log_time}" "FATAL Cannot create log file $LOG_FILE. Exiting."
                exit 1;
            fi
            _compose "${log_time}" "${log_level}" "${log_text}" | tee -a "$LOG_FILE";
        fi
    fi
}

# internal function - compose the log message
# params:
# [1] time
# [2] level
# [3] text
_compose() {
    compose_time=${1:-}
    compose_level=${2:-}
    compose_text=${3:-}

    echo -e "${compose_time} ${compose_level} ${compose_text}";
}

# verbosity level constant
readonly off_lvl=0
readonly fatal_lvl=100
readonly error_lvl=200
readonly warning_lvl=300
readonly info_lvl=400
readonly debug_lvl=500
readonly trace_lvl=600

# default value
verbosity=${verbosity:=$info_lvl}

# log functions
FATAL() { _log $fatal_lvl "FATAL" "$@" ;  }
ERROR() { _log $error_lvl "ERROR" "$@" ;  }
WARN()  { _log $warning_lvl "WARN " "$@" ;}
INFO()  { _log $info_lvl "INFO " "$@" ;   }
DEBUG() { _log $debug_lvl "DEBUG" "$@" ;  }
TRACE() { _log $trace_lvl "TRACE" "$@" ;  }
# config functions
SET_LEVEL() { _set_verbosity "$1" ;}
SET_TIME_FORMAT() { LOG_TIME_FMT="$1" ;}

# internal function - set verbosity level
# params:
# [1] verbosity level
_set_verbosity() {
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

_logo() {
    echo -e "   __          ____     __  "
    echo -e "  / /__  ___ _/ / /___ / / "
    echo -e " / / _ \/ _ \`/_  _(_-</ _ \\"
    echo -e "/_/\___/\_, / /_//___/_//_/"
    echo -e "       /___/          $LOG4SH_VERSION"
    echo -e ""
}

# internal function - print help page
_usage() {
    _logo
    echo -e "Usage: $LOG4SH_BASENAME [OPTIONS]"
    echo -e " -h , --help                     : Print this help"
    echo -e " -v , --verbosity [LEVEL]        : Define the verbosity level. "
    echo -e "                                   Levels are: FATAL < ERROR < WARNING < INFO < DEBUG < TRACE | OFF"
    echo -e " -d , --dateformat [DATE FORMAT] : Set the date format. Refer to date command (man date)"
    echo -e " -f , --file [FILE NAME]         : Set the log file name"
    echo -e " -i , --install                  : Auto install log4sh in /usr/bin/. Current user must be a sudoers"
    echo -e "      --version                  : Print version"
    echo -e ""
    echo -e "Exit status:"
    echo -e " 0  if OK,"
    echo -e " 1  if some problems (e.g., cannot access subdirectory)."
    echo -e ""
}

# internal function - print version
_version() {
    _logo
    echo -e "Makes logging in Bash scripting smart"
    echo -e "Copyright (c) Marco Lovazzano"
    echo -e "Licensed under the GNU General Public License v3.0"
    echo -e "http://github.com/martcus"
    echo -e ""
}

# internal function - auto install function
_install() {
    wd=$(pwd)
    basename "$(test -L "$0" && readlink "$0" || echo "$0")" > /tmp/log4sh_tmp
    scriptname=$(echo -e -n "$wd"/ && cat /tmp/log4sh_tmp)
    sudo cp "$scriptname" /usr/bin/log4sh && echo "Congratulations! log4sh Installed!" || echo "Installation failed"
    rm /tmp/log4sh_tmp
}

OPTS=$(getopt -o :d:v:f:hi --long "help,version,verbosity:,file:,dateformat:,install" -n $LOG4SH_APPNAME -- "$@")
OPTS_EXITCODE=$?
# bad arguments, something has gone wrong with the getopt command.
if [ $OPTS_EXITCODE -ne 0 ]; then
    # Option not allowed
    echo -e "Error: '$LOG4SH_BASENAME' invalid option '$1'."
    echo -e "Try '$LOG4SH_BASENAME -h' for more information."
    exit 1
fi

# a little magic, necessary when using getopt.
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
        -i|--install) #auto install
            _install
            shift;;
        --)
            shift
            break;;
    esac
done
