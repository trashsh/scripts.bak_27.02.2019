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
				
				
				echo -n -e "Пользователь $COLOR_YELLOW" $1 "$COLOR_NC? имеет набор прав пользователя или администратора сервера? Введите $COLOR_BLUE\"1\"$COLOR_NC, если набор прав пользователя, $COLOR_BLUE\"2\"$COLOR_NC если администратора: "
		read item
		case "$item" in
			1) echo							
				/$SCRIPTS/mysql/make/useradd_make.sh $1 $PASSWORD			
				;;
			2) 
			echo 'Отмена операции добавления пользователя'
			/$SCRIPTS/mysql/make/useradd_make_root.sh $1 $PASSWORD
			echo ''
            ;;
		esac
		
		
			if [ -f "$HOMEPATHWEBUSERS"/"$1"/".my.cnf" ] ; then
				   cat $HOMEPATHWEBUSERS/$1/.my.cnf | grep $HOMEPATHWEBUSERS
							{
					echo '[client]'
					echo 'user='$1
					echo 'password='$PASSWORD
					} > $HOMEPATHWEBUSERS/$1/.my.cnf
					chmod 600 $HOMEPATHWEBUSERS/$1/.my.cnf
					chown $1:users $HOMEPATHWEBUSERS/$1/.my.cnf		
			fi
							

				;;
        *) echo 'Отмена операции добавления пользователя'
			echo ''
            ;;
    esac

