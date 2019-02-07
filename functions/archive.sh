#!/bin/bash
#source /etc/profile
#source ~/.bashrc
#Вывод сообщения с предложением запуска указанного в параметре 3 меню

#архивация файла со структурой каталогов
tar_file_structure(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	#если есть файл архивации
	if [ -f $1 ] ; then
		#Если есть каталог назначения
		if [ -d `dirname $2` ] ; then
			tar cfz $2 $1
		#Если нет каталога назначения	
		else
			echo -e "${COLOR_RED} Каталог \"$1\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога \"`dirname $2`\", для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
				case "$REPLY" in
				y|Y) mkdir -p \"`dirname $2`\";
					 tar cfz $2 $1;
					 break;;
				n|N)
					 break;;
				esac							 
			done		
		fi
	
	
	
	
	else	
	#нет файла
	echo -e "${COLOR_RED} Отсутствует файл \"$1\" ${COLOR_NC}"
	fi	
#нет параметров	
	echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции \"tar_file_structure\" ${COLOR_NC}"
fi	
	


}

#архивация файла со структурой каталогов и удаление оригинала
tar_file_structure_remove(){
	tar cfz $3 $2 --remove-files
}

declare -x -f tar_file_structure	#архивация файла со структурой каталогов
declare -x -f tar_file_structure_remove		#архивация файла со структурой каталогов и удаление оригинала