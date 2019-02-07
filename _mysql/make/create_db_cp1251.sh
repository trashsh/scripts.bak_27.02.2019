#!/bin/bash
# $1-username process; $2-db
source /etc/profile
source ~/.bashrc

if [ -n "$2" ] 
then
	mysql -e "CREATE DATABASE IF NOT EXISTS $2 CHARACTER SET cp1251 COLLATE cp1251_general_ci;"
	echo -e "$COLOR_LIGHT_PURPLEБаза данных $COLOR_YELLOW$2$COLOR_LIGHT_PURPLE с кодировкой $COLOR_YELLOW cp1251_general_ci $COLOR_NC $COLOR_LIGHT_PURPLEсоздана $COLOR_NC"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: Название базы данных"
    FileParamsNotFound "$1" "Для запуска меню управления базами данных MYSQL введите" "$MENU/sql.sh"  
fi


