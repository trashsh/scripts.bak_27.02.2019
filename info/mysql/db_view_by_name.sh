#!/bin/bash
# $1-username process; $2-mysql database;
#Выпод списка баз данных, которые содержат в названии определенное значение
source /etc/profile
source ~/.bashrc


if [ -n "$1" ] && [ -n "$2" ]
then
echo -e "$COLOR_LIGHT_PURPLE \nПеречень баз данных mysql, содержащих в названии \"$2\" $COLOR_NC"
mysql -e "SHOW DATABASES LIKE '%$2%';"

else
    echo -e "\n$COLOR_YELLOW Параметры запуска не найдены$COLOR_NC. Необходимы параметры: имя пользователя mysql, столбец для сортировки"
	FileParamsNotFound "$1" "Для запуска главного меню введите" "$SCRIPTS/menu"
fi
