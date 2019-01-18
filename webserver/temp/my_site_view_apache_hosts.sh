#!/bin/bash
#Вывод всех папок в каталоге $HOMEPATHWEBUSERS
source /etc/profile
source ~/.bashrc

echo ''
echo "Список виртуальных хостов Apache - sites-available"
ls $APACHEAVAILABLE

echo "Список виртуальных хостов Apache - sites-enabled"
ls $APACHEENABLED

$MENU/menu_site.sh