#!/bin/bash
#$1-$USERNAME process; $2- путь к каталогу, файлы в котором подлежат архивации; $3-каталог размещения архива; $4 - имя архива
#Архивация файлов с относительными путями
source /etc/profile
source ~/.bashrc

if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]  && [ -n "$4" ] 
then
if [ -d $2 ] ; then
					tar -cf - -C $2 . | gzip -c > $3/$4
				else
					echo -e "${COLOR_RED}Каталог \"$2\" для архивации не найден${COLOR_NC}"
                fi

else
    echo -e "\n${COLOR_YELLOW}Параметры запуска не найдены${COLOR_NC}. Необходимы параметры: 1-USERNAME process; 2- путь к каталогу, файлы в котором подлежат архивации; 3-каталог размещения архива; 4 - имя архива"
    FileParamsNotFound "$1" "Для запуска главного меню введите" "$SCRIPTS/menu"
fi

exit 0