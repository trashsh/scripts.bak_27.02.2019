#!/bin/bash

declare -x -f dbBackupBases #Создание бэкапа всех пользовательских баз данных mysql: ($1-В параметре может быть указан путь к каталогу сохранения бэкапов.Если путь не указан, то выгрузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d` ;)
declare -x -f dbBackupBase #Создание бэкапа указанной базы данных: ($1-dbname ; $2-В параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d` )
declare -x -f dbBackupBasesOneUser #Создание бэкапа все баз данных указанного систеного пользователя: ($1-user ; $2-В параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d ;)
declare -x -f dbCheckExportedBase #Проверка успешности выгрузки базы данных mysql $1 в архив $2: ($1-Имя базы данных ; $2-Путь к архиву ;)
declare -x -f dbCreateUser #Создание пользователя mysql: ($1-user ; $2-password ; $3-type of user ;)
declare -x -f dbSetMyCnfFile #Смена пароля и создание файла ~/.my.cnf (только файл): ($1-user ; $2-password ;)
declare -x -f dbChangeUserPassword #Смена пароля пользователю mysql: ($1-user ; $2-host ; $3-password ; $4-autentification type (mysql_native_password) ; )
declare -x -f dbDropUser #Удаление пользователя mysql: ($1-user ; $2-"drop"-подтверждение ; )
declare -x -f dbDropBase #Удаление базы данных mysql: ($1-dbname ; $2"drop"-подтверждение ;)
declare -x -f dbSetFullAccessToBase #Предоставление всех прав пользователю $1 на базу данных $1: ($1-dbname ; $2-user ; $3-host ;)
declare -x -f dbCreateBase #Создание базы данных $1: ($1-dbname ; $2-CHARACTER SET (например utf8) ; $3-COLLATE (например utf8_general_ci) ;)
declare -x -f dbShowTables #Вывод всех таблиц базы данных $1: ($1-dbname ;)
declare -x -f dbViewUserGrant #Вывод прав пользователя mysql на все базы: ($1-user ; $2-host ;)
declare -x -f dbViewUserInfo #Вывести информацию о пользователе mysql: ($1-user ;)
declare -x -f dbViewAllUsersByContainName #Отобразить список всех пользователей mysql,содержащих в названии переменную $1: ($1-переменная для поиска пользователя ;
declare -x -f dbViewBasesByUsername #Отобразить список всех баз данных, владельцем которой является пользователь mysql $1_%: ($1-user ;)
declare -x -f dbViewBasesByTextContain #Отобразить список всех баз данных mysql с названием, содержащим переменную $1: ($1-Переменная, по которой необходимо осуществить поиск баз данных ;)
declare -x -f dbViewAllBases #Вывод списка всех баз данных
declare -x -f dbViewAllUsers #Вывод списка всех пользователей mysql
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

#
#Проверка успешности выгрузки базы данных mysql $1 в архив $2
#$1-Имя базы данных ; $2-Путь к архиву ;
dbCheckExportedBase() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования файла "$2"
		if [ -f $2 ] ; then
		    #Файл "$2" существует    
		    echo -e "${COLOR_GREEN}Выгрузка базы данных MYSQL:${COLOR_NC} ${COLOR_YELLOW}\"$1\"${COLOR_NC} ${COLOR_GREEN}успешно завершилась в файл ${COLOR_NC}${COLOR_YELLOW} \"$2\"${COLOR_NC}\n---"
		    #Файл "$2" существует (конец)
		else
		    #Файл "$2" не существует   
		    echo -e "${COLOR_RED}Выгрузка базы данных: ${COLOR_NC}${COLOR_YELLOW}\"$1\"${COLOR_NC}${COLOR_RED} в файл ${COLOR_YELLOW}\"$2\"${COLOR_NC}${COLOR_RED} завершилась с ошибкой. Указанный файл отсутствует${COLOR_NC}\n---"
		    #Файл "$2" не существует (конец)
		fi
		#Конец проверки существования файла "$2"
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbCheckExportedBase\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
    
}


#
#Создание пользователя mysql
#$1-user ; $2-password ; $3-type of user ;
dbCreateUser() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]
	then
	#Параметры запуска существуют
	    #проверка на существование пользователя mysql "$1"
	    if [[ ! -z "`mysql -qfsBe "SELECT User FROM mysql.user WHERE User='$1'" 2>&1`" ]];
	    then
	    #Пользователь mysql "$1" существует
	        case "$3" in
            #права пользователя
            1)  mysql -e "CREATE USER '$1'@'localhost' IDENTIFIED BY '$2';"
                mysql -e "FLUSH PRIVILEGES;"
                echo -e "${COLOR_LIGHT_PURPLE}\nПользователь баз данных mysql ${COLOR_YELLOW}$2${COLOR_LIGHT_PURPLE} создан${COLOR_NC}"
                dbViewUserInfo $1
                ;;
            #права администратора без GRANT OPTION
            2)  mysql -e "GRANT ALL PRIVILEGES ON *.* To '$1'@'localhost' IDENTIFIED BY '$2';"
                mysql -e "FLUSH PRIVILEGES;"
                echo -e "${COLOR_LIGHT_PURPLE}\nПользователь баз данных mysql ${COLOR_YELLOW}$2${COLOR_LIGHT_PURPLE} с правами администратора создан${COLOR_NC}"
                dbViewUserInfo $1
                ;;
            #права администратора с GRANT OPTION
            3)  mysql -e "GRANT ALL PRIVILEGES ON *.* To '$1'@'localhost' IDENTIFIED BY '$2'  WITH GRANT OPTION;"
                mysql -e "FLUSH PRIVILEGES;"
                echo -e "${COLOR_LIGHT_PURPLE}\nПользователь баз данных mysql ${COLOR_YELLOW}$2${COLOR_LIGHT_PURPLE} с правами администратора {WITH GRANT OPTION} создан${COLOR_NC}"
                dbViewUserInfo $1
                ;;
            *) echo -e "${COLOR_RED}Ошибка передачи параметра 'type' в функцию ${COLOR_YELLOW}dbCreateUser${COLOR_NC}";;
        esac
	    #Пользователь mysql "$1" существует (конец)
	    else
	    #Пользователь mysql "$1" не существует
	        echo -e "${COLOR_RED}\nПользователь ${COLOR_YELLOW}\"$1\"${COLOR_RED} уже существует."
		    dbViewUserInfo $1
	    #Пользователь mysql "$1" не существует (конец) 
	    fi
	    #Конец проверки на существование пользователя mysql "$1"
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
	    echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbCreateUser\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#
#Смена пароля и создание файла ~/.my.cnf (только файл)
#$1-user ; $2-password ;
dbSetMyCnfFile() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]  
	then
	#Параметры запуска существуют
		#Проверка существования системного пользователя "$1"
			grep "^$1:" /etc/passwd >/dev/null
			if ! [ $? -ne 0 ]
			then
			#Пользователь $1 существует
				   #пользователь существует
			dt=`date +%Y.%m.%d_%H.%M.%S`;
			#если файл для бэкапа существует
			if [ -f "$HOMEPATHWEBUSERS"/"$1"/"my.cnf" ] ; then
					backupImportantFile $1 "my.cnf"  $HOMEPATHWEBUSERS/$1/.my.cnf
					sed -i "s/.*password=.*/password=$2/" $HOMEPATHWEBUSERS/$1/.my.cnf
			#если файл для бэкапа не существует
			else
				touch $HOMEPATHWEBUSERS/$1/.my.cnf
				cat $HOMEPATHWEBUSERS/$1/.my.cnf | grep $HOMEPATHWEBUSERS
									{
							echo '[mysqld]'
							echo 'init_connect=‘SET collation_connection=utf8_general_ci’'
							echo 'character-set-server=utf8'
							echo 'collation-server=utf8_general_ci'
							echo ''
							echo '[client]'
							echo 'default-character-set=utf8'
							echo 'user='$1
							echo 'password='$2
							} > $HOMEPATHWEBUSERS/$1/.my.cnf
							chmod 600 $HOMEPATHWEBUSERS/$1/.my.cnf
							chown $1:users $HOMEPATHWEBUSERS/$1/.my.cnf

							backupImportantFile $1 "my.cnf"  $HOMEPATHWEBUSERS/$1/.my.cnf

			fi
			#Пользователь $1 существует (конец)
			else
			#Пользователь $1 не существует
				echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует. Ошибка выполнения скрипта dbSetMyCnfFile${COLOR_NC}".
			#Пользователь $1 не существует (конец)
			fi
		#Конец проверки существования системного пользователя $1
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbSetMyCnfFile\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#
#Смена пароля пользователю mysql
#$1-user ; $2-host ; $3-password ; $4-autentification type (mysql_native_password) ; $5- ;
dbChangeUserPassword() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] && [ -n "$4" ]
	then
	#Параметры запуска существуют
		#проверка на существование пользователя mysql "$1"
		if [[ ! -z "`mysql -qfsBe "SELECT User FROM mysql.user WHERE User='$1'" 2>&1`" ]];
		then
		#Пользователь mysql "$1" существует
		    mysql -e "ALTER USER '$1'@'$2' IDENTIFIED WITH '$4' BY '$3';"
			echo -e "${COLOR_LIGHT_PURPLE}Пароль пользователя $1 изменен ${COLOR_NC}"
			#корректирование файла ~/.my.cnf
			dbSetMyCnfFile $1 $3
		#Пользователь mysql "$1" существует (конец)
		else
		#Пользователь mysql "$1" не существует
		    echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует ${COLOR_NC}"
		#Пользователь mysql "$1" не существует (конец) 
		fi
		#Конец проверки на существование пользователя mysql "$1"
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbChangeUserPassword\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#
#Удаление пользователя mysql
#$1-user ; $2-"drop"-подтверждение ;
dbDropUser() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка наличия подтверждения на удаление
		if [ "$2" = "drop" ]
		then
		    #Получено подтверждение на удаление
            #проверка на существование пользователя mysql "$1"
            if [[ ! -z "`mysql -qfsBe "SELECT User FROM mysql.user WHERE User='$1'" 2>&1`" ]];
            then
            #Пользователь mysql "$1" существует
                mysql -e "DROP USER IF EXISTS '$1'@'localhost';"
				mysql -e "DROP USER IF EXISTS '$1'@'%';"
				echo -e "${COLOR_LIGHT_PURPLE}Пользователь ${COLOR_YELLOW}$1${COLOR_LIGHT_PURPLE} удален $COLOR_NC"
            #Пользователь mysql "$1" существует (конец)
            else
            #Пользователь mysql "$1" не существует
                echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует ${COLOR_NC}"
            #Пользователь mysql "$1" не существует (конец) 
            fi
            #Конец проверки на существование пользователя mysql "$1"
            #Получено подтверждение на удаление - конец
        else
            #Не получено подтверждение на удаление
            echo -e "${COLOR_RED}Подтверждение на удаление пользователя ${COLOR_GREEN}\"$1\"${COLOR_RED} не получено ${COLOR_NC}"
            #Не получено подтверждение на удаление (конец)
		fi
		#Проверка наличия подтверждения на удаление (конец)
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbDropUser\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#
#Удаление базы данных mysql
#$1-dbname ; $2-"drop"-подтверждение ;
dbDropBase() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка наличия подтверждения на удаление
		if [ "$2" = "drop" ]
		then
            #проверка существования базы данных "$1"
            if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$1'" 2>&1`" ]];
            	then
            	#база $1 - существует
                    dbViewBasesByTextContain $1
                    mysql -e "DROP DATABASE IF EXISTS $1;"
                    dbViewBasesByTextContain $1
            	#база $1 - существует (конец)	
            	else
            	#база $1 - не существует
                    echo -e "${COLOR_RED}База данных ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует ${COLOR_NC}"
            	#база $1 - не существует (конец)
            fi
            #конец проверки существования базы данных $1
        else
            #Не получено подтверждение на удаление
            echo -e "${COLOR_RED}Подтверждение на удаление базы данных ${COLOR_GREEN}\"$1\"${COLOR_RED} не получено ${COLOR_NC}"
            #Не получено подтверждение на удаление (конец)
		fi
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbDropBase\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#
#Предоставление всех прав пользователю $1 на базу данных $1
#$1-dbname ; $2-user ; $3-host ;
dbSetFullAccessToBase() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]
	then
	#Параметры запуска существуют
		#проверка на существование пользователя mysql "$2"
		if [[ ! -z "`mysql -qfsBe "SELECT User FROM mysql.user WHERE User='$2'" 2>&1`" ]];
		then
		#Пользователь mysql "$2" существует
		    #проверка существования базы данных "$1"
		    if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$1'" 2>&1`" ]];
		    	then
		    	#база $1 - существует
		    		dbViewUserGrant $2
				mysql -e "GRANT ALL PRIVILEGES ON $1.* TO $2@$3 REQUIRE NONE WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0; FLUSH PRIVILEGES;"
		    	#база $1 - существует (конец)	
		    	else
		    	#база $1 - не существует
		    	     echo -e "${COLOR_RED}База данных ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует ${COLOR_NC}"
		    	#база $1 - не существует (конец)
		    fi
		    #конец проверки существования базы данных $1
		    
		#Пользователь mysql "$2" существует (конец)
		else
		#Пользователь mysql "$2" не существует
		    echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$2\"${COLOR_RED} не существует ${COLOR_NC}"
		#Пользователь mysql "$2" не существует (конец) 
		fi
		#Конец проверки на существование пользователя mysql "$2"
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbSetFullAccessToBase\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#
#Создание базы данных $1
#$1-dbname ; $2-CHARACTER SET (например utf8) ; $3-COLLATE (например utf8_general_ci) ;
dbCreateBase() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]
	then
	#Параметры запуска существуют
		#проверка существования базы данных "$1"
		if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$1'" 2>&1`" ]];
			then
			#база $1 - существует
				echo -e "${COLOR_LIGHT_RED}Ошибка создания базы данных. База данных ${COLOR_YELLOW}\"$1\"${COLOR_LIGHT_RED} уже существует ${COLOR_NC}"
			#база $1 - существует (конец)	
			else
			#база $1 - не существует
			     mysql -e "CREATE DATABASE IF NOT EXISTS $1 CHARACTER SET $2 COLLATE $3;"
			#база $1 - не существует (конец)
		fi
		#конец проверки существования базы данных $1
		
		
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbCreateBase\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#
#Вывод всех таблиц базы данных $1
#$1-dbname ;
dbShowTables() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
		#проверка существования базы данных "$1"
		if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$1'" 2>&1`" ]];
			then
			#база $1 - существует
				mysql -e "SHOW TABLES FROM $1;"
			#база $1 - существует (конец)	
			else
			#база $1 - не существует
			     echo -e "${COLOR_RED}База данных ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует ${COLOR_NC}" 
			#база $1 - не существует (конец)
		fi
		#конец проверки существования базы данных $1

	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbShowTables\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#
#Вывод прав пользователя mysql на все базы
#$1-user ; $2-host ;
dbViewUserGrant() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#проверка на существование пользователя mysql "$1"
		if [[ ! -z "`mysql -qfsBe "SELECT User FROM mysql.user WHERE User='$1'" 2>&1`" ]];
		then
		#Пользователь mysql "$1" существует
		    mysql -e "SHOW GRANTS FOR '$1'@'$2';"
		#Пользователь mysql "$1" существует (конец)
		else
		#Пользователь mysql "$1" не существует
		    echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует ${COLOR_NC}"
		#Пользователь mysql "$1" не существует (конец) 
		fi
		#Конец проверки на существование пользователя mysql "$1"
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbViewUserGrant\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

declare -x -f dbViewUserInfo #Вывести информацию о пользователе mysql: ($1-user ;)

#
#Вывести информацию о пользователе mysql $1
#$1-user ;
dbViewUserInfo() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
		#проверка на пустой результат
				if [[ $(mysql -e "SELECT User,Host,Grant_priv,Create_priv,Drop_priv,Create_user_priv, Delete_priv,account_locked, password_last_changed FROM mysql.user WHERE User like '$1' ORDER BY User ASC") ]]; then
					#непустой результат
					echo -e "${COLOR_YELLOW}Информация о пользователе MYSQL ${COLOR_GREEN}\"$1\" $COLOR_NC"
			        mysql -e "SELECT User,Host,Grant_priv,Create_priv,Drop_priv,Create_user_priv, Delete_priv,account_locked, password_last_changed FROM mysql.user WHERE User like '$1' ORDER BY User ASC"
					#непустой результат (конец)
				else
				    #пустой результат
					echo -e "${COLOR_LIGHT_RED}Пользователь ${COLOR_YELLOW}\"$1\"${COLOR_LIGHT_RED} не существует ${COLOR_NC}"
					#пустой результат (конец)
				fi
		#Конец проверки на пустой результат
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbViewUserInfo\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#
#Отобразить список всех пользователей mysql,содержащих в названии переменную $1
#$1-переменная для поиска пользователя ;
dbViewAllUsersByContainName() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
		#Проверка на существование параметров запуска скрипта
		if [ -n "$1" ]
		then
		#Параметры запуска существуют
		    #проверка на пустой результат
		    		if [[ $(mysql -e "SELECT User,Host,Grant_priv,Create_priv,Drop_priv,Create_user_priv,Delete_priv,account_locked, password_last_changed FROM mysql.user WHERE User like '%%$1%%' ORDER BY User ASC") ]]; then
		    			#непустой результат
		    			echo -e "${COLOR_YELLOW}Перечень пользователей MYSQL, содержащих в названии ${COLOR_GREEN}\"$1\" $COLOR_NC"
		                mysql -e "SELECT User,Host,Grant_priv,Create_priv,Drop_priv,Create_user_priv,Delete_priv,account_locked, password_last_changed FROM mysql.user WHERE User like '%%$1%%' ORDER BY User ASC"
		    			#непустой результат (конец)
		    		else
		    		    #пустой результат
		    			echo -e "${COLOR_LIGHT_RED}Пользователи, в имени которых содержится значение ${COLOR_YELLOW}\"$1\"${COLOR_LIGHT_RED} отсутствуют${COLOR_NC}"
		    			#пустой результат (конец)
		    		fi
		    #Конец проверки на пустой результат
		#Параметры запуска существуют (конец)
		else
		#Параметры запуска отсутствуют
		    echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"\"${COLOR_RED} ${COLOR_NC}"
		#Параметры запуска отсутствуют (конец)
		fi
		#Конец проверки существования параметров запуска скрипта
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbViewAllUsersByContainName\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#
#Отобразить список всех баз данных, владельцем которой является пользователь mysql $1_%
#$1-user ;
dbViewBasesByUsername() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
		#проверка на пустой результат
				if [[ $(mysql -e "SHOW DATABASES LIKE '$1\_%';") ]]; then
					#непустой результат
					echo -e "${COLOR_YELLOW}Перечень баз данных MYSQL пользователя ${COLOR_GREEN}\"$1\" ${COLOR_NC}"
			        mysql -e "SHOW DATABASES LIKE '$1\_%';"
					#непустой результат (конец)
				else
				    #пустой результат
					echo -e "${COLOR_LIGHT_RED}Базы данных, в имени которых содержится значение ${COLOR_GREEN}\"$1\"${COLOR_LIGHT_RED} отсутствуют${COLOR_NC}"
					#пустой результат (конец)
				fi
		#Конец проверки на пустой результат
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbViewBasesByUsername\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#
#Отобразить список всех баз данных mysql с названием, содержащим переменную $1
#$1-Переменная, по которой необходимо осуществить поиск баз данных ;
dbViewBasesByTextContain() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
		#проверка на пустой результат
				if [[ $(mysql -e "SHOW DATABASES LIKE '%$1%';") ]]; then
					#непустой результат
					echo -e "${COLOR_YELLOW}Перечень баз данных MYSQL содержащих в названии слово ${COLOR_GREEN}\"$1\" ${COLOR_NC}"
			        mysql -e "SHOW DATABASES LIKE '%$1%';"
					#непустой результат (конец)
				else
				    #пустой результат
					echo -e "${COLOR_LIGHT_RED}Пользователи, в имени которых содержится значение ${COLOR_YELLOW}\"$1\"${COLOR_LIGHT_RED} отсутствуют${COLOR_NC}"
					#пустой результат (конец)
				fi
		#Конец проверки на пустой результат
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"dbViewBasesByTextContain\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#
#Вывод списка всех баз данных
dbViewAllBases() {
    echo -e "${COLOR_YELLOW}Перечень баз данных MYSQL ${COLOR_NC}"
	mysql -e "show databases;"
}

#
#Вывод списка всех пользователей mysql
dbViewAllUsers() {
    echo -e "${COLOR_YELLOW}Перечень пользователей MYSQL ${COLOR_NC}"
	mysql -e "SELECT User,Host,Grant_priv,Create_priv,Drop_priv,Create_user_priv,Delete_priv,account_locked, password_last_changed FROM mysql.user;"
}