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
source ../script/log4.sh -v TRACE -d +"%Y-%m-%d %H:%M:%S"

DEBUG "__dir  = "$__dir
DEBUG "__file = "$__file
DEBUG "__base = "$__base
DEBUG "__root = "$__root

echo -e ""
#
# Simple message
#
INFO "Standard log message"

echo -e ""
#
# You can use level message
#
TRACE  "Sed lorem leo"
DEBUG  "In ligula nunc, commodo et tincidunt ac"
INFO "Integer purus neque, pharetra in mollis non, pretium vitae enim"
WARN  "Proin eget enim elementum, molestie sem ac"
ERROR "Praesent vehicula pharetra quam eget ultrices"
FATAL "Lorem ipsum dolor sit amet, consectetur adipiscing"

echo -e ""
#
# Modify the date format
#
LOG_TIME_FMT="+%Y%m%d_%H:%M:%S%z"
INFO "You can change the date format! WOW!"

echo "Pipe data have the priority" 
INFO "Hello World! -> CLASSIC MODE: 'INFO "Hello World!"'"
echo "Hello" | INFO "World! -> PIPE MODE: 'echo "Hello" | INFO "World!"'"

# Restore IFS
IFS=$SAVEIFS
exit 0