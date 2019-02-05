#!/bin/bash
# $1-username process;
source /etc/profile
source ~/.bashrc

echo -e "$COLOR_LIGHT_PURPLE Сводная информация по пользователям и базам данным mysql $COLOR_NC"
$SCRIPTS/info/mysql/db_view.sh
$SCRIPTS/info/mysql/users_view.sh


