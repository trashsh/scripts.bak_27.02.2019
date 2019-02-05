#!/bin/bash
#создание коммита
#$1-$USERNAME process;
source /etc/profile
source ~/.bashrc

echo -n -e "Для создания коммита репозитария $COLOR_YELLOW\""$SCRIPTS"\"$COLOR_NC введите $COLOR_BLUE\"y\"$COLOR_NC, для выхода - $COLOR_BLUE\"n\"$COLOR_NC: " 
while read
    do
        case "$REPLY" in
        "y"|"Y")  
			echo -e "\n ${COLOR_YELLOW} Git commit generation:${COLOR_NC}"
			cd $SCRIPTS
			dt=$(date '+%d/%m/%Y %H:%M:%S');
			sudo git add .
			sudo git commit -m "$dt"
			$MENU/git.sh $1
			break
			;;
        "n"|"N")  
			echo 'Отмена создания коммита'
			$SCRIPTS/.menu/git.sh $1
			break;; 
			
        *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2;;
        esac
    done

