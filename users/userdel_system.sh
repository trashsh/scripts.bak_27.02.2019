#!/bin/bash
#удалить системного пользователя
#$1-username
source /etc/profile
source ~/.bashrc

echo ''
cat /etc/passwd | grep ":100::"
echo -e "\n$COLOR_YELLOWУдаление системного пользователя  $COLOR_NC"
read -p "Введите имя пользователя: " username
	
	echo -n -e "Для удаления системного пользователя $COLOR_YELLOW" $username "$COLOR_NC введите $COLOR_BLUE\"y\"$COLOR_NC, для выхода - $COLOR_BLUE\"n\"$COLOR_NC: "
	
	while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) userdel -r $username
				 $SCRIPTS/mysql/userdel.sh $1 $username
					$MENU/user.sh
					break;;
			n|N)  $MENU/user.sh $1
					break;;
			esac
		done

 $SCRIPTS/info/mysql/full_info.sh
	
