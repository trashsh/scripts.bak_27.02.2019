#!/bin/bash
source /etc/profile
source ~/.bashrc
#Добавление системного пользователя
#$1-username process ; $2-user (создаваемый пользователь)
echo ''
echo -e "$COLOR_YELLOW Добавление пользователя $COLOR_NC"		
		mkdir -p $HOMEPATHWEBUSERS/$2
		mkdir -p $HOMEPATHWEBUSERS/$2/.backups
		mkdir -p $HOMEPATHWEBUSERS/$2/.backups/autobackup
		mkdir -p $HOMEPATHWEBUSERS/$2/.backups/userbackup
		echo "source /etc/profile" >> $HOMEPATHWEBUSERS/$2/.bashrc
		sed -i '$ a source $SCRIPTS/functions/file_params_not_found.sh'  $HOMEPATHWEBUSERS/$2/.bashrc
		sed -i '$ a source $SCRIPTS/external_scripts/dev-shell-essentials-master/dev-shell-essentials.sh'  $HOMEPATHWEBUSERS/$2/.bashrc
		sed -i '$ a source $SCRIPTS/functions/mysql.sh' $HOMEPATHWEBUSERS/$2/.bashrc
		sed -i '$ a source $SCRIPTS/functions/archive.sh'  $HOMEPATHWEBUSERS/$2/.bashrc
		sed -i '$ a source $SCRIPTS/functions/site.sh' $HOMEPATHWEBUSERS/$2/.bashrc
		sed -i '$ a source $SCRIPTS/functions/other.sh'  $HOMEPATHWEBUSERS/$2/.bashrc
		
		useradd -N -g users -d $HOMEPATHWEBUSERS/$2 -s /bin/bash $2
		chmod 755 $HOMEPATHWEBUSERS/$2
		chown $2:users $HOMEPATHWEBUSERS/$2
		touch $HOMEPATHWEBUSERS/$2/.bashrc
		touch $HOMEPATHWEBUSERS/$2/.sudo_as_admin_successful
		passwd $2

#.my.cnf
touch $HOMEPATHWEBUSERS/$2/.my.cnf
cat $HOMEPATHWEBUSERS/$2/.my.cnf | grep $HOMEPATHWEBUSERS
		{
echo '[client]'
echo 'user='$2
echo 'password='$2
} > $HOMEPATHWEBUSERS/$2/.my.cnf
chmod 600 $HOMEPATHWEBUSERS/$2/.my.cnf
chown $2:users $HOMEPATHWEBUSERS/$2/.my.cnf
chown $2:users $HOMEPATHWEBUSERS/$2/ -R