#!/bin/bash
source /etc/profile
source ~/.bashrc
# $1-username process;
#Отобразить все базы, содержащие определенное значение

echo "Список баз данных, содержащих опредленное заничение:"	
    echo -n -e "${COLOR_BLUE} Введите название(часть названия) базы данных ${COLOR_NC}: "
    read db
    echo -e "Список баз данных пользователя:"
	$SCRIPTS/info/mysql/db_view_by_name.sh $1 $db
