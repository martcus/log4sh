#!/bin/bash
source write_log.sh

LOG_FILE=test

echo "--------" | write_log
echo "This is a simple test to check the write_log function" | write_log
echo "--------" | write_log
echo "You can concat with command (ls | write_log)" | write_log
ls | write_log
echo "--------" | write_log
