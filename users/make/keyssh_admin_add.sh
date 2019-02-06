#!/bin/bash
source /etc/profile
source ~/.bashrc
# Добавления ключа пользователя $USERLAMER в список разрешенных при ssh-подключении
# $1-username process $2-user

if [ -n "$1" ] && [ -n "$2" ] 
then

				cat $SETTINGS/ssh/keys/lamer >> $HOMEPATHWEBUSERS/$2/.ssh/authorized_keys
		
	else
    echo -e "\n$COLOR_YELLOW Параметры запуска не найдены$COLOR_NC. Необходимы параметры: имя пользователя"
    FileParamsNotFound "$1" "Для запуска главного введите" "$SCRIPTS/menu"  
fi
