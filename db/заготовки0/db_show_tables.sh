#!/bin/bash
# $1-username process; $2-db
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] &&[ -n "$2" ] 
then
	mysql -e "USE [$2];"
	mysql -e "SHOW TABLES;"
	echo -e "$COLOR_LIGHT_PURPLEТаблицы базы данных $COLOR_YELLOW$2$COLOR_NC"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: Имя пользователя, Название базы данных"
    FileParamsNotFound "$1" "Для запуска меню управления базами данных MYSQL введите" "$MENU/sql.sh"  
fi


