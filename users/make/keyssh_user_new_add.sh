#!/bin/bash
source /etc/profile
source ~/.bashrc
# Генерация и добавление ключа SSH для пользователя
# $1-username process $2-user

if [ -n "$1" ] && [ -n "$2" ] 
then

echo ''
echo -e "$COLOR_YELLOWГенерация ssh-ключа $COLOR_NC"

		echo -n -e "Сгенерировать ключ доступа по SSH пользователю $COLOR_YELLOW" $2 "$COLOR_NC? введите $COLOR_BLUE\"y\"$COLOR_NC для подтверждения, $COLOR_BLUE\"n\"$COLOR_NC  - для импорта загруженного ключа, $COLOR_BLUE любой другой символ$COLOR_NC - для отмены: "
		
		
		while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y)  echo
				DATE=`date '+%Y-%m-%d__%H-%M'`				
				mkdir -p $HOMEPATHWEBUSERS/$2/.ssh
				cd $HOMEPATHWEBUSERS/$2/.ssh
				echo -e "\n$COLOR_YELLOWГенерация ключа. Сейчас необходимо будет установить пароль на ключевой файл.Минимум - 5 символов$COLOR_NC"
				ssh-keygen -t rsa -f ssh_$2 -C "ssh_$2"
				echo -e "\n$COLOR_YELLOWКонвертация ключа в формат программы Putty. Необходимо ввести пароль на ключевой файл, установленный на предыдушем шаге $COLOR_NC"
				sudo puttygen $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2 -C "ssh_$2" -o $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.ppk
				DATE=`date '+%Y-%m-%d__%H-%M'`
				mkdir -p $BACKUPFOLDER_IMPORTANT/ssh/$2
				mkdir -p $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE
				cat $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.pub >> $HOMEPATHWEBUSERS/$2/.ssh/authorized_keys
				$SCRIPTS/users/make/keyssh_admin_add.sh $1 $2
				cat $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.pub >> $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE/ssh_$2.pub
				cat $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2 >> $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE/ssh_$2
				cat $HOMEPATHWEBUSERS/$2/.ssh/ssh_$2.ppk >> $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE/ssh_$2.ppk
				$SCRIPTS/archive/tar_without_structure.sh $1 $HOMEPATHWEBUSERS/$2/.ssh/ $BACKUPFOLDER_IMPORTANT/ssh/$2/ $DATE.tar.gz
				
				if [ -d $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE ] ; then
					if [ -f $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE.tar.gz ] ; then
										rm -Rfv $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE
									else
										echo -e "$COLOR_REDОшибка автоматического удаления каталога \"$BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE\". Требуется удалить его вручную.$COLOR_NC"
									fi

								
					else
						echo -e "$COLOR_REDОшибка автоматического удаления каталога \"$BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE\". Требуется удалить его вручную.$COLOR_NC"
					fi
				
				
				
#				tar -czf $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE.tar.gz $BACKUPFOLDER_IMPORTANT/ssh/$2/$DATE
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
				break
				;;
			n|N)  echo -e "\n$COLOR_YELLOWСписок возможных ключей для импорта: $COLOR_NC"
			   ls -l $SETTINGS/ssh/keys/
			   echo -n -e "$COLOR_BLUEУкажите название открытого ключа, который необходимо применить к текущему пользователю: $COLOR_NC"
			   read -p ":" key
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
				echo -e "\n$COLOR_YELLOWИмпорт ключа $COLOR_LIGHT_PURPLE\"$key\"$COLOR_YELLOW пользователю $COLOR_LIGHT_PURPLE\"$2\"$COLOR_YELLOW выполнен$COLOR_NC"
				$SCRIPTS/menu
				break				
				;;
			*) 
			echo ''
            ;;	
			esac
		done


	else
    echo -e "\n$COLOR_YELLOWПараметры запуска не найдены$COLOR_NC. Необходимы параметры: имя пользователя"
    echo -n -e "$COLOR_YELLOWДля запуска основного меню напишите $COLOR_BLUE\"y\"$COLOR_YELLOW, для выхода - $COLOR_BLUE\"n\"$COLOR_NC:"
	while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y)	$SCRIPTS/menu $1;
					break;;
			n|N)  exit 0;
			esac
		done

fi