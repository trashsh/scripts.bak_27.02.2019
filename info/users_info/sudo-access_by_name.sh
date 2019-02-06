#!/bin/bash
#Вывод пользователей группы sudo
#$1-username process; $user
source /etc/profile
source ~/.bashrc

echo -e "\n${COLOR_YELLOW}Список пользователей группы \"sudo\":${COLOR_NC}"
more /etc/group | grep sudo: | highlight green "$2"