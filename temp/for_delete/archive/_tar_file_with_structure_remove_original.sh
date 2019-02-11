#!/bin/bash
#$1-$USERNAME process; $2- путь к каталогу, файлы в котором подлежат архивации; $3-имя файла, подлежащего архивации, $4-каталог размещения архива; $5 - имя архива
#Архивация файлов с полными абсолютными путями и удаление оригинала
source /etc/profile
source ~/.bashrc


if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] && [ -n "4" ] 
then
if [ -f $2/$3 ] ; then
					tar cfz $3/$4 $2/$3 --remove-files
				else
					echo -e "{$COLOR_RED}Файл \"$2\/$3\" для архивации не найден${COLOR_NC}"
                fi

else
    echo -e "\n${COLOR_YELLOW}Параметры запуска не найдены${COLOR_NC}. Необходимы параметры: 1-USERNAME process; 2- путь к каталогу, файлы в котором подлежат архивации; 3-каталог размещения архива; 4 - имя архива"
    FileParamsNotFound "$1" "Для запуска главного меню введите" "$SCRIPTS/menu"
fi
exit 0
