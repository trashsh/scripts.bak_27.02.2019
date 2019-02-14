#!/bin/bash

declare -x -f tar_file_structure	#архивация файла со структурой каталогов:	#$1-ссылка на архивируемый файл; $2-ссылка на конечный архив
declare -x -f tar_file_structure_remove	#архивация файла со структурой каталогов, последующее удаление оригинала файла:	#$1-ссылка на архивируемый файл; $2-ссылка на конечный архив
declare -x -f tar_file_without_structure	#архивация файла без сохранения структуры каталогов:	#$1-ссылка на архивируемый файл; $2-ссылка на конечный архив
declare -x -f tar_file_without_structure_remove	#архивация файла без сохранения структуры каталогов, последующее удаление оригинала файла:	#$1-ссылка на архивируемый файл; $2-ссылка на конечный архив
declare -x -f tar_folder_structure #архивация папки со структурой каталогов:	#$1-ссылка на архивируемый каталог; $2-ссылка на конечный архив
declare -x -f tar_folder_structure_remove	#архивация папки со структурой каталогов, последующее удаление оригинала файла:	#$1-ссылка на архивируемый каталог; $2-ссылка на конечный архив
declare -x -f tar_folder_without_structure #архивация содержимого папки без сохранения структуры каталогов: #$1-ссылка на каталог, содержащий архивируемые файлы; $2-ссылка на конечный архив
declare -x -f tar_folder_without_structure_remove #архивация содержимого папки без сохранения структуры каталогов, последующее удаление оригинала файла:	#$1-ссылка на каталог, содержащий архивируемые файлы; $2-ссылка на конечный архив
declare -x -f untar_without_structure #разархивация содержимого папки без сохранения структуры каталогов #$1-ссылка на каталог разархивации; $2-ссылка на архив
declare -x -f untar_with_structure	#разархивация содержимого папки с сохранением структуры каталогов: ##$1-ссылка на каталог разархивации; $2-ссылка на архив

declare -x -f backupImportantFile #Создание бэкапов в каталог BACKUPFOLDER_IMPORTANT $1-user, $2-destination_folder в папке BACKUPFOLDER_IMPORTANT, $3-файл для создания бэкапа


#######СДЕЛАНО. Не трогать!!!!#######
#архивация файла со структурой каталогов
#$1-ссылка на архивируемый файл; $2-ссылка на конечный архив
tar_file_structure(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	#если есть файл архивации
	if [ -f $1 ] ; then
		#Если есть каталог назначения
		if [ -d `dirname $2` ]
		then
			tar -czpf $2 -P $1
#			echo -e "Архивация файла ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
		#Если нет каталога назначения	
		else
			echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 
					mkdir -p `dirname $2`;
					tar -czpf $2 -P $1;
#					echo -e "Архивация файла ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
					break;;
				n|N)
					 break;;
				esac	
			done		
		fi
		return	
	else	
	#нет файла
	echo -e "${COLOR_RED} Отсутствует файл ${COLOR_YELLOW}\"$1\"${COLOR_RED} для архивации${COLOR_NC}"
	return
	fi	
#нет параметров	
else
	echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции \"tar_file_structure\" ${COLOR_NC}"
fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#архивация файла со структурой каталогов, последующее удаление оригинала файла
#$1-ссылка на архивируемый файл; $2-ссылка на конечный архив
tar_file_structure_remove(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	#если есть файл архивации
	if [ -f $1 ] ; then
		#Если есть каталог назначения
		if [ -d `dirname $2` ] ; then
			tar -czpf $2 -P $1 --remove-files
#			echo -e "Архивация файла ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}. Оригинал файла удален"
		#Если нет каталога назначения	
		else
			echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 
					mkdir -p `dirname $2`;
					tar -czpf $2 -P $1 --remove-files;
#					echo -e "Архивация файла ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}. Оригинал файла удален"
					break;;
				n|N)
					 break;;
				esac	
			done		
		fi
		return	
	else	
	#нет файла
	echo -e "${COLOR_RED} Отсутствует файл ${COLOR_YELLOW}\"$1\"${COLOR_RED} для архивации${COLOR_NC}"
	return
	fi	
#нет параметров	
else
	echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции \"tar_file_structure_remove\" ${COLOR_NC}"
fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#архивация файла без сохранения структуры каталогов
#$1-ссылка на архивируемый файл; $2-ссылка на конечный архив
tar_file_without_structure(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	#если есть файл архивации
	if [ -f $1 ] ; then
		#Если есть каталог назначения
		if [ -d `dirname $2` ] ; then
			cd `dirname $1` && tar -czpf $2 `basename $1`
#			echo -e "Архивация файла ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}."
		#Если нет каталога назначения	
		else
			echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 					
					mkdir -p "`dirname $2`";
#					cd "/my/scripts/testing" && tar -P -czf "/my/1/1.tar.gz" "mysql.sh"
					cd `dirname $1` && tar -czpf $2 `basename $1`
#					echo -e "Архивация файла ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}."
					break;;
				n|N)
					 break;;
				esac	
			done		
		fi
		return	
	else	
	#нет файла
	echo -e "${COLOR_RED} Отсутствует файл ${COLOR_YELLOW}\"$1\"${COLOR_RED} для архивации${COLOR_NC}"
	return
	fi	
#нет параметров	
else
	echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции \"tar_file_without_structure\" ${COLOR_NC}"
fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#архивация файла без сохранения структуры каталогов, последующее удаление оригинала файла
#$1-ссылка на архивируемый файл; $2-ссылка на конечный архив
tar_file_without_structure_remove(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	#если есть файл архивации
	if [ -f $1 ] ; then
		#Если есть каталог назначения
		if [ -d `dirname $2` ] ; then
			cd `dirname $1` && tar -czpf $2 `basename $1` --remove-files
#			echo -e "Архивация файла ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}. Оригинал файла удален"
		#Если нет каталога назначения	
		else
			echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 
					mkdir -p `dirname $2`;
					cd `dirname $1` && tar -czpf $2 `basename $1` --remove-files
#					echo -e "Архивация файла ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}. Оригинал файла удален"
					break;;
				n|N)
					 break;;
				esac	
			done		
		fi
		return	
	else	
	#нет файла
	echo -e "${COLOR_RED} Отсутствует файл ${COLOR_YELLOW}\"$1\"${COLOR_RED} для архивации${COLOR_NC}"
	return
	fi	
#нет параметров	
else
	echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции \"tar_file_without_structure_remove\" ${COLOR_NC}"
fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#архивация папки со структурой каталогов
#$1-ссылка на архивируемый каталог; $2-ссылка на конечный архив
tar_folder_structure(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	#если есть папка архивации
	if [ -d $1 ] ; then
		#Если есть каталог назначения
		if [ -d `dirname $2` ] ; then
			tar -czpf $2 -P $1
#			echo -e "Архивация каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
		#Если нет каталога назначения	
		else
			echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 
					mkdir -p `dirname $2`;
					tar -czpf $2 -P $1;
#					echo -e "Архивация каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
					break;;
				n|N)
					 break;;
				esac	
			done		
		fi
		return	
	else	
	#нет файла
	echo -e "${COLOR_RED} Отсутствует каталог ${COLOR_YELLOW}\"$1\"${COLOR_RED} для архивации${COLOR_NC}"
	return
	fi	
#нет параметров	
else
	echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции \"tar_folder_structure\" ${COLOR_NC}"
fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#архивация папки со структурой каталогов, последующее удаление оригинала файла
#$1-ссылка на архивируемый каталог; $2-ссылка на конечный архив
tar_folder_structure_remove(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	#если есть папка архивации
	if [ -d $1 ] ; then
		#Если есть каталог назначения
		if [ -d `dirname $2` ] ; then
			tar -czpf $2 -P $1 --remove-files
#			echo -e "Архивация каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}. Оригинал файла удален"
		#Если нет каталога назначения	
		else
			echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 
					mkdir -p `dirname $2`;
					tar -czpf $2 -P $1 --remove-files;
#					echo -e "Архивация каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}. Оригинал файла удален"
					break;;
				n|N)
					 break;;
				esac	
			done		
		fi
		return	
	else	
	#нет файла
	echo -e "${COLOR_RED} Отсутствует каталог ${COLOR_YELLOW}\"$1\"${COLOR_RED} для архивации${COLOR_NC}"
	return
	fi	
#нет параметров	
else
	echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции \"tar_folder_structure_remove\" ${COLOR_NC}"
fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#архивация содержимого папки без сохранения структуры каталогов
#$1-ссылка на каталог, содержащий архивируемые файлы; $2-ссылка на конечный архив
tar_folder_without_structure(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	#если есть папка архивации
	if [ -d $1 ] ; then
		#Если есть каталог назначения
		if [ -d `dirname $2` ] ; then
			tar -cpf - -P -C $1 . | gzip -c > $2
#			echo -e "Архивация каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
		#Если нет каталога назначения	
		else
			echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 
					mkdir -p `dirname $2`;
					tar -cpf - -P -C $1 . | gzip -c > $2;
#					echo -e "Архивация каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
					break;;
				n|N)
					 break;;
				esac	
			done		
		fi
		return	
	else	
	#нет файла
	echo -e "${COLOR_RED} Отсутствует каталог ${COLOR_YELLOW}\"$1\"${COLOR_RED} для архивации${COLOR_NC}"
	return
	fi	
#нет параметров	
else
	echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции \"tar_folder_without_structure\" ${COLOR_NC}"
fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#архивация содержимого папки без сохранения структуры каталогов, последующее удаление оригинала файла
#$1-ссылка на каталог, содержащий архивируемые файлы; $2-ссылка на конечный архив
tar_folder_without_structure_remove(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	#если есть папка архивации
	if [ -d $1 ] ; then
		#Если есть каталог назначения
		if [ -d `dirname $2` ] ; then
			tar -cpf - -P -C  $1 . --remove-files | gzip -c > $2
#			echo -e "Архивация каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
		#Если нет каталога назначения	
		else
			echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 
					mkdir -p `dirname $2`;
					tar -cpf - -P -C $1 . --remove-files | gzip -c > $2;
#					echo -e "Архивация каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
					break;;
				n|N)
					 break;;
				esac	
			done		
		fi
		return	
	else	
	#нет файла
	echo -e "${COLOR_RED} Отсутствует каталог ${COLOR_YELLOW}\"$1\"${COLOR_RED} для архивации${COLOR_NC}"
	return
	fi	
#нет параметров	
else
	echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции \"tar_folder_without_structure_remove\" ${COLOR_NC}"
fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#разархивация содержимого папки без сохранения структуры каталогов
#$1-ссылка на каталог разархивации; $2-ссылка на архив
untar_without_structure(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	#если есть папка архивации
	if [ -f $2 ] ; then
		#Если есть каталог назначения
		if [ -d $1 ] ; then
			tar -xpf $2 -P -C $1
#			echo -e "Разархивация архива ${COLOR_YELLOW}\"$2\"${COLOR_NC} завершена в каталог ${COLOR_YELLOW}\"$1\"${COLOR_NC}"
		#Если нет каталога назначения	
		else
			echo -e "${COLOR_RED} Каталог \"$1\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 
					mkdir -p $1;
					tar -xpf $2 -P -C $1;
#					echo -e "Разархивация архива ${COLOR_YELLOW}\"$2\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$1\"${COLOR_NC}"
					break;;
				n|N)
					 break;;
				esac	
			done		
		fi
		return	
	else	
	#нет файла
	echo -e "${COLOR_RED} Отсутствует архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
	return
	fi	
#нет параметров	
else
	echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции \"untar_without_structure\" ${COLOR_NC}"
fi
}

#######СДЕЛАНО. Не трогать!!!!#######
#разархивация содержимого папки с сохранением структуры каталогов
#$1-ссылка на каталог разархивации; $2-ссылка на архив
untar_with_structure(){
if [ -n "$1" ] && [ -n "$2" ] 
then
	#если есть папка архивации
	if [ -f $2 ] ; then
		#Если есть каталог назначения
		if [ -d $1 ] ; then
			tar -xzpf $2 -P -C $1
#			echo -e "Разархивация архива ${COLOR_YELLOW}\"$2\"${COLOR_NC} завершена в каталог ${COLOR_YELLOW}\"$1\"${COLOR_NC}"
		#Если нет каталога назначения	
		else
			echo -e "${COLOR_RED} Каталог \"$1\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 
					mkdir -p $1;
					tar -xzpf $2 -P -C $1;
#					echo -e "Разархивация архива ${COLOR_YELLOW}\"$2\"${COLOR_NC} завершена в архив ${COLOR_YELLOW}\"$1\"${COLOR_NC}"
					break;;
				n|N)
					 break;;
				esac	
			done		
		fi
		return	
	else	
	#нет файла
	echo -e "${COLOR_RED} Отсутствует архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
	return
	fi	
#нет параметров	
else
	echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции \"untar_with_structure\" ${COLOR_NC}"
fi
}

#$1-user, $2-destination_folder в папке BACKUPFOLDER_IMPORTANT, $3-файл для создания бэкапа
backupImportantFile(){
	dt=`date +%Y.%m.%d_%H.%M.%S`;
	if ! [ -f $3 ] ; then
		echo -e "${COLOR_RED} Файл ${COLOR_YELLOW}\"$3\"${COLOR_RED} не существует${COLOR_NC}"
	else
			#если папка для бэкапов не существует
			if ! [ -d "$BACKUPFOLDER_IMPORTANT"/"$2"/"$1" ] ; then
				mkdir -p $BACKUPFOLDER_IMPORTANT/$2/$1
			fi
												
	tar_file_structure $3 $BACKUPFOLDER_IMPORTANT/$2/$1/$2_$1_$dt.tar.gz
	fi
}

