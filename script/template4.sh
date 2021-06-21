#!/usr/bin/env bash
#--------------------------------------------------------------------------------------------------
# Template script
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
__base="$(basename "${__file}".sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)" # <-- change this as it depends on your app

# log4.sh inclusion
# shellcheck disable=SC1091
source ./log4.sh -v TRACE #-d "+%Y-%m-%d %H:%M:%S" # use -f $__base.$(date +%Y%m%d_%H%M%S).log

DEBUG "__dir  = $__dir"
DEBUG "__file = $__file"
DEBUG "__base = $__base"
DEBUG "__root = $__root"
echo -e ""
# --> function

# --> Some script here
TRACE "Ultra-fine-grained informational events."
DEBUG "Fine-grained informational events that are most useful to debug an application."
INFO  "Informational messages that highlight the progress of the application at coarse-grained level."
WARN  "Potentially harmful situations."
ERROR "Error events that might still allow the application to continue running."
FATAL "Very severe error events that will presumably lead the application to abort."

# Restore IFS
IFS=$SAVEIFS
exit 0
