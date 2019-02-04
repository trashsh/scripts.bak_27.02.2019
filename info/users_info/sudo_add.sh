#!/bin/bash
#Вывод пользователей группы sudo
#$1-username process;
source /etc/profile
source ~/.bashrc

clear
echo -e "\n${COLOR_YELLOW}Список пользователей группы \"sudo\":${COLOR_NC}"
more /etc/group | grep sudo:
$MENU/submenu/users_info.sh $1