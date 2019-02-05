#!/bin/bash
# $1-username process; $2-db, $3-charset
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] 
then
	mysql -e "CREATE DATABASE IF NOT EXISTS $2 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE $3;"
	echo -e "$COLOR_LIGHT_PURPLEБаза данных $COLOR_YELLOW$2$COLOR_LIGHT_PURPLE с кодировкой $COLOR_YELLOW $3 $COLOR_NC $COLOR_LIGHT_PURPLEсоздана $COLOR_NC"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: Название базы данных"
    echo -n "Для запуска меню управление mysql напишите \"y\", для выхода - любой другой символ: "
    read item
    case "$item" in
        y|Y) $MENU/menu_sql.sh $1
            ;;
        *) echo "Выход..."
            exit 0
            ;;
    esac
fi


