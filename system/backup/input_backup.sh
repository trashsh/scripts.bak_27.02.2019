#!/bin/bash
#$1-$USERNAME
source /etc/profile
source ~/.bashrc


echo ''
echo -e "$COLOR_YELLOW"Создание бэкапа каталога" $COLOR_NC"
read -p "Введите путь к каталогу: " path


echo -n -e "Для создания бэкапа $COLOR_YELLOW" $path "$COLOR_NC введите $COLOR_BLUE\"y\"$COLOR_NC, для выхода - любой символ: "
    read item
    case "$item" in
        y|Y) 		
		$SCRIPTS/system/backup/make_backup_path.sh $1 $path
            ;;
        *) echo 'Отмена операции создания бэкапа'
			echo ''
            ;;
    esac



