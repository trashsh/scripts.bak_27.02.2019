#!/bin/bash
source /etc/profile
source ~/.bashrc
#Вывод информации о пользователях

declare -x -f viewMysqlDb_all 			#отобразить список всех баз данных mysql
declare -x -f viewMysqlDbByUser 		#отобразить список всех баз данных, владельцем которой является пользователь mysql $1_*		 	($1-user)
declare -x -f viewMysqlDbByName 		#отобразить список всех баз данных mysql с названием, содержащим переменную $1		 			($1-user)
declare -x -f viewMysqlUsers			#отобразить список всех пользователей баз данных mysql
declare -x -f viewMysqlUsersByName		#отобразить список всех пользователей баз данных mysql, содержащих в названии переменную $1		($1-user)
declare -x -f viewMysqlAllInfo			#отобразить всю информацию по mysql-базам

#отобразить список всех баз данных mysql
viewMysqlDb_all(){
	echo -e "${COLOR_LIGHT_YELLOW}Перечень баз данных MYSQL ${COLOR_NC}"
	mysql -e "show databases;"	
}

#отобразить список всех баз данных, владельцем которой является пользователь mysql $1_*
viewMysqlDbByUser(){
	if [ -n "$1" ] 
	then
		echo -e "${COLOR_LIGHT_YELLOW} \nПеречень баз данных MYSQL пользователя \"$1\" ${COLOR_NC}"
		mysql -e "SHOW DATABASES LIKE '$1\_%';"
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewMysqlDbByUser в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi
}

#отобразить список всех баз данных mysql с названием, содержащим переменную $1
viewMysqlDbByName(){	
	if [ -n "$1" ] 
	then
		echo -e "${COLOR_LIGHT_YELLOW} \nПеречень баз данных MYSQL содержащих в названии слово \"$1\" ${COLOR_NC}"
		mysql -e "SHOW DATABASES LIKE '%$1%';"
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewMysqlDbByName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi
}

#отобразить список всех пользователей баз данных mysql
viewMysqlUsers(){
	echo -e "${COLOR_LIGHT_YELLOW}Перечень пользователей MYSQL ${COLOR_NC}"
	mysql -e "SELECT User,Host FROM mysql.user;"
}

#отобразить список всех пользователей баз данных mysql, содержащих в названии переменную $1
viewMysqlUsersByName(){
	if [ -n "$1" ] 
	then
		echo -e "${COLOR_LIGHT_YELLOW}\nПеречень пользователей MYSQL, содержащих в названии \"$1\" $COLOR_NC"
		mysql -e "SELECT User,Host,Grant_priv,Create_priv,Drop_priv,Create_user_priv FROM mysql.user WHERE User like '%%$1%%' ORDER BY User ASC"
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewMysqlUsersByName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi
}

#отобразить всю информацию по mysql-базам
viewMysqlAllInfo(){
	viewMysqlDb_all
	viewMysqlDbByUser $1
	viewMysqlDbByName $1
	viewMysqlUsers
	viewMysqlUsersByName $1
}