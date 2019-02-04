#!/bin/bash
#Вывод всех пользователей в системе
#$1-username process;
source /etc/profile
source ~/.bashrc

clear
echo -e "\n${COLOR_YELLOW}Список пользователей группы \"users\":${COLOR_NC}"
cat /etc/passwd | grep ":100::"
$MENU/submenu/users_info.sh $1