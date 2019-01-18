#!/bin/bash
source /etc/profile
source ~/.bashrc

echo ''
echo -e "\033[32m"Создание системного пользователя "\033[0;39m"
read -p "Введите имя пользователя: " username
mkdir -p $HOMEPATHWEBUSERS/$username
useradd -N -g users $username -d $HOMEPATHWEBUSERS/$username -s /bin/bash
passwd $username
chmod 755 $HOMEPATHWEBUSERS/$username
chown $username:users $HOMEPATHWEBUSERS/$username
touch $HOMEPATHWEBUSERS/$username/.bashrc

echo -n "Добавить пользователя " $username "в список sudo? введите \"y\" для подтверждения, для выхода - любой символ: "
    read item
    case "$item" in
        y|Y) echo
            adduser $username sudo
			echo 'Пользователь $username добавлен в список sudo'
            ;;
        *) echo "Выход..."
            ;;
    esac

