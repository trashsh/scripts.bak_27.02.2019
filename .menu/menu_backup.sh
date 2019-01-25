#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Управление бэкапами===${COLOR_NC}"

echo '1: Создать файловый бэкап сайта'
echo '2: Восстановить файловый бэкап сайта'
echo '+3: Создать бэкап баз данных mysql'
echo '4: Восстановить бэкап баз данных mysql'
echo '+5: Просмотр бэкапов'


echo '0: Назад'
echo '/: Выход'
echo ''
echo -n 'Выберите пункт меню:'
read item
case "$item" in
        1) sudo $SCRIPTS/system/backup/input_backup.sh $1
            ;;
		2) sudo $SCRIPTS/system/backup/input_backup.sh $1
            ;;
		3) $MENU/menu_sql_backup.sh $1
            ;;
		4) sudo $SCRIPTS/system/backup/restore_backup.sh $1
            ;;
		5) $SCRIPTS/.menu/menu_backup_show.sh $1
            ;;
        
        0)  echo ''
            $MYFOLDER/scripts/menu $1
            ;;
        /) echo "Выход..."
            exit 0
            ;;
esac