#!/bin/bash
source /etc/profile
source ~/.bashrc
# $1-user
echo ''
echo -e "$COLOR_YELLOW"Генерация ssh-ключа" $COLOR_NC"

		echo -n -e "Сгенерировать ключ доступа по SSH пользователю $COLOR_YELLOW" $1 "$COLOR_NC? введите $COLOR_BLUE\"1\"$COLOR_NC для подтверждения, $COLOR_BLUE\"2\"$COLOR_NC  - для импорта загруженного ключа, $COLOR_BLUEлюбой другой символ$COLOR_NC - для отмены: "
		read item
		case "$item" in
			1) echo
				DATE=`date '+%Y-%m-%d__%H-%M'`				
				mkdir -p $HOMEPATHWEBUSERS/$1/.ssh
				cd $HOMEPATHWEBUSERS/$1/.ssh
				ssh-keygen -t rsa -f ssh_$1 -C "ssh_$1"
				sudo puttygen $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1 -C "ssh_$1" -o $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.ppk
				DATE=`date '+%Y-%m-%d__%H-%M'`
				mkdir -p $BACKUPFOLDER_IMPORTANT/ssh/$1
				mkdir -p $BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE
				cat $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.pub >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				cat $SETTINGS/ssh/keys/lamer >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				cat $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.pub >> $BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE/ssh_$1.pub
				cat $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1 >> $BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE/ssh_$1
				cat $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.ppk >> $BACKUPFOLDER_IMPORTANT/ssh/$1/$DATE/ssh_$1.ppk
				chmod 700 $HOMEPATHWEBUSERS/$1/.ssh
				chmod 600 $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				chmod 600 $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.pub
				chmod 600 $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1
				chmod 600 $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.ppk
				chown $1:users $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.pub
				chown $1:users $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1
				chown $1:users $HOMEPATHWEBUSERS/$1/.ssh/ssh_$1.ppk
				chown $1:users $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				usermod -G ssh-access -a $1
				;;
			2) echo -e "\n$COLOR_YELLOWИмпорт открытого ключа $COLOR_NC"
			   ls -l $SETTINGS/ssh/keys/
			   read -p "Укажите название открытого ключа, который необходимо применить к текущему пользователю: " key
				mkdir -p $HOMEPATHWEBUSERS/$1/.ssh
				cat $SETTINGS/ssh/keys/$1 >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				DATE=`date '+%Y-%m-%d__%H-%M'`
				mkdir -p $BACKUPFOLDER_IMPORTANT/ssh/$1
				cat $SETTINGS/ssh/keys/lamer >> $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				chmod 700 $HOMEPATHWEBUSERS/$1/.ssh
				chmod 600 $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				chown $1:users $HOMEPATHWEBUSERS/$1/.ssh/authorized_keys
				usermod -G ssh-access -a $1
				;;
        *) echo 'Отмена операции добавления пользователя'
			echo ''
            ;;
    esac

