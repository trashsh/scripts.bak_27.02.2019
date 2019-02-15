#!/bin/bash
#Функции пользователей
source $SCRIPTS/functions/archive.sh
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/other.sh
source $SCRIPTS/functions/site.sh

declare -x -f useraddSystem #Добавление системного пользователя: ($1-user ;)
declare -x -f userAddToGroupSudo #Добавление пользователя в группу sudo: ($1-user)
declare -x -f userShowGroup #Вывод списка групп, в которых состоит пользователь: ($1-user ;)
declare -x -f userDeleteFromGroup #Удаление пользователя $1 из группы $2: ($1-user ; $2-group ;)
declare -x -f addAdminSshKeytoSite #Добавить ключ ssh к указанному пользователю: ($1-user ; $2-путь к ключу ssh ;)
declare -x -f generateSshKey #Генерация ssh-ключа пользователю $1: ($1-user ;)

declare -x -f viewGroupFtpAccessAll						#Вывод всех пользователей группы ftp-access
declare -x -f viewGroupFtpAccessByName					#Вывод всех пользователей группы ftp-access с указанием части имени пользователя ($1-user)
declare -x -f viewGroupSshAccessAll						#Вывод всех пользователей группы ssh-access
declare -x -f viewGroupSshAccessByName					#Вывод всех пользователей группы ssh-access с указанием части имени пользователя ($1-user)
declare -x -f viewGroupUsersAccessByName				#Вывод всех пользователей группы users с указанием части имени пользователя ($1-user)
declare -x -f viewGroupAdminAccessAll					#Вывод всех пользователей группы admin-access
declare -x -f viewGroupAdminAccessByName				#Вывод всех пользователей группы admin-access с указанием части имени пользователя ($1-user)
declare -x -f viewGroupSudoAccessAll					#Вывод всех пользователей группы sudo
declare -x -f viewGroupSudoAccessByName					#Вывод пользователей группы sudo с указанием части имени пользователя ($1-user)
declare -x -f viewUserInGroupByName						#Вывод групп, в которых состоит указанный пользователь ($1-user)

#ПРОВЕРЕНО
declare -x -f viewGroupUsersAccessAll					#Вывод всех пользователей группы users. #$1 - может быть выведен дополнительно текст, предшествующий выводу списка пользователей
declare -x -f userExistInGroup                          #состоит ли пользователь $1 в группе $2
                                                        #функция возвращает значение 0-если пользователь состоит в группе "$2", 1- если не состоит в группе "$2"
                                                        #ничего не выводится
                                                        #$1-user ; $2-group
declare -x -f existGroup                                #Существует ли группа $1
                                                        #функция возвращает значение 0-если группа $1 существует. 1- если группа не существует
                                                        #ничего не выводится
                                                        #$1-group




#Добавление пользователя в группу sudo
#$1-user
userAddToGroupSudo() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
        echo -e "${COLOR_YELLOW} Добавление пользователя в группу sudo ${COLOR_NC}"
	    grep "^$1:" /etc/passwd >/dev/null
	    #Проверка на успешность выполнения предыдущей команды
	    if [ $? -eq 0 ]
	    	then
	    		#предыдущая команда завершилась успешно
	    		echo -n -e "Добавить пользователя ${COLOR_YELLOW}\""$1"\"${COLOR_NC} в список ${COLOR_YELLOW}\"sudo\"${COLOR_NC}? введите ${COLOR_BLUE}\"y\"${COLOR_NC} для подтверждения, для выхода - ${COLOR_BLUE}\"n\"${COLOR_NC}: "

                while read
                do
                    case "$REPLY" in
                    y|Y)  adduser $1 sudo;
                            echo -e "Пользователь ${COLOR_YELLOW}" $1 "${COLOR_NC} добавлен в список sudo";
                            echo ""
                            userShowGroup $1
                            break;;
                    n|N)  echo -e "\n${COLOR_YELLOW} Пользователь ${COLOR_LIGHT_PURPLE}\"$1\" ${COLOR_NC}${COLOR_YELLOW} создан, но не добавлен в список ${COLOR_GREEN}\"sudo\"${COLOR_NC}";  break;;
                    esac
                done
	    		#предыдущая команда завершилась успешно (конец)
	    	else
	    		#предыдущая команда завершилась с ошибкой
	    		echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
	    		#предыдущая команда завершилась с ошибкой (конец)
	    fi
	    #Конец проверки на успешность выполнения предыдущей команды
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"userAddToGroupSudo\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}


#Вывод списка групп, в которых состоит пользователь
#$1-user ;
userShowGroup() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]  
	then
	#Параметры запуска существуют
		grep "^$1:" /etc/passwd >/dev/null
		#Проверка на успешность выполнения предыдущей команды
		if [ $? -eq 0 ]
			then
				#предыдущая команда завершилась успешно
				echo -e "${COLOR_YELLOW}Список групп, в которых состоит пользователь ${COLOR_GREEN}\""$1"\"${COLOR_NC}: "
		        grep "$1" /etc/group | highlight green "$1"
				#предыдущая команда завершилась успешно (конец)
			else
				#предыдущая команда завершилась с ошибкой
				echo -e "${COLOR_RED}Пользователь ${COLOR_YELLOW}\"$1\"${COLOR_RED} не найден. Ошибка выполнения функции userShowGroup${COLOR_NC}"
				#предыдущая команда завершилась с ошибкой (конец)
		fi
		#Конец проверки на успешность выполнения предыдущей команды
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"userShowGroup\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#Удаление пользователя $1 из группы $2
#$1-user ; $2-group ;
userDeleteFromGroup() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
        echo -e "${COLOR_YELLOW} Удаление пользователя ${COLOR_GREEN}\"$1\"${COLOR_YELLOW} из группы  ${COLOR_GREEN}\"$2\"${COLOR_NC}"
        userShowGroup $1
        grep "^$1:" /etc/passwd >/dev/null
        #Проверка на успешность выполнения предыдущей команды
        if [ $? -eq 0 ]
        	then
        		#предыдущая команда завершилась успешно
        		if grep -q $2 /etc/group
                then
                     echo -n -e "Удалить пользователя ${COLOR_YELLOW}\""$1"\"${COLOR_NC} из группы ${COLOR_YELLOW}\"$2\"${COLOR_NC}? введите ${COLOR_BLUE}\"y\"${COLOR_NC} для подтверждения, для выхода - ${COLOR_BLUE}\"n\"${COLOR_NC}: "

                        while read
                        do
                            case "$REPLY" in
                            y|Y)  gpasswd -d $1 $2;
                                    userShowGroup $1
                                    break;;
                            n|N)  echo -e "\n${COLOR_YELLOW} Удаление пользователя ${COLOR_GREEN}\"$1\" ${COLOR_NC}${COLOR_YELLOW} из группы ${COLOR_GREEN}\"$2\"${COLOR_YELLOW} прекращено${COLOR_NC}"
                            break;;

                            esac
                        done

                else
                    echo -e "${COLOR_RED}Группа ${COLOR_GREEN}$2${COLOR_RED} не существует. Ошибка выполнения функции userDeleteFromGroup${COLOR_NC}"
                fi
        		#предыдущая команда завершилась успешно (конец)
        	else
        		#предыдущая команда завершилась с ошибкой
        		echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
        		#предыдущая команда завершилась с ошибкой (конец)
            fi
        #Конец проверки на успешность выполнения предыдущей команды
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
	    echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#Добавить ключ ssh к указанному пользователю
#$1-user ; $2-путь к ключу ssh ;
addAdminSshKeytoSite() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ] 
	then
	#Параметры запуска существуют
		grep "^$1:" /etc/passwd >/dev/null
		#Проверка на успешность выполнения предыдущей команды
		if [ $? -eq 0 ]
			then
				#предыдущая команда завершилась успешно
				#Проверка существования файла "$2"
				if [ -f $2 ] ; then
				    #Файл "$2" существует
				    #Проверка существования файла ""$HOMEPATHWEBUSERS/$1/.ssh/authorized_keys""
				    if [ -f "$HOMEPATHWEBUSERS/$1/.ssh/authorized_keys" ] ; then
				        #Файл ""$HOMEPATHWEBUSERS/$1/.ssh/authorized_keys"" существует
				        cat $2 >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				        #Файл ""$HOMEPATHWEBUSERS/$1/.ssh/authorized_keys"" существует (конец)
				    else
				        #Файл ""$HOMEPATHWEBUSERS/$1/.ssh/authorized_keys"" не существует
				        echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$HOMEPATHWEBUSERS/$1/.ssh/authorized_keys\"${COLOR_RED} не найден ${COLOR_NC}"
				        #Файл ""$HOMEPATHWEBUSERS/$1/.ssh/authorized_keys"" не существует (конец)
				    fi
				    #Конец проверки существования файла ""$HOMEPATHWEBUSERS/$1/.ssh/authorized_keys""

				    #Файл "$2" существует (конец)
				else
				    #Файл "$2" не существует
				    echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$2\"${COLOR_RED} не найден ${COLOR_NC}"
				    #Файл "$2" не существует (конец)
				fi
				#Конец проверки существования файла "$2"
				#предыдущая команда завершилась успешно (конец)
			else
				#предыдущая команда завершилась с ошибкой
				echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
				#предыдущая команда завершилась с ошибкой (конец)
		fi
		#Конец проверки на успешность выполнения предыдущей команды
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"addAdminSshKeytoSite\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#Генерация ssh-ключа пользователю $1
#$1-user ;
generateSshKey() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
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
				echo -e "\n${COLOR_YELLOW} Импорт ключа ${COLOR_LIGHT_PURPLE}\"$key\"${COLOR_YELLOW} пользователю ${COLOR_LIGHT_PURPLE}\"$1\"${COLOR_YELLOW} выполнен${COLOR_NC}"
				break
				;;
			*)
			echo ''
            ;;
			esac
		done



	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"generateSshKey\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}



#Вывод всех пользователей группы ftp-access
viewGroupFtpAccessAll(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"ftp-access\":${COLOR_NC}"
	more /etc/group | grep "ftp-access:" | highlight magenta "ftp-access"
}

#Вывод всех пользователей группы ftp-access с указанием части имени пользователя
# $1 - имя пользователя
viewGroupFtpAccessByName(){
	if [ -n "$1" ]
	then
		echo -e "\n${COLOR_YELLOW}Список пользователей группы \"ftp-access\", содержащих в имени \"$1\"${COLOR_NC}"
		more /etc/group | grep -E "ftp-access.*$1" | highlight green "$1" | highlight magenta "ftp-access"
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewGroupFtpAccessByName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}"
		exit 1
	fi
}

#Вывод всех пользователей группы ssh-access
viewGroupSshAccessAll(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"ssh-access\":${COLOR_NC}"
	more /etc/group | grep ssh-access: | highlight magenta "ssh-access"
}

#Вывод всех пользователей группы ssh-access с указанием части имени пользователя
# $1 - имя пользователя
viewGroupSshAccessByName(){
	if [ -n "$1" ]
	then
		echo -e "\n${COLOR_YELLOW}Список пользователей группы \"ssh-access\", содержащих в имени \"$1\"${COLOR_NC}"
		more /etc/group | grep -E "ssh-access.*$1" | highlight green "$1" | highlight magenta "ssh-access"
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewGroupSshAccessByName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}"
		exit 1
	fi
}

#ПРОВЕРНО
#Вывод всех пользователей группы users
#$1 - может быть выведен дополнительно текст, предшествующий выводу списка пользователей
viewGroupUsersAccessAll(){
    #Проверка на существование параметров запуска скрипта
    if [ -n "$1" ]
    then
    #Параметры запуска существуют
        echo -e "${COLOR_YELLOW}$1${COLOR_NC}"
        cat /etc/passwd | grep ":100::" | highlight magenta ":100::"
    #Параметры запуска существуют (конец)
    else
    #Параметры запуска отсутствуют
        cat /etc/passwd | grep ":100::" | highlight magenta ":100::"
    #Параметры запуска отсутствуют (конец)
    fi
    #Конец проверки существования параметров запуска скрипта
}

#Вывод всех пользователей группы users с указанием части имени пользователя
# $1 - имя пользователя
viewGroupUsersAccessByName(){
	if [ -n "$1" ]
	then
		echo -e "\n${COLOR_YELLOW}Список пользователей группы \"users\", содержащих в имени \"$1\"${COLOR_NC}"
		more /etc/passwd | grep -E ":100::.*$1" | highlight green "$1"
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewGroupUsersAccessByName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}"
		exit 1
	fi
}

#Вывод всех пользователей группы admin-access
viewGroupAdminAccessAll(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"admin-access:\":${COLOR_NC}"
	more /etc/group | grep admin-access: | highlight magenta "admin-access"
}

#Вывод всех пользователей группы admin-access с указанием части имени пользователя
# $1 - имя пользователя
viewGroupAdminAccessByName(){
	if [ -n "$1" ]
	then
		echo -e "\n${COLOR_YELLOW}Список пользователей группы \"admin-access\", содержащих в имени \"$1\"${COLOR_NC}"
		more /etc/group | grep -E "admin.*$1" | highlight green "$1" | highlight magenta "admin-access"
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewGroupAdminAccessByName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}"
		exit 1
	fi
}

#Вывод всех пользователей группы sudo
viewGroupSudoAccessAll(){
		echo -e "\n${COLOR_YELLOW}Список пользователей группы \"sudo\":${COLOR_NC}"
		more /etc/group | grep sudo: | highlight magenta "sudo"
}

#Вывод пользователей группы sudo с указанием части имени пользователя
# $1 - имя пользователя
viewGroupSudoAccessByName(){
	if [ -n "$1" ]
	then
		echo -e "\n${COLOR_YELLOW}Список пользователей группы \"sudo\", содержащих в названии {COLOR_YELLOW}\"$1\"{COLOR_NC}:${COLOR_NC}"
		more /etc/group | grep sudo: | highlight green "$1" | highlight magenta "sudo"
	else
		echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewGroupSudoAccessByName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}"
		exit 1
	fi
}

#Вывод групп, в которых состоит указанный пользователь
# $1 - имя пользователя
viewUserInGroupByName(){
	if [ -n "$1" ]
		then
			cat /etc/group | grep -P $1 | highlight green $1 | highlight magenta "ssh-access" | highlight magenta "ftp-access" | highlight magenta "sudo" | highlight magenta "admin-access"
		else
			echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewUserInGroupByName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}"
			exit 1
		fi
}

#Добавление системного пользователя
#$1-user ;
useraddSystem() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
	    grep "^$1:" /etc/passwd >/dev/null
	    #Проверка на успешность выполнения предыдущей команды
	    if [ $? -eq 0 ]
	    	then
	    		#Пользователь уже существует
	    		echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} уже существует${COLOR_NC}"
	    		#Пользователь уже существует (конец)
	    	else
	    		#Пользователь не существует и будет добавлен
	    		echo ''
                mkdir -p $HOMEPATHWEBUSERS/$1
                mkdir -p $HOMEPATHWEBUSERS/$1/.backups
                mkdir -p $HOMEPATHWEBUSERS/$1/.backups/autobackup
                mkdir -p $HOMEPATHWEBUSERS/$1/.backups/userbackup
                echo "source /etc/profile" >> $HOMEPATHWEBUSERS/$1/.bashrc
                sed -i '$ a source $SCRIPTS/include/include.sh'  $HOMEPATHWEBUSERS/$1/.bashrc

                useradd -N -g users -d $HOMEPATHWEBUSERS/$1 -s /bin/bash $1
                chmod 755 -R $HOMEPATHWEBUSERS/$1
                #chown $1:users -R $HOMEPATHWEBUSERS/$1
                find $HOMEPATHWEBUSERS/$1 -type d -exec chown $1:users {} \;
			    find $HOMEPATHWEBUSERS/$1 -type f -exec chown $1:users {} \;

                touch $HOMEPATHWEBUSERS/$1/.bashrc
                touch $HOMEPATHWEBUSERS/$1/.sudo_as_admin_successful
                echo -e "${COLOR_YELLOW}Установите пароль для пользователя ${COLOR_GREEN}\"$1\"${COLOR_NC}"
                passwd $1
                #Пользователь не существует и будет добавлен (конец)
	    fi
	    #Конец проверки на успешность выполнения предыдущей команды
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"useraddSystem\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}


#состоит ли пользователь $1 в группе $2
#функция возвращает значение 0-если пользователь состоит в группе "$2", 1- если не состоит в группе "$2"
#ничего не выводится
#$1-user ; $2-group
userExistInGroup() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования системного пользователя "$1"
			grep "^$1:" /etc/passwd >/dev/null
			if [ $? -eq 0 ]
			then
			#Пользователь $1 существует
				id $1 | grep -w $2 >/dev/null
				#Проверка на успешность выполнения предыдущей команды
				if [ $? -eq 0 ]
					then
						#предыдущая команда завершилась успешно
						return 0
						#предыдущая команда завершилась успешно (конец)
					else
						#предыдущая команда завершилась с ошибкой
						return 1
						#предыдущая команда завершилась с ошибкой (конец)
				fi
				#Конец проверки на успешность выполнения предыдущей команды
				return 0
			#Пользователь $1 существует (конец)
			else
			#Пользователь $1 не существует
				return 1
			#Пользователь $1 не существует (конец)
			fi
		#Конец проверки существования системного пользователя $1
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"UserExistInGroup\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#Существует ли группа $1
#функция возвращает значение 0-если группа $1 существует. 1- если группа не существует
#ничего не выводится
#$1-group
existGroup() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
		cat /etc/group | grep -w $1
		#Проверка на успешность выполнения предыдущей команды
		if [ $? -eq 0 ]
			then
				#предыдущая команда завершилась успешно
				return 0
				#предыдущая команда завершилась успешно (конец)
			else
				#предыдущая команда завершилась с ошибкой
				return 1
				#предыдущая команда завершилась с ошибкой (конец)
		fi
		#Конец проверки на успешность выполнения предыдущей команды
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"ExistGroup\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}


