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


