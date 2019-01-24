#!/bin/bash
source /etc/profile
source ~/.bashrc
# $1-база данных, $2-путь к расположению бэкапа


mysql -e "mysqldump --databases $1 >$2;"

