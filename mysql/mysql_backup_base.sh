#!/bin/bash
source /etc/profile
source ~/.bashrc

# $_1 - BACKUPPATH

USER="root"
PASSWORD=""
BACKUPPATH=$1

#rm "BACKUPPATH/*gz" > /dev/null 2>&1

databases=`mysql -u $USER -p$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump -u $USER -p$PASSWORD --databases $db > $BACKUPPATH/`date +%Y%m%d`_$db.sql
        gzip $BACKUPPATH/`date +%Y%m%d`_$db.sql
    fi
done