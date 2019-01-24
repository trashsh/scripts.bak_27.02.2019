#!/bin/bash
source /etc/profile
source ~/.bashrc
# $1-база данных, $2-путь к расположению бэкапа? $3 - название таблицы

mysql -e "mysqldump -c $1 $3 > $2;"