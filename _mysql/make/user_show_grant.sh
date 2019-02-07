#!/bin/bash
# $1-username process;E $2-db
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] &&[ -n "$2" ] 
then
	echo -e "$COLOR_LIGHT_PURPLEСписок прав доступа к базам mysql пользователя $COLOR_YELLOW$2$COLOR_LIGHT_PURPLE : $COLOR_NC"
	mysql -e "SHOW GRANTS FOR '$2'@'localhost';"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: Имя пользователя"
    FileParamsNotFound "$1" "Для запуска меню управления базами данных MYSQL введите" "$MENU/sql.sh"  
fi


