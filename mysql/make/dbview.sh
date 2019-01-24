#!/bin/bash
source /etc/profile
source ~/.bashrc

echo -e "$COLOR_LIGHT_PURPLEПеречень баз данных mysql $COLOR_NC"
mysql -e "show databases;"

