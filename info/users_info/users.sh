#!/bin/bash
#Вывод пользователей группы users
#$1-username process;
source /etc/profile
source ~/.bashrc

echo -e "\n${COLOR_YELLOW}Список пользователей группы \"users\":${COLOR_NC}"
cat /etc/passwd | grep ":100::"