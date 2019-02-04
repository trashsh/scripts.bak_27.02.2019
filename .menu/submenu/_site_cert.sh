#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Управление Сертификатами===${COLOR_NC}"

echo '1: certbot certificates'
echo '2: letsencrypt'

echo '0: Назад'
echo 'q: Выход'
echo ''
echo -n 'Выберите пункт меню:'

while read
    do
        case "$REPLY" in
        "1")  sudo certbot certificates $1;;
        "2")  sudo letsencrypt $1;;
		"0")  $SCRIPTS/.menu/menu_site.sh $1;  break;;
        "q"|"Q")  break 2;; 
         *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2;;
        esac
    done
