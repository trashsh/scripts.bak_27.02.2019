#!/bin/bash
#Функции пользователей
source $SCRIPTS/functions/archive.sh
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/other.sh
source $SCRIPTS/functions/site.sh

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

declare -x -f sshKeyAddToUser                           #$1-user ; $2-Если параметр равен 1, то запрос происходит в интерактивном режиме, если 0, то в тихом режиме ;
                                                        #3 - $3-путь к ключу ;
                                                        #return 1 - пользователь не существует, 2 - файл ключа не существует
                                                        #3- ошибка передачи параметра $3, 4 - не передан путь к файлу при тихом режиме

#описать функцию
declare -x -f viewUserFullInfo #Отображение полной информации о пользователе: ($1-user)



#Полностью проверено
declare -x -f existGroup                                #Существует ли группа $1
                                                        #функция возвращает значение 0-если группа $1 существует. 1- если группа не существует
                                                        #Если передан параметр $2, равный 1, то выведется текст сообщения о существовании группы
                                                        #$1-group
                                                        #return 0 - группа $1 существует, 1 - группа $1 не существует
declare -x -f userAddSystem #Добавление системного пользователя: ($1-user ;)
declare -x -f viewGroupUsersAccessAll					#Вывод всех пользователей группы users. #$1 - может быть выведен дополнительно текст, предшествующий выводу списка пользователей
declare -x -f userExistInGroup                          #состоит ли пользователь $1 в группе $2
                                                        #функция возвращает значение 0-если пользователь состоит в группе "$2", 1- если не состоит в группе "$2"
                                                        #ничего не выводится
                                                        #$1-user ; $2-group; $3-может быть передан параметр 3, равеный 1, тогда выведется сообщение о присутствии или отсутствии пользвоателя в группе
                                                        #return 0 - нет ошибок, 1 - пользователь не существует, 2 - не переданы параметры
declare -x -f viewUserGroups                            #Вывод списка групп, в которых состоит пользователь (полное совпадение): ($1-user ;)
declare -x -f userAddToGroup                            #Добавить пользователя в группу sudo
                                                        #$1-user ; $2-группа; Если есть параметр 3, равный 1, то добавление происходит с запросом подтверждения, если без - в тихом режиме
                                                        #return 0 - успешно выполнено; 1 - не существует пользователь; 2 - отмена пользователем
                                                        #3 - пользователь уже присутствует в группе $1
declare -x -f userDeleteFromGroup                       #Удаление пользователя $1 из группы $2
                                                        #$1-user ; $2-group ;
                                                        #return 0 - пользователь удален; 1 - отмена удаления пользователем
                                                        #2 - пользователя $1 нет в группе $2; 3 - группа $2 не существует
declare -x -f sshKeyGenerateToUser                      #Генерация ssh-ключа для пользователя: ($1-user)
                                                        #return 0 - выполнено без ошибок, 1 - отсутствуют параметры запуска
                                                        #2 - нет указанного пользователя


#Отображение полной информации о пользователе
#$1-user ;
#return 0 - выполнено успешно, 1 - отсутствуют параметры
#2 - пользователь не существует
viewUserFullInfo() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
		#Проверка существования системного пользователя "$1"
			grep "^$1:" /etc/passwd >/dev/null
			if  [ $? -eq 0 ]
			then
			#Пользователь $1 существует
			    viewUserGroups $1
				echo "Описать функцию viewUserFullInfo. Пользователь $1 существует"
				return 0
			#Пользователь $1 существует (конец)
			else
			#Пользователь $1 не существует
			    echo -e "${COLOR_RED}Пользователь mysql ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует. Функция ${COLOR_GREEN}\"viewUserFullInfo\"${COLOR_NC}"
                return 2
			#Пользователь $1 не существует (конец)
			fi
		#Конец проверки существования системного пользователя $1
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"viewUserFullInfo\"${COLOR_RED} ${COLOR_NC}"
		return 1
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}



#Проте
#Вывод списка групп, в которых состоит пользователь
#$1-user ;
viewUserGroups() {
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

		        #Проверка наличия пользователя в группе users
		        userExistInGroup $1 users
		        #Проверка на успешность выполнения предыдущей команды
		        if [ $? -eq 0 ]
		        	then
		        		#предыдущая команда завершилась успешно
		        		echo -e "users:x:100:$1" | highlight green "$1"
		        		#предыдущая команда завершилась успешно (конец)
		        fi
		        #Конец проверки на успешность выполнения предыдущей команды

				#предыдущая команда завершилась успешно (конец)
			else
				#предыдущая команда завершилась с ошибкой
				echo -e "${COLOR_RED}Пользователь ${COLOR_YELLOW}\"$1\"${COLOR_RED} не найден. Ошибка выполнения функции viewUserGroups${COLOR_NC}"
				#предыдущая команда завершилась с ошибкой (конец)
		fi
		#Конец проверки на успешность выполнения предыдущей команды
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"viewUserGroups\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

#Удаление пользователя $1 из группы $2
#$1-user ; $2-group ;
#return 0 - пользователь удален; 1 - отмена удаления пользователем
#2 - пользователя $1 нет в группе $2; 3 - группа $2 не существует
userDeleteFromGroup() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют

	#Проверка существования системного пользователя "$1"
		grep "^$1:" /etc/passwd >/dev/null
		if  [ $? -eq 0 ]
		then
		#Пользователь $1 существует

		    existGroup $2
		    #Проверка на успешность выполнения предыдущей команды
		    if [ $? -eq 0 ]
		    	then
		    		#если группа $1 существует
		    		#проверка на наличие пользователя в группе $2
                    userExistInGroup $1 $2
                    #Проверка на успешность выполнения предыдущей команды (наличие пользователя в группе)
                    if [ $? -eq 0 ]
                        then
                            #предыдущая команда завершилась успешно
                            echo -e "${COLOR_YELLOW}Удалить пользователя ${COLOR_GREEN}\"$1\"${COLOR_YELLOW} из группы ${COLOR_GREEN}\"$2\"${COLOR_YELLOW}? ${COLOR_NC}"
                            echo -n -e "${COLOR_YELLOW}Введите ${COLOR_GREEN}\"y\"${COLOR_YELLOW} для подтверждения или ${COLOR_GREEN}\"n\"${COLOR_YELLOW} - для отмены: ${COLOR_NC}: "
                            while read
                            do
                                case "$REPLY" in
                                    y|Y)
                                        gpasswd -d $1 $2
                                        echo -e "${COLOR_GREEN}Пользователь ${COLOR_YELLOW}\"$1\"${COLOR_GREEN} успешно удален из группы ${COLOR_YELLOW}\"$2\" ${COLOR_NC}"
                                        return 0
                                        #break
                                        ;;
                                    n|N)
                                        return 1
                                        #break
                                        ;;
                                    *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2
                                       ;;
                                esac
                            done

                            #предыдущая команда завершилась успешно (конец)
                        else
                            #предыдущая команда завершилась с ошибкой
                            echo -e "${COLOR_YELLOW}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_YELLOW} не присутствует в группе ${COLOR_GREEN}\"$2\" ${COLOR_NC}"
                            return 2
                                    #предыдущая команда завершилась с ошибкой (конец)
                        fi
                            #Конец проверки на успешность выполнения предыдущей команды
                    #проверка на наличие пользователя в группе sudo (конец)
                #если группа $1 существует (конец)
		    	else
		    		#если группа $1 не существует
		    		echo -e "${COLOR_RED}Группа ${COLOR_GREEN}\"$2\"${COLOR_RED} не существует. Ошибка выполнения функции ${COLOR_YELLOW}\"userDeleteFromGroup\"${COLOR_NC}"
		    		return 3
		    		#если группа $1 не существует (конец)
		    fi
		    #Конец проверки на успешность выполнения предыдущей команды
		#Пользователь $1 существует (конец)
		else
		#Пользователь $1 не существует
		    echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует. Ошибка выполнения функции ${COLOR_YELLOW}\"userDeleteFromGroup\"${COLOR_NC}"
            return 1
		#Пользователь $1 не существует (конец)
		fi
	#Конец проверки существования системного пользователя $1

	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"userDeleteFromGroup\"${COLOR_RED} ${COLOR_NC}"
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

#Полностью готово
#Вывод всех пользователей группы users
#$1 - может быть выведен дополнительно текст, предшествующий выводу списка пользователей
#return 0 - успешно, 1 - неуспешно, параметр $1 передан, 2 - неуспешно, параметр $1 не передан
viewGroupUsersAccessAll(){
    #Проверка на существование параметров запуска скрипта
    if [ -n "$1" ]
    then
    #Параметры запуска существуют
        echo -e "${COLOR_YELLOW}$1${COLOR_NC}"
        cat /etc/passwd | grep ":100::" | highlight magenta ":100::"
        #Проверка на успешность выполнения предыдущей команды
        if [ $? -eq 0 ]
        	then
        		#предыдущая команда завершилась успешно
        		return  0
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
        cat /etc/passwd | grep ":100::" | highlight magenta ":100::"
        #Проверка на успешность выполнения предыдущей команды
        if [ $? -eq 0 ]
        	then
        		#предыдущая команда завершилась успешно
        		return 0
        		#предыдущая команда завершилась успешно (конец)		
        	else
        		#предыдущая команда завершилась с ошибкой
        		return 2
        		#предыдущая команда завершилась с ошибкой (конец)
        fi
        #Конец проверки на успешность выполнения предыдущей команды
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
		echo -e "\n${COLOR_YELLOW}Список пользователей группы \"sudo\", содержащих в названии ${COLOR_YELLOW}\"$1\"${COLOR_NC}:${COLOR_NC}"
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
			return 0
		else
			echo -e "${COLOR_LIGHT_RED}Не передан параметр в функцию viewUserInGroupByName в файле $0. Выполнение скрипта аварийно завершено ${COLOR_NC}"
			exit 1
		fi
}

#Готово. Можно добавить доп.функционал
#Добавление системного пользователя
#$1-user ;
#return 0 - выполнено успешно, 1 - пользователь уже существует
#2 - пользователь отменил создание пользователя
userAddSystem() {
	viewGroupUsersAccessAll
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
	    username=$1

	else
	    echo -e -n "${COLOR_BLUE}"Введите имя пользователя: "${COLOR_NC}"
		read username
	fi
	    grep "^$username:" /etc/passwd >/dev/null

	    #Проверка на успешность выполнения предыдущей команды
	    if [ $? -eq 0 ]
	    	then
	    		#Пользователь уже существует
	    		echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$username\"${COLOR_RED} уже существует${COLOR_NC}"
	    		return 1
	    		#Пользователь уже существует (конец)
	    else
                #Пользователь не существует и будет добавлен
                echo -n -e "${COLOR_YELLOW}Подтвердите добавление пользователя ${COLOR_GREEN}\"$username\"${COLOR_YELLOW} введя ${COLOR_BLUE}\"y\"${COLOR_YELLOW}, или для отмены операции ${COLOR_BLUE}\"n\"${COLOR_NC}: "
                while read
                do
                    case "$REPLY" in
                        y|Y)
                            echo -e "${COLOR_YELLOW}Выполнение операций по созданию пользователя ${COLOR_GREEN}\"$username\"${COLOR_NC}"
                            echo -n -e "${COLOR_YELLOW}Установите пароль пользователя ${COLOR_GREEN}$username: ${COLOR_NC}: "
                            read password

                            #Проверка на пустое значение переменной
                            if [[ -z "$password" ]]; then
                                #переменная имеет пустое значение
                                echo -e "${COLOR_RED}"Пароль не может быть пустым. Отмена создания пользователя"${COLOR_NC}"
                                #переменная имеет пустое значение (конец)
                            else
                                #переменная имеет не пустое значение
                                mkdir -p $HOMEPATHWEBUSERS/$username
                                useradd -N -g users -G ftp-access -d $HOMEPATHWEBUSERS/$username -s /bin/bash $username
                                echo "$username:$password" | chpasswd
                                mkdirWithOwn $HOMEPATHWEBUSERS/$username/backups $username users 777
                                mkdirWithOwn $HOMEPATHWEBUSERS/$username/backups/auto $username users 755
                                mkdirWithOwn $HOMEPATHWEBUSERS/$username/backups/manually $username users 755
                                touchFileWithModAndOwn $HOMEPATHWEBUSERS/$username/.bashrc $username users 644
                                touchFileWithModAndOwn $HOMEPATHWEBUSERS/$username/.sudo_as_admin_successful $username users 644
                                echo "source /etc/profile" >> $HOMEPATHWEBUSERS/$username/.bashrc
                                sed -i '$ a source $SCRIPTS/include/include.sh'  $HOMEPATHWEBUSERS/$username/.bashrc
                                dbSetMyCnfFile $username $password
                                chModAndOwnFile $HOMEPATHWEBUSERS/$username/.my.cnf $username users 600
                                #chModAndOwnFolderAndFiles $HOMEPATHWEBUSERS/$username 755 644 $username users
                                #добавление в группу sudo
                                userAddToGroup $username sudo 1

                                echo -n -e "${COLOR_YELLOW}Введите ${COLOR_BLUE}\"g\"${COLOR_NC}${COLOR_YELLOW} для генерации ssh-ключа, ${COLOR_GREEN}\"i\"${COLOR_NC}${COLOR_YELLOW} - для импорта существующего на сервер ключа, ${COLOR_BLUE}\"q\"${COLOR_YELLOW} - для отмены добавления ssh-ключа${COLOR_NC}: "
                                	while read
                                	do
                                    	echo -n ": "
                                    	case "$REPLY" in
                                	    	g|G) sshKeyGenerateToUser $username;
                                	    	     sshKeyAddToUser $username 0 $sshAdminKeyFilePath;
                                		    	break;;
                                		    i|I)
                                                sshKeyAddToUser $username 1;
                                                sshKeyAddToUser $username 0 $sshAdminKeyFilePath;
                                		    	break;;
                                		    q|Q)
                                                return 2;
                                			    break;;
                                	    esac
                                	done

                                echo -e "${COLOR_GREEN}Пользователь ${COLOR_YELLOW}\"$username\"${COLOR_GREEN} успешно добавлен${COLOR_YELLOW}\"\"${COLOR_GREEN} ${COLOR_NC}"

                                viewUserFullInfo $username
                            fi
                            #Проверка на пустое значение переменной (конец)

                            break
                            ;;
                        n|N)
                            echo -e "${COLOR_RED}Отмена создания пользователя ${COLOR_GREEN}\"$username\"${COLOR_NC}"
                            return 2
                            break
                            ;;
                        *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2
                           ;;
                    esac
                done

	##Здесь описать порядок действий при создании пользователя
	return 0
                #Пользователь не существует и будет добавлен (конец)
	    fi
	    #Конец проверки на успешность выполнения предыдущей команды
	#Параметры запуска существуют (конец)
}

#Полностью проверно
#состоит ли пользователь $1 в группе $2
#функция возвращает значение 0-если пользователь состоит в группе "$2", 1- если не состоит в группе "$2"
#ничего не выводится
#$1-user ; $2-group; $3-может быть передан параметр 3, равеный 1, тогда выведется сообщение о присутствии или отсутствии пользвоателя в группе
#return 0 - нет ошибок, 1 - пользователь не существует, 2 - не переданы параметры
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
						#Если передан параметр 3 и он равен 1
                        if [ "$3" == "1" ]
                        then
                            echo -e "${COLOR_GREEN}Пользователь ${COLOR_YELLOW}\"$1 \"${COLOR_GREEN}входит в группу ${COLOR_YELLOW}\"$2\"${COLOR_GREEN} ${COLOR_NC}"
                        fi
						return 0
						#предыдущая команда завершилась успешно (конец)
					else
						#предыдущая команда завершилась с ошибкой
						#Если передан параметр 3 и он равен 1
                        if [ "$3" == "1" ]
                        then
                            echo -e "${COLOR_RED}Пользователь ${COLOR_YELLOW}\"$1 \"${COLOR_RED}не входит в группу ${COLOR_YELLOW}\"$2\" ${COLOR_NC}"
                        fi
						return 1
						#предыдущая команда завершилась с ошибкой (конец)
				fi
				#Конец проверки на успешность выполнения предыдущей команды
				return 0
			#Пользователь $1 существует (конец)
			else
			#Пользователь $1 не существует
			    echo -e "${COLOR_RED}Пользователь ${COLOR_YELLOW}\"$1 \"${COLOR_RED}не существует${COLOR_NC}"
				return 1
			#Пользователь $1 не существует (конец)
			fi
		#Конец проверки существования системного пользователя $1
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"UserExistInGroup\"${COLOR_RED} ${COLOR_NC}"
		return 2
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#Существует ли группа $1
#функция возвращает значение 0-если группа $1 существует. 1- если группа не существует
#Если передан параметр $2, равный 1, то выведется текст сообщения о существовании группы
#$1-group
#return 0 - группа $1 существует, 1 - группа $1 не существует
existGroup() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]
	then
	#Параметры запуска существуют
		cat /etc/group | grep -w $1 >/dev/null
		#Проверка на успешность выполнения предыдущей команды
		if [ $? -eq 0 ]
			then
				#предыдущая команда завершилась успешно
				#Проверка наличия параметра $2, равного 1
				if [ "$2" == "1" ]
				then
				     echo -e "${COLOR_GREEN}Группа ${COLOR_YELLOW}\"$1 \"${COLOR_GREEN}существует${COLOR_NC}"
				fi
				#Проверка наличия параметра $2, равного 1 (конец)
				return 0
				#предыдущая команда завершилась успешно (конец)
			else
				#предыдущая команда завершилась с ошибкой
				#Проверка наличия параметра $2, равного 1
				if [ "$2" == "1" ]
				then
				     echo -e "${COLOR_RED}Группа ${COLOR_YELLOW}\"$1 \"${COLOR_RED}не существует${COLOR_NC}"
				fi
				#Проверка наличия параметра $2, равного 1 (конец)
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

#Добавить пользователя в группу sudo
#$1-user ; $2-группа; Если есть параметр 3, равный 1, то добавление происходит с запросом подтверждения, если без - в тихом режиме
#return 0 - успешно выполнено; 1 - не существует пользователь; 2 - отмена пользователем
#3 - пользователь уже присутствует в группе $1
userAddToGroup() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]  && [ -n "$2" ] && [ -n "$3" ]
	then
	#Параметры запуска существуют

	#Проверка существования системного пользователя "$1"
		grep "^$1:" /etc/passwd >/dev/null
		if  [ $? -eq 0 ]
		then
		#Пользователь $1 существует

		    existGroup $2
		    #Проверка на успешность выполнения предыдущей команды
		    if [ $? -eq 0 ]
		    	then
		    		#если группа $1 существует
		    		#проверка на наличие пользователя в группе $2
                    userExistInGroup $1 $2
                    #Проверка на успешность выполнения предыдущей команды (наличие пользователя в группе)
                    if [ $? -eq 0 ]
                        then
                            #предыдущая команда завершилась успешно
                            echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} уже присутствует в группе ${COLOR_GREEN}\"$2\"${COLOR_NC}"
                            return 3
                            #предыдущая команда завершилась успешно (конец)
                        else
                            #предыдущая команда завершилась с ошибкой

                            #Проверка наличия параметра $3, равного 1
                            if [ "$3" == "1" ]
                            then
                                    #Присутстует параметр $3, равный 1
                                    echo -e "${COLOR_YELLOW}Добавить пользователя ${COLOR_GREEN}\"$1\"${COLOR_YELLOW} в группу ${COLOR_GREEN}\"$2\"${COLOR_YELLOW}? ${COLOR_NC}"
                                    echo -n -e "${COLOR_YELLOW}Введите ${COLOR_GREEN}\"y\"${COLOR_YELLOW} для подтверждения или ${COLOR_GREEN}\"n\"${COLOR_YELLOW} - для отмены: ${COLOR_NC}: "
                                    while read
                                    do
                                        case "$REPLY" in
                                            y|Y)
                                                adduser $1 $2;
                                                echo -e "${COLOR_GREEN}Пользователь ${COLOR_YELLOW}\"$1\"${COLOR_GREEN} успешно добавлен в группу ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
                                                return 0
                                                #break
                                                ;;
                                            n|N)
                                                return 2
                                                #break
                                                ;;
                                            *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2
                                               ;;
                                        esac
                                    done
                                 #Присутствует параметр $3, равный 1 (конец)
                            else
                                if [ "$3" == "0" ]
                                then
                                    #Отсутствует параметр $3, равный 1
                                    adduser $1 $2
                                    echo -e "${COLOR_GREEN}Пользователь ${COLOR_YELLOW}\"$1\"${COLOR_GREEN} успешно добавлен в группу ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
                                    #Отсутствует параметр $3, равный 1 (конец)
                                else
                                    echo -e "${COLOR_RED}Ошибка в параметре в функции ${COLOR_GREEN}\"userAddToGroup\"${COLOR_NC}"
                                fi
                            fi
                            #Проверка наличия параметра $3, равного 1 (конец)

                            #предыдущая команда завершилась с ошибкой (конец)
                            fi
                            #Конец проверки на успешность выполнения предыдущей команды
                    #проверка на наличие пользователя в группе sudo (конец)
                #если группа $1 существует (конец)
		    	else
		    		#если группа $1 не существует
		    		echo -e "${COLOR_RED}Группа ${COLOR_GREEN}\"$2\"${COLOR_RED} не существует. Ошибка выполнения функции ${COLOR_YELLOW}\"userAddToGroup\"${COLOR_NC}"
		    		#если группа $1 не существует (конец)
		    fi
		    #Конец проверки на успешность выполнения предыдущей команды
		#Пользователь $1 существует (конец)
		else
		#Пользователь $1 не существует
		    echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует. Ошибка выполнения функции ${COLOR_YELLOW}\"userAddToGroup\"${COLOR_NC}"
            return 1
		#Пользователь $1 не существует (конец)
		fi
	#Конец проверки существования системного пользователя $1

	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"userAddToGroup\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}


#Добавление существующего ключа $2 пользователю $1
#$1-user ; $2-Если параметр равен 1, то запрос происходит в интерактивном режиме, если 0, то в тихом режиме ;
#3 - $3-путь к ключу ;
#return 1 - пользователь не существует, 2 - файл ключа не существует
#3- ошибка передачи параметра $3, 4 - не передан путь к файлу при тихом режиме
sshKeyAddToUser() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
    #Проверка существования системного пользователя "$1"
    	grep "^$1:" /etc/passwd >/dev/null
    	if  [ $? -eq 0 ]
    	then
    	#Пользователь $1 существует
            #Проверка наличия параметра $2, равного 1
    		if [ "$2" == "1" ]
    		then
                 echo -e "\n${COLOR_YELLOW} Список возможных ключей для импорта: ${COLOR_NC}"
			     ls -l $SETTINGS/ssh/keys/
			     echo -n -e "${COLOR_BLUE} Укажите название открытого ключа, который необходимо применить к текущему пользователю: ${COLOR_NC}"
			     read  keyname
			     key=$SETTINGS/ssh/keys/$keyname
			     #Проверка существования файла "$key"
			     if ! [ -f $key ] ; then
			         #Файл "$key" не существует
			         echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$key\"${COLOR_RED} не существует. Выполнение операции прервано${COLOR_NC}"
			         return 2
			         break
			         #Файл "$key" не существует (конец)
			     fi
			     #Конец проверки существования файла "$key"
    		else
                if [ "$2" == "0" ]
                then
                    #Проверка на существование параметров запуска скрипта
                    if [ -n "$3" ]
                    then
                    #Параметры запуска существуют
                        #Проверка существования файла "$3"
                        if [ -f $3 ] ; then
                            #Файл "$3" существует
                            key=$3
                            #Файл "$3" существует (конец)
                        else
                            #Файл "$3" не существует
                            echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$3\"${COLOR_RED} не существует. Ошибка выполнения функции ${COLOR_GREEN}\"sshKeyAddToUser\"${COLOR_NC}"
                            return 2
                            break
                            #Файл "$3" не существует (конец)
                        fi
                        #Конец проверки существования файла "$3"
                    #Параметры запуска существуют (конец)
                    else
                    #Параметры запуска отсутствуют
                        echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"sshKeyAddToUser\"${COLOR_RED} ${COLOR_NC}"
                        return 4
                        break
                    #Параметры запуска отсутствуют (конец)
                    fi
                    #Конец проверки существования параметров запуска скрипта
                else
                    echo -e "${COLOR_RED}"Ошибка передачи параметра $3"${COLOR_NC}"
                    return 3
                    break
                fi
    		fi

                 mkdirWithOwn $HOMEPATHWEBUSERS/$1/ $1 users 755
    		     mkdirWithOwn $HOMEPATHWEBUSERS/$1/.ssh $1 users 755
    		     DATE=`date '+%Y-%m-%d__%H-%M-%S'`
				 mkdirWithOwn $BACKUPFOLDER_IMPORTANT/ssh/$1 $1 users 755
				 cat $key >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				 echo "" >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				 tar_file_structure $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys $BACKUPFOLDER_IMPORTANT/ssh/$1/authorized_keys_$DATE.tar.gz
				 chModAndOwnFile $BACKUPFOLDER_IMPORTANT/ssh/$1/authorized_keys_$DATE.tar.gz $1 users 644
				 chModAndOwnFile $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys $1 users 600
				 chown $1:users $HOMEPATHWEBUSERS/$1/.ssh
				 usermod -G ssh-access -a $1
				 echo -e "\n${COLOR_YELLOW} Импорт ключа ${COLOR_LIGHT_PURPLE}\"$key\"${COLOR_YELLOW} пользователю ${COLOR_LIGHT_PURPLE}\"$1\"${COLOR_YELLOW} выполнен${COLOR_NC}"
    		#Проверка наличия параметра $2, равного 1 (конец)

    	#Пользователь $1 существует (конец)
    	else
    	#Пользователь $1 не существует
    	    echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
    		return 1
    	#Пользователь $1 не существует (конец)
    	fi
    #Конец проверки существования системного пользователя $1

	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"sshKeyAddToUser\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}


#Генерация ssh-ключа для пользователя
#$1-user ;
#return 0 - выполнено без ошибок, 1 - отсутствуют параметры запуска
#2 - нет указанного пользователя
sshKeyGenerateToUser() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ]   
	then
	#Параметры запуска существуют

	#Проверка существования системного пользователя "$1"
		grep "^$1:" /etc/passwd >/dev/null
		if  [ $? -eq 0 ]
		then
		#Пользователь $1 существует
                DATE=`date '+%Y-%m-%d__%H-%M-%S'`
                DATE_TYPE2=`date '+%d.%m.%Y %H:%M:%S'`
                #Проверка существования каталога "$HOMEPATHWEBUSERS/$1/.ssh"
                if [ -d $HOMEPATHWEBUSERS/$1/.ssh ] ; then
                    #Каталог "$HOMEPATHWEBUSERS/$1/.ssh" существует
                    tar_folder_structure $HOMEPATHWEBUSERS/$1/.ssh/ $BACKUPFOLDER_IMPORTANT/ssh/$1/ssh_backuped_$DATE.tar.gz
                    #Каталог "$HOMEPATHWEBUSERS/$1/.ssh" существует (конец)
                fi
            #Конец проверки существования каталога "$HOMEPATHWEBUSERS/$1/.ssh"
				#mkdir -p $HOMEPATHWEBUSERS/$1/.ssh
				mkdirWithOwn $HOMEPATHWEBUSERS/$1/.ssh $1 users 766
				cd $HOMEPATHWEBUSERS/$1/.ssh
				echo -e "\n${COLOR_YELLOW} Генерация ключа. Сейчас необходимо будет установить пароль на ключевой файл.Минимум - 5 символов${COLOR_NC}"
				ssh-keygen -t rsa -f ssh_$1 -C "ssh_$1 ($DATE_TYPE2)"
				#echo -e "\n${COLOR_YELLOW} Конвертация ключа в формат программы Putty. Необходимо ввести пароль на ключевой файл, установленный на предыдушем шаге ${COLOR_NC}"
				sudo puttygen $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1 -C "ssh_$1 ($DATE_TYPE2)" -o $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.ppk
				mkdirWithOwn $BACKUPFOLDER_IMPORTANT/ssh/$1 $1 users 766
				cat $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.pub >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				tar_folder_structure $HOMEPATHWEBUSERS/$1/.ssh/ $BACKUPFOLDER_IMPORTANT/ssh/$1/ssh_generated_$DATE.tar.gz
                chModAndOwnFile $BACKUPFOLDER_IMPORTANT/ssh/$1/ssh_generated_$DATE.tar.gz $1 users 644

                #chModAndOwnFolderAndFiles $HOMEPATHWEBUSERS/$1/.ssh 700 600 $1 users
				usermod -G ssh-access -a $1
				return 0
		#Пользователь $1 существует (конец)
		else
		#Пользователь $1 не существует
		    echo -e "${COLOR_RED}Пользователь ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует. Ошибка в функции ${COLOR_GREEN}\"sshKeyGenerateToUser\"${COLOR_NC}"
			return 2
		#Пользователь $1 не существует (конец)
		fi
	#Конец проверки существования системного пользователя $1
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в функции ${COLOR_GREEN}\"sshKeyGenerateToUser\"${COLOR_RED} ${COLOR_NC}"
		return 1
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта    
}

