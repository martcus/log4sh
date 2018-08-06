#!/bin/bash
#--------------------------------------------------------------------------------------------------
# Makes logging in Bash scripting smart
# Copyright (c) Marco Lovazzano
# Licensed under the GNU General Public License v3.0
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------
source log4.sh -d +"%Y-%m-%d %H:%M:%S" -v TRACE

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

echo "Pipe data have the priority" | INFO "it's TRUE!"
