#!/bin/bash
source /etc/profile
source ~/.bashrc
# $1-username $2-user
echo ''
echo -e "$COLOR_YELLOW Добавление пользователя в группу sudo $COLOR_NC"

		echo -n -e "Добавить пользователя $COLOR_YELLOW" $2 "$COLOR_NC в список sudo? введите $COLOR_BLUE\"y\"$COLOR_NC для подтверждения, для выхода - любой символ: "
		read item
		case "$item" in
			y|Y) echo
				adduser $2 sudo
				echo -e "Пользователь $COLOR_YELLOW" $2 "$COLOR_NC добавлен в список sudo"
				;;
			*) echo -e "Пользователь $COLOR_YELLOW" $2 "$COLOR_NC создан, но не добавлен в список sudo"
				;;
			esac		




