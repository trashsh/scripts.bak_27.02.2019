#!/bin/bash
# $1-username process; $2-mysql username; $3-sort collumn
#Выпод списка пользователей, которые содержат в названии определенное значение
source /etc/profile
source ~/.bashrc


if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] 
then
echo -e "$COLOR_LIGHT_PURPLE \nПеречень пользователей mysql, содержащих в названии \"$2\" $COLOR_NC"
mysql -e "SELECT User,Host,Grant_priv,Create_priv,Drop_priv,Create_user_priv FROM mysql.user WHERE User like '%%$2%%' ORDER BY $3 ASC"

else
    echo -e "\n$COLOR_YELLOW Параметры запуска не найдены$COLOR_NC. Необходимы параметры: имя пользователя mysql, столбец для сортировки"
    echo -n -e "$COLOR_YELLOW Для запуска основного меню напишите $COLOR_BLUE\"y\"$COLOR_YELLOW, для выхода - $COLOR_BLUE\"n\"$COLOR_NC:"
	while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) $SCRIPTS/menu $1;
					break;;
			n|N)  exit 0;
			esac
		done

fi


