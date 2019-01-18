#!/bin/bash
#Вывод всех папок в каталоге $HOMEPATHWEBUSERS
source /etc/profile
source ~/.bashrc

clear
echo ''
echo 'Список всех сайтов в каталоге' $HOMEPATHWEBUSERS:
ls $HOMEPATHWEBUSERS

echo '---'
echo -n "Apache - sites-available: "
ls $APACHEENABLED
echo  -n "Apache - sites-enabled: "
ls $APACHEAVAILABLE
echo '---'
echo  -n "Nginx - sites-available: "
ls $NGINXAVAILABLE
echo  -n "Nginx - sites-enabled: "
ls $NGINXENABLED
echo ''

$MENU/menu_site.sh