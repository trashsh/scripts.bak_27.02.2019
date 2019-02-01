#!/bin/bash
#$1-$USERNAME process;
source /etc/profile
source ~/.bashrc


echo ''
echo -e "$COLOR_YELLOW"Создание бэкапа каталога" $COLOR_NC"
read -p "Введите путь к каталогу: " path
echo -n -e "Для создания бэкапа $COLOR_YELLOW" $path "$COLOR_NC введите $COLOR_BLUE\"y\"$COLOR_NC, для выхода - $COLOR_BLUE\"n\"$COLOR_NC: "


	while read
    do
        case "$REPLY" in
        "y"|"Y")  
			$SCRIPTS/system/backup/make_backup_path.sh $1 $path
			$SCRIPTS/.menu/menu_backup.sh $1
			;;
        "n"|"N")  
			echo "Отмена операции создания бэкапа\n"
			$SCRIPTS/.menu/menu_backup.sh $1
			break;; 			
        *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2;;
        esac
    done

