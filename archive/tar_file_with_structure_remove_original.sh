#!/bin/bash
#$1-$USERNAME process; $2- путь к файлу, подлежащего архивации; $3-каталог размещения архива; $4 - имя архива
#Архивация файлов с полными абсолютными путями и удаление оригинала
source /etc/profile
source ~/.bashrc


if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] && [ -n "4" ] 
then
if [ -f $2 ] ; then
					tar cfz $3/$4 $2 --remove-files
				else
					echo -e "$COLOR_REDКаталог \"$2\" для архивации не найден$COLOR_NC"
                fi

else
    echo -e "\n$COLOR_YELLOWПараметры запуска не найдены$COLOR_NC. Необходимы параметры: путь к каталогу для архивации, путь к архиву"
    echo -n -e "$COLOR_YELLOWДля запуска основного меню напишите $COLOR_BLUE\"y\"$COLOR_YELLOW, для выхода - $COLOR_BLUE\"n\"$COLOR_NC:"
	while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) $SCRIPTS/menu $1;
					break;;
			n|N)  exit 0;
			esac
		done

fi

