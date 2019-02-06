#!/bin/bash
#Вывод пользователей группы ftp-access с указанием пользователя
#$1-username process;  $2-user
source /etc/profile
source ~/.bashrc

$SCRIPTS/info/users_info/group_users_by_name.sh "$1" "$1"
$SCRIPTS/info/users_info/group_ssh-access_by_name.sh "$1" "$1"
$SCRIPTS/info/users_info/group_ftp-access_by_name.sh "$1" "$1"
$SCRIPTS/info/users_info/sudo-access_by_name.sh "$1" "$1"