#!/bin/bash
source /etc/profile
source ~/.bashrc

echo ''
echo -e -n "$COLOR_BLUE"Укажите дату в формате yyyy-mm-dd:" $COLOR_NC"

read DATE

echo -e "$COLOR_YELLOW"Список бэкапов $DATE" $COLOR_NC"
ls -l $BACKUPFOLDER_DAYS/$DATE





