#!/bin/bash
source /etc/profile
source ~/.bashrc
#$1-$USERNAME

echo ''
echo -e -n "$COLOR_BLUE"Укажите дату в формате yyyymmdd:" $COLOR_NC"

read DATE

echo -e "$COLOR_YELLOW"Список бэкапов $DATE" $COLOR_NC"
ls -l $BACKUPFOLDER_DAYS/$DATE





