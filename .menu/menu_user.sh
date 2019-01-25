#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Управление пользователями===${COLOR_NC}"

echo '1: Добавить пользователя ssh'
echo '2: Добавить пользователя web'
echo '3: Удаление пользователя'
echo '4: Список пользователей'


echo '0: Назад'
echo '/: Выход'
echo ''
echo -n 'Выберите пункт меню:'
read item
case "$item" in
        1) sudo $SCRIPTS/users/input_useradd.sh
           $MENU/menu_user.sh
            ;;
		2) sudo $SCRIPTS/users/useradd_web.sh
           $MENU/menu_user.sh
            ;;
        3) sudo $SCRIPTS/users/userdel_system.sh
            $MENU/menu_user.sh
            ;;
        4) sudo $SCRIPTS/users/usersview.sh
            $MENU/menu_user.sh
            ;;

        0)  echo ''
            $MYFOLDER/scripts/menu
            ;;
        /) echo "Выход..."
            exit 0
            ;;
esac