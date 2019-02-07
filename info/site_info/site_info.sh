#!/bin/bash
source /etc/profile
source ~/.bashrc
#Вывод информации о пользователях
# не трогать

declare -x -f viewFtpAccess				#отобразить реквизиты доступа к серверу FTP ($1-user)
declare -x -f viewSshAccess				#отобразить реквизиты доступа к серверу SSH  ($1-user)
declare -x -f viewMysqlAccess			#отобразить реквизиты доступа к серверу MYSQL  ($1-user)
declare -x -f viewSiteConfigsByName		#Вывод перечня сайтов указанного пользователя (конфиги веб-сервера)  ($1-user)
declare -x -f viewSiteFoldersByName		#Вывод перечня сайтов указанного пользователя  ($1-user)

#отобразить реквизиты доступа к серверу FTP
viewFtpAccess(){
	if [ -n "$1" ] 
	then
		echo -e "${COLOR_YELLOW}"Реквизиты FTP-Доступа" ${COLOR_NC}"
		echo -e "Пользователь: ${COLOR_YELLOW}" $1 "${COLOR_NC}"
		echo -e "Сервер: ${COLOR_YELLOW}" $MYSERVER "${COLOR_NC}"
		echo -e "Порт ${COLOR_YELLOW}" $FTPPORT "${COLOR_NC}"
		echo $LINE
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewFtpAccess в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi		
}

#отобразить реквизиты доступа к серверу SSH
viewSshAccess(){
	if [ -n "$1" ] 
	then
		echo -e "${COLOR_YELLOW}"Реквизиты SSH-Доступа" ${COLOR_NC}"
		echo -e "Пользователь: ${COLOR_YELLOW}" $1 "${COLOR_NC}"
		echo -e "Сервер: ${COLOR_YELLOW}" $MYSERVER "${COLOR_NC}"
		echo -e "Порт ${COLOR_YELLOW}" $SSHPORT "${COLOR_NC}"
		echo $LINE
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewSshAccess в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi		
}

#отобразить реквизиты доступа к серверу MYSQL
viewMysqlAccess(){
	if [ -n "$1" ] 
	then
		echo -e "${COLOR_YELLOW}"Реквизиты PHPMYADMIN" ${COLOR_NC}"
		echo -e "Пользователь: ${COLOR_YELLOW}" $1 "${COLOR_NC}"
		echo -e "Сервер: ${COLOR_YELLOW}" http://$MYSERVER:$APACHEHTTPPORT/$PHPMYADMINFOLDER "${COLOR_NC}"
		echo -e "\n${COLOR_YELLOW}Пользователь MySQL:${COLOR_NC}"
		if [ -f $HOMEPATHWEBUSERS/$1/.my.cnf ] ;  then
            cat $HOMEPATHWEBUSERS/$1/.my.cnf
		else echo -e "${COLOR_RED}Файл $HOMEPATHWEBUSERS/$1/.my.cnf не существует${COLOR_NC}"
        fi
		
		
		echo $LINE
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewMysqlAccess в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi	
}

#Вывод перечня сайтов указанного пользователя (конфиги веб-сервера)
# $1 - имя пользователя
viewSiteConfigsByName(){
	if [ -n "$1" ] 
	then
		if [ -d $HOMEPATHWEBUSERS/$1 ] ;  then
            echo -e "\nСписок сайтов в каталоге пользователя ${COLOR_YELLOW}\"$1\"${COLOR_NC}" $HOMEPATHWEBUSERS/$1:
			ls $HOMEPATHWEBUSERS/$1 | echo ""
        fi		
		
		
		echo -n "Apache - sites-available (user:$1): "
		ls $APACHEAVAILABLE | grep -E "$1.*$1" | echo ""
		echo  -n "Apache - sites-enabled (user:$1): "
		ls $APACHEENABLED | grep -E "$1.*$1" | echo ""
		echo  -n "Nginx - sites-available (user:$1): "
		ls $NGINXAVAILABLE | grep -E "$1.*$1" | echo ""
		echo  -n "Nginx - sites-enabled (user:$1): "
		ls $NGINXENABLED | grep -E "$1.*$1" | echo ""
		echo $LINE
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewSiteConfigsByName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi		
}

#Вывод перечня сайтов указанного пользователя
# $1 - имя пользователя
viewSiteFoldersByName(){
	if [ -n "$1" ] 
	then
		if [ -d $HOMEPATHWEBUSERS/$1 ] ;  then
            echo -e "\nСписок сайтов в каталоге пользователя ${COLOR_YELLOW}\"$1\"${COLOR_NC}" $HOMEPATHWEBUSERS/$1:
			ls $HOMEPATHWEBUSERS/$1/
		else 	
			echo -e "${COLOR_RED}Каталог $HOMEPATHWEBUSERS/$1/ не существует. Ошибка в функции viewSiteFoldersByName ${COLOR_NC}" 
        fi
		
		
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewSiteFoldersByName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi		
}

