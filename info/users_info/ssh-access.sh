#!/bin/bash
#Вывод пользователей группы ssh-access
#$1-username process;
source /etc/profile
source ~/.bashrc

echo -e "\n${COLOR_YELLOW}Список пользователей группы \"ssh-access\":${COLOR_NC}"
more /etc/group | grep ssh-access:
$MENU/submenu/users_info.sh $1