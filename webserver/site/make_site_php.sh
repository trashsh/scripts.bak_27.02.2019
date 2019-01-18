#!/bin/bash
#добавление сайта php/html
source /etc/profile
source ~/.bashrc
user=$USER
# $1 - домен ($DOMAIN), $2 - имя пользователя, $3 - путь к папке с сайтом,  $4 - шаблон виртуального хоста apache, $5 - шаблон виртуального хоста nginx

#проверка на наличие параметров запуска
if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] && [ -n "$4" ] && [ -n "$5" ]
then
        #make user
        echo "Добавление веб пользователя $2_$1 с домашним каталогом: $3 для домена $1"
        sudo mkdir -p $3		
        sudo useradd $2_$1 -N -d $3 -m -s /bin/false
        sudo adduser $2_$1 www-data
		echo -e "${COLOR_YELLOW}Установка пароля для ftp-пользователя \"$2\"${COLOR_NC}"
        sudo passwd $2_$1
        sudo cp -R /etc/skel/* $3

       #copy index.php
       sudo cp $TEMPLATES/index_php/index.php $3/$WWWFOLDER/index.php
       sudo cp $TEMPLATES/index_php/underconstruction.jpg $3/$WWWFOLDER/underconstruction.jpg
       sudo grep '#__DOMAIN' -P -R -I -l  $3/$WWWFOLDER/index.php | sudo xargs sed -i 's/#__DOMAIN/'$1'/g' $3/$WWWFOLDER/index.php
 #       sed -i 's/#__DOMAIN/$1' $3/$WWWFOLDER/index.php
 

       #nginx
       sudo cp -rf $TEMPLATES/nginx/$5 /etc/nginx/sites-available/"$2"_"$1".conf
	   sudo chmod 644 /etc/nginx/sites-available/"$2"_"$1".conf
       sudo echo "Замена переменных в файле /etc/nginx/sites-available/"$2"_"$1".conf"
       sudo grep '#__DOMAIN' -P -R -I -l  /etc/nginx/sites-available/"$2"_"$1".conf | sudo xargs sed -i 's/#__DOMAIN/'$1'/g' /etc/nginx/sites-available/"$2"_"$1".conf
	   sudo grep '#__USER' -P -R -I -l  /etc/nginx/sites-available/"$2"_"$1".conf | sudo xargs sed -i 's/#__USER/'$2'/g' /etc/nginx/sites-available/"$2"_"$1".conf
       sudo grep '#__PORT' -P -R -I -l  /etc/nginx/sites-available/"$2"_"$1".conf | sudo xargs sed -i 's/#__PORT/'$HTTPNGINXPORT'/g' /etc/nginx/sites-available/"$2"_"$1".conf
       sudo grep '#__HOMEPATHWEBUSERS' -P -R -I -l  /etc/nginx/sites-available/"$2"_"$1".conf | sudo xargs sed -i 's/'#__HOMEPATHWEBUSERS'/\/home\/webusers/g' /etc/nginx/sites-available/"$2"_"$1".conf

       sudo  ln -s /etc/nginx/sites-available/"$2"_"$1".conf /etc/nginx/sites-enabled/"$2"_"$1".conf
       sudo  systemctl reload nginx

        #apache2
        sudo cp -rf $TEMPLATES/apache2/$4 /etc/apache2/sites-available/"$2"_"$1".conf
		chmod 644 /etc/apache2/sites-available/"$2"_"$1".conf
        sudo echo "Замена переменных в файле /etc/apache2/sites-available/"$2"_"$1".conf"
        sudo grep '#__DOMAIN' -P -R -I -l  /etc/apache2/sites-available/"$2"_"$1".conf | sudo xargs sed -i 's/#__DOMAIN/'$1'/g' /etc/apache2/sites-available/"$2"_"$1".conf
		sudo grep '#__USER' -P -R -I -l  /etc/apache2/sites-available/"$2"_"$1".conf | sudo xargs sed -i 's/#__USER/'$2'/g' /etc/apache2/sites-available/"$2"_"$1".conf
        sudo grep '#__HOMEPATHWEBUSERS' -P -R -I -l  /etc/apache2/sites-available/"$2"_"$1".conf | sudo xargs sed -i 's/#__HOMEPATHWEBUSERS/\/home\/webusers/g' /etc/apache2/sites-available/"$2"_"$1".conf
        sudo grep '#__PORT' -P -R -I -l  /etc/apache2/sites-available/"$2"_"$1".conf | sudo xargs sed -i 's/#__PORT/'$HTTPAPACHEPORT'/g' /etc/apache2/sites-available/"$2"_"$1".conf

        sudo a2ensite "$2"_"$1".conf
        sudo service apache2 reload    
		
        #chmod
        sudo find $3 -type d -exec chmod 755 {} \;
        sudo find $3/$WWWFOLDER -type d -exec chmod 755 {} \;
        sudo find $3 -type f -exec chmod 644 {} \;
        sudo find $3/$WWWFOLDER -type f -exec chmod 644 {} \;
        sudo find $3/logs -type f -exec chmod 644 {} \;

        sudo chown -R $2:www-data $3/logs
        sudo chown -R $2:www-data $3/$WWWFOLDER
        sudo chown -R $2:www-data $3/tmp
		
		cd $3/$WWWFOLDER
		echo -e "\033[32m" Инициализация Git "\033[0;39m"
		git init
		git add .
		git commit -m "initial commit"
		
		echo -e "==========================================="
		echo -e "Сайт доступен по адресу: ${COLOR_YELLOW} Параметры подключения к сайту ${COLOR_NC} (nginx)"
        echo -e "Сайт доступен по адресу: ${COLOR_YELLOW} http://"$1" ${COLOR_NC} (nginx)"
        echo -e "Сайт доступен по адресу: ${COLOR_YELLOW} http://"$1":8080 ${COLOR_NC} (apache)"
		echo -e "Сервер FTP: ${COLOR_YELLOW} "$1":10081 ${COLOR_NC}"
		echo -e "FTP User: ${COLOR_YELLOW} $2_$1 ${COLOR_NC}"
		echo -e "PhpMyAdmin: ${COLOR_YELLOW} https://conf.mmgx.ru/dbase ${COLOR_NC}"
		echo -e "Adminer: ${COLOR_YELLOW} https://conf.mmgx.ru/a ${COLOR_NC}"
		echo -e "MYSQL User: ${COLOR_YELLOW} $2_$1 ${COLOR_NC}"
		echo -e "MYSQL DB: ${COLOR_YELLOW} $2_$1 ${COLOR_NC}"
		
		$SCRIPTS/menu

else
    echo "Возможные варианты шаблонов apache:"
    ls $TEMPLATES/apache2/
    echo "Возможные варианты шаблонов nginx:"
    ls $TEMPLATES/nginx/
    echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: домен, имя пользователя,путь к папке с сайтом,название шаблона apache,название шаблона nginx."
    echo "Например $0 domain.ru user /home/webusers/domain.ru php.conf php.conf"
    echo -n "Для запуска основного меню напишите ${COLOR_BLUE} \"y\" ${COLOR_NC}, для выхода - любой другой символ: "
    read item
    case "$item" in
        y|Y) echo "Ввели «y», продолжаем..."
            $SCRIPTS/menu.sh
            ;;
        *) echo "Выход..."
            exit 0
            ;;
    esac
fi


