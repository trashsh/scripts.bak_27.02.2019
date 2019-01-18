#!/bin/bash
source /etc/profile
source ~/.bashrc
#$1-path

DATE=$(date +%Y-%m-%d)
TIME=$(date +%H-%M)

echo  "$D" "$T"
echo ''
echo -e "$COLOR_YELLOW Создание бэкапа $COLOR_NC"
		
		mkdir -p $BACKUPFOLDER_DAYS/$DATE
		tar -czvf $BACKUPFOLDER_DAYS/$DATE/$(basename $1)_$TIME.tar.gz $1
		
		