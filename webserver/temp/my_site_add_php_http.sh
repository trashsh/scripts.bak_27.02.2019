#!/bin/bash
#добавление сайта php/html
source /etc/profile
source ~/.bashrc
# $1 - домен ($DOMAIN), $2 - имя пользователя ($MYUSER), $3 - путь к папке с сайтом,  $4 - шаблон виртуального хоста apache, $5 - шаблон виртуального хоста nginx

#проверка на наличие параметров запуска
if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] && [ -n "$4" ] && [ -n "$5" ]
then
        #make user
        echo "Добавление веб пользователя $2 с домашним каталогом: $3 для домена $1"
        mkdir -p $3
        useradd $2 -N -d $3 -m -s /bin/false
        adduser $2 www-data
        passwd $2
        cp -R /etc/skel/* $3

       #copy index.php
       cp  $TEMPLATES/index_php/index.php $3/$WWWFOLDER/index.php
       cp  $TEMPLATES/index_php/underconstruction.jpg $3/$WWWFOLDER/underconstruction.jpg
       grep '#__DOMAIN' -P -R -I -l  $3/$WWWFOLDER/index.php | xargs sed -i 's/#__DOMAIN/'$1'/g' $3/$WWWFOLDER/index.php
 #       sed -i 's/#__DOMAIN/$1' $3/$WWWFOLDER/index.php

       #nginx
       cp -rf $TEMPLATES/nginx/$5 /etc/nginx/sites-available/$1.conf
       echo "Замена переменных в файле /etc/nginx/sites-available/$1.conf"
       grep '#__DOMAIN' -P -R -I -l  /etc/nginx/sites-available/$1.conf | xargs sed -i 's/#__DOMAIN/'$1'/g' /etc/nginx/sites-available/$1.conf
       grep '#__PORT' -P -R -I -l  /etc/nginx/sites-available/$1.conf | xargs sed -i 's/#__PORT/'$HTTPNGINXPORT'/g' /etc/nginx/sites-available/$1.conf
       grep '#__HOMEPATHWEBUSERS' -P -R -I -l  /etc/nginx/sites-available/$1.conf | xargs sed -i 's/'#__HOMEPATHWEBUSERS'/\/home\/webusers/g' /etc/nginx/sites-available/$1.conf

        ln -s /etc/nginx/sites-available/$1.conf /etc/nginx/sites-enabled/$1.conf
        systemctl reload nginx

        #apache2
        cp -rf $TEMPLATES/apache2/$4 /etc/apache2/sites-available/$1.conf
        echo "Замена переменных в файле /etc/apache2/sites-available/$1.conf"
        grep '#__DOMAIN' -P -R -I -l  /etc/apache2/sites-available/$1.conf | xargs sed -i 's/#__DOMAIN/'$1'/g' /etc/apache2/sites-available/$1.conf
        grep '#__HOMEPATHWEBUSERS' -P -R -I -l  /etc/apache2/sites-available/$1.conf | xargs sed -i 's/#__HOMEPATHWEBUSERS/\/home\/webusers/g' /etc/apache2/sites-available/$1.conf
        grep '#__PORT' -P -R -I -l  /etc/apache2/sites-available/$1.conf | xargs sed -i 's/#__PORT/'$HTTPAPACHEPORT'/g' /etc/apache2/sites-available/$1.conf

        a2ensite $1.conf
        service apache2 reload
        echo ''
        echo 'Сайт доступен по адресу: http://'$1' (nginx)'
        echo 'Сайт доступен по адресу: http://'$1':8080 (apache)'

        #chmod
        find $3 -type d -exec chmod 755 {} \;
        find $3/$WWWFOLDER -type d -exec chmod 755 {} \;
        find $3 -type f -exec chmod 644 {} \;
        find $3/$WWWFOLDER -type f -exec chmod 644 {} \;
        find $3/logs -type f -exec chmod 644 {} \;

        chown -R $2:www-data $3/logs
        chown -R $2:www-data $3/$WWWFOLDER
        chown -R $2:www-data $3/tmp

else
    echo "Возможные варианты шаблонов apache:"
    ls $TEMPLATES/apache2/
    echo "Возможные варианты шаблонов nginx:"
    ls $TEMPLATES/nginx/
    echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: домен, имя пользователя,путь к папке с сайтом,название шаблона apache,название шаблона nginx."
    echo "Например $0 domain.ru user /home/webusers/domain.ru php.conf php.conf"
    echo -n "Для запуска основного меню напишите \"y\", для выхода - любой другой символ: "
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


