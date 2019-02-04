#!/bin/bash
#$1-$USERNAME
source /etc/profile
source ~/.bashrc

echo -e "$COLOR_YELLOW"Открытые сетевые порты на сервере:" $COLOR_NC"
netstat -ntulp
$MENU/submenu/server_firewall.sh $1