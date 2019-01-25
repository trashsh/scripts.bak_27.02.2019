#!/bin/bash
# $1-$USERNAME $2-db
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


