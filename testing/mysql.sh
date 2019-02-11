#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/archive.sh
source /my/scripts/functions/mysql.sh

#if [[ ! -z "`mysql -qfsBe "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='$1'" 2>&1`" ]];
#then
  #echo "DATABASE ALREADY EXISTS"
#else
  #echo "DATABASE DOES NOT EXIST"
#fi

dbBackupBase $1 $2