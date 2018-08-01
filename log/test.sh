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
push "Context A"
INFO "Started!"
push "Subtask 1"
INFO "Completed"
pop
push "Subtask 2"
WARN  "Proin eget enim elementum, molestie sem ac"
ERROR "Praesent vehicula pharetra quam eget ultrices"
pop
INFO "Terminated"
pop
INFO "Exiting"

echo -e ""
#
# Modify the date format
#
LOG_TIME_FMT="+%Y%m%d_%H:%M:%S%z"
INFO "You can change the date format! WOW!"