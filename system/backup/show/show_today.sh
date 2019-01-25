#!/bin/bash
source /etc/profile
source ~/.bashrc

echo ''
DATE=$(date +%Y%m%d)
echo -e "$COLOR_YELLOW"Список бэкапов за сегодня - $DATE" $COLOR_NC"
echo -e "$COLOR_BROWN"$BACKUPFOLDER_DAYS/$DATE:" $COLOR_NC"
ls -l $BACKUPFOLDER_DAYS/$DATE


