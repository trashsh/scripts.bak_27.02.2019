#!/bin/bash
source /etc/profile
source ~/.bashrc

# $_1 - BACKUPPATH

mysql -e "show databases;"
d=`date +%Y%m%d_%H%M`;

#rm "BACKUPPATH/*gz" > /dev/null 2>&1

databases=`mysql -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
        echo -e "Dumping database: $COLOR_YELLOW$db$COLOR_NC"
        mysqldump --databases $db > $1/db.$d.$db.sql
        gzip $1/db.$d.$db.sql
    fi
done
