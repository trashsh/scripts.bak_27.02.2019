#!/bin/bash
#Вывод пользователей группы ftp-access с указанием пользователя
#$1-username process;  $2-user
source /etc/profile
source ~/.bashrc

echo -e "\n${COLOR_YELLOW}Список пользователей группы \"ftp-access\", содержащих в имени \"$2\"${COLOR_NC}"
more /etc/group | grep -E "ftp-access.*$2"
echo ""
