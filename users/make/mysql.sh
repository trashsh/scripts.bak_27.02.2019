#!/bin/bash
source /etc/profile
source ~/.bashrc
#Добавление пользователя базы данных mysql
#$1-username process ; $2-user (создаваемый пользователь)

if [ -n "$1" ] && [ -n "$2" ] 
then

echo ''
echo -e "$COLOR_YELLOW"Создание пользователя базы данных mysql" $COLOR_NC"

		echo -n -e "Добавить пользователя $COLOR_YELLOW" $2 "$COLOR_NC? пользователем баз данных mysql? \nВведите $COLOR_BLUE\"y\"$COLOR_NC для подтверждения, для выхода - $COLOR_BLUEлюбой символ$COLOR_NC: "
		
		
		read item
		case "$item" in
			y|Y) echo
				#.my.cnf

				touch $HOMEPATHWEBUSERS/$2/.my.cnf		
				
				
				
				echo -n -e "$COLOR_BLUE Введите пароль для пользователя$COLOR_NC $COLOR_YELLOW" $2 "$COLOR_NC $COLOR_BLUEбазы данных mysql$COLOR_NC:"
				read -s PASSWORD
				echo ""				
				echo -n -e "Пользователь $COLOR_YELLOW" $2 "$COLOR_NC имеет набор прав пользователя или администратора сервера? Введите $COLOR_BLUE\"1\"$COLOR_NC, если набор прав пользователя, $COLOR_BLUE\"2\"$COLOR_NC если администратора: "
		read item
		case "$item" in
			1) echo							
				$SCRIPTS/mysql/make/useradd_make_user.sh $1 $2 $PASSWORD			
				;;
			2) 
			echo 'Отмена операции добавления пользователя баз данных mysql'
			$SCRIPTS/mysql/make/useradd_make_root.sh $1 $2 $PASSWORD
			echo ''
            ;;
		esac
		
		
			if [ -f "$HOMEPATHWEBUSERS"/"$2"/".my.cnf" ] ; then
				   cat $HOMEPATHWEBUSERS/$2/.my.cnf | grep $HOMEPATHWEBUSERS
							{
					echo '[client]'
					echo 'user='$2
					echo 'password='$PASSWORD
					} > $HOMEPATHWEBUSERS/$2/.my.cnf
					chmod 600 $HOMEPATHWEBUSERS/$2/.my.cnf
					chown $2:users $HOMEPATHWEBUSERS/$2/.my.cnf		
			fi
							

				;;
        *) echo 'Отмена операции добавления пользователя'
			echo ''
            ;;
    esac

else
    echo -e "\n$COLOR_YELLOWПараметры запуска не найдены$COLOR_NC. Необходимы параметры: имя пользователя"
    echo -n -e "$COLOR_YELLOWДля запуска основного меню напишите $COLOR_BLUE\"y\"$COLOR_YELLOW, для выхода - $COLOR_BLUE\"n\"$COLOR_NC:"
	while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) $SCRIPTS/menu $1;
					break;;
			n|N)  exit 0;
			esac
		done

fi







