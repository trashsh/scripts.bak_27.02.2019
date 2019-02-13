#!/bin/bash
#Функции пользователей
source $SCRIPTS/functions/archive.sh
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/other.sh
source $SCRIPTS/functions/site.sh

declare -x -f UserAddToGroupSudo
declare -x -f UserShowGroup
declare -x -f AddAdminSshKeytoSite
declare -x -f GenerateSshKey

#Добавление пользователя $1 в группу sudo
UserAddToGroupSudo(){

if [ -n "$1" ]
then
	echo -e "${COLOR_YELLOW} Добавление пользователя в группу sudo ${COLOR_NC}"
	grep "^$1:" /etc/passwd >/dev/null
	if [ $? -ne 0 ]
	then
		echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
	
	else
		echo -n -e "Добавить пользователя ${COLOR_YELLOW}\""$1"\"${COLOR_NC} в список ${COLOR_YELLOW}\"sudo\"${COLOR_NC}? введите ${COLOR_BLUE}\"y\"${COLOR_NC} для подтверждения, для выхода - ${COLOR_BLUE}\"n\"${COLOR_NC}: "
		
		
		while read
		do
			case "$REPLY" in
			y|Y)  adduser $1 sudo;
					echo -e "Пользователь ${COLOR_YELLOW}" $1 "${COLOR_NC} добавлен в список sudo";
					echo ""
					UserShowGroup $1
					break;;
			n|N)  echo -e "\n${COLOR_YELLOW} Пользователь ${COLOR_LIGHT_PURPLE}\"$1\" ${COLOR_NC}${COLOR_YELLOW} создан, но не добавлен в список $COLOR_GREEN\"sudo\"${COLOR_NC}";  break;;
			esac
		done	
	fi
else
    echo -e "\n${COLOR_YELLOW} Параметры запуска не найдены${COLOR_NC}. Функция UserAddToGroupSudo"
    FileParamsNotFound "$1" "Для запуска главного введите" "$SCRIPTS/menu"  
fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#Вывод списка групп, в которых состоит пользователь $1
UserShowGroup(){
	if [ -n "$1" ]
then

grep "^$1:" /etc/passwd >/dev/null
if [ $? -ne 0 ]; then
 echo -e "${COLOR_RED}Пользователь ${COLOR_YELLOW}\"$1\"${COLOR_RED} не найден. Ошибка выполнения функции UserShowGroup${COLOR_NC}"
else
		echo -e "${COLOR_YELLOW}Список групп, в которых состоит пользователь ${COLOR_GREEN}\""$1"\"${COLOR_NC}: "
		grep "$1" /etc/group | highlight green "$1"
		
fi

else
    echo -e "\n${COLOR_YELLOW} Параметры запуска не найдены${COLOR_NC}. Функция UserShowGroup"
    FileParamsNotFound "$1" "Для запуска главного введите" "$SCRIPTS/menu"  
fi
}



#Удаление пользователя $1 из группы $2
UserDeleteFromGroup(){
if [ -n "$1" ] && [ -n "$2" ]
then
	echo -e "${COLOR_YELLOW} Удаление пользователя ${COLOR_GREEN}\"$1\"${COLOR_YELLOW} из группы  ${COLOR_GREEN}\"$2\"${COLOR_NC}"
	UserShowGroup $1
	grep "^$1:" /etc/passwd >/dev/null
	if [ $? -ne 0 ]
	then
		echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
	
	else
		if grep -q $2 /etc/group
		then
			 echo -n -e "Удалить пользователя ${COLOR_YELLOW}\""$1"\"${COLOR_NC} из группы ${COLOR_YELLOW}\"$2\"${COLOR_NC}? введите ${COLOR_BLUE}\"y\"${COLOR_NC} для подтверждения, для выхода - ${COLOR_BLUE}\"n\"${COLOR_NC}: "
		
				while read
				do
					case "$REPLY" in
					y|Y)  gpasswd -d $1 $2;
							UserShowGroup $1
							break;;
					n|N)  echo -e "\n${COLOR_YELLOW} Удаление пользователя ${COLOR_GREEN}\"$1\" ${COLOR_NC}${COLOR_YELLOW} из группы ${COLOR_GREEN}\"$2\"${COLOR_YELLOW} прекращено${COLOR_NC}"
					break;;
					
					esac
				done	
	
	else
		echo -e "${COLOR_RED}Группа ${COLOR_GREEN}$2${COLOR_RED} не существует. Ошибка выполнения функции UserDeleteFromGroup${COLOR_NC}"
	fi
			
	fi	
		
		
else
    echo -e "\n${COLOR_YELLOW} Параметры запуска не найдены${COLOR_NC}. Функция UserDeleteFromGroup"
    FileParamsNotFound "$1" "Для запуска главного введите" "$SCRIPTS/menu"  
fi
}


#Добавление ключа ssh к указанному пользователю
#$1-user $2-путь к добавляемому ключу
AddAdminSshKeytoSite(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	grep "^$1:" /etc/passwd >/dev/null
	if [ $? -ne 0 ]
	then
		echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
	
	else
	
			if [ -f $2 ]
			then
					if [ -f "$HOMEPATHWEBUSERS/$1/.ssh/authorized_keys" ]
					then
						cat $2 >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
					else
						echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$HOMEPATHWEBUSERS/$1/.ssh/authorized_keys\"${COLOR_RED} не найден ${COLOR_NC}"
					fi
			else
				echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$2\"${COLOR_RED} не найден ${COLOR_NC}"
				#Сделать предложение генерации ключа
			fi
	fi
else
    echo -e "\n${COLOR_YELLOW} Параметры запуска не найдены. Функция AddAdminSshKeytoSite"
    FileParamsNotFound "$1" "Для запуска главного введите" "$SCRIPTS/menu"  
fi
}


#Генерация ключа ssh для указанного пользователя $1
#$1-user
GenerateSshKey(){
if [ -n "$1" ]
then
	echo ''
echo -e "${COLOR_YELLOW} Генерация ssh-ключа ${COLOR_NC}"

		echo -n -e "Сгенерировать ключ доступа по SSH пользователю ${COLOR_YELLOW}" $1 "${COLOR_NC}? введите ${COLOR_BLUE}\"y\"${COLOR_NC} для подтверждения, ${COLOR_BLUE}\"n\"${COLOR_NC}  - для импорта загруженного ключа: "
				
		while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y)  echo
				DATE=`date '+%Y-%m-%d__%H-%M'`				
				mkdir -p $HOMEPATHWEBUSERS/$1/.ssh
				cd $HOMEPATHWEBUSERS/$1/.ssh
				echo -e "\n${COLOR_YELLOW} Генерация ключа. Сейчас необходимо будет установить пароль на ключевой файл.Минимум - 5 символов${COLOR_NC}"
				ssh-keygen -t rsa -f ssh_$1 -C "ssh_$1"
				echo -e "\n${COLOR_YELLOW} Конвертация ключа в формат программы Putty. Необходимо ввести пароль на ключевой файл, установленный на предыдушем шаге ${COLOR_NC}"
				sudo puttygen $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1 -C "ssh_$1" -o $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.ppk
				DATE=`date '+%Y-%m-%d__%H-%M'`
				mkdir -p $BACKUPFOLDER_IMPORTANT/ssh/$1
				mkdir -p $BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE
				cat $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.pub >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				$SCRIPTS/users/make/keyssh_admin_add.sh $1 $1
				cat $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.pub >> $BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE/ssh_$1.pub
				cat $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1 >> $BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE/ssh_$1
				cat $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.ppk >> $BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE/ssh_$1.ppk
				$SCRIPTS/archive/tar_folder_without_structure.sh $1 $HOMEPATHWEBUSERS/$1/.ssh/ $BACKUPFOLDER_IMPORTANT/ssh/$1/ $DATE.tar.gz
				
				if [ -d $BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE ] ; then
					if [ -f $BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE.tar.gz ] ; then
										rm -Rf $BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE
									else
										echo -e "${COLOR_RED} Ошибка автоматического удаления каталога \"$BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE\". Требуется удалить его вручную.${COLOR_NC}"
									fi

								
					else
						echo -e "${COLOR_RED} Ошибка автоматического удаления каталога \"$BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE\". Требуется удалить его вручную.${COLOR_NC}"
					fi
				
				
				
				chmod 700 $HOMEPATHWEBUSERS/$1/.ssh
				chmod 600 $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				chmod 600 $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.pub
				chmod 600 $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1
				chmod 600 $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.ppk
				chown $1:users $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.pub
				chown $1:users $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1
				chown $1:users $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.ppk
				chown $1:users $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				usermod -G ssh-access -a $1
				break
				;;
			n|N)  echo -e "\n${COLOR_YELLOW} Список возможных ключей для импорта: ${COLOR_NC}"
			   ls -l $SETTINGS/ssh/keys/
			   echo -n -e "${COLOR_BLUE} Укажите название открытого ключа, который необходимо применить к текущему пользователю: ${COLOR_NC}"
			   read -p ":" key
				mkdir -p $HOMEPATHWEBUSERS/$1/.ssh
				cat $SETTINGS/ssh/keys/$key >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				echo "" >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				cat $SETTINGS/ssh/keys/lamer >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				DATE=`date '+%Y-%m-%d__%H-%M'`
				mkdir -p $BACKUPFOLDER_IMPORTANT/ssh/$1				
				chmod 700 $HOMEPATHWEBUSERS/$1/.ssh
				chmod 600 $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				chown $1:users $HOMEPATHWEBUSERS/$1/.ssh
				chown $1:users $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				usermod -G ssh-access -a $1
				echo -e "\n${COLOR_YELLOW} Импорт ключа $COLOR_LIGHT_PURPLE\"$key\"${COLOR_YELLOW} пользователю $COLOR_LIGHT_PURPLE\"$1\"${COLOR_YELLOW} выполнен${COLOR_NC}"
				break
				;;
			*) 
			echo ''
            ;;	
			esac
		done


	else
    echo -e "\n${COLOR_YELLOW} Параметры запуска не найдены${COLOR_NC}. Необходимы параметры: имя пользователя"
    FileParamsNotFound "$1" "Для запуска главного введите" "$SCRIPTS/menu"  
fi
}
