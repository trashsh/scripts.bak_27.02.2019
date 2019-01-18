#apt update
#apt -y upgrade
#apt -y install mc git

#echo 'Git script'
#mkdir -p /my
#cd /my
#git clone https://github.com/trashsh/trash_repo.git
#mv ./trash_repo ./scripts
#cd /my/scripts
#git init
#find /my/scripts -type d -exec chmod 755 {} \;
#find /my/scripts -type f -exec chmod 777 {} \;
#find /my/scripts -type d -exec chown root:root {} \;
#find /my/scripts -type f -exec chown root:root {} \;



echo "make dirs"
mkdir -p $BACKUPFOLDER_EMPTY
mkdir -p $BACKUPFOLDER_INSTALLED
mkdir -p $BACKUPFOLDER_DAYS
mkdir -p $BACKUPFOLDER_IMPORTANT
mkdir -p $BACKUPFOLDER_IMPORTANT/ssh
mkdir -p $MYFOLDER
mkdir -p $HOMEPATHSYSUSERS
mkdir -p $HOMEPATHWEBUSERS
mkdir -p $TEMPLATES
mkdir -p $SETTINGS
mkdir /etc/skel/logs
mkdir /etc/skel/tmp
mkdir /etc/skel/$WWWFOLDER
mkdir /etc/skel/.ssh

echo "make backups"
#cp -R /etc/ $BACKUPFOLDER_EMPTY/
mkdir -p $BACKUPFOLDER_EMPTY/_null
tar -czvf $BACKUPFOLDER_EMPTY/_null/etc_null.tar.gz /etc
#mv $BACKUPFOLDER_EMPTY/etc $BACKUPFOLDER_EMPTY/_etc
#cp -R /etc/default/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/cron.d/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/cron.daily/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/cron.hourly/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/cron.monthly/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/cron.weekly/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/network/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/pam.d/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/skel/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/ssl/ $BACKUPFOLDER_EMPTY/
#cp /etc/hosts $BACKUPFOLDER_EMPTY/hosts
#cp /etc/bash.bashrc $BACKUPFOLDER_EMPTY/bash.bashrc
#cp /etc/profile $BACKUPFOLDER_EMPTY/profile
#cp /etc/sudoers $BACKUPFOLDER_EMPTY/sudoers

echo "set locale"
sudo locale-gen "ru_RU.UTF-8"
dpkg-reconfigure locales

echo "set default"
sed -i -e "s/LANG=en_US.UTF-8/LANG=ru_RU.UTF-8/" /etc/default/locale
sed -i -e "s/# GROUP=100/GROUP=100/" /etc/default/useradd
###вернуться к этому позже
#sed -i -e 's/'# HOME=\/home'/'HOME=$HOMEPATHSYSUSERS'/' /etc/default/useradd
#sed -i -e 's/"# HOME=\/home"/"HOME=$HOMEPATHSYSUSERS"/' /etc/default/useradd
#sed -i 's|'# HOME=\/home'|HOME=$HOMEPATHSYSUSERS|g' /etc/default/useradd

echo "ssh settings"
#cp -R /etc/ssh/ $BACKUPFOLDER_EMPTY/
tar -czvf $BACKUPFOLDER_INSTALLED/ssh.tar.gz /etc/ssh/
sed -i -e "s/#Port 22/Port 6666/" /etc/ssh/sshd_config
sed -i -e "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
#sed -i -e "s/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/" /etc/ssh/sshd_config
#sed -i '$ a \\nAuthenticationMethods publickey,password publickey,keyboard-interactive'  /etc/ssh/sshd_config
#sed -i -e "s/@include common-auth/#@include common-auth/" /etc/pam.d/sshd
#service sshd restart

echo "install webmin"
apt update
apt -y install software-properties-common apt-transport-https wget
wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib"
apt -y install webmin
#cp -R /etc/webmin/ $BACKUPFOLDER_EMPTY/
tar -czvf $BACKUPFOLDER_INSTALLED/webmin.tar.gz /etc/webmin/

echo "install soft"
apt -y install mc git git-core composer  wget zip unzip unrar arj putty-tools nano  ufw proftpd  apache2
tar -czvf $BACKUPFOLDER_INSTALLED/apache2.tar.gz /etc/apache2/
tar -czvf $BACKUPFOLDER_INSTALLED/proftpd.tar.gz /etc/proftpd/
tar -czvf $BACKUPFOLDER_INSTALLED/ufw.tar.gz /etc/ufw/
apt -y install curl build-essential software-properties-common


echo "php repository"
add-apt-repository -y ppa:ondrej/php
add-apt-repository -y ppa:nilarimogard/webupd8

echo "letsencrypt"
apt update
apt -y upgrade
apt -y install launchpad-getkeys
apt -y install letsencrypt
tar -czvf $BACKUPFOLDER_INSTALLED/letsencrypt.tar.gz /etc/letsencrypt/
launchpad-getkeys

echo "php"
apt -y install php-pear php5.6-curl php5.6-dev php5.6-gd php5.6-mbstring php5.6-zip php5.6-mysql php5.6-xml
apt -y install php-pear php7.0-zip php7.0-curl php7.0-gd php7.0-mysql php7.0-mcrypt php7.0-xml libapache2-mod-php7.0
apt -y install php-pear php7.1-curl php7.1-dev php7.1-gd php7.1-mbstring php7.1-zip php7.1-mysql php7.1-xml
apt -y install php-pear php7.2-curl php7.2-dev php7.2-gd php7.2-mbstring php7.2-zip php7.2-mysql php7.2-xml
apt -y install php-pear php7.3-curl php7.3-dev php7.3-gd php7.3-mbstring php7.3-zip php7.3-mysql php7.3-xml
apt -y install nginx php libapache2-mod-php php-zip php7.2-zip php7.3-zip php7.1-zip php7.0-zip apache2 php-fpm php-gd php-mysql
update-alternatives --set php /usr/bin/php7.2
update-alternatives --set php /usr/bin/php7.2

echo "make backups"
#cp -R /etc/mc/ $BACKUPFOLDER_EMPTY/
tar -czvf $BACKUPFOLDER_INSTALLED/mc.tar.gz /etc/mc/
#cp -R /etc/ufw $BACKUPFOLDER_EMPTY/
#cp -R /etc/proftpd/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/apache2/ $BACKUPFOLDER_EMPTY/
#cp -R /etc/nginx/ $BACKUPFOLDER_EMPTY/
tar -czvf $BACKUPFOLDER_INSTALLED/nginx.tar.gz /etc/nginx/
#cp -R /etc/php/ $BACKUPFOLDER_EMPTY/
tar -czvf $BACKUPFOLDER_INSTALLED/php_01.tar.gz /etc/php/

echo "install mcrypt"
apt -y install php-dev libmcrypt-dev php-pear
apt -y install php7.0-mcrypt
apt -y install php7.1-mcrypt
apt -y install php5.6-mcrypt
#pecl install mcrypt-1.0.1
#sed -i '$ a extension=mcrypt.so'  /etc/php/7.2/apache2/php.ini
#tar -czvf $BACKUPFOLDER_INSTALLED/php_02_after_mcrypt.tar.gz /etc/php/
#apt -y install php7.2-mcrypt
#apt -y install php7.3-mcrypt

echo "nginx settings"
#sed -i -e "s/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf
cp -R $SCRIPTS/.config/settings/nginx/nginx.conf /etc/nginx/nginx.conf
cp -R $SCRIPTS/.config/settings/nginx/nginxconfig.io/ /etc/nginx/
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

echo "apache conf"
/etc/init.d/apache2 stop
sed -i -e "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf
sed -i -e "s/Listen 443/Listen 8443/" /etc/apache2/ports.conf
sed -i -e "s/Listen 443/Listen 8443/" /etc/php/7.2/fpm/php.ini
sed -i -e "s/Listen 443/Listen 8443/" /etc/php/7.3/fpm/php.ini
a2enmod rewrite
service apache2 start
service apache2 stop
service apache2 start
service nginx restart
php -v

echo "install mysql"
apt -y install mysql-server
#apt -y install mariadb-server mariadb-client
mysql_secure_installation
tar -czvf $BACKUPFOLDER_INSTALLED/mysql.tar.gz /etc/mysql/

echo "phpmyadmin"
apt -y install phpmyadmin php-mbstring php-gettext
tar -czvf $BACKUPFOLDER_INSTALLED/phpmyadmin.tar.gz /etc/phpmyadmin/
#cp -R /etc/phpmyadmin/ $BACKUPFOLDER_EMPTY/
a2enmod proxy_fcgi setenvif
a2enconf php7.2-fpm
sed -i -e "s/Alias \/phpmyadmin/Alias \/dbase/" /etc/phpmyadmin/apache.conf
service apache2 stop
service apache2 start

echo "create user"
source /etc/profile
$SCRIPTS/users/input_useradd.sh
mkdir -p $HOMEPATHWEBUSERS/$USERLAMER/.ssh
touch $HOMEPATHWEBUSERS/$USERLAMER/.ssh/authorized_keys
cat /etc/passwd | grep $HOMEPATHWEBUSERS
{
  echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAp2FS7uz8Y5lo+022MmRgwiFEmlZfK9WKdamw2DH'
  echo '3blowO0736Z7H4PPcx8PGSxOfeBcl6iZ+G+ukNKrDLBY0EPqc6jNE9966zvdE9N2ws9NfNZD+7+'
  echo '26JARRlkYnqIuUIqCiO0bz1eICyDV+1TwZ7anKxUgG+dfbFIjSdfeodSVHMeNaT8NCcYho1lWXg'
  echo 'wy6q7h3k8EikS0qLqQmWOAPRrKUPXpsIzQTS8ll5B27U+w0OV0E222W4NOWHIbWDTorFxhqV7B4'
  echo 'L+Z8+eao2en3i75Qng9YEe5l09HN33oQe2SsU6CfpeN0+FqwWaUT/hsYU2qS80U2oK5DGKA6vgk'
  echo '8rQ== myvds_lamer'
} > $HOMEPATHWEBUSERS/$USERLAMER/.ssh/authorized_keys

chmod 700 $HOMEPATHWEBUSERS/$USERLAMER/.ssh
chmod 600 $HOMEPATHWEBUSERS/$USERLAMER/.ssh/authorized_keys
chown $USERLAMER:users $HOMEPATHWEBUSERS/$USERLAMER/.ssh
chown $USERLAMER:users $HOMEPATHWEBUSERS/$USERLAMER/.ssh/authorized_keys
  service ssh restart

touch $HOMEPATHWEBUSERS/$USERLAMER/.my.cnf
echo -n -e "$COLOR_BLUEВведите пароль для пользователя$COLOR_NC $COLOR_YELLOW" $USERLAMER "$COLOR_NC $COLOR_BLUEбазы данных mysql$COLOR_NC:"
read PASSWORD
cat $HOMEPATHWEBUSERS/$USERLAMER/.my.cnf | grep $HOMEPATHWEBUSERS
{
echo '[client]'
echo 'user='$USERLAMER
echo 'password='$PASSWORD
} > $HOMEPATHWEBUSERS/$USERLAMER/.my.cnf
chmod 600 $HOMEPATHWEBUSERS/$USERLAMER/.my.cnf
chown $USERLAMER:users $HOMEPATHWEBUSERS/$USERLAMER/.my.cnf
  

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


###Еще не сделал
echo "webmin settings"
sed -i -e "s/ssl=1/ssl=0/" /etc/webmin/miniserv.conf
sed -i -e "s/port=10000/port=7000/" /etc/webmin/miniserv.conf
sed -i -e "s/listen=10000/listen=7000/" /etc/webmin/miniserv.conf
sed -i '$ a referers=wm.mmgx.ru'  /etc/webmin/config
#cp /my/scripts/.config/settings/webmin/apache/wm.mmgx.ru.conf $APACHEAVAILABLE/wm.mmgx.ru.conf
systemctl restart webmin
a2enmod proxy_http
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
