#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Резервное копирование баз данных===${COLOR_NC}"

echo '1: +Создать копию всех баз всего сервера'
echo '2: Создать копию всех баз конкретного пользователя'
echo '3: Создать копию одной базы'
echo '4: Восстановить из бэкапа сервер баз данных'
echo '5: Восстановить из бэкапа все базы пользователя'
echo '6: Восстановить из бэкапа одну базу'

echo '0: Назад'
echo '/: Выход'
echo ''
echo -n 'Выберите пункт меню:'
read item
case "$item" in
        1) $SCRIPTS/mysql/backup_all_bases.sh
            ;;
        2) $SCRIPTS/mysql/backup_all_bases_user.sh
            ;;
		3) $SCRIPTS/mysql/mysql_backup_base.sh
            ;;
		4) $SCRIPTS/mysql/
            ;;
		5) $SCRIPTS/mysql/
            ;;
		6) $SCRIPTS/mysql/
            ;;

        0)  echo ''
            $MENU/menu_sql.sh
            ;;
        /) echo "Выход..."
            exit 0
            ;;
esac