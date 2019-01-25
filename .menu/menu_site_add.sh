#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN}===Добавление сайта===${COLOR_NC}"

echo '1: PHP/HTML'
echo '2: PHP/HTML (с вводом доп.параметров)'
echo '3: Framework Laravel'
echo '4: Framework Laravel (с вводом доп.параметров)'


echo '0: Назад'
echo '/: Выход'
echo ''
echo -n 'Выберите пункт меню:'
read item
case "$item" in
        1) $SCRIPTS/webserver/site/input_site_php_easy.sh $1
            ;;
		2) $SCRIPTS/webserver/site/input_site_php_full.sh $1
            ;;
        3) $SCRIPTS/webserver/site/input_site_laravel_easy.sh $1
            ;;
		4) $SCRIPTS/webserver/site/input_site_laravel_full.sh $1
            ;;

        0)  echo ''
            $MENU/menu_site.sh $1
            ;;
        /) echo "Выход..."
            exit 0
            ;;
esac