#!/bin/bash
#--------------------------------------------------------------------------------------------------
# Makes logging in Bash scripting smart
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------
source log.sh

#
# Simple message
#
LOG "Standard and simple log message"

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
# Nested Diagnostic Context
#
PUSH "Context A"
INFO "Started!"
PUSH "Subtask 1"
INFO "Completed"
POP
PUSH "Subtask 2"
WARN  "Proin eget enim elementum, molestie sem ac"
ERROR "Praesent vehicula pharetra quam eget ultrices"
POP
INFO "Terminated"
POP
INFO "Exiting"

echo -e ""
#
# Modify the date format
#
LOG_TIME_FMT="+%Y%m%d_%H:%M:%S%z"
INFO "You can change the date format! WOW!"

echo ">>> echo \"Pipe data have the priority\" | INFO \"it's TRUE!\""
echo "Pipe data have the priority" | INFO "it's TRUE!"
