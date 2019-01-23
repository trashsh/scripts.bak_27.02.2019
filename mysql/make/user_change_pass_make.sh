#!/bin/bash
#$1-user; $2-pass
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] 
then
	echo -e "$COLOR_YELLOW"Смена пароля для пользователя $1" $COLOR_NC"
	mysql -e "ALTER USER '$1'@'localhost' IDENTIFIED WITH mysql_native_password BY '$2';"
	echo -e "$COLOR_YELLOW"Пароль пользователя $1 изменен" $COLOR_NC"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: имя пользователя mysql, пароль"
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



