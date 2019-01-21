#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Управление базами данных===${COLOR_NC}"

echo '1: Добавить базу данных'
echo '3: Резервное копирование базы данных'
echo '4: Управление пользователями баз данных'

echo '0: Назад'
echo '/: Выход'
echo ''
echo -n 'Выберите пункт меню:'
read item
case "$item" in
        1) $SCRIPTS/sql/db_create.sh
            ;;
        3) $MENU/menu_sql_backup.sh
            ;;
		4) $MENU/menu_sql_users.sh
            ;;

        0)  echo ''
            $MENU/menu_sql.sh
            ;;
        /) echo "Выход..."
            exit 0
            ;;
esac