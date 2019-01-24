#!/bin/bash
#$1-user; $2-pass
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] 
then
	mysql -e "GRANT ALL PRIVILEGES ON *.* To '$1'@'localhost' IDENTIFIED BY '$2';"
	mysql -e "FLUSH PRIVILEGES;"
	echo -e "$COLOR_LIGHT_PURPLEПользователь баз данных mysql $COLOR_YELLOW$1$COLOR_LIGHT_PURPLE с правами администратора создан$COLOR_NC"
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
