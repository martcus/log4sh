#!/bin/bash
#--------------------------------------------------------------------------------------------------
# Testing script
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

# IFS stands for "internal field separator". It is used by the shell to determine how to do word splitting, i. e. how to recognize word boundaries.
SAVEIFS=$IFS
IFS=$(echo -en "\n\b") # <-- change this as it depends on your app

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

# log4.sh inclusion
source ../script/log4.sh -v TRACE -d +"%Y-%m-%d %H:%M:%S" -f $__base.$(date +%Y%m%d_%H%M%S).log

DEBUG "__dir  = "$__dir
DEBUG "__file = "$__file
DEBUG "__base = "$__base
DEBUG "__root = "$__root

function test_log_func() {
    ERROR ["$0":"$FUNCNAME":"$LINENO"] Test log function
}

echo -e ""

# You can use level message
TRACE "Ultra-fine-grained informational events."
DEBUG "Fine-grained informational events that are most useful to debug an application."
INFO  "Informational messages that highlight the progress of the application at coarse-grained level."
WARN  "Potentially harmful situations."
ERROR "Error events that might still allow the application to continue running."
FATAL "Very severe error events that will presumably lead the application to abort."

echo -e ""
echo -e "sleeping..."
echo -e ""
sleep 1

# Modify the date format
SET_TIME_FORMAT "+%Y%m%d_%H:%M:%S%z"
INFO "Change the date format: +%Y%m%d_%H:%M:%S%z"
echo "Pipe data have the priority" 
INFO "Hello World! -> Classic mode: 'INFO "Hello World!"'"
echo "Hello" | INFO "from the Pipe World! -> Pipe mode priority: 'echo "Hello" | INFO "World!"'"

SET_LEVEL ERROR
SET_TIME_FORMAT "+%Y-%m-%d %H:%M:%S"
INFO "This message will not be printed!"
ERROR "This message WILL be printed!"
test_log_func

# Restore IFS
IFS=$SAVEIFS
exit 0
