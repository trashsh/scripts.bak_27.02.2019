#!/bin/bash
#В какие группы входит пользователь
#$1-username process;
source /etc/profile
source ~/.bashrc

clear
echo -e "\n${COLOR_YELLOW}Список системных пользователей:${COLOR_NC}"
cat /etc/passwd | grep ":100::"
echo -e "\n${COLOR_BLUE}Введите интересующего вас пользователя \"ssh-access\":${COLOR_NC}"
read -p ":" username
echo -e "\n${COLOR_YELLOW}Пользователь \"$username\" состоит в следующих группах:${COLOR_NC}"
more /etc/group | grep $username	
	
$MENU/submenu/users_view.sh $1