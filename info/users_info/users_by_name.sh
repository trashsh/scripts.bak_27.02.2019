#!/bin/bash
#Вывод пользователей группы users, содержащих указанное значение имени
#$1-username process; $2-user
source /etc/profile
source ~/.bashrc

echo -e "\n${COLOR_YELLOW}Список пользователей группы \"users\", содержащих в имени \"$2\"${COLOR_NC}"
more /etc/passwd | grep -E ":100::.*$2"
