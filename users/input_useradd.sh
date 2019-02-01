#!/bin/bash
#$1-$USERNAME
source /etc/profile
source ~/.bashrc

echo ''
echo -e "$COLOR_YELLOW"Создание системного пользователя " $COLOR_NC"
read -p "Введите имя пользователя: " username


echo -n -e "Для добавления системного пользователя $COLOR_YELLOW" $username "$COLOR_NC введите $COLOR_BLUE\"y\"$COLOR_NC, для выхода - любой символ: "
    read item
    case "$item" in
        y|Y) 		
		$SCRIPTS/users/make/user.sh $1 $username
		$SCRIPTS/users/make/sudo.sh $1 $username
		$SCRIPTS/users/make/keyssh.sh $1 $username
		$SCRIPTS/users/make/mysql.sh $1 $username
		
		$SCRIPTS/users/make/showinfo_ssh.sh $1 $username
		$SCRIPTS/users/make/showinfo_ftp.sh $1 $username
		$SCRIPTS/users/make/showinfo_mysql.sh $1 $username
            ;;
        *) echo 'Отмена операции добавления пользователя'
			echo ''
            ;;
    esac



