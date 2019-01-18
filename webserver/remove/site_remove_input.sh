#!/bin/bash
#ввод параметров удаляемого сайта
source /etc/profile
source ~/.bashrc
user=$USER
#Ввод параметров сайта для удаления
    echo "--------------------------------------"
    echo "Удаление виртуального хоста:"
    echo "Список имеющихся доменов для пользователя $user:"
    ls $HOMEPATHWEBUSERS/$user
	echo ''
    echo -n "Введите домен для удаления: "
    read domain
	path=$HOMEPATHWEBUSERS/$user/$domain
	echo ''
#    echo "Список имеющихся пользователей:"
#    getent group www-data
#	echo ''
    
    sudo $SCRIPTS/webserver/remove/site_remove_make.sh $domain $path $user

