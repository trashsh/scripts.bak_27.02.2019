#!/bin/bash
#$1-$USERNAME process; $2- путь к каталогу для разархивации; $3-путь к архиву; 
#Архивация файлов с сохранением полной структуры папок и файлов
source /etc/profile
source ~/.bashrc


if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] 
then
if [ -d $2 ] ; then

		if [ -f $3 ] ; then
							tar -xzf $3 -C $2
						else
							echo -e "$COLOR_REDАрхив \"$3\" для разархивации не найден$COLOR_NC"
						fi

					
				else
					echo -e "$COLOR_REDКаталог \"$2\" для разархивации не найден$COLOR_NC"
                fi

else
    echo -e "\n$COLOR_YELLOWПараметры запуска не найдены$COLOR_NC. Необходимы параметры: путь к каталогу для разархивации, путь к архиву"
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


