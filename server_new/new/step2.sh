echo "install mysql"
apt -y install mysql-server
#apt -y install mariadb-server mariadb-client
tar -czvf $BACKUPFOLDER_INSTALLED/mysql.tar.gz /etc/mysql
mysql_secure_installation
service mysql restart

echo "install apache2"
apt -y install apache2
tar -czvf $BACKUPFOLDER_INSTALLED/apache2.tar.gz /etc/apache2

echo "install php"
apt -y install php libapache2-mod-php php-mysql php-fpm
apt -y install php-pear php7.2-curl php7.2-dev php7.2-gd php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xml
apt -y install libapache2-mod-php7.2 php7.2-cli php7.2-pgsql php7.2-imagick php7.2-intl

apt -y install php php-zip php-gd php-mysql php-memcache php-memcached
a2enmod proxy_fcgi setenvif
a2enconf php7.2-fpm
a2enmod proxy_http

echo "apache conf"
sed -i -e "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf
sed -i -e "s/Listen 443/Listen 8443/" /etc/apache2/ports.conf
#sed -i -e "s/Listen 443/Listen 8443/" /etc/php/7.2/fpm/php.ini
#sed -i -e "s/Listen 443/Listen 8443/" /etc/php/7.3/fpm/php.ini
a2enmod rewrite
service apache2 restart


echo "install soft"
apt -y install mc git git-core composer  wget zip unzip unrar arj putty-tools nano  ufw proftpd  
tar -czvf $BACKUPFOLDER_INSTALLED/proftpd.tar.gz /etc/proftpd/
tar -czvf $BACKUPFOLDER_INSTALLED/ufw.tar.gz /etc/ufw/
apt -y install curl build-essential software-properties-common

echo "letsencrypt"
add-apt-repository -y ppa:nilarimogard/webupd8
apt update
apt -y upgrade
apt -y install launchpad-getkeys
apt -y install letsencrypt
tar -czvf $BACKUPFOLDER_INSTALLED/letsencrypt.tar.gz /etc/letsencrypt/
launchpad-getkeys

echo "php repository"
add-apt-repository -y ppa:ondrej/php
apt update
apt -y upgrade
echo "php"
apt -y install php-pear php5.6-curl php5.6-dev php5.6-gd php5.6-mbstring php5.6-zip php5.6-mysql php5.6-xml libapache2-mod-php5.6 php5.6-mcrypt
apt -y install php-pear php7.0-curl php7.0-dev php7.0-zip  php7.0-gd php7.0-mysql php7.0-mcrypt php7.0-xml libapache2-mod-php7.0
apt -y install php-pear php7.1-curl php7.1-dev php7.1-gd php7.1-mbstring php7.1-zip php7.1-mysql php7.1-xml libapache2-mod-php7.1 php7.1-mcrypt
#apt -y install php-pear php7.3-curl php7.3-dev php7.3-gd php7.3-mbstring php7.3-zip php7.3-mysql php7.3-xml libapache2-mod-php7.3
#update-alternatives --set php /usr/bin/php7.2
tar -czvf $BACKUPFOLDER_INSTALLED/php_01.tar.gz /etc/php/

#echo "install mcrypt"
#apt -y install php-dev libmcrypt-dev php-pear
#pecl install mcrypt-1.0.1
#sed -i '$ a extension=mcrypt.so'  /etc/php/7.2/apache2/php.ini
#tar -czvf $BACKUPFOLDER_INSTALLED/php_02_after_mcrypt.tar.gz /etc/php/
#apt -y install php7.2-mcrypt
#apt -y install php7.3-mcrypt


echo "install nginx"
apt -y install nginx 

echo "make backups"
#cp -R /etc/mc/ $BACKUPFOLDER_EMPTY/

#cp -R /etc/ufw $BACKUPFOLDER_EMPTY/
#cp -R /etc/proftpd/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/apache2/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/nginx/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/php/ $BACKUPFOLDER_EMPTY/
tar -czvf $BACKUPFOLDER_INSTALLED/mc.tar.gz /etc/mc/
tar -czvf $BACKUPFOLDER_INSTALLED/nginx.tar.gz /etc/nginx/

echo "nginx settings"
#sed -i -e "s/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf
cp -R $SCRIPTS/.config/settings/nginx/nginx.conf /etc/nginx/nginx.conf
cp -R $SCRIPTS/.config/settings/nginx/nginxconfig.io/ /etc/nginx/
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
service nginx restart
php -v

echo "fail2ban"
apt -y install fail2ban
tar -czvf $BACKUPFOLDER_INSTALLED/fail2ban.tar.gz /etc/fail2ban/

echo "ufw settings"
ufw enable
ufw default allow outgoing
ufw default deny incoming
ufw allow 6666/tcp comment 'SSH'
ufw allow 80/tcp comment 'HTTP-Nginx'
ufw allow 443/tcp comment 'HTTPS-Nginx'
ufw allow 10081/tcp comment 'ProFTPd'
ufw allow 8080/tcp comment 'HTTP-Apache'
ufw allow 8443/tcp comment 'HTTPS-Apacne'
ufw allow 7000/tcp comment 'Webmin from Home'

echo "install policykit"
apt -y install policykit-1

echo "phpmyadmin"
apt -y install phpmyadmin php-mbstring php-gettext
a2enmod proxy_fcgi setenvif
a2enconf php7.2-fpm
tar -czvf $BACKUPFOLDER_INSTALLED/phpmyadmin.tar.gz /etc/phpmyadmin/
#cp -R /etc/phpmyadmin/ $BACKUPFOLDER_EMPTY/
sed -i -e "s/Alias \/phpmyadmin/Alias \/dbase/" /etc/phpmyadmin/apache.conf
service apache2 restart

echo "install webmin"
apt update
apt -y install software-properties-common apt-transport-https wget
wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib"
apt -y install webmin
#cp -R /etc/webmin/ $BACKUPFOLDER_EMPTY/
tar -czvf $BACKUPFOLDER_INSTALLED/webmin.tar.gz /etc/webmin/
sed -i -e "s/port=10000/port=7000/" /etc/webmin/miniserv.conf
sed -i -e "s/listen=10000/listen=7000/" /etc/webmin/miniserv.conf

a2enmod proxy
a2enmod ssl
a2enmod cache

service webmin restart

echo "git-etc"
cd /etc
git init
git add .
git commit -m "initial commit etc"

