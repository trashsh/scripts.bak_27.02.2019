#!/bin/bash
source /etc/profile
source ~/.bashrc
#Добавление пользователя базы данных mysql
#$1-username process ; $2-user (создаваемый пользователь)

if [ -n "$1" ] && [ -n "$2" ] 
then

echo ''
echo -e "$COLOR_YELLOW"Создание пользователя базы данных mysql" $COLOR_NC"

		echo -n -e "Добавить пользователя $COLOR_YELLOW" $2 "$COLOR_NC? пользователем баз данных mysql? \nВведите $COLOR_BLUE\"y\"$COLOR_NC для подтверждения, для выхода - $COLOR_BLUE\"n\"$COLOR_NC: "
		while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) echo
				#.my.cnf
				touch $HOMEPATHWEBUSERS/$2/.my.cnf	
				
				
		echo -n -e "Пароль для пользователя $COLOR_YELLOW" $2 "$COLOR_NC сгенерировать или установить вручную? \nВведите $COLOR_BLUE\"y\"$COLOR_NC для автогенерации, для ручного ввода - $COLOR_BLUE\"n\"$COLOR_NC: "
		while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) PASSWORD="$(openssl rand -base64 14)";
				 echo "Password: $PASSWORD";
				 break;;
			n|N) echo -n -e "$COLOR_BLUE Введите пароль для пользователя$COLOR_NC $COLOR_YELLOW" $2 "$COLOR_NC $COLOR_BLUEбазы данных mysql$COLOR_NC:";
				 read PASSWORD;
				 break;;
			esac
		done	
				
				
		echo ""				
				echo -n -e "Пользователь $COLOR_YELLOW" $2 "$COLOR_NC имеет набор прав пользователя или администратора сервера? Введите $COLOR_BLUE\"y\"$COLOR_NC, если набор прав пользователя, $COLOR_BLUE\"n\"$COLOR_NC если администратора: "
		while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) $SCRIPTS/mysql/make/useradd_make_user.sh $1 $2 $PASSWORD	
					break;;
			n|N) $SCRIPTS/mysql/make/useradd_make_root.sh $1 $2 $PASSWORD
					break;;
			esac
		done		

		
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
			break
			;;
			
			n|N)  exit 0;
			esac
		done

else
    echo -e "\n$COLOR_YELLOW Параметры запуска не найдены$COLOR_NC. Необходимы параметры: имя пользователя"
    echo -n -e "$COLOR_YELLOW Для запуска основного меню напишите $COLOR_BLUE\"y\"$COLOR_YELLOW, для выхода - $COLOR_BLUE\"n\"$COLOR_NC:"
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







