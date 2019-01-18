#!/bin/bash
#Вывод всех папок в каталоге $HOMEPATHWEBUSERS
source /etc/profile
source ~/.bashrc

echo ''
echo "Список виртуальных хостов Nginx - sites-available"
ls $NGINXAVAILABLE

echo "Список виртуальных хостов Nginx - sites-enabled"
ls $NGINXENABLED

$MENU/menu_site.sh