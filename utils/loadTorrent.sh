#!/bin/bash
# Script di caricamento massivo di file .torrent su transmission

source write_log.sh

#TORRENT_PATH=/mnt/dietpi_userdata/transmission
#PROCESSED_PATH=/mnt/dietpi_userdata/transmission/processed/
TORRENT_PATH=/mnt/samba/torrent

#gestione dei file con gli spazi nel nome
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

if [ -z "$(ls -A $TORRENT_PATH)" ]; then
    echo "Directory is empty" | write_log
    exit 0
fi

for f in $TORRENT_PATH/*.torrent
do
  echo "Adding $f ..." | write_log
  # take action on each file. $f store current file name
  transmission-remote -n 'pi:raspberry' -a $f | write_log
  if [ $? -eq 0 ]; then
    echo "Removing $f ..." | write_log
    sudo rm $f
  else
    echo "Error on $f ..." | write_log
  fi
done

IFS=$SAVEIFS

exit 0
