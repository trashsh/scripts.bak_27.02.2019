#!/bin/bash
#ввод параметров добавления сайта на laravel
source /etc/profile
source ~/.bashrc
#$1_$USERNAME
echo "Список имеющихся доменов на сервере: "
ls $HOMEPATHWEBUSERS
echo ""
read -p "Введите домен: " domain
echo ''
echo "Список имеющихся пользователей:"
getent group www-data



echo -n "Введите пользователя для создания FTP-пользователя для домена $domain: "
read user

site_path=$HOMEPATHWEBUSERS/$domain
    echo ''
    echo "Возможные варианты шаблонов apache:"
    ls $TEMPLATES/apache2/
    echo -n "Введите название конфигурации apache (включая расширение):"
    read apache_config
    echo ''
    echo "Возможные варианты шаблонов nginx:"
    ls $TEMPLATES/nginx/
    echo -n "Введите название конфигурации nginx (включая расширение):"
    read nginx_config
    echo ''
    echo -n "Для создания домена $domain, пользователя $user в каталоге $site_path с конфигурацией apache \"$apache_config\" и конфирурацией nginx \"$nginx_config\" введите \"y\", для выхода - любой символ: "
    read item
    case "$item" in
        y|Y) echo
            $SCRIPTS/webserver/make/my_site_add_laravel.sh $domain $user $site_path $apache_config $nginx_config
            exit 0
            ;;
        *) echo "Выход..."
            exit 0
            ;;
    esac