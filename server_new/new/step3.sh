


  

###Еще не сделал
echo "webmin settings"
sed -i -e "s/ssl=1/ssl=0/" /etc/webmin/miniserv.conf
sed -i '$ a referers=wm.mmgx.ru'  /etc/webmin/config
#cp /my/scripts/.config/settings/webmin/apache/wm.mmgx.ru.conf $APACHEAVAILABLE/wm.mmgx.ru.conf
systemctl restart webmin

#a2ensite wm.mmgx.ru
systemctl restart apache2

echo "git-etc"
cd /etc
git init
git add .
git commit -m "initial commit etc"

#apt-get install automysqlbackup
#info
##wm.mmgx.ru:7000




apt install bacula
apt-get -y install quota quotatool
