#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Управление сайтами===${COLOR_NC}"

echo '1: Добавить сайт на сервер'
echo '2: Удаление сайта с сервера'
echo '3: Список виртуальных хостов на сервере'
echo '4: Сертификаты'

echo '9: Перезапустить Apache2 и Nginx'
echo '0: Назад'
echo '/: Выход'
echo ''
echo -n 'Выберите пункт меню:'
read item
case "$item" in
        1) $MENU/menu_site_add.sh $1
            ;;
        2) $SCRIPTS/webserver/remove/site_remove_input.sh $1
            ;;
        3) $SCRIPTS/webserver/view/site_view_all.sh $1
            ;;
		4) $MENU/menu_site_cert.sh $1
            ;;
        9) $SCRIPTS/webserver/server/restart_webserver.sh $1
            ;;

        0)  echo ''
            $MYFOLDER/scripts/menu $1
            ;;
        /) echo "Выход..."
            exit 0
            ;;
esac