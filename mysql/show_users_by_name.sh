#!/bin/bash
source /etc/profile
source ~/.bashrc
# $1-username process; $2-username
#Отобразить всех пользователей, содержащих определенное значение в имени

echo "Список пользователей, содержащих опредленное заничение:"	
    echo -n -e "${COLOR_BLUE} Введите имя(часть имени) пользователя mysql ${COLOR_NC}: "
    read username
    echo -e "Список баз данных пользователя:"
	$SCRIPTS/info/mysql/users_view_by_name.sh $1 $username User
