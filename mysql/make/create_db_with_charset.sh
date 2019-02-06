#!/bin/bash
# $1-username process; $2-db, $3-COLLATE; $4-CHARACTERSET
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] && [ -n "$4" ] 
then
	mysql -e "CREATE DATABASE IF NOT EXISTS $2 CHARACTER SET $4 COLLATE $3;"
	
	echo -e "$COLOR_LIGHT_PURPLEБаза данных $COLOR_YELLOW$2$COLOR_LIGHT_PURPLE с кодировкой $COLOR_YELLOW $3 $COLOR_NC $COLOR_LIGHT_PURPLEсоздана $COLOR_NC"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: Название базы данных"
    FileParamsNotFound "$1" "Для запуска меню управления базами данных MYSQL введите" "$MENU/sql.sh"  
fi


