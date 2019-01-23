apt update
apt -y upgrade
apt -y install mc git

echo 'Git script'
mkdir -p /my
cd /my
git clone https://github.com/trashsh/trash_repo.git
mv ./trash_repo ./scripts
cd /my/scripts
git init
find /my/scripts -type d -exec chmod 755 {} \;
find /my/scripts -type f -exec chmod 777 {} \;
find /my/scripts -type d -exec chown root:root {} \;
find /my/scripts -type f -exec chown root:root {} \;

echo "set vars"
sed -i '$ a \\nexport USERLAMER=\"lamer\"'  /etc/profile
sed -i '$ a export WWWFOLDER=\"public_html\"'  /etc/profile
sed -i '$ a export MYFOLDER=\"\/my\"'  /etc/profile
sed -i '$ a export BACKUPFOLDER=\"\/var\/backups\"'  /etc/profile
sed -i '$ a export BACKUPFOLDER_EMPTY=\"$BACKUPFOLDER\/vds\/empty\"'  /etc/profile
sed -i '$ a export BACKUPFOLDER_INSTALLED=\"$BACKUPFOLDER\/vds\/empty\/_installed\"'  /etc/profile
sed -i '$ a export BACKUPFOLDER_DAYS=\"$BACKUPFOLDER\/vds\/days\"'  /etc/profile
sed -i '$ a export BACKUPFOLDER_IMPORTANT=\"$BACKUPFOLDER\/vds\/important\"'  /etc/profile
sed -i '$ a export HOMEPATHSYSUSERS=\"\/home\/system\"'  /etc/profile
sed -i '$ a export HOMEPATHWEBUSERS=\"\/home\/webusers\"'  /etc/profile
sed -i '$ a export NGINXAVAILABLE=\"\/etc\/nginx\/sites-available\"'  /etc/profile
sed -i '$ a export NGINXENABLED="\/etc\/nginx\/sites-enabled\"'  /etc/profile
sed -i '$ a export APACHEAVAILABLE=\"\/etc\/apache2\/sites-available\"'  /etc/profile
sed -i '$ a export APACHEENABLED="\/etc\/apache2\/sites-enabled\"'  /etc/profile
sed -i '$ a export HTTPNGINXPORT=80'  /etc/profile
sed -i '$ a export HTTPSNGINXPORT=443'  /etc/profile
sed -i '$ a export HTTPAPACHEPORT=8080'  /etc/profile
sed -i '$ a export HTTPSAPACHEPORT=8081'  /etc/profile
sed -i '$ a PATH=$PATH:\/my\/scripts\/system/'  /etc/profile
sed -i '$ a PATH=$PATH:\/my\/scripts\/users/'  /etc/profile
sed -i '$ a PATH=$PATH:\/my\/scripts\/webserver/'  /etc/profile
sed -i '$ a PATH=$PATH:\/my\/scripts/'  /etc/profile
source /etc/profile
sed -i '$ a export SCRIPTS=\'$MYFOLDER'\/scripts'  /etc/profile
sed -i '$ a export MENU=\'$MYFOLDER'\/scripts\/.menu'  /etc/profile
sed -i '$ a PATH=$PATH:'$HOMEPATHSYSUSERS\/$USERLAMER'\/.composer\/vendor\/bin'  /etc/profile
sed -i '$ a export TEMPLATES="\/my'$MYFOlDER'\/scripts\/.config\/templates"'  /etc/profile
sed -i '$ a export SETTINGS="\/my'$MYFOlDER'\/scripts\/.config\/settings"'  /etc/profile
source /etc/profile
sed -i "$ a export COLOR_NC='\\\e[0m'"  /etc/profile
sed -i "$ a export COLOR_WHITE='\\\e[1;37m'"  /etc/profile
sed -i "$ a export COLOR_BLACK='\\\e[0;30m'"  /etc/profile
sed -i "$ a export COLOR_BLUE='\\\e[1;34m'"  /etc/profile
sed -i "$ a export COLOR_LIGHT_BLUE='\\\e[0;32m'"  /etc/profile
sed -i "$ a export COLOR_LIGHT_GREEN='\\\e[0;36m'"  /etc/profile
sed -i "$ a export COLOR_LIGHT_CYAN='\\\e[1;36m'"  /etc/profile
sed -i "$ a export COLOR_RED='\\\e[0;31m'"  /etc/profile
sed -i "$ a export COLOR_LIGHT_RED='\\\e[1;31m'"  /etc/profile
sed -i "$ a export COLOR_PURPLE='\\\e[0;35m'"  /etc/profile
sed -i "$ a export COLOR_LIGHT_PURPLE='\\\e[1;35m'"  /etc/profile
sed -i "$ a export COLOR_BROWN='\\\e[0;33m'"  /etc/profile
sed -i "$ a export COLOR_YELLOW='\\\e[1;33m'"  /etc/profile
sed -i "$ a export COLOR_GRAY='\\\e[0;30m'"  /etc/profile
sed -i "$ a export COLOR_LIGHT_GRAY='\\\e[0;37m'"  /etc/profile
sed -i "$ a export COLOR_GREEN='\\\e[0;32m'"  /etc/profile
source /etc/profile

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
service sshd restart

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
  