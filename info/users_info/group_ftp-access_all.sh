#!/bin/bash
#Вывод пользователей группы ftp-access
#$1-username process;
source /etc/profile
source ~/.bashrc

echo -e "\n${COLOR_YELLOW} Список пользователей группы \"ftp-access\":${COLOR_NC}"
more /etc/group | grep "ftp-access:"
