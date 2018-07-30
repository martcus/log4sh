#!/bin/bash
source log.sh

LOG_LEVEL_DEFAULT="INFO"
	
LOG "This is a simple test to check the write_log function"
FATAL "fatal message"
ERROR "error message"
WARN  "warning message"
INFO "info message"
DEBUG  "debug message"