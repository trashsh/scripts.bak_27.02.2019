#!/bin/bash
source /etc/profile
source ~/.bashrc

echo ''
DATE=$(date --date yesterday "+%Y%m%d")
echo -e "$COLOR_YELLOW"Список бэкапов за вчерашний день - $DATE" $COLOR_NC"
echo -e "$COLOR_BROWN"$DATE:" $COLOR_NC"
ls -l $BACKUPFOLDER_DAYS/$DATE


