#!/bin/bash
# $1-username process; $2-user; $3-pass
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] && [ -n "$2" ]  && [ -n "$3" ] 
then
	mysql -e "GRANT ALL PRIVILEGES ON *.* To '$2'@'localhost' IDENTIFIED BY '$3' WITH GRANT OPTION;"
	mysql -e "FLUSH PRIVILEGES;"
	echo -e "$COLOR_LIGHT_PURPLEПользователь баз данных mysql $COLOR_YELLOW$2$COLOR_LIGHT_PURPLE с правами администратора создан$COLOR_NC"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: имя пользователя mysql, пароль"
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
