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

/my/scripts/server_new/step1/step1.sh