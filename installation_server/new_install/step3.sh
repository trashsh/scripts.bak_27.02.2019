

#nginx
apt-get update
sed -i -e "s/<VirtualHost\ \*:80>/<VirtualHost\ \*:8080>/" /etc/apache2/sites-available/000-default.conf
a2enmod actions
a2enmod proxy_fcgi






  

###Еще не сделал
echo "webmin settings"
sed -i -e "s/ssl=1/ssl=0/" /etc/webmin/miniserv.conf
sed -i '$ a referers=wm.mmgx.ru'  /etc/webmin/config
#cp /my/scripts/.config/settings/webmin/apache/wm.mmgx.ru.conf $APACHEAVAILABLE/wm.mmgx.ru.conf
systemctl restart webmin

#a2ensite wm.mmgx.ru
systemctl restart apache2


#apt-get install automysqlbackup
#info
##wm.mmgx.ru:7000

