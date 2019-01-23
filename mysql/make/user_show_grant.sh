#!/bin/bash
#$1-db
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] 
then
	echo -e "$COLOR_YELLOW"Список прав доступа к базам mysql пользователя $1" $COLOR_NC"
	mysql -e "SHOW GRANTS FOR '$1'@'localhost';"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: Имя пользователя"
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


