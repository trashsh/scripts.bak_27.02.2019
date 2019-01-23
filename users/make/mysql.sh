#!/bin/bash
source /etc/profile
source ~/.bashrc
# $1-user
echo ''
echo -e "$COLOR_YELLOW"Создание пользователя базы данных mysql" $COLOR_NC"

		echo -n -e "Добавить пользователя $COLOR_YELLOW" $1 "$COLOR_NC? пользователем баз данных mysql? Введите $COLOR_BLUE\"y\"$COLOR_NC для подтверждения, для выхода - любой символ: "
		read item
		case "$item" in
			y|Y) echo
				#.my.cnf
				touch $HOMEPATHWEBUSERS/$1/.my.cnf
				echo -n -e "$COLOR_BLUEВведите пароль для пользователя$COLOR_NC $COLOR_YELLOW" $1 "$COLOR_NC $COLOR_BLUEбазы данных mysql$COLOR_NC:"
				read PASSWORD
				cat $HOMEPATHWEBUSERS/$1/.my.cnf | grep $HOMEPATHWEBUSERS
						{
				echo '[client]'
				echo 'user='$1
				echo 'password='$PASSWORD
				} > $HOMEPATHWEBUSERS/$1/.my.cnf
				chmod 600 $HOMEPATHWEBUSERS/$1/.my.cnf
				chown $1:users $HOMEPATHWEBUSERS/$1/.my.cnf
				echo -e "\nПользователь базы данных mysql $COLOR_YELLOW " $1"$COLOR_NC успешно добавлен"
				;;
        *) echo 'Отмена операции добавления пользователя'
			echo ''
            ;;
    esac

