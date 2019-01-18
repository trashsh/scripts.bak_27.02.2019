#!/bin/bash
source /etc/profile
source ~/.bashrc

# $_1 - BACKUPPATH

echo -e "\n${COLOR_GREEN}Резервирование всех баз данных ${COLOR_NC}"
echo -e "${COLOR_YELLOW}Список имеющихся баз данных на сервере: ${COLOR_NC}"


echo -n -e "${COLOR_BLUE}Введите имя пользователя${COLOR_NC}"
read -p ": " USER

echo -n -e "${COLOR_BLUE}Введите пароль пользователя${COLOR_NC}"
read -p ": " PASSWORD

mysql -u $USER -p$PASSWORD -e "show databases;"


BACKUPPATH="/var/backup/"

#rm "BACKUPPATH/*gz" > /dev/null 2>&1

databases=`mysql -u $USER -p$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump -u $USER -p$PASSWORD --databases $db > $BACKUPPATH/`date +%Y%m%d`_$db.sql
        gzip $BACKUPPATH/`date +%Y%m%d`_$db.sql
    fi
done