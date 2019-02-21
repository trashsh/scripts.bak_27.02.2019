#!/bin/bash

declare -x -f backupImportantFile #Создание бэкапа в папку BACKUPFOLDER_IMPORTANT: ($1-user ; $2-destination_folder ; $3-архивируемый файл ;)
declare -x -f dbBackupBases #Создание бэкапа всех пользовательских баз данных mysql: ($1-В параметре может быть указан путь к каталогу сохранения бэкапов.Если путь не указан, то выгрузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d` ;)
declare -x -f dbBackupBase #Создание бэкапа указанной базы данных: ($1-dbname ; $2-В параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d` )
declare -x -f dbBackupTable #Создание бэкапа отдельной таблицы: ($1-dbname ; $2-tablename ; $3-В параметре $3 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d`)
declare -x -f dbBackupBasesOneUser #Создание бэкапа все баз данных указанного систеного пользователя: ($1-user ; $2-В параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d ;)

######ПОЛНОСТЬЮ ПРОТЕСТИРОВАНО
declare -x -f viewBackupsRange          #Вывод бэкапов конкретный день ($1-DATE)
                                        #Проверка на существование параметров запуска скрипта
                                        #return 0 - выполнено успешно, 1 - отсутствуют параметры
                                        #2 - бэкапы за указанный диапазон отсутствуют
declare -x -f viewBackupsToday          #Вывод бэкапов за сегодня
                                        #return 0 - выполнено успешно, 1 - каталог не найден
declare -x -f viewBackupsYestoday       #Вывод бэкапов за вчерашний день
                                        #return 0 - выполнено успешно, 1 - каталог не найден
declare -x -f viewBackupsWeek           #Вывод бэкапов за последнюю неделю
                                        #return 0 - выполнено успешно, 1 - каталог не найден
declare -x -f viewBackupsRangeInput     #Вывод бэкапов за указанный диапазон дат ($1-date1, $2-data2)
                                        #Вывод бэкапов за указанный диапазон дат ($1-date1, $2-data2)
                                        #return 0 - выполнено, 1 - отсутствуют параметры


#
#Создание бэкапа в папку BACKUPFOLDER_IMPORTANT
#$1-user ; $2-destination_folder ; $3-архивируемый файл ;
backupImportantFile() {
	dt=`date +%Y.%m.%d_%H.%M.%S`;
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]
	then
	#Параметры запуска существуют
		#Проверка существования файла "$3"
		if [ -f $3 ] ; then
		    #Файл "$3" существует
		    #Проверка существования каталога "$BACKUPFOLDER_IMPORTANT"/"$2"/"$1"
			if ! [ -d "$BACKUPFOLDER_IMPORTANT"/"$2"/"$1" ] ; then
				mkdir -p $BACKUPFOLDER_IMPORTANT/$2/$1
			fi
			#Проверка существования каталога "$BACKUPFOLDER_IMPORTANT"/"$2"/"$1" (конец)
	        tar_file_structure $3 $BACKUPFOLDER_IMPORTANT/$2/$1/$2_$1_$dt.tar.gz
		    #Файл "$3" существует (конец)
		else
		    #Файл "$3" не существует
		    echo -e "${COLOR_RED} Файл ${COLOR_YELLOW}\"$3\"${COLOR_RED} не существует${COLOR_NC}"
		    #Файл "$3" не существует (конец)
		fi
		#Конец проверки существования файла "$3"

	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"backupImportantFile\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта

}

#
#Создание бэкапа указанной базы данных
#$1-dbname ; $2-В параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d` ;
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
			echo -n -e "Введите ${COLOR_BLUE}\"y\"${COLOR_NC} для создания каталога ${COLOR_YELLOW}\"$DESTINATION\"${COLOR_nC}, для отмены операции - ${COLOR_BLUE}\"n\"${COLOR_NC}: "

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

#Создание бэкапа отдельной таблицы
#$1-dbname ; $2-tablename ; $3-path-Путь по желанию ; ;
dbBackupTable() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]
	then
	#Параметры запуска существуют
		d=`date +%Y.%m.%d`;
	    dt=`date +%Y.%m.%d_%H.%M`;
	    #проверка существования базы данных "$1"
	    if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$1'" 2>&1`" ]];
	    	then
	    	#база $1 - существует
	    		#Проверка на существование параметров запуска скрипта
	    		if [ -n "$3" ]
	    		then
	    		#Параметры запуска существуют
	    		    DESTINATION=$3
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
		    mysql -e "mysqldump -c $1 $2 > $FILENAME.sql;"
#		    mysqldump -c $1 $2 > $FILENAME.sql
			tar_file_without_structure_remove $FILENAME.sql $FILENAME.tar.gz
			dbCheckExportedBase $1 $FILENAME.tar.gz
		    #Каталог "$DESTINATION" существует (конец)
		else
		    #Каталог "$DESTINATION" не существует
		    echo -e "${COLOR_RED} Каталог ${COLOR_YELLOW}\"$DESTINATION\"${COLOR_NC}${COLOR_RED} не найден ${COLOR_NC}. Создать его?"
			echo -n -e "Введите ${COLOR_BLUE}\"y\"${COLOR_NC} для создания каталога ${COLOR_YELLOW}\"$DESTINATION\"${COLOR_nC}, для отмены операции - ${COLOR_BLUE}\"n\"${COLOR_NC}: "

			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y)
					mkdir -p $DESTINATION;
					mysqldump -c $1 $2 > $FILENAME.sql
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


#
#Создание бэкапа все баз данных указанного систеного пользователя
#$1-user ; $2-В параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d ; $3- ; $4- ; $5- ;
dbBackupBasesOneUser() {
	#проверка существования базы данных "$1"
	if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$1'" 2>&1`" ]];
		then
		#база $1 - существует
			#Проверка на существование параметров запуска скрипта
			if [ -n "$2" ]
			then
			#Параметры запуска существуют
                #Проверка существования каталога "$2"
                if ! [ -d $2 ] ; then
                    #Каталог "$2" не существует
                    echo -e "${COLOR_RED} Каталог \"$2\" не найден ${COLOR_NC}. Создать его?"
                    echo -n -e "Введите ${COLOR_BLUE}\"y\"${COLOR_NC} для создания каталога ${COLOR_YELLOW}\"$2\"${COLOR_NC}, для отмены операции - ${COLOR_BLUE}\"n\"${COLOR_NC}: "

                    while read
                    do
                    echo -n ": "
                        case "$REPLY" in
                        y|Y)
                            mkdir -p "$2";
                        DESTINATION=$2
                        echo $DESTINATION
                            break;;
                        n|N)
                             break;;
                        esac
                    done
                    #Каталог "$2" не существует (конец)
                else
                    DESTINATION=$2
                fi
                #Конец проверки существования каталога "$2"

			#Параметры запуска существуют (конец)
			else
			#Параметры запуска отсутствуют
			    echo -e ""
			#Параметры запуска отсутствуют (конец)
			fi
			#Конец проверки существования параметров запуска скрипта

		databases=`mysql -e "SHOW DATABASES LIKE '"$1"_%';" | tr -d "| " | grep -v Database`
		#Проверка существования каталога "$DESTINATION"
		if ! [ -d $DESTINATION ] ; then
		    #Каталог "$DESTINATION" не существует
            mkdir -p "$DESTINATION"
		    #Каталог "$DESTINATION" не существует (конец)
		fi
		#Конец проверки существования каталога "$DESTINATION"

		#выгрузка баз данных
        for db in $databases; do
            FILENAME=$DESTINATION/mysql."$db"-$dt
            echo $FILENAME
            if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] && [[ "$db" != "phpmyadmin" ]] && [[ "$db" != "sys" ]] ; then
                echo -e "---\nВыгрузка базы данных MYSQL: ${COLOR_YELLOW}$db${COLOR_NC}"
                mysqldump --databases $db > $FILENAME.sql
    #архивация выгруженной базы и удаление оригинального файла sql
                tar_file_without_structure_remove	$FILENAME.sql $FILENAME.tar.gz
    #проверка на существование выгруженных и заархививанных баз данных
        fi
    done

		#база $1 - существует (конец)
	else
		#база $1 - не существует
		    echo -e "${COLOR_RED}Указанная база данных ${COLOR_YELLOW}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
		#база $1 - не существует (конец)
	fi
	#конец проверки существования базы данных $1
}


######ПОЛНОСТЬЮ ПРОТЕСТИРОВАНО

#Вывод бэкапов за сегодня
#return 0 - выполнено успешно, 1 - каталог не найден
viewBackupsToday(){
	echo ""
	DATE=$(date +%Y.%m.%d)
	if [ -d "$BACKUPFOLDER_DAYS"/"$DATE"/"mysql" ] ; then
		echo -e "${COLOR_YELLOW}"Список бэкапов за сегодня - $DATE" ${COLOR_NC}"
		echo -e "${COLOR_BROWN}"$BACKUPFOLDER_DAYS/$DATE/mysql:" ${COLOR_NC}"
		ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
		return 0
	else
		echo -e "${COLOR_RED}Бэкапы mysql за $(date --date today "+%Y.%m.%d") отсутствуют${COLOR_NC}"
		return 1
	fi

}

#Вывод бэкапов за вчерашний день
#return 0 - выполнено успешно, 1 - каталог не найден
viewBackupsYestoday(){
	echo ""
	DATE=$(date --date yesterday "+%Y.%m.%d")
	 if [ -d "$BACKUPFOLDER_DAYS"/"$DATE"/"mysql" ] ; then
		echo -e "${COLOR_YELLOW}"Список бэкапов за сегодня - $DATE" ${COLOR_NC}"
		echo -e "${COLOR_BROWN}"$BACKUPFOLDER_DAYS/$DATE/mysql:" ${COLOR_NC}"
		ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
		return 0
	else
		echo -e "${COLOR_RED}Бэкапы mysql за $(date --date yesterday "+%Y.%m.%d") отсутствуют${COLOR_NC}"
		return 1
	fi
}

#Вывод бэкапов за последнюю неделю
#return 0 - выполнено успешно, 1 - каталог не найден
viewBackupsWeek(){
	echo ""
	TODAY=$(date +%Y.%m.%d)
	DATE=$(date --date='7 days ago' "+%Y.%m.%d")
	echo -e "${COLOR_YELLOW}"Список бэкапов за Неделю - $DATE-$TODAY" ${COLOR_NC}"

	for ((i=0; i<7; i++))
	do
		DATE=$(date --date=''$i' days ago' "+%Y.%m.%d");
		if [ -d "$BACKUPFOLDER_DAYS"/"$DATE" ] ; then
			echo -e "$COLOR_BROWN"$DATE:" ${COLOR_NC}"
			ls -l $BACKUPFOLDER_DAYS/$DATE/
			return 0
		else
		    echo -e "${COLOR_RED}Каталог ${COLOR_GREEN}\"$BACKUPFOLDER_DAYS/$DATE/\"${COLOR_RED}не найден${COLOR_NC}"
		    return 1
		fi
	done
}


#Вывод бэкапов за указанный диапазон дат ($1-date1, $2-data2)
#return 0 - выполнено, 1 - отсутствуют параметры
viewBackupsRangeInput(){
    #Проверка на существование параметров запуска скрипта
    if [ -n "$1" ] && [ -n "$2" ]
    then
    #Параметры запуска существуют
        echo -e "${COLOR_YELLOW}"Список бэкапов $(date --date $1 "+%Y.%m.%d") - $(date --date $2 "+%Y.%m.%d")" ${COLOR_NC}"
        start_ts=$(date -d "$1" '+%s')
        end_ts=$(date -d "$2" '+%s')
        range=$(( ( end_ts - start_ts )/(60*60*24) ))
        echo -e "$COLOR_BROWN" Базы данных mysql:" ${COLOR_NC}"
        n=0
        for ((i=0; i<${range#-}+1; i++))
        do
            DATE=$(date --date=''$i' days ago' "+%Y.%m.%d");
            if [ -d "$BACKUPFOLDER_DAYS"/"$DATE" ] ; then
                echo -e "$COLOR_BROWN"$DATE:" ${COLOR_NC}"
                ls -l $BACKUPFOLDER_DAYS/$DATE/
                n=$(($n+1))

            fi

        done
        echo $n
        return 0
    #Параметры запуска существуют (конец)
    else
    #Параметры запуска отсутствуют
        echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"viewBackupsRangeInput\"${COLOR_RED} ${COLOR_NC}"
        return 1
    #Параметры запуска отсутствуют (конец)
    fi
    #Конец проверки существования параметров запуска скрипта

}

#Вывод бэкапов конкретный день ($1-DATE)
viewBackupsRange(){
#Проверка на существование параметров запуска скрипта
#return 0 - выполнено успешно, 1 - отсутствуют параметры
#2 - бэкапы за указанный диапазон отсутствуют
if [ -n "$1" ]
then
#Параметры запуска существуют
    echo ''
    if [ -d "$BACKUPFOLDER_DAYS"/"$1"/ ] ; then
        echo -e "${COLOR_YELLOW}"Список бэкапов $(date --date $1 "+%Y.%m.%d")" ${COLOR_NC}"
        echo -e "$COLOR_BROWN"$1 - Базы данных mysql:" ${COLOR_NC}"
        ls -l $BACKUPFOLDER_DAYS/$1/
        return 0
    else
        echo -e "${COLOR_RED}Бэкапы за $(date --date $1 "+%Y.%m.%d") отсутствуют${COLOR_NC}"
        return 2
    fi
#Параметры запуска существуют (конец)
else
#Параметры запуска отсутствуют
    echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"viewBackupsRange\"${COLOR_RED} ${COLOR_NC}"
    return 1
#Параметры запуска отсутствуют (конец)
fi
#Конец проверки существования параметров запуска скрипта
}