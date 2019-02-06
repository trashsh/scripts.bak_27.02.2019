#!/bin/bash
#Вывод пользователей группы ssh-access с указанием пользователя
#$1-username process; $2-user
source /etc/profile
source ~/.bashrc

echo -e "\n${COLOR_YELLOW}Список пользователей группы \"ssh-access\", содержащих в имени \"$2\"${COLOR_NC}"
more /etc/group | grep -E "ssh-access.*$2" | highlight green "$2"
