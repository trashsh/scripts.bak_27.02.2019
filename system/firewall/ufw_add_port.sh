#!/bin/bash
#$1-$USERNAME
source /etc/profile
source ~/.bashrc

echo ''
echo -e "$COLOR_YELLOW"Добавление порта в firewall ufw " $COLOR_NC"
read -p "Введите номер порта: " PORT
read -p "Введите протокол: " PROTOCOL
read -p "Введите комментарий для правила: " COMMENT


echo -n -e "Для добавления правила с портом $COLOR_YELLOW" $PORT/$PROTOCOL \"$COMMENT\" "$COLOR_NC введите $COLOR_BLUE\"y\"$COLOR_NC, для выхода - $COLOR_BLUE\"n\"$COLOR_NC:" 
while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) ufw allow $PORT/$PROTOCOL comment $COMMENT
					break;;
			n|N)  $MENU/submenu/server_firewall.sh $1
			break;;
			esac
		done


