#!/bin/bash
#$1-user, $2-db
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] && [ -n "$2" ] 
then
	mysql -e "GRANT ALL ON $2.* TO '$1'@'localhost';"
	mysql -e "FLUSH PRIVILEGES;"
	echo -e "$COLOR_YELLOW"Права администратора для пользователя $1 на базу $2 добавлены" $COLOR_NC"
	echo -e "$COLOR_LIGHT_PURPLEПрава администратора для пользователя  $COLOR_YELLOW$1$COLOR_LIGHT_PURPLE на базу $2 $COLOR_NC $COLOR_LIGHT_PURPLEдобавлены $COLOR_NC"
else
       echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: Имя пользователя, Название базы данных"
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


