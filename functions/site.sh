#!/bin/bash
#Функции mysql
source $SCRIPTS/functions/archive.sh
source $SCRIPTS/functions/mysql.sh

declare -x -f viewFtpAccess				#отобразить реквизиты доступа к серверу FTP ($1-user)
declare -x -f viewSshAccess				#отобразить реквизиты доступа к серверу SSH  ($1-user)
declare -x -f viewMysqlAccess			#отобразить реквизиты доступа к серверу MYSQL  ($1-user)
declare -x -f viewSiteConfigsByName		#Вывод перечня сайтов указанного пользователя (конфиги веб-сервера)  ($1-user)
declare -x -f viewSiteFoldersByName		#Вывод перечня сайтов указанного пользователя  ($1-user)

declare -x -f viewBackupsToday          #Вывод бэкапов за сегодня
declare -x -f viewBackupsYestoday       #Вывод бэкапов за вчерашний день
declare -x -f viewBackupsWeek           #Вывод бэкапов за последнюю неделю
declare -x -f viewBackupsRange          #Вывод бэкапов конкретный день ($1-DATE)
declare -x -f viewBackupsRangeInput     #Вывод бэкапов за указанный диапазон дат ($1-date1, $2-data2)


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

#Вывод бэкапов за сегодня
viewBackupsToday(){
	echo ""
	DATE=$(date +%Y%m%d)
	if [ -d "$BACKUPFOLDER_DAYS"/"$DATE"/"mysql" ] ; then
		echo -e "${COLOR_YELLOW}"Список бэкапов за сегодня - $DATE" ${COLOR_NC}"
		echo -e "${COLOR_BROWN}"$BACKUPFOLDER_DAYS/$DATE/mysql:" ${COLOR_NC}"
		ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
	else
		echo -e "${COLOR_RED}Бэкапы mysql за $(date --date today "+%Y.%m.%d") отсутствуют${COLOR_NC}"
	fi

}

#Вывод бэкапов за вчерашний день
viewBackupsYestoday(){
	echo ""
	DATE=$(date --date yesterday "+%Y%m%d")
	 if [ -d "$BACKUPFOLDER_DAYS"/"$DATE"/"mysql" ] ; then
		echo -e "${COLOR_YELLOW}"Список бэкапов за сегодня - $DATE" ${COLOR_NC}"
		echo -e "${COLOR_BROWN}"$BACKUPFOLDER_DAYS/$DATE/mysql:" ${COLOR_NC}"
		ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
	else
		echo -e "${COLOR_RED}Бэкапы mysql за $(date --date yesterday "+%Y.%m.%d") отсутствуют${COLOR_NC}"
	fi
}

#Вывод бэкапов за последнюю неделю
viewBackupsWeek(){
	echo ""
	TODAY=$(date +%Y%m%d)
	DATE=$(date --date='7 days ago' "+%Y%m%d")
	echo -e "$COLOR_YELLOW"Список бэкапов за Неделю - $DATE-$TODAY" $COLOR_NC"

	for ((i=0; i<7; i++))
	do
		DATE=$(date --date=''$i' days ago' "+%Y%m%d");
		if [ -d "$BACKUPFOLDER_DAYS"/"$DATE" ] ; then
			echo -e "$COLOR_BROWN"$DATE:" $COLOR_NC"
			ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
		fi
	done
}

#Вывод бэкапов конкретный день ($1-DATE)
viewBackupsRange(){
#Проверка на существование параметров запуска скрипта
if [ -n "$1" ]
then
#Параметры запуска существуют
    echo ''
    if [ -d "$BACKUPFOLDER_DAYS"/"$1"/ ] ; then
        echo -e "$COLOR_YELLOW"Список бэкапов $(date --date $1 "+%Y.%m.%d")" $COLOR_NC"
        echo -e "$COLOR_BROWN"$1 - Базы данных mysql:" $COLOR_NC"
        ls -l $BACKUPFOLDER_DAYS/$1/mysql
    else
        echo -e "$COLOR_REDБэкапы mysql за $(date --date $1 "+%Y.%m.%d") отсутствуют$COLOR_NC"
    fi
#Параметры запуска существуют (конец)
else
#Параметры запуска отсутствуют
    echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"viewBackupsRange\"${COLOR_RED} ${COLOR_NC}"
#Параметры запуска отсутствуют (конец)
fi
#Конец проверки существования параметров запуска скрипта


}

#Вывод бэкапов за указанный диапазон дат ($1-date1, $2-data2)
viewBackupsRangeInput(){
    #Проверка на существование параметров запуска скрипта
    if [ -n "$1" ] && [ -n "$2" ]
    then
    #Параметры запуска существуют
        echo -e "$COLOR_YELLOW"Список бэкапов $(date --date $1 "+%Y.%m.%d") - $(date --date $2 "+%Y.%m.%d")" $COLOR_NC"
        start_ts=$(date -d "$1" '+%s')
        end_ts=$(date -d "$2" '+%s')
        range=$(( ( end_ts - start_ts )/(60*60*24) ))
        echo -e "$COLOR_BROWN" Базы данных mysql:" $COLOR_NC"
        n=0
        for ((i=0; i<${range#-}+1; i++))
        do
            DATE=$(date --date=''$i' days ago' "+%Y%m%d");
            if [ -d "$BACKUPFOLDER_DAYS"/"$DATE" ] ; then
                echo -e "$COLOR_BROWN"$DATE:" $COLOR_NC"
                ls -l $BACKUPFOLDER_DAYS/$DATE/
                n=$(($n+1))
            fi

        done
        echo $n
    #Параметры запуска существуют (конец)
    else
    #Параметры запуска отсутствуют
        echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"viewBackupsRangeInput\"${COLOR_RED} ${COLOR_NC}"
    #Параметры запуска отсутствуют (конец)
    fi
    #Конец проверки существования параметров запуска скрипта

}

declare -x -f chModAndOwn #Смена разрешений на каталог и файлы, а также владельца: ($1-путь к каталогу; $2-права на каталог ; $3-Права на файлы ; $4-Владелец-user ; $5-Владелец-группа ;)
#Смена разрешений на каталог и файлы, а также владельца
#$1-путь к каталогу; $2-права на каталог ; $3-Права на файлы ; $4-Владелец-user ; $5-Владелец-группа ;
chModAndOwn() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] && [ -n "$4" ] && [ -n "$5" ]
	then
	#Параметры запуска существуют
		#Проверка существования каталога "$1"
		if [ -d $1 ] ; then
		    #Каталог "$2" существует
		    find $1 -type d -exec chmod $2 {} \;
			find $1 -type f -exec chmod $3 {} \;
			find $1 -type d -exec chown $4:$5 {} \;
			find $1 -type f -exec chown $4:$5 {} \;
		    #Каталог "$1" существует (конец)
		else
		    #Каталог "$1" не существует
		    echo -e "${COLOR_RED}Каталог ${COLOR_GREEN}\"$1\"${COLOR_RED}не существует. Ошибка в фукции chModAndOwn ${COLOR_NC}"
		    #Каталог "$1" не существует (конец)
		fi
		#Конец проверки существования каталога "$1"

	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"chModAndOwn\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}