#!/bin/bash
source /etc/profile
source ~/.bashrc
#$1-user
echo ''
echo -e "$COLOR_YELLOW Добавление пользователя $COLOR_NC"
		
		mkdir -p $HOMEPATHWEBUSERS/$1
		echo "source /etc/profile" >> $HOMEPATHWEBUSERS/$1/.bashrc
#		echo "source ~/.bashrc" >> $HOMEPATHWEBUSERS/$1/.bashrc
		useradd -N -g users $1 -d $HOMEPATHWEBUSERS/$1 -s /bin/bash
		chmod 755 $HOMEPATHWEBUSERS/$1
		chown $1:users $HOMEPATHWEBUSERS/$1
		touch $HOMEPATHWEBUSERS/$1/.bashrc
		touch $HOMEPATHWEBUSERS/$1/.sudo_as_admin_successful
		passwd $1

#.my.cnf
touch $HOMEPATHWEBUSERS/$1/.my.cnf
cat $HOMEPATHWEBUSERS/$1/.my.cnf | grep $HOMEPATHWEBUSERS
		{
echo '[client]'
echo 'user='$1
echo 'password='$1
} > $HOMEPATHWEBUSERS/$1/.my.cnf
chmod 600 $HOMEPATHWEBUSERS/$1/.my.cnf
chown $1:users $HOMEPATHWEBUSERS/$1/.my.cnf