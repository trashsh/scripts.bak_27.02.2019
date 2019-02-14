#fix phpmyadmin error
sudo sed -i "s/|\s*\((count(\$analyzed_sql_results\['select_expr'\]\)/| (\1)/g" /usr/share/phpmyadmin/libraries/sql.lib.php


sed -i '$ a source $SCRIPTS/functions/mysql.sh'  /root/.bashrc
sed -i '$ a source $SCRIPTS/functions/archive.sh'  /root/.bashrc
sed -i '$ a source $SCRIPTS/external_scripts/dev-shell-essentials-master/dev-shell-essentials.sh'  /root/.bashrc
sed -i '$ a source $SCRIPTS/external_scripts/dev-shell-essentials-master/dev-shell-essentials.sh'  /etc/profile
sed -i '$ a export LINE=\"----------------------------------------------------------------------------------------------"'  /etc/profile
source ~/.bashrc
source /etc/profile

groupadd admin-access
usermod -G admin-access -a root
usermod -G admin-access -a $USERLAMER

apt-get install quota
#fstab usrquota
sed -i -e "s/=remount-ro /=remount-ro,usrquota /" /etc/fstab
mount -o remount /
quotacheck -cum /
quotaon /