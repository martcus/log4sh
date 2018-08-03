#!/bin/bash --------------------------------------------------------------------------------------------------
# Makes logging in Bash scripting simple 
# Copyright (c) Marco Lovazzano 
# Licensed under the GNU General Public License v3.0 
# http://github.com/martcus
#--------------------------------------------------------------------------------------------------
APPNAME="dos2unix-custom"
VERSION="0.1.0"

find "$1" -type f -print0 | xargs -0 dos2unix
