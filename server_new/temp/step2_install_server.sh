



apt install php-zip
apt install composer

echo "set locale"
sudo locale-gen "ru_RU.UTF-8"
dpkg-reconfigure locales

echo "stop apache"
service apache2 stop



echo "set apt"
cp -R /etc/apt/ $BACKUPFOLDER_EMPTY/
cp -R $SETTINGS/apt/sources.list /etc/apt/sources.list
#sed -i -e "s/deb http:\/\/archive.ubuntu.com\/ubuntu xenial main restricted universe/#deb http:\/\/archive.ubuntu.com\/ubuntu xenial main restricted universe/" /etc/apt/sources.list
#sed -i -e "s/deb http:\/\/archive.ubuntu.com\/ubuntu xenial-updates main restricted universe/#deb http:\/\/archive.ubuntu.com\/ubuntu xenial-updates main restricted universe/" /etc/apt/sources.list
#sed -i -e "s/deb http:\/\/security.ubuntu.com\/ubuntu xenial-security main restricted universe multiverse/#deb http:\/\/security.ubuntu.com\/ubuntu xenial-security main restricted universe multiverse/" /etc/apt/sources.list
#sed -i -e '1 s/^/\n/;' /etc/apt/sources.list
#sed -i -e "s/deb http:\/\/archive.canonical.com\/ubuntu xenial partner/#deb http:\/\/archive.canonical.com\/ubuntu xenial partner/" /etc/apt/sources.list
#sed -i -e '1 s/^deb http:\/\/mirror.yandex.ru\/ubuntu xenial partner/\n/;' /etc/apt/sources.list
#sed -i -e '1 s/^/deb http:\/\/mirror.yandex.ru\/ubuntu xenial-security main restricted universe multiverse\n/;' /etc/apt/sources.list
#sed -i -e '1 s/^/deb http:\/\/mirror.yandex.ru\/ubuntu xenial-updates main restricted universe\n/;' /etc/apt/sources.list
#sed -i -e '1 s/^/deb http:\/\/mirror.yandex.ru\/ubuntu xenial main restricted universe\n/;' /etc/apt/sources.list
#sed -i -e '1 s/^/#yandex mirror\n/;' /etc/apt/sources.list


echo "set default"
sed -i -e "s/LANG=en_US.UTF-8/LANG=ru_RU.UTF-8/" /etc/default/locale
sed -i -e "s/# GROUP=100/GROUP=100/" /etc/default/useradd

###вернуться к этому позже
#sed -i -e 's/'# HOME=\/home'/'HOME=$HOMEPATHSYSUSERS'/' /etc/default/useradd
#sed -i -e 's/"# HOME=\/home"/"HOME=$HOMEPATHSYSUSERS"/' /etc/default/useradd
#sed -i 's|'# HOME=\/home'|HOME=$HOMEPATHSYSUSERS|g' /etc/default/useradd

echo "install soft"
apt update
apt -y upgrade
#apt -y install rcconf 


###вернуться к этому позже
apt install python-software-properties






#echo "ssh settings"
#cp -R /etc/ssh/ $BACKUPFOLDER_EMPTY/
#sed -i -e "s/Port 22/Port 6666/" /etc/ssh/sshd_config
#sed -i -e "s/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/" /etc/ssh/sshd_config
#sed -i -e "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
#sed -i '$ a \\nAuthenticationMethods publickey,password publickey,keyboard-interactive'  /etc/ssh/sshd_config
#sed -i -e "s/@include common-auth/#@include common-auth/" /etc/pam.d/sshd
#service sshd restart

echo "install php"
apt update
/etc/init.d/apache2 stop










echo "install mysql"
apt -y install mysql-server
#apt -y install mariadb-server mariadb-client
mysql_secure_installation

apt -y install phpmyadmin php-mbstring php-gettext
cp -R /etc/phpmyadmin/ $BACKUPFOLDER_EMPTY/
sed -i -e "s/Alias \/phpmyadmin/Alias \/dbase/" /etc/phpmyadmin/apache.conf
service apache2 stop
service apache2 start


echo "create user"
$SCRIPTS/users/useradd.sh


###google autentificator###
#apt install -y libpam-google-authenticator
#google-authenticator
#sed -i '$ a \\n#Google autentificator\nauth required pam_google_authenticator.so nullok'  /etc/pam.d/sshd

#chmod -x $(dirname $0)/install_server.sh

