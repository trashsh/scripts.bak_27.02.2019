#!/bin/bash
#$1-user
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] 
then
	echo -e "$COLOR_YELLOW"Удаление пользователя $1" $COLOR_NC"
	mysql -e "DROP USER '$1'@'localhost';"
	echo -e "$COLOR_YELLOW"Пользователь $1 удален" $COLOR_NC"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: имя пользователя mysql"
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

