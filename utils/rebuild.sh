#!/bin/bash
# Function to write to the Log file
source write_log.sh

read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # do dangerous stuff
    echo "Reset ReadyMedia" | write_log
    rm -rf /mnt/dietpi_userdata/.MiniDLNA_Cache/* && systemctl restart minidlna | write_log
    exit 1
else
    echo "Nothing" | log_info
fi
