#!/bin/bash
#Функции mysql
source $SCRIPTS/functions/archive.sh
declare -x -f dbBackupBases	#Создание бэкапа всех пользовательских баз данных. #В параметре $1 может быть установлен каталог выгрузки. По умолчанию грузится в `date +%Y.%m.%d`
declare -x -f dbBackupBase
declare -x -f dbShowGrants
declare -x -f dbBaseIsExist

#Создание бэкапа всех пользовательских баз данных.
#В параметре $1 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d`
#tested
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
			echo -n -e "Введите $COLOR_BLUE\"y\"${COLOR_NC} для создания каталога \"$1\", для отмены операции - $COLOR_BLUE\"n\"${COLOR_NC}: "
		
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
			mysqldump --databases $db > $DESTINATION/$db.$dt.sql
#архивация выгруженной базы и удаление оригинального файла sql
			tar_file_without_structure_remove	$DESTINATION/$db.$dt.sql $DESTINATION/$db.$dt.tar.gz	
#проверка на существование выгруженных и заархививанных баз данных
			if  [ -f "$DESTINATION/$db.$dt.tar.gz" ] ; then
				echo -e "${COLOR_GREEN}Выгрузка базы данных MYSQL:${COLOR_NC} ${COLOR_YELLOW}$db${COLOR_NC} ${COLOR_GREEN}успешно завершилась в файл${COLOR_NC}${COLOR_YELLOW} \"$DESTINATION/$db.$dt.tar.gz\"${COLOR_NC}\n---"
			else
				echo -e "${COLOR_RED}Выгрузка базы данных: ${COLOR_NC}${COLOR_YELLOW}$db${COLOR_NC} ${COLOR_RED}завершилась с ошибкой${COLOR_NC}\n---"
			fi			
	fi		
done
}

#--------------------------------------------------------------------------------------------------------------------------------

##НЕ СДЕЛАНО!!!!
#Создание бэкапа указанной базы данных.
#$1 - название базы данных. В параметре $2 может быть установлен каталог выгрузки. По умолчанию грузится в $BACKUPFOLDER_DAYS\`date +%Y.%m.%d`
dbBackupBase(){
#	mysql -e "show databases;"
	d=`date +%Y.%m.%d`;
	dt=`date +%Y.%m.%d_%H.%M`;
#проверка существование каталога назначения и его создание при необходимости		
#проверка существования переданного параметра (название базы)
	DESTINATION=/my/2
				
						echo -e "---\nВыгрузка базы данных MYSQL: ${COLOR_YELLOW}$1${COLOR_NC}"
						mysqldump $1 > $DESTINATION/$1.$dt.sql
			#архивация выгруженной базы и удаление оригинального файла sql
						tar_file_without_structure_remove	$DESTINATION/$1.$dt.sql $DESTINATION/$1.$dt.tar.gz	
			#проверка на существование выгруженных и заархививанных баз данных
						if  [ -f "$DESTINATION/$1.$dt.tar.gz" ] ; then
							echo -e "${COLOR_GREEN}Выгрузка базы данных MYSQL:${COLOR_NC} ${COLOR_YELLOW}$1${COLOR_NC} ${COLOR_GREEN}успешно завершилась в файл${COLOR_NC}${COLOR_YELLOW} \"$DESTINATION/$1.$dt.tar.gz\"${COLOR_NC}\n---"
						else
							echo -e "${COLOR_RED}Выгрузка базы данных: ${COLOR_NC}${COLOR_YELLOW}$1${COLOR_NC} ${COLOR_RED}завершилась с ошибкой${COLOR_NC}\n---"
						fi			

	
}



dbShowGrants(){
if [ -n "$1" ] 
then
	dbBaseIsExist $1
	if (dbexist==='1')
	then
		echo "true"		
	else
		echo "false"
	fi
fi
}




dbBaseIsExist(){
if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$1'" 2>&1`" ]];
then
 dbexist=1
else
 dbexist=2
fi
}