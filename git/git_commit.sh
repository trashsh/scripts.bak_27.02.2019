#!/bin/bash
#просмотр удаленных репозиториев
#$1-$USERNAME
source /etc/profile
source ~/.bashrc



echo -n -e "Для создания коммита $COLOR_YELLOW" $SCRIPTS "$COLOR_NC введите $COLOR_BLUE\"y\"$COLOR_NC, для выхода - любой символ: "
    read item
    case "$item" in
        y|Y) 		
			echo -e "\n ${COLOR_YELLOW} Git commit generation:${COLOR_NC}"
			cd $SCRIPTS
			dt=$(date '+%d/%m/%Y %H:%M:%S');
			sudo git add .
			sudo git commit -m "$dt"
			$MENU/menu_git.sh $1
            ;;
        *) echo 'Отмена создания коммита'
			echo ''
            ;;
    esac


