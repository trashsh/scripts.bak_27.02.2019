#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Управление бэкапами===${COLOR_NC}"

echo '1: Создать файловый бэкап сайта'
echo '2: Восстановить файловый бэкап сайта'
echo '3: Создать бэкап баз данных mysql'
echo '4: Восстановить бэкап баз данных mysql'
echo '5: Просмотр бэкапов'


echo '0: Назад'
echo 'q: Выход'
echo ''
echo -n 'Выберите пункт меню:'

while read
    do
        case "$REPLY" in
        "1")  sudo $SCRIPTS/system/backup/input_backup.sh $1;  break;;
        "2")  sudo $SCRIPTS/system/backup/input_backup.sh $1;  break;;
		"3")  $MENU/menu_sql_backup.sh $1;  break;;
		"4")  sudo $SCRIPTS/system/backup/restore_backup.sh $1;  break;;
		"5")  $SCRIPTS/.menu/menu_backup_show.sh $1;  break;;
		"0")  $MYFOLDER/scripts/menu $1;  break;;
        "q"|"Q")  break 2;; 
         *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2;;
        esac
    done
