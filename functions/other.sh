#!/bin/bash


declare -x -f fileParamsNotFound	#Вывод сообщения с предложением запуска указанного в параметре 3 меню. #$1-user; $2-сообщение; $3-ссылка на скрипт меню для запуска
declare -x -f folderExistWithInfo #проверка существования папки с выводом информации о ее существовании: ($1-path ; $2-type (create/exist))
declare -x -f fileExistWithInfo	#проверка существования файла с выводом информации о ее существовании: ($1-path ; $2-type (create/exist))
declare -x -f viewPHPVersion #вывод информации о версии PHP
declare -x -f ufwAddPort #Добавление порта с исключением в firewall ufw: ($1-port ; $2-protocol ; $3-комментарий ;)
declare -x -f ufwOpenPorts #Вывод открытых портов ufw:
declare -x -f webserverRestart #Перезапуск Веб-сервера


#Полностью протестировано
declare -x -f mkdirWithOwn #Создание папки и применение ей владельца и прав доступа: ($1-путь к папке ; $2-user ; $3-group ; $4-разрешения )
                                #return 1 - не переданы параметры, 2 - пользователь не существует, 3 - группа не существует

#Создание папки и применение ей владельца и прав доступа
#$1-путь к папке ; $2-user ; $3-group ; $4-разрешения ;
#return 1 - не переданы параметры, 2 - пользователь не существует, 3 - группа не существует
mkdirWithOwn() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] && [ -n "$4" ]
	then
	#Параметры запуска существуют
		    #Проверка существования системного пользователя "$2"
		    	grep "^$2:" /etc/passwd >/dev/null
		    	if  [ $? -eq 0 ]
		    	then
		    	#Пользователь $2 существует
		    		#Проверка существования системной группы пользователей "$3"
		    		if grep -q $3 /etc/group
		    		    then
		    		        #Группа "$3" существует
		    		            mkdir -p $1
		    		            chmod $4 $1
				                chown $2:$3 $1
		    		        #Группа "$3" существует (конец)
		    		    else
		    		        #Группа "$3" не существует
		    		        echo -e "${COLOR_RED}Группа ${COLOR_GREEN}\"$3\"${COLOR_RED} не существует. Ошибка в функции ${COLOR_GREEN}\"mkdirWithOwn\"${COLOR_NC}"
                            return 3
		    				#Группа "$3" не существует (конец)
		    		    fi
		    		#Конец проверки существования системного пользователя $3
		    	#Пользователь $2 существует (конец)
		    	else
		    	#Пользователь $2 не существует
		    	    echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$2\"${COLOR_RED} не существует. Ошибка в функции ${COLOR_GREEN}\"mkdirWithOwn\"${COLOR_NC}"
		    	    return 2
		    	#Пользователь $2 не существует (конец)
		    	fi
		    #Конец проверки существования системного пользователя $2


	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"mkdirWithOwn\"${COLOR_RED} ${COLOR_NC}"
		return 1
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#Вывод сообщения с предложением запуска указанного в параметре 3 меню
#$1-user; $2-сообщение; $3-ссылка на скрипт меню для запуска
fileParamsNotFound(){
echo -n -e "${COLOR_YELLOW}$2 ${COLOR_BLUE}\"y\"${COLOR_YELLOW}, для выхода введите ${COLOR_BLUE}\"n\"${COLOR_NC}:"
	while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) echo "$2"
				$3 $1;
					break;;
			n|N)  break;;
			esac
		done
		
}


#проверка существования папки с выводом информации о ее существовании
#$1-path ; $2-type (create/exist)
folderExistWithInfo() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		case "$2" in
				"create")
					if ! [ -d $1 ] ; then
						echo -e "${COLOR_RED}Каталог ${COLOR_GREEN}\"$1\"${COLOR_RED} не создан${COLOR_NC}"
					else
						echo -e "${COLOR_GREEN}Каталог ${COLOR_YELLOW}\"$1\"${COLOR_GREEN} создан успешно${COLOR_NC}"
					fi
						;;
				"exist")
					if ! [ -d $1 ] ; then
						echo -e "${COLOR_RED}Каталог ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
					else
						echo -e "${COLOR_GREEN}Каталог ${COLOR_YELLOW}\"$1\"${COLOR_GREEN} существует${COLOR_NC}"
					fi
					;;
				*)
					echo -e "${COLOR_GREEN}Ошибка параметров в функции ${COLOR_YELLOW}\"folderExistWithInfo\"${COLOR_NC}";;
				esac
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"folderExistWithInfo\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}


#проверка существования файла с выводом информации.
#$1-path, $2-type (create/exist)
fileExistWithInfo(){
	case "$2" in
				"create") 	
					if ! [ -f $1 ] ; then
						echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$1\"${COLOR_RED} не создан${COLOR_NC}"
					else 
						echo -e "${COLOR_GREEN}Файл ${COLOR_YELLOW}\"$1\"${COLOR_GREEN} создан успешно${COLOR_NC}"
					fi
						;;			
				"exist")
					if ! [ -f $1 ] ; then 
						echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
					else 
						echo -e "${COLOR_GREEN}Файл ${COLOR_YELLOW}\"$1\"${COLOR_GREEN} существует${COLOR_NC}"
					fi
					;;
				*) 
					echo -e "${COLOR_GREEN}Ошибка параметров в функции ${COLOR_YELLOW}\"folderExistWithInfo\"${COLOR_NC}";;
				esac
}

#вывод информации о версии PHP
viewPHPVersion(){
	echo ""
	echo "Версия PHP:"
	php -v
	echo ""
}

#Добавление порта с исключением в firewall ufw
#$1-port ; $2-protocol ; $3-комментарий ;
ufwAddPort() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]
	then
	#Параметры запуска существуют
		ufw allow $1/$2 comment $3
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"ufwAddPort\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#Вывод открытых портов ufw
ufwOpenPorts() {
    netstat -ntulp
}

#Перезапуск Веб-сервера
webserverRestart() {
    /etc/init.d/apache2 restart
    /etc/init.d/nginx restart
}