#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Управление базами данных===${COLOR_NC}"

echo '1: Добавить базу данных'

echo '2: Управление пользователями баз данных'

echo '0: Назад'
echo '/: Выход'
echo ''
echo -n 'Выберите пункт меню:'
read item
case "$item" in
        1) $SCRIPTS/sql/db_create.sh
            ;;

		2) $MENU/menu_sql_users.sh
            ;;

        0)  echo ''
            $SCRIPTS/menu
            ;;
        /) echo "Выход..."
            exit 0
            ;;
esac