#!/bin/bash
source /etc/profile
source ~/.bashrc
# не трогать
#Вывод информации о пользователях
declare -x -f viewGroupFtpAccessAll						#Вывод всех пользователей группы ftp-access
declare -x -f viewGroupFtpAccessByName					#Вывод всех пользователей группы ftp-access с указанием части имени пользователя ($1-user)
declare -x -f viewGroupSshAccessAll						#Вывод всех пользователей группы ssh-access
declare -x -f viewGroupSshAccessByName					#Вывод всех пользователей группы ssh-access с указанием части имени пользователя ($1-user)
declare -x -f viewGroupUsersAccessAll					#Вывод всех пользователей группы users
declare -x -f viewGroupUsersAccessByName				#Вывод всех пользователей группы users с указанием части имени пользователя ($1-user)
declare -x -f viewGroupAdminAccessAll					#Вывод всех пользователей группы admin-access
declare -x -f viewGroupAdminAccessByName				#Вывод всех пользователей группы admin-access с указанием части имени пользователя ($1-user)
declare -x -f viewGroupSudoAccessAll					#Вывод всех пользователей группы sudo
declare -x -f viewGroupSudoAccessByName					#Вывод пользователей группы sudo с указанием части имени пользователя ($1-user)
declare -x -f viewUserInGroupByName						#Вывод групп, в которых состоит указанный пользователь ($1-user)

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

#Вывод всех пользователей группы users
viewGroupUsersAccessAll(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"users\":${COLOR_NC}"
	cat /etc/passwd | grep ":100::" | highlight magenta ":100::"
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
