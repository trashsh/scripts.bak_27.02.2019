#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Пользователями базы данных===${COLOR_NC}"

echo '1: Добавить пользователя'
echo '2: Удалить пользователя'
echo '3: Просмотр списка пользователей'

echo '0: Назад'
echo '/: Выход'
echo ''
echo -n 'Выберите пункт меню:'
read item
case "$item" in
        1) $SCRIPTS/mysql/useradd.sh
            ;;
        2) $SCRIPTS/mysql/userdel.sh
            ;;
		3) $SCRIPTS/mysql/usersview.sh
            ;;

        0)  echo ''
            $MENU/menu_sql.sh
            ;;
        /) echo "Выход..."
            exit 0
            ;;
esac