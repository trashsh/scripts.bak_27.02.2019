#!/bin/bash
source /etc/profile
source ~/.bashrc
# $1-username $2-user
echo ''
echo -e "$COLOR_YELLOW"Генерация ssh-ключа" $COLOR_NC"

		echo -n -e "Сгенерировать ключ доступа по SSH пользователю $COLOR_YELLOW" $2 "$COLOR_NC? введите $COLOR_BLUE\"1\"$COLOR_NC для подтверждения, $COLOR_BLUE\"2\"$COLOR_NC  - для импорта загруженного ключа, $COLOR_BLUE любой другой символ$COLOR_NC - для отмены: "
		read item
		case "$item" in
			1) echo
				DATE=`date '+%Y-%m-%d__%H-%M'`				
				mkdir -p $HOMEPATHWEBUSERS/$2/.ssh
				cd $HOMEPATHWEBUSERS/$2/.ssh
				ssh-keygen -t rsa -f ssh_$2 -C "ssh_$2"
				sudo puttygen $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2 -C "ssh_$2" -o $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.ppk
				DATE=`date '+%Y-%m-%d__%H-%M'`
				mkdir -p $BACKUPFOLDER_IMPORTANT/ssh/$2
				mkdir -p $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE
				cat $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.pub >> $HOMEPATHWEBUSERS/$2/.ssh/authorized_keys
				cat $SETTINGS/ssh/keys/lamer >> $HOMEPATHWEBUSERS/$2/.ssh/authorized_keys
				cat $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.pub >> $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE/ssh_$2.pub
				cat $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2 >> $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE/ssh_$2
				cat $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.ppk >> $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE/ssh_$2.ppk
				chmod 700 $HOMEPATHWEBUSERS/$2/.ssh
				chmod 600 $HOMEPATHWEBUSERS/$2/.ssh/authorized_keys
				chmod 600 $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.pub
				chmod 600 $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2
				chmod 600 $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.ppk
				chown $2:users $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.pub
				chown $2:users $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2
				chown $2:users $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.ppk
				chown $2:users $HOMEPATHWEBUSERS/$2/.ssh/authorized_keys
				usermod -G ssh-access -a $2
				;;
			2) echo -e "\n$COLOR_YELLOWИмпорт открытого ключа $COLOR_NC"
			   ls -l $SETTINGS/ssh/keys/
			   read -p "Укажите название открытого ключа, который необходимо применить к текущему пользователю: " key
				mkdir -p $HOMEPATHWEBUSERS/$2/.ssh
				cat $SETTINGS/ssh/keys/$key >> $HOMEPATHWEBUSERS/$2/.ssh/authorized_keys
				echo "" >> $HOMEPATHWEBUSERS/$2/.ssh/authorized_keys
				cat $SETTINGS/ssh/keys/lamer >> $HOMEPATHWEBUSERS/$2/.ssh/authorized_keys
				DATE=`date '+%Y-%m-%d__%H-%M'`
				mkdir -p $BACKUPFOLDER_IMPORTANT/ssh/$2				
				chmod 700 $HOMEPATHWEBUSERS/$2/.ssh
				chmod 600 $HOMEPATHWEBUSERS/$2/.ssh/authorized_keys
				chown $2:users $HOMEPATHWEBUSERS/$2/.ssh
				chown $2:users $HOMEPATHWEBUSERS/$2/.ssh/authorized_keys
				usermod -G ssh-access -a $2
				
				
				;;
        *) 
			echo ''
            ;;
    esac

