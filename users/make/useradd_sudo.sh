#!/bin/bash
source /etc/profile
source ~/.bashrc
#Добавление пользователя в группу sudo
#$1-username process ; $2-user (создаваемый пользователь)

if [ -n "$1" ] && [ -n "$2" ] 
then

echo ''
echo -e "$COLOR_YELLOW Добавление пользователя в группу sudo $COLOR_NC"

		echo -n -e "Добавить пользователя $COLOR_YELLOW\""$2"\"$COLOR_NC в список $COLOR_YELLOW\"sudo\"$COLOR_NC? введите $COLOR_BLUE\"y\"$COLOR_NC для подтверждения, для выхода - $COLOR_BLUE\"n\"$COLOR_NC: "
		
		while read
		do
			case "$REPLY" in
			y|Y)  adduser $2 sudo;
					echo -e "Пользователь $COLOR_YELLOW" $2 "$COLOR_NC добавлен в список sudo";
					break;;
			n|N)  echo -e "\n$COLOR_YELLOWПользователь $COLOR_LIGHT_PURPLE\"$2\" $COLOR_NC$COLOR_YELLOWсоздан, но не добавлен в список $COLOR_GREEN\"sudo\"$COLOR_NC";  break;;
			esac
		done

else
    echo -e "\n$COLOR_YELLOWПараметры запуска не найдены$COLOR_NC. Необходимы параметры: имя пользователя"
    echo -n -e "$COLOR_YELLOWДля запуска основного меню напишите $COLOR_BLUE\"y\"$COLOR_YELLOW, для выхода - $COLOR_BLUE\"n\"$COLOR_NC:"
	while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y)  $SCRIPTS/menu $1;
				  break;;
			n|N)  exit 0;
			esac
		done

fi