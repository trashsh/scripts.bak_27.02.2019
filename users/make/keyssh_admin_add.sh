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
    echo -n -e "$COLOR_YELLOW Для запуска основного меню напишите $COLOR_BLUE\"y\"$COLOR_YELLOW, для выхода - $COLOR_BLUE\"n\"$COLOR_NC:"
	while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y)	$SCRIPTS/menu $1;
					break;;
			n|N)  exit 0;
			esac
		done
fi
