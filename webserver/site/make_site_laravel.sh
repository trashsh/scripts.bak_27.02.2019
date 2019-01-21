#!/bin/bash
#добавление сайта на laravel
source /etc/profile
source ~/.bashrc
# $1 - домен ($DOMAIN), $2 - имя пользователя, $3 - путь к папке с сайтом,  $4 - шаблон виртуального хоста apache, $5 - шаблон виртуального хоста nginx

#проверка на наличие параметров запуска
if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ] && [ -n "$4" ] && [ -n "$5" ]
then

        cd $HOMEPATHWEBUSERS/$2
        composer create-project --prefer-dist laravel/laravel $1

        #make user
        echo "Добавление веб пользователя $2 с домашним каталогом: $3 для домена $1"
        mkdir -p $3
        useradd $2_$1 -N -d $3 -m -s /bin/false
        adduser $2_$1 www-data
        passwd $2_$1
        cp -R /etc/skel/* $3
        rm -rf $3/public_html
		
		cd $3 
		cp -a $3/.env.example $3/.env
		php artisan key:generate
		php artisan config:cache


       #nginx
       cp -rf $TEMPLATES/nginx/$5 /etc/nginx/sites-available/$2_$1.conf
       echo "Замена переменных в файле /etc/nginx/sites-available/$2_$1.conf"
       grep '#__DOMAIN' -P -R -I -l  /etc/nginx/sites-available/$2_$1.conf | xargs sed -i 's/#__DOMAIN/'$1'/g' /etc/nginx/sites-available/$2_$1.conf
	   grep '#__USER' -P -R -I -l  /etc/nginx/sites-available/$2_$1.conf | xargs sed -i 's/#__USER/'$2'/g' /etc/nginx/sites-available/$2_$1.conf
       grep '#__PORT' -P -R -I -l  /etc/nginx/sites-available/$2_$1.conf | xargs sed -i 's/#__PORT/'$HTTPNGINXPORT'/g' /etc/nginx/sites-available/$2_$1.conf
       grep '#__HOMEPATHWEBUSERS' -P -R -I -l  /etc/nginx/sites-available/$2_$1.conf | xargs sed -i 's/'#__HOMEPATHWEBUSERS'/\/home\/webusers/g' /etc/nginx/sites-available/$2_$1.conf

        ln -s /etc/nginx/sites-available/$2_$1.conf /etc/nginx/sites-enabled/$2_$1.conf
        systemctl reload nginx

        #apache2 
        cp -rf $TEMPLATES/apache2/$4 /etc/apache2/sites-available/$2_$1.conf
        grep '#__DOMAIN' -P -R -I -l  /etc/apache2/sites-available/$2_$1.conf | xargs sed -i 's/#__DOMAIN/'$1'/g' /etc/apache2/sites-available/$2_$1.conf
		grep '#__USER' -P -R -I -l  /etc/apache2/sites-available/$2_$1.conf | xargs sed -i 's/#__USER/'$2'/g' /etc/apache2/sites-available/$2_$1.conf
        grep '#__HOMEPATHWEBUSERS' -P -R -I -l  /etc/apache2/sites-available/$2_$1.conf | xargs sed -i 's/#__HOMEPATHWEBUSERS/\/home\/webusers/g' /etc/apache2/sites-available/$2_$1.conf
        grep '#__PORT' -P -R -I -l  /etc/apache2/sites-available/$2_$1.conf | xargs sed -i 's/#__PORT/'$HTTPAPACHEPORT'/g' /etc/apache2/sites-available/$2_$1.conf

        a2ensite $2_$1.conf
        systemctl reload apache2
		
		cp -rf $TEMPLATES/laravel/.gitignore $3/.gitignore

        echo -e "\033[32m" Применение прав к папкам и каталогам. Немного подождите "\033[0;39m"

        #chmod
        find $3 -type d -exec chmod 755 {} \;
        find $3/public -type d -exec chmod 755 {} \;
        find $3 -type f -exec chmod 644 {} \;
        find $3/public -type f -exec chmod 644 {} \;
        find $3/logs -type f -exec chmod 644 {} \;
		find $3 -type d -exec chown $2:www-data {} \;
		find $3 -type f -exec chown $2:www-data {} \;

        chown -R $2:www-data $3/logs
        chown -R $2:www-data $3/public
        chown -R $2:www-data $3/tmp
		

        chmod 777 $3/bootstrap/cache -R
        chmod 777 $3/storage -R

		cd $3
		echo -e "\033[32m" Инициализация Git "\033[0;39m"
		git init
		git add .
		git commit -m "initial commit"
		$SCRIPTS/menu


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
            $SCRIPTS/menu
            ;;
        *) echo "Выход..."
            exit 0
            ;;
    esac
fi


