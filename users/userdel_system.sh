#!/bin/bash
#удалить системного пользователя
source /etc/profile
source ~/.bashrc

echo ''
cat /etc/passwd
echo -e "\n$COLOR_YELLOWУдаление системного пользователя  $COLOR_NC"
read -p "Введите имя пользователя: " username
	
	echo -n -e "Для удаления системного пользователя $COLOR_YELLOW" $username "$COLOR_NC введите $COLOR_BLUE\"y\"$COLOR_NC, для выхода - любой символ: "
    read item
    case "$item" in
        y|Y) 
		userdel -r $username	
		
            ;;
        *) echo 'Отмена удаления пользователя'
			echo ''
            ;;
    esac