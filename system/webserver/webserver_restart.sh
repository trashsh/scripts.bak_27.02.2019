#!/bin/bash
#$1-$USERNAME process 
#перезапуск веб-серверов
source /etc/profile
source ~/.bashrc

sudo /etc/init.d/apache2 restart
sudo /etc/init.d/nginx restart
$MENU/server.sh $1