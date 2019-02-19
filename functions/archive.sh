#!/bin/bash



declare -x -f tar_folder_structure #Архивация каталога с сохранением структуры относительно корня: ($1-Ссылка на каталог для архивации ; $2-Ссылка на конечный архив ; )
declare -x -f tar_folder_structure_remove #Архивация каталога с сохранением структуры каталогов относительно корня, с последующим удалением исходного каталога: ($1-Ссылка на каталог для архивации ; $2-Ссылка на конечный архив ; )
declare -x -f tar_folder_without_structure #Архивация каталога без сохранения структуры каталогов относительно корня: ($1-Ссылка на каталог для архивации ; $2-Ссылка на конечный архив ; )
declare -x -f tar_folder_without_structure_remove #Архивация каталога без сохранения структуры каталогов относительно корня, с последующим удалением исходного каталога: ($1-Ссылка на каталог для архивации ; $2-Ссылка на конечный архив ; )
declare -x -f untar_without_structure #разархивирование без сохранения структуры каталогов относительно корня: ($1-Ссылка на каталог назначения ; $2-Ссылка на архив)
declare -x -f backupImportantFile #Создание бэкапа в папку BACKUPFOLDER_IMPORTANT: ($1-user ; $2-destination_folder ; $3-архивируемый файл ;)


#################ПОЛНОСТЬЮ ГОТОВО###########################
declare -x -f tar_file_structure #Архивация файла с сохранением структуры каталогов: ($1-Ссылка на файл для архивации ; $2-Ссылка на конечный архив ;)
                                 #return 0 - выполнено успешно, 1-не переданы параметры в функцию, 2 - файл не найден после архивации
                                 #3 - конечный каталог не найден, пользоватль отменил создание каталога
declare -x -f tar_file_structure_remove #Архивация файла с сохранением структуры каталогов с последующим удалением исходного файла: ($1-Ссылка на файл для архивации ; $2-Ссылка на конечный архив ;)
                                 #return 0 - выполнено успешно, 1-не переданы параметры в функцию, 2 - файл не найден после архивации
                                 #3 - конечный каталог не найден, пользоватль отменил создание каталога
declare -x -f tar_file_without_structure #Архивация файла без сохранения структуры каталогов: ($1-Ссылка на файл для архивации ; $2-Ссылка на конечный архив ;)
                                         #return 0 - выполнено успешно, 1-не переданы параметры в функцию, 2 - файл не найден после архивации
                                         #3 - конечный каталог не найден, пользоватль отменил создание каталога
declare -x -f tar_file_without_structure_remove #Архивация файла без сохранения структуры каталогов с последующим удалением исходного файла: ($1-Ссылка на файл для архивации ; $2-Ссылка на конечный архив ;)
                                                #return 0 - выполнено успешно, 1-не переданы параметры в функцию, 2 - файл не найден после архивации
                                                #3 - конечный каталог не найден, пользоватль отменил создание каталога



#
#Архивация каталога с сохранением структуры относительно корня
#$1-Ссылка на каталог для архивации ; $2-Ссылка на конечный архив ;
#return 0 - выполнено успешно, 1-не переданы параметры в функцию, 2 - каталог архивации не найден
tar_folder_structure() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования каталога "$1"
		if [ -d $1 ] ; then
		    #Каталог "$1" существует    
		    #Проверка существования каталога "`dirname $2`"
		    if [ -d `dirname $2` ] ; then
		        #Каталог "`dirname $2`" существует    
		        tar -czpf $2 -P $1 --format=posix
		        #Каталог "`dirname $2`" существует (конец)
		    else
		        #Каталог "`dirname $2`" не существует   
		        echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "

			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y)
					mkdir -p `dirname $2`;
					tar -czpf $2 -P $1 --format=posix ;
					break;;
				n|N)
				     return 3;
					 break;;
				esac
			done
		        #Каталог "`dirname $2`" не существует (конец)
		    fi
		    #Конец проверки существования каталога "`dirname $2`"

		    #Финальная проверка существования файла "$2"
		        if [ -f $2 ] ; then
		            #Файл "$2" существует
		            return 0
		            #Файл "$2" существует (конец)
		        else
		            #Файл "$2" не существует
		            echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$2\"${COLOR_RED} не найден после завершения архивации. Функция ${COLOR_GREEN}\"tar_folder_structure\"${COLOR_NC}"
		            return 2
		            #Файл "$2" не существует (конец)
		        fi
		        #Финальная проверка существования файла "$2" (конец)

		    #Каталог "$1" существует (конец)
		else
		    #Каталог "$1" не существует   
		    echo -e "${COLOR_RED}Отсутствует каталог ${COLOR_GREEN}\"$1\"${COLOR_RED} для архивации в ${COLOR_GREEN}\"$2\". ${COLOR_RED}Ошибка в функции ${COLOR_GREEN}\"tar_folder_structure\"${COLOR_NC}"
		    return 2
		    #Каталог "$1" не существует (конец)
		fi
		#Конец проверки существования каталога "$1"
		
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"tar_folder_structure\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#
#Архивация каталога с сохранением структуры относительно корня, с последующим удалением исходной папки
#$1-Ссылка на каталог для архивации ; $2-Ссылка на конечный архив ;
tar_folder_structure_remove() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования каталога "$1"
		if [ -d $1 ] ; then
		    #Каталог "$1" существует
		    #Проверка существования каталога "`dirname $2`"
		    if [ -d `dirname $2` ] ; then
		        #Каталог "`dirname $2`" существует
		        tar -czpf $2 -P $1 --remove-files
		        #Каталог "`dirname $2`" существует (конец)
		    else
		        #Каталог "`dirname $2`" не существует
		        echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "

			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y)
					mkdir -p `dirname $2`;
					tar -czpf $2 -P $1 --remove-files;
					break;;
				n|N)
					 break;;
				esac
			done
		        #Каталог "`dirname $2`" не существует (конец)
		    fi
		    #Конец проверки существования каталога "`dirname $2`"
		    return
		    #Каталог "$1" существует (конец)
		else
		    #Каталог "$1" не существует
		    echo -e "${COLOR_RED}Отсутствует каталог ${COLOR_GREEN}\"$1\"${COLOR_RED} для архивации в ${COLOR_GREEN}\"$2\"${COLOR_NC}"
		    return
		    #Каталог "$1" не существует (конец)
		fi
		#Конец проверки существования каталога "$1"

	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"tar_folder_structure_remove\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#
#Архивация каталога без сохранения структуры каталогов относительно корня
#$1-Ссылка на каталог для архивации ; $2-Ссылка на конечный архив ;
tar_folder_without_structure() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования каталога "$1"
		if [ -d $1 ] ; then
		    #Каталог "$1" существует
		    #Проверка существования каталога "`dirname $2`"
		    if [ -d `dirname $2` ] ; then
		        #Каталог "`dirname $2`" существует
		        tar -cpf - -P -C $1 . | gzip -c > $2
		        #Каталог "`dirname $2`" существует (конец)
		    else
		        #Каталог "`dirname $2`" не существует
		        echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "

			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y)
					mkdir -p `dirname $2`;
					tar -cpf - -P -C $1 . | gzip -c > $2;
					break;;
				n|N)
					 break;;
				esac
			done
		        #Каталог "`dirname $2`" не существует (конец)
		    fi
		    #Конец проверки существования каталога "`dirname $2`"
		    return
		    #Каталог "$1" существует (конец)
		else
		    #Каталог "$1" не существует
		    echo -e "${COLOR_RED}Отсутствует каталог ${COLOR_GREEN}\"$1\"${COLOR_RED} для архивации в ${COLOR_GREEN}\"$2\"${COLOR_NC}"
		    return
		    #Каталог "$1" не существует (конец)
		fi
		#Конец проверки существования каталога "$1"

	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"tar_folder_without_structure\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#
#Архивация каталога без сохранения структуры каталогов относительно корня, с последующим удалением исходного файла
#$1-Ссылка на каталог для архивации ; $2-Ссылка на конечный архив ;
tar_folder_without_structure_remove() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования каталога "$1"
		if [ -d $1 ] ; then
		    #Каталог "$1" существует
		    #Проверка существования каталога "`dirname $2`"
		    if [ -d `dirname $2` ] ; then
		        #Каталог "`dirname $2`" существует
		        tar -cpf - -P -C $1 . --remove-files | gzip -c > $2
		        #Каталог "`dirname $2`" существует (конец)
		    else
		        #Каталог "`dirname $2`" не существует
		        echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "

			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y)
					mkdir -p `dirname $2`;
					tar -cpf - -P -C $1 . --remove-files | gzip -c > $2;
					break;;
				n|N)
					 break;;
				esac
			done
		        #Каталог "`dirname $2`" не существует (конец)
		    fi
		    #Конец проверки существования каталога "`dirname $2`"
		    return
		    #Каталог "$1" существует (конец)
		else
		    #Каталог "$1" не существует
		    echo -e "${COLOR_RED}Отсутствует каталог ${COLOR_GREEN}\"$1\"${COLOR_RED} для архивации в ${COLOR_GREEN}\"$2\"${COLOR_NC}"
		    return
		    #Каталог "$1" не существует (конец)
		fi
		#Конец проверки существования каталога "$1"

	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"tar_folder_without_structure_remove\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#
#разархивирование без сохранения структуры каталогов относительно корня
#$1-Ссылка на каталог назначения ; $2-Ссылка на архив ;
untar_without_structure() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования файла "$2"
		if [ -f $2 ] ; then
		    #Файл "$2" существует
		    #Проверка существования каталога "$1"
		    if [ -d $1 ] ; then
		        #Каталог "$1" существует    
		        tar -xpf $2 -P -C $1
		        #Каталог "$1" существует (конец)
		    else
		        #Каталог "$1" не существует   
		        echo -e "${COLOR_RED} Каталог \"$1\" не найден ${COLOR_NC}. Создать его?"	
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "
		
			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y) 
					mkdir -p $1;
					tar -xpf $2 -P -C $1;
					break;;
				n|N)
					 break;;
				esac	
			done
		        #Каталог "$1" не существует (конец)
		    fi
		    #Конец проверки существования каталога "$1"
		    return
		    #Файл "$2" существует (конец)
		else
		    #Файл "$2" не существует
		    echo -e "${COLOR_RED} Отсутствует архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
	        return
		    #Файл "$2" не существует (конец)
		fi
		#Конец проверки существования файла "$2"
		
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"untar_without_structure\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#
#разархивирование с сохранением структуры каталогов относительно корня
#$1-Ссылка на каталог назначения ; $2-Ссылка на архив ;
untar_with_structure() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования файла "$2"
		if [ -f $2 ] ; then
		    #Файл "$2" существует
		    #Проверка существования каталога "$1"
		    if [ -d $1 ] ; then
		        #Каталог "$1" существует
		        tar -xzpf $2 -P -C $1
		        #Каталог "$1" существует (конец)
		    else
		        #Каталог "$1" не существует
		        echo -e "${COLOR_RED} Каталог \"$1\" не найден ${COLOR_NC}. Создать его?"
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"$1\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "

			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y)
					mkdir -p $1;
					tar -xzpf $2 -P -C $1;
					break;;
				n|N)
					 break;;
				esac
			done
		        #Каталог "$1" не существует (конец)
		    fi
		    #Конец проверки существования каталога "$1"
		    return
		    #Файл "$2" существует (конец)
		else
		    #Файл "$2" не существует
		    echo -e "${COLOR_RED} Отсутствует архив ${COLOR_YELLOW}\"$2\"${COLOR_NC}"
	        return
		    #Файл "$2" не существует (конец)
		fi
		#Конец проверки существования файла "$2"

	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"untar_without_structure\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#
#Создание бэкапа в папку BACKUPFOLDER_IMPORTANT
#$1-user ; $2-destination_folder ; $3-архивируемый файл ;
backupImportantFile() {
	dt=`date +%Y.%m.%d_%H.%M.%S`;
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]
	then
	#Параметры запуска существуют
		#Проверка существования файла "$3"
		if [ -f $3 ] ; then
		    #Файл "$3" существует
		    #Проверка существования каталога "$BACKUPFOLDER_IMPORTANT"/"$2"/"$1"
			if ! [ -d "$BACKUPFOLDER_IMPORTANT"/"$2"/"$1" ] ; then
				mkdir -p $BACKUPFOLDER_IMPORTANT/$2/$1
			fi
			#Проверка существования каталога "$BACKUPFOLDER_IMPORTANT"/"$2"/"$1" (конец)
	        tar_file_structure $3 $BACKUPFOLDER_IMPORTANT/$2/$1/$2_$1_$dt.tar.gz
		    #Файл "$3" существует (конец)
		else
		    #Файл "$3" не существует
		    echo -e "${COLOR_RED} Файл ${COLOR_YELLOW}\"$3\"${COLOR_RED} не существует${COLOR_NC}"
		    #Файл "$3" не существует (конец)
		fi
		#Конец проверки существования файла "$3"
		
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"backupImportantFile\"${COLOR_RED} ${COLOR_NC}"
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
    
}



########################ПОЛНОСТЬЮ ГОТОВО#################################################
#Архивация файла с сохранением структуры каталогов
#$1-Ссылка на файл для архивации ; $2-Ссылка на конечный архив ;
#return 0 - выполнено успешно, 1-не переданы параметры в функцию, 2 - файл не найден после архивации
#3 - каталог не найден, пользоватль отменил создание каталога
tar_file_structure() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования файла "$1"
		if [ -f $1 ] ; then
		    #Файл "$1" существует
		    #Проверка существования каталога "`dirname $2`"
		    if [ -d `dirname $2` ] ; then
		        #Каталог "`dirname $2`" существует
		        tar -czpf $2 -P $1
		        #Каталог "`dirname $2`" существует (конец)
		    else
		        #Каталог "`dirname $2`" не существует
		    echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "

			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y)
					mkdir -p `dirname $2`;
					tar -czpf $2 -P $1;
					break;;
				n|N)
				     return 3;
					 break;;
				esac
			done
		        #Каталог "`dirname $2`" не существует (конец)
		    fi
		    #Конец проверки существования каталога "`dirname $2`"

		     #Финальная проверка существования файла "$2"
		        if [ -f $2 ] ; then
		            #Файл "$2" существует
		            return 0
		            #Файл "$2" существует (конец)
		        else
		            #Файл "$2" не существует
		            echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$2\"${COLOR_RED} не найден после завершения архивации. Функция ${COLOR_GREEN}\"tar_file_structure\"${COLOR_NC}"
		            return 2
		            #Файл "$2" не существует (конец)
		        fi
		        #Финальная проверка существования файла "$2"

		    #Файл "$1" существует (конец)
		else
		    #Файл "$1" не существует
		    echo -e "${COLOR_RED}Отсутствует файл ${COLOR_GREEN}\"$1\"${COLOR_RED} для архивации в ${COLOR_GREEN}\"$2\".${COLOR_RED}Функция ${COLOR_GREEN}\"tar_file_structure\"${COLOR_NC}"
		    #Файл "$1" не существует (конец)
		fi
		#Конец проверки существования файла "$1"
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"tar_file_structure\"${COLOR_RED} ${COLOR_NC}"
		return 1
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#Архивация файла с сохранением структуры каталогов, с последующим удалением исходного файла
#$1-Ссылка на файл для архивации ; $2-Ссылка на конечный архив ;
#return 0 - выполнено успешно, 1-не переданы параметры в функцию, 2 - файл не найден после архивации
#3 - каталог не найден, пользоватль отменил создание каталога
tar_file_structure_remove() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования файла "$1"
		if [ -f $1 ] ; then
		    #Файл "$1" существует
		    #Проверка существования каталога "`dirname $2`"
		    if [ -d `dirname $2` ] ; then
		        #Каталог "`dirname $2`" существует
		        tar -czpf $2 -P $1 --remove-files
		        #Каталог "`dirname $2`" существует (конец)
		    else
		        #Каталог "`dirname $2`" не существует
		    echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "

			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y)
					mkdir -p `dirname $2`;
					tar -czpf $2 -P $1 --remove-files;
					break;;
				n|N)
				     return 3;
					 break;;
				esac
			done
		        #Каталог "`dirname $2`" не существует (конец)
		    fi
		    #Конец проверки существования каталога "`dirname $2`"

		     #Финальная проверка существования файла "$2"
		        if [ -f $2 ] ; then
		            #Файл "$2" существует
		            return 0
		            #Файл "$2" существует (конец)
		        else
		            #Файл "$2" не существует
		            echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$2\"${COLOR_RED} не найден после завершения архивации. Функция ${COLOR_GREEN}\"tar_file_structure_remove\"${COLOR_NC}"
		            return 2
		            #Файл "$2" не существует (конец)
		        fi
		        #Финальная проверка существования файла "$2" (конец)

		    #Файл "$1" существует (конец)
		else
		    #Файл "$1" не существует
		    echo -e "${COLOR_RED}Отсутствует файл ${COLOR_GREEN}\"$1\"${COLOR_RED} для архивации в ${COLOR_GREEN}\"$2\".${COLOR_RED}Функция ${COLOR_GREEN}\"tar_file_structure_remove\"${COLOR_NC}"
		    #Файл "$1" не существует (конец)
		fi
		#Конец проверки существования файла "$1"
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"tar_file_structure_remove\"${COLOR_RED} ${COLOR_NC}"
		return 1
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#Архивация файла без сохранения структуры каталогов
#$1-Ссылка на файл для архивации ; $2-Ссылка на конечный архив ;
#return 0 - выполнено успешно, 1-не переданы параметры в функцию, 2 - файл не найден после архивации
#3 - каталог не найден, пользоватль отменил создание каталога
tar_file_without_structure() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования файла "$1"
		if [ -f $1 ] ; then
		    #Файл "$1" существует
		    #Проверка существования каталога "`dirname $2`"
		    if [ -d `dirname $2` ] ; then
		        #Каталог "`dirname $2`" существует
		        cd `dirname $1` && tar -czpf $2 `basename $1`
		        #Каталог "`dirname $2`" существует (конец)
		    else
		        #Каталог "`dirname $2`" не существует
		    echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "

			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y)
					mkdir -p `dirname $2`;
					cd `dirname $1` && tar -czpf $2 `basename $1`;
					break;;
				n|N)
				     return 3;
					 break;;
				esac
			done
		        #Каталог "`dirname $2`" не существует (конец)
		    fi
		    #Конец проверки существования каталога "`dirname $2`"

		     #Финальная проверка существования файла "$2"
		        if [ -f $2 ] ; then
		            #Файл "$2" существует
		            return 0
		            #Файл "$2" существует (конец)
		        else
		            #Файл "$2" не существует
		            echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$2\"${COLOR_RED} не найден после завершения архивации. Функция ${COLOR_GREEN}\"tar_file_without_structure\"${COLOR_NC}"
		            return 2
		            #Файл "$2" не существует (конец)
		        fi
		        #Финальная проверка существования файла "$2" (конец)

		    #Файл "$1" существует (конец)
		else
		    #Файл "$1" не существует
		    echo -e "${COLOR_RED}Отсутствует файл ${COLOR_GREEN}\"$1\"${COLOR_RED} для архивации в ${COLOR_GREEN}\"$2\".${COLOR_RED}Функция ${COLOR_GREEN}\"tar_file_without_structure\"${COLOR_NC}"
		    #Файл "$1" не существует (конец)
		fi
		#Конец проверки существования файла "$1"
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"tar_file_without_structure\"${COLOR_RED} ${COLOR_NC}"
		return 1
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}

#Архивация файла без сохранения структуры каталогов с последующим удалением исходного файла
#$1-Ссылка на файл для архивации ; $2-Ссылка на конечный архив ;
#return 0 - выполнено успешно, 1-не переданы параметры в функцию, 2 - файл не найден после архивации
#3 - каталог не найден, пользоватль отменил создание каталога
tar_file_without_structure_remove() {
	#Проверка на существование параметров запуска скрипта
	if [ -n "$1" ] && [ -n "$2" ]
	then
	#Параметры запуска существуют
		#Проверка существования файла "$1"
		if [ -f $1 ] ; then
		    #Файл "$1" существует
		    #Проверка существования каталога "`dirname $2`"
		    if [ -d `dirname $2` ] ; then
		        #Каталог "`dirname $2`" существует
		        cd `dirname $1` && tar -czpf $2 `basename $1` --remove-files;
		        #Каталог "`dirname $2`" существует (конец)
		    else
		        #Каталог "`dirname $2`" не существует
		    echo -e "${COLOR_RED} Каталог \"`dirname $2`\" не найден ${COLOR_NC}. Создать его?"
			echo -n -e "Введите $COLOR_BLUE\"y\"$COLOR_NC для создания каталога ${COLOR_YELLOW}\"`dirname $2`\"${COLOR_NC}, для отмены операции - $COLOR_BLUE\"n\"$COLOR_NC: "

			while read
			do
			echo -n ": "
				case "$REPLY" in
				y|Y)
					mkdir -p `dirname $2`;
					cd `dirname $1` && tar -czpf $2 `basename $1` --remove-files;
					break;;
				n|N)
				     return 3;
					 break;;
				esac
			done
		        #Каталог "`dirname $2`" не существует (конец)
		    fi
		    #Конец проверки существования каталога "`dirname $2`"

		     #Финальная проверка существования файла "$2"
		        if [ -f $2 ] ; then
		            #Файл "$2" существует
		            return 0
		            #Файл "$2" существует (конец)
		        else
		            #Файл "$2" не существует
		            echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"$2\"${COLOR_RED} не найден после завершения архивации. Функция ${COLOR_GREEN}\"tar_file_without_structure\"${COLOR_NC}"
		            return 2
		            #Файл "$2" не существует (конец)
		        fi
		        #Финальная проверка существования файла "$2" (конец)

		    #Файл "$1" существует (конец)
		else
		    #Файл "$1" не существует
		    echo -e "${COLOR_RED}Отсутствует файл ${COLOR_GREEN}\"$1\"${COLOR_RED} для архивации в ${COLOR_GREEN}\"$2\".${COLOR_RED}Функция ${COLOR_GREEN}\"tar_file_without_structure\"${COLOR_NC}"
		    #Файл "$1" не существует (конец)
		fi
		#Конец проверки существования файла "$1"
	#Параметры запуска существуют (конец)
	else
	#Параметры запуска отсутствуют
		echo -e "${COLOR_RED} Отсутствуют необходимые параметры в фукнции ${COLOR_GREEN}\"tar_file_without_structure\"${COLOR_RED} ${COLOR_NC}"
		return 1
	#Параметры запуска отсутствуют (конец)
	fi
	#Конец проверки существования параметров запуска скрипта
}