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
echo 'q: Выход'
echo ''
echo -n 'Выберите пункт меню:'

while read
    do
        case "$REPLY" in
        "1")  $MENU/menu_site_add.sh $1;  break;;
        "2")  $SCRIPTS/webserver/remove/site_remove_input.sh $1;  break;;
		"3")  $SCRIPTS/webserver/view/site_view_all.sh $1;  break;;
		"4")  $MENU/menu_site_cert.sh $1;  break;;
		"9")  $SCRIPTS/webserver/server/restart_webserver.sh $1;  break;;
		"0")  $MYFOLDER/scripts/menu $1;  break;;
        "q"|"Q")  break 2;; 
         *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2;;
        esac
    done
