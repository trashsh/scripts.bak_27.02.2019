#!/bin/bash
#Вывод всех пользователей в системе
#$1-username
source /etc/profile
source ~/.bashrc

cat /etc/passwd
echo ""
$SCRIPTS/menu $1