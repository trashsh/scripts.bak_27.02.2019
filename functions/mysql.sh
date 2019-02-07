#!/bin/bash
#Функции mysql

declare -x -f backupAllBases

backupAllBases(){
mysql -e "show databases;"
		d=`date +%Y%m%d`;
		dt=`date +%Y%m%d_%H%M`;

		echo -e "${COLOR_YELLOW}Список имеющихся баз данных на сервере: ${COLOR_NC}"
		databases=`mysql -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

	for db in $databases; do
		if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
			echo -e "Dumping database: $COLOR_YELLOW$db$COLOR_NC"
				mysqldump --databases $db > $1$db.$dt.sql
		fi	
	done
}