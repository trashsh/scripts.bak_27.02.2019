#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Просмотр списка бэкапов===${COLOR_NC}"

echo '1: Бэкапы за сегодняшний день'
echo '2: Бэкапы за вчерашний день'
echo '3: Бэкапы за последнюю неделю'
echo '4: Указать дату'


echo '0: Назад'
echo '/: Выход'
echo ''
echo -n 'Выберите пункт меню:'
read item
case "$item" in
        1) sudo $SCRIPTS/system/backup/show/show_today.sh
           $MENU/menu_backup.sh
            ;;
		2) sudo $SCRIPTS/system/backup/restore_backup.sh
           $MENU/menu_backup.sh
            ;;
		3) sudo $SCRIPTS/system/backup/show_backup.sh
           $MENU/menu_backup.sh
            ;;
		4) sudo $SCRIPTS/system/backup/show_backup.sh
           $MENU/menu_backup.sh
            ;;
        
        0)  echo ''
            $MYFOLDER/scripts/menu
            ;;
        /) echo "Выход..."
            exit 0
            ;;
esac