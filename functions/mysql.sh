#!/bin/bash

declare -x -f dbBackupBases #Создание бэкапа всех пользовательских баз данных mysql: ($1-В параметре может быть указан путь к каталогу сохранения бэкапов.Если путь не указан, то выгрузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d` ;)
declare -x -f dbBackupBase #Создание бэкапа указанной базы данных: ($1-dbname ; $2-В параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d` )


#
#Создание бэкапа всех пользовательских баз данных mysql
#$1-В параметре может быть указан путь к каталогу сохранения бэкапов.Если путь не указан, то выгрузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d` ;
dbBackupBases() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
		d=`date +%Y.%m.%d`;
	    dt=`date +%Y.%m.%d_%H.%M`;
	    #Проверка существования файла "$1"
	    if ! [ -f $1 ] ; then
	        #Файл "$1" не существует
	        echo -e "${COLOR_RED} Каталог \"$1\" не найден ${COLOR_NC}. Создать его?"
			echo -n -e "Введите ${COLOR_BLUE}\"y\"${COLOR_NC} для создания каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC}, для отмены операции - ${COLOR_BLUE}\"n\"${COLOR_NC}: "

			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y)
					mkdir -p "$1";
				DESTINATION=$1
				echo $DESTINATION
					break;;
				n|N)
					 break;;
				esac
			done
	        #Файл "$1" не существует (конец)
	    else
	        #Файл "$1" существует
			DESTINATION=$1
	        #Файл "$1" существует (конец)
	    fi
	    #Конец проверки существования файла "$1"
	    
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		#каталог устанавливается по умолчанию
		DESTINATION=$BACKUPFOLDER_DAYS/$d
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта

    databases=`mysql -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
    
    #Проверка существования каталога "$DESTINATION"
    if ! [ -d $DESTINATION ] ; then
        #Каталог "$DESTINATION" не существует
        mkdir -p "$DESTINATION"
    fi
    #Конец проверки существования каталога "$DESTINATION"
    
#выгрузка баз данных
	for db in $databases; do
		if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] && [[ "$db" != "phpmyadmin" ]] && [[ "$db" != "sys" ]] ; then
			echo -e "---\nВыгрузка базы данных MYSQL: ${COLOR_YELLOW}$db${COLOR_NC}"
			mysqldump --databases $db > $DESTINATION/$db_$dt.sql
#архивация выгруженной базы и удаление оригинального файла sql
			tar_file_without_structure_remove	$DESTINATION/$db_$dt.sql $DESTINATION/$db_$dt.tar.gz
#проверка на существование выгруженных и заархививанных баз данных
			if  [ -f "$DESTINATION/$db_$dt.tar.gz" ] ; then
				echo -e "${COLOR_GREEN}Выгрузка базы данных MYSQL:${COLOR_NC} ${COLOR_YELLOW}$db${COLOR_NC} ${COLOR_GREEN}успешно завершилась в файл${COLOR_NC}${COLOR_YELLOW} \"$DESTINATION/$db_$dt.tar.gz\"${COLOR_NC}\n---"
			else
				echo -e "${COLOR_RED}Выгрузка базы данных: ${COLOR_NC}${COLOR_YELLOW}$db${COLOR_NC} ${COLOR_RED}завершилась с ошибкой${COLOR_NC}\n---"
			fi
	fi
done
}


#
#Создание бэкапа указанной базы данных
#$1-dbname ; $2-В параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d` ; $3- ; $4- ; $5- ;
dbBackupBase() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
		d=`date +%Y.%m.%d`;
	    dt=`date +%Y.%m.%d_%H.%M`;
	    #проверка существования базы данных "$1"
	    if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$1'" 2>&1`" ]];
	    	then
	    	#база $1 - существует
	    		#Проверка на существование параметров запуска скрипта
	    		if [ -n "$2" ]
	    		then
	    		#Параметры запуска существуют
	    		    DESTINATION=$2
	    		#Параметры запуска существуют (конец)
	    		else
	    		#Параметры запуска отсутствуют
	    		    DESTINATION=$BACKUPFOLDER_DAYS/$d
			        mkdir -p $BACKUPFOLDER_DAYS/$d
	    		#Параметры запуска отсутствуют (конец)
	    		fi
	    		#Конец проверки существования параметров запуска скрипта

	    		#пусть к файлу с бэкапом без расширения
        		FILENAME=$DESTINATION/mysql."$db"-$dt

		#Проверка существования каталога "$DESTINATION"
		if [ -d $DESTINATION ] ; then
		    #Каталог "$DESTINATION" существует    
		    mysqldump --databases $1 > $FILENAME.sql				
			tar_file_without_structure_remove $FILENAME.sql $FILENAME.tar.gz
			dbCheckExportedBase $1 $FILENAME.tar.gz
		    #Каталог "$DESTINATION" существует (конец)
		else
		    #Каталог "$DESTINATION" не существует   
		    echo -e "${COLOR_RED} Каталог ${COLOR_YELLOW}\"$DESTINATION\"${COLOR_NC}${COLOR_RED} не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите ${COLOR_BLUE}\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"$DESTINATION\"${COLOR_nC}, для отмены операции - ${COLOR_BLUE}\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 
					mkdir -p $DESTINATION;
					mysqldump --databases $1 > $FILENAME.sql				
					tar_file_without_structure_remove $FILENAME.sql $FILENAME.tar.gz
					dbCheckExportedBase $1 $FILENAME.tar.gz
					break;;
				n|N)
					 break;;
				esac	
			done
		    #Каталог "$DESTINATION" не существует (конец)
		fi
		#Конец проверки существования каталога "$DESTINATION"
		
		
	    	#база $1 - существует (конец)	
	    	else
	    	#база $1 - не существует
	    	    echo -e "${COLOR_RED}Ошибка создания бэкапа базы данных ${COLOR_YELLOW}\"$1\"${COLOR_NC}${COLOR_RED}. Указанная база не существует${COLOR_NC}"
	    	#база $1 - не существует (конец)
	    fi
	    #конец проверки существования базы данных $1
	    
	    
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbBackupBase\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
    
}