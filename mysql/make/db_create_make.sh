#!/bin/bash
#$1-db
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] 
then
	echo -e "$COLOR_YELLOW"Создание базы данных $1 с кодировкой utf8_general_ci" $COLOR_NC"
	mysql -e "CREATE DATABASE IF NOT EXISTS $1 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
	echo -e "$COLOR_YELLOW"База данных $1 создана" $COLOR_NC"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: Название базы данных"
    echo -n "Для запуска меню управление mysql напишите \"y\", для выхода - любой другой символ: "
    read item
    case "$item" in
        y|Y) $MENU/menu_sql.sh
            ;;
        *) echo "Выход..."
            exit 0
            ;;
    esac
fi


