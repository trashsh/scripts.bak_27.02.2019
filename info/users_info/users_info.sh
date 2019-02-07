#!/bin/bash
source /etc/profile
source ~/.bashrc
#Вывод информации о пользователях

declare -x -f View_group_ftp-access_all
declare -x -f View_group_ftp-access_by_name
declare -x -f View_group_ssh-access_all
declare -x -f View_group_ssh-access_by_name
declare -x -f View_group_users_all
declare -x -f View_group_users_by_name
declare -x -f View_group_admin-access_all
declare -x -f View_group_admin-access_by_name
declare -x -f View_sudo-access_by_name
declare -x -f View_user_in_group

#Вывод всех пользователей группы ftp-access
View_group_ftp-access_all(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"ftp-access\":${COLOR_NC}"
	more /etc/group | grep "ftp-access:" | highlight green "ftp-access"
		
}

#Вывод всех пользователей группы ftp-access с указанием части имени пользователя
View_group_ftp-access_by_name(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"ftp-access\", содержащих в имени \"$1\"${COLOR_NC}"
	more /etc/group | grep -E "ftp-access.*$1" | highlight green "$1"
}

#Вывод всех пользователей группы ssh-access
View_group_ssh-access_all(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"ssh-access\":${COLOR_NC}"
	more /etc/group | grep ssh-access: | highlight green "ssh-access"
}

#Вывод всех пользователей группы ssh-access с указанием части имени пользователя
View_group_ssh-access_by_name(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"ssh-access\", содержащих в имени \"$1\"${COLOR_NC}"
	more /etc/group | grep -E "ssh-access.*$1" | highlight green "$1"
}

#Вывод всех пользователей группы users
View_group_users_all(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"users\":${COLOR_NC}"
	cat /etc/passwd | grep ":100::" | highlight green "users"
}

#Вывод всех пользователей группы users с указанием части имени пользователя
View_group_users_by_name(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"users\", содержащих в имени \"$1\"${COLOR_NC}"
	more /etc/passwd | grep -E ":100::.*$1" | highlight green "$1"
}

#Вывод всех пользователей группы admin-access
View_group_admin-access_all(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"admin-access:\":${COLOR_NC}"
	more /etc/group | grep admin-access: | highlight green "admin-access"
}

#Вывод всех пользователей группы admin-access с указанием части имени пользователя
View_group_admin-access_by_name(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"admin-access\", содержащих в имени \"$1\"${COLOR_NC}"
	more /etc/passwd | grep -E "admin-access.*$1" | highlight green "$1"
}


#Вывод всех пользователей группы sudo
View_sudo-access_by_name(){
	echo -e "\n${COLOR_YELLOW}Список пользователей группы \"sudo\":${COLOR_NC}"
	more /etc/group | grep sudo: | highlight green "$1" 
}

#Вывод групп, в которых состоит указанный пользователь
View_user_in_group(){
	cat /etc/group | grep -P $1 | highlight green $1 | highlight yellow "ssh-access" | highlight yellow "ftp-access" | highlight yellow "sudo" | highlight yellow "admin-access" 
}



