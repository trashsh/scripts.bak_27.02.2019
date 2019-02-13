#!/bin/bash


declare -x -f FileParamsNotFound	#Вывод сообщения с предложением запуска указанного в параметре 3 меню. #$1-user; $2-сообщение; $3-ссылка на скрипт меню для запуска
declare -x -f FolderExistWithInfo	#проверка существования папки с выводом информации. #$1-path, $2-type (create/exist)
declare -x -f FileExistWithInfo	#проверка существования файла с выводом информации. #$1-path, $2-type (create/exist)

#Вывод сообщения с предложением запуска указанного в параметре 3 меню
#$1-user; $2-сообщение; $3-ссылка на скрипт меню для запуска
FileParamsNotFound(){
echo -n -e "${COLOR_YELLOW}$2 ${COLOR_BLUE}\"y\"${COLOR_YELLOW}, для выхода введите ${COLOR_BLUE}\"n\"${COLOR_NC}:"
	while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) echo "$2"
				$3 $1;
					break;;
			n|N)  break;;
			esac
		done
		
}

#проверка существования папки с выводом информации.
#$1-path, $2-type (create/exist)
FolderExistWithInfo(){
	case "$2" in
				"create") 	
					if ! [ -d $1 ] ; then
						echo -e "${COLOR_RED}Каталог ${COLOR_GREEN}\"$1\"${COLOR_RED} не создан${COLOR_NC}"
					else 
						echo -e "${COLOR_GREEN}Каталог ${COLOR_YELLOW}\"$1\"${COLOR_GREEN} создан успешно${COLOR_NC}"
					fi
						;;			
				"exist")
					if ! [ -d $1 ] ; then 
						echo -e "${COLOR_RED}Каталог ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
					else 
						echo -e "${COLOR_GREEN}Каталог ${COLOR_YELLOW}\"$1\"${COLOR_GREEN} существует${COLOR_NC}"
					fi
					;;
				*) 
					echo -e "${COLOR_GREEN}Ошибка параметров в функции ${COLOR_YELLOW}\"FolderExistWithInfo\"${COLOR_NC}";;
				esac

}

#проверка существования файла с выводом информации.
#$1-path, $2-type (create/exist)
FileExistWithInfo(){
	case "$2" in
				"create") 	
					if ! [ -f $1 ] ; then
						echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$1\"${COLOR_RED} не создан${COLOR_NC}"
					else 
						echo -e "${COLOR_GREEN}Файл ${COLOR_YELLOW}\"$1\"${COLOR_GREEN} создан успешно${COLOR_NC}"
					fi
						;;			
				"exist")
					if ! [ -f $1 ] ; then 
						echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$1\"${COLOR_RED} не существует${COLOR_NC}"
					else 
						echo -e "${COLOR_GREEN}Файл ${COLOR_YELLOW}\"$1\"${COLOR_GREEN} существует${COLOR_NC}"
					fi
					;;
				*) 
					echo -e "${COLOR_GREEN}Ошибка параметров в функции ${COLOR_YELLOW}\"FolderExistWithInfo\"${COLOR_NC}";;
				esac
}