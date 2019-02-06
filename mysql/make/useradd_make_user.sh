#!/bin/bash
# $1-username process; $2-user; $3-pass
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]
then
	mysql -e "CREATE USER '$2'@'localhost' IDENTIFIED BY '$3';"
	mysql -e "FLUSH PRIVILEGES;"
	echo -e "$COLOR_LIGHT_PURPLEПользователь баз данных mysql $COLOR_YELLOW$2$COLOR_LIGHT_PURPLE создан$COLOR_NC"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: имя пользователя mysql, пароль"
	FileParamsNotFound "$1" "Для запуска меню управления базами данных MYSQL введите" "$MENU/sql.sh"  
fi



