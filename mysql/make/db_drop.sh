#!/bin/bash
# $1-username process; $2-db
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] && [ -n "$2" ] 
then
	mysql -e "DROP DATABASE IF EXISTS $2;"
	echo -e "$COLOR_LIGHT_PURPLEБаза данных $COLOR_YELLOW$2$COLOR_LIGHT_PURPLE удалена $COLOR_NC"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: имя пользователя mysql"
    FileParamsNotFound "$1" "Для запуска меню управления базами данных MYSQL введите" "$MENU/sql.sh"  
fi

