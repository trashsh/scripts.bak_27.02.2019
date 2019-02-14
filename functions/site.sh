#!/bin/bash
#Функции mysql
source $SCRIPTS/functions/archive.sh
source $SCRIPTS/functions/mysql.sh

declare -x -f viewFtpAccess				#отобразить реквизиты доступа к серверу FTP ($1-user)
declare -x -f viewSshAccess				#отобразить реквизиты доступа к серверу SSH  ($1-user)
declare -x -f viewMysqlAccess			#отобразить реквизиты доступа к серверу MYSQL  ($1-user)
declare -x -f viewSiteConfigsByName		#Вывод перечня сайтов указанного пользователя (конфиги веб-сервера)  ($1-user)
declare -x -f viewSiteFoldersByName		#Вывод перечня сайтов указанного пользователя  ($1-user)

declare -x -f viewBackupsToday
declare -x -f viewBackupsYestoday
declare -x -f viewBackupsWeek
declare -x -f viewBackupsRange
declare -x -f viewBackupsRangeInput


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

viewBackupsRange(){
echo ''
echo -e -n "$COLOR_BLUE"Укажите дату в формате yyyymmdd:" $COLOR_NC"
read DATE
 if [ -d "$BACKUPFOLDER_DAYS"/"$DATE"/"mysql" ] ; then
    echo -e "$COLOR_YELLOW"Список бэкапов $(date --date $DATE "+%Y.%m.%d")" $COLOR_NC"
	echo -e "$COLOR_BROWN"$DATE - Базы данных mysql:" $COLOR_NC"
	ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
 else
	echo -e "$COLOR_REDБэкапы mysql за $(date --date $DATE "+%Y.%m.%d") отсутствуют$COLOR_NC"
 fi
}

viewBackupsRangeInput(){
echo ''
echo -e -n "$COLOR_BLUE"Укажите первую дату диапазона в формате yyyymmdd:" $COLOR_NC"
read DATE1
echo -e -n "$COLOR_BLUE"Укажите последнюю дату диапазона в формате yyyymmdd:" $COLOR_NC"
read DATE2
echo -e "$COLOR_YELLOW"Список бэкапов $(date --date $DATE1 "+%Y.%m.%d") - $(date --date $DATE2 "+%Y.%m.%d")" $COLOR_NC"
start_ts=$(date -d "$DATE1" '+%s')
end_ts=$(date -d "$DATE2" '+%s')
range=$(( ( end_ts - start_ts )/(60*60*24) ))
echo -e "$COLOR_BROWN" Базы данных mysql:" $COLOR_NC"
n=0
for ((i=0; i<${range#-}+1; i++))
do
	DATE=$(date --date=''$i' days ago' "+%Y%m%d");
	if [ -d "$BACKUPFOLDER_DAYS"/"$DATE" ] ; then
		echo -e "$COLOR_BROWN"$DATE:" $COLOR_NC"
		ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
		n=$(($n+1))
	fi

done
echo $n
}
