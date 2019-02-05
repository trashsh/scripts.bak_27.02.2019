#!/bin/bash
source /etc/profile
source ~/.bashrc
#$1-$USERNAME process; $2-path
#Создание бэкапа папки

DATE=$(date +%Y%m%d)
TIME=$(date +%H%M)

echo  "$D" "$T"
echo ''
echo -e "$COLOR_YELLOW Создание бэкапа $COLOR_NC"
		
		mkdir -p $BACKUPFOLDER_DAYS/$DATE
		$SCRIPTS/archive/tar_folder_with_structure.sh $1 $2 $BACKUPFOLDER_DAYS/$DATE $(basename $2)_$TIME.tar.gz

		
		