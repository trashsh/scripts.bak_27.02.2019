#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Управление Сертификатами===${COLOR_NC}"

echo '1: certbot certificates'
echo '2: letsencrypt'

echo '0: Назад'
echo '/: Выход'
echo ''
echo -n 'Выберите пункт меню:'
read item
case "$item" in
        1) sudo certbot certificates $1
			$MENU/menu_site_cert.sh $1
            ;;
        2) sudo letsencrypt $1
			$MENU/menu_site_cert.sh $1
            ;;
        0)  echo ''
            $MENU/menu_site.sh $1
            ;;
        /) echo "Выход..."
            exit 0
            ;;
esac