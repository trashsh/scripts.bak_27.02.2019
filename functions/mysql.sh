#!/bin/bash
#Функции mysql
source $SCRIPTS/functions/archive.sh
declare -x -f dbBackupBases	#Создание бэкапа всех пользовательских баз данных. #В параметре $1 может быть установлен каталог выгрузки. По умолчанию грузится в `date +%Y.%m.%d`
declare -x -f dbBackupBase	#Создание бэкапа указанной базы данных. #$1 - название базы данных. В параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d`
declare -x -f dbCheckExportedBase #проверка успешности выгрузки базы данных mysql. $1-имя базы; $2-имя проверяемого файла
declare -x -f dbBackupBasesOneUser # #Создание бэкапа всех пользовательских баз данных указанного пользователя. #$1-username параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d`


declare -x -f dbViewAllBases 			#отобразить список всех баз данных mysql
declare -x -f dbViewBasesByUsername 		#отобразить список всех баз данных, владельцем которой является пользователь mysql $1_*		 	($1-user)
declare -x -f dbViewBasesByTextContain 		#отобразить список всех баз данных mysql с названием, содержащим переменную $1		 			($1-user)
declare -x -f dbViewAllUsers			#отобразить список всех пользователей баз данных mysql
declare -x -f dbViewAllUsersByContainName		#отобразить список всех пользователей баз данных mysql, содержащих в названии переменную $1		($1-user)
declare -x -f dbViewUserInfo


#######СДЕЛАНО. Не трогать!!!!#######
#Создание бэкапа всех пользовательских баз данных.
#В параметре $1 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d`
dbBackupBases(){
#	mysql -e "show databases;"
	d=`date +%Y.%m.%d`;
	dt=`date +%Y.%m.%d_%H.%M`;
#проверка существование каталога назначения и его создание при необходимости		
#проверка существования переданного параметра
	if [ -n "$1" ] 
	then	
#проверка существования каталога из полученного параметра
		if ! [ -d "$1" ] ; then
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
			else 
			#каталог существует
			DESTINATION=$1
		fi	
	else
		#каталог устанавливается по умолчанию
		DESTINATION=$BACKUPFOLDER_DAYS/$d
	fi

	databases=`mysql -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
#создание каталога назначения, если его нет
	if ! [ -d "$DESTINATION" ] ; then
		mkdir -p "$DESTINATION"
	fi
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

#--------------------------------------------------------------------------------------------------------------------------------
#######СДЕЛАНО. Не трогать!!!!#######
#Создание бэкапа всех пользовательских баз данных указанного пользователя.
#$1-username параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d`
dbBackupBasesOneUser(){
#	mysql -e "show databases;"
	d=`date +%Y.%m.%d`;
	dt=`date +%Y.%m.%d_%H.%M`;
	
	if [[ ! -z "`mysql -qfsBe "SELECT User FROM mysql.user WHERE User='$1'" 2>&1`" ]]
	then
	  #Указанный пользователь существует
#проверка существование каталога назначения и его создание при необходимости		
#проверка существования переданного параметра
	if [ -n "$2" ] 
	then	
#проверка существования каталога из полученного параметра
		if ! [ -d "$2" ] ; then
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
			else 
			#каталог существует
			DESTINATION=$2
		fi	
	else
		#каталог устанавливается по умолчанию
		DESTINATION=$BACKUPFOLDER_DAYS/$d
	fi

	databases=`mysql -e "SHOW DATABASES LIKE '"$1"_%';" | tr -d "| " | grep -v Database`
#создание каталога назначения, если его нет
	if ! [ -d "$DESTINATION" ] ; then
		mkdir -p "$DESTINATION"
	fi
	
	
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
			if  [ -f "$FILENAME.tar.gz" ] ; then
				echo -e "${COLOR_GREEN}Выгрузка базы данных MYSQL:${COLOR_NC} ${COLOR_YELLOW}$db${COLOR_NC} ${COLOR_GREEN}успешно завершилась в файл${COLOR_NC}${COLOR_YELLOW} \"$FILENAME.tar.gz\"${COLOR_NC}\n---"
			else
				echo -e "${COLOR_RED}Выгрузка базы данных: ${COLOR_NC}${COLOR_YELLOW}$db${COLOR_NC} ${COLOR_RED}завершилась с ошибкой${COLOR_NC}\n---"
			fi			
	fi		
done
	else	
	  echo -e "${COLOR_RED}Указанный пользователь ${COLOR_YELLOW}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
	fi
	
		
		
	

}

#--------------------------------------------------------------------------------------------------------------------------------
#######СДЕЛАНО. Не трогать!!!!#######
#Создание бэкапа указанной базы данных.
#$1 - название базы данных. В параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d`
dbBackupBase(){
	#	mysql -e "show databases;"
	d=`date +%Y.%m.%d`;
	dt=`date +%Y.%m.%d_%H.%M`;
	if [ -n "$1" ]
	then
	
	#проверка существования базы данных, переданной в параметре $1
	if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$1'" 2>&1`" ]];
	then
	 #база $1- существует	  
	  
	  #проверка передачи параметра $2 с путем сохранения бэкапа
		if [ -n "$2" ]
		then
		#передан путь сохраненя бэкапа
			DESTINATION=$2
		else
		#путь сохранения бэкапа не передан
			DESTINATION=$BACKUPFOLDER_DAYS/$d
			mkdir -p $BACKUPFOLDER_DAYS/$d
		fi		
		
		
		#пусть к файлу с бэкапом без расширения
		FILENAME=$DESTINATION/mysql."$db"-$dt 

		#проверка существования папки для сохранения бэкапа
		if [ -d "$DESTINATION" ] ; then
				mysqldump --databases $1 > $FILENAME.sql				
				tar_file_without_structure_remove $FILENAME.sql $FILENAME.tar.gz
				dbCheckExportedBase $1 $FILENAME.tar.gz
		#Если нет каталога назначения	
		else
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
		fi	
		
	else
		#название базы данных не передано в параметрах
		echo -e "${COLOR_RED}Ошибка создания бэкапа базы данных ${COLOR_YELLOW}\"$1\"${COLOR_NC}${COLOR_RED}. Указанная база не существует${COLOR_NC}"
	fi	
	
	#конец проверки на наличие переданного параметра имени базы
	else
	 #база $1 - не существует
	  echo -e "${COLOR_RED}В функцию ${COLOR_YELLOW}\"dbBackupBase\"${COLOR_NC}${COLOR_RED} не передано название базы данных${COLOR_NC}"
	fi
	#конец проверки существования базы		
}

#---------------------------------------------------------------------------------------------------------------------
#######СДЕЛАНО. Не трогать!!!!####### Можно сделать проверку не по наличию файла, а используя тестирование архива
#проверка успешности выгрузки базы данных mysql $1 в файл $2
#$1-имя базы; $2-имя файла
dbCheckExportedBase(){
	if  [ -f "$2" ] ; then
				echo -e "${COLOR_GREEN}Выгрузка базы данных MYSQL:${COLOR_NC} ${COLOR_YELLOW}\"$1\"${COLOR_NC} ${COLOR_GREEN}успешно завершилась в файл ${COLOR_NC}${COLOR_YELLOW} \"$2\"${COLOR_NC}\n---"
			else
				echo -e "${COLOR_RED}Выгрузка базы данных: ${COLOR_NC}${COLOR_YELLOW}\"$1\"${COLOR_NC}${COLOR_RED} в файл ${COLOR_YELLOW}\"$2\"${COLOR_NC}${COLOR_RED} завершилась с ошибкой. Указанный файл отсутствует${COLOR_NC}\n---"
	fi
}

#проверка успешности выгрузки базы данных mysql $1 в файл $2
#$1-имя пользователя, $2-пароль, $3 - тип пользователя
#type1-user,	type2-admin WITH GRANT OPTION
dbCreateUser(){
if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] 
then
	if [[  -z "`mysql -qfsBe "SELECT User FROM mysql.user WHERE User='$1'" 2>&1`" ]]
	then
				
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
		
	else
		echo -e "${COLOR_RED}\nПользователь ${COLOR_YELLOW}\"$1\"${COLOR_RED} уже существует."
		dbViewUserInfo $1
		
	fi
else
 echo -e "${COLOR_RED}В функцию ${COLOR_NC}${COLOR_YELLOW}\"dbCreateUser\"${COLOR_NC}${COLOR_RED} не переданы параметры ${COLOR_NC}"
fi
}










#отобразить список всех баз данных mysql
dbViewAllBases(){
	echo -e "${COLOR_YELLOW}\nПеречень баз данных MYSQL ${COLOR_NC}"
	mysql -e "show databases;"	
}


#отобразить список всех баз данных, владельцем которой является пользователь mysql $1_*
dbViewBasesByUsername(){
	if [ -n "$1" ] 
	then
		echo -e "${COLOR_YELLOW} \nПеречень баз данных MYSQL пользователя ${COLOR_GREEN}\"$1\" ${COLOR_NC}"
		mysql -e "SHOW DATABASES LIKE '$1\_%';"
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию dbViewBasesByUsername в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#отобразить список всех баз данных mysql с названием, содержащим переменную $1
#$без параметров
dbViewBasesByTextContain(){	
	if [ -n "$1" ] 
	then
		echo -e "${COLOR_YELLOW} \nПеречень баз данных MYSQL содержащих в названии слово ${COLOR_GREEN}\"$1\" ${COLOR_NC}"
		mysql -e "SHOW DATABASES LIKE '%$1%';"
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию dbViewBasesByTextContain в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#отобразить список всех пользователей баз данных mysql
#$без параметров
dbViewAllUsers(){
	echo -e "${COLOR_LIGHT_YELLOW}Перечень пользователей MYSQL ${COLOR_NC}"
	mysql -e "SELECT User,Host,Grant_priv,Create_priv,Drop_priv,Create_user_priv,Delete_priv,account_locked, password_last_changed FROM mysql.user;"
}

#######СДЕЛАНО. Не трогать!!!!#######
#отобразить список всех пользователей баз данных mysql, содержащих в названии переменную $1
#$1-user
dbViewAllUsersByContainName(){
	if [ -n "$1" ] 
	then
		echo -e "${COLOR_YELLOW}\nПеречень пользователей MYSQL, содержащих в названии ${COLOR_GREEN}\"$1\" $COLOR_NC"
		mysql -e "SELECT User,Host,Grant_priv,Create_priv,Drop_priv,Create_user_priv,Delete_priv,account_locked, password_last_changed FROM mysql.user WHERE User like '%%$1%%' ORDER BY User ASC"
	else
		echo -e "${COLOR_RED}Не передан параметр в функцию dbViewAllUsersByContainName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#отобразить информацию о пользователе
#$1-user
dbViewUserInfo(){
	if [ -n "$1" ] 
	then
		if [[ ! -z "`mysql -qfsBe "SELECT User FROM mysql.user WHERE User='$1'" 2>&1`" ]]
		then
			echo -e "${COLOR_YELLOW}\nИнформация о пользователе MYSQL ${COLOR_GREEN}\"$1\" $COLOR_NC"
			mysql -e "SELECT User,Host,Grant_priv,Create_priv,Drop_priv,Create_user_priv, Delete_priv,account_locked, password_last_changed FROM mysql.user WHERE User like '$1' ORDER BY User ASC"
			
		else
			echo -e "${COLOR_RED}Пользователь ${COLOR_YELLOW} \"$1\" ${COLOR_RED} не существует ${COLOR_NC}" 
		fi		
	else
		echo -e "${COLOR_RED}Не передан параметр в функцию dbViewUserInfo в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}" 
		exit 1
	fi
}