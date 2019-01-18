#!/bin/bash
#ввод параметров добавления сайта php/html
source /etc/profile
source ~/.bashrc
# $1 - домен ($DOMAIN), $2 - имя пользователя ($MYUSER), $3 - путь к папке с сайтом,  $4 - шаблон виртуального хоста apache, $5 - шаблон виртуального хоста nginx

#Ввод параметров сайта для добавления виртуального хоста
	user=$USER
	
    echo "--------------------------------------"
    echo "Добавление виртуального хоста."
	if ! [ -d $HOMEPATHWEBUSERS/$user/ ]; then
		sudo mkdir -p $HOMEPATHWEBUSERS/$user
	fi
	
    echo "Список имеющихся доменов:"	

    ls $HOMEPATHWEBUSERS/$user
    echo -e "${COLOR_BLUE} Введите домен для добавления ${COLOR_NC}"
	echo -n ": "	
    read domain
	site_path=$HOMEPATHWEBUSERS/$user/$domain
	echo ''
    echo -e "Возможные варианты шаблонов apache:"

    ls $TEMPLATES/apache2/
    echo -e "${COLOR_BLUE}Введите название конфигурации apache (включая расширение):${COLOR_NC}"
	echo -n ": "
    read apache_config
    echo ''
    echo "Возможные варианты шаблонов nginx:"
    ls $TEMPLATES/nginx/
    echo -e "${COLOR_BLUE}Введите название конфигурации nginx (включая расширение):${COLOR_NC}"
	echo -n ": "
    read nginx_config
    echo ''
	echo -e "Для создания домена ${COLOR_YELLOW}\"$domain\"${COLOR_NC}, пользователя ftp ${COLOR_YELLOW}\"$user\"${COLOR_NC} в каталоге ${COLOR_YELLOW}\"$site_path\"${COLOR_NC} с конфигурацией apache ${COLOR_YELLOW}\"$apache_config\"\033[0;39m и конфирурацией nginx ${COLOR_YELLOW}\"$nginx_config\"${COLOR_NC} введите ${COLOR_BLUE}\"y\" ${COLOR_NC}, для выхода - любой символ: "
    echo -n ": "
    read item
    case "$item" in
        y|Y) echo
            sudo $MYFOLDER/scripts/webserver/site/make_site_php.sh $domain $user $site_path $apache_config $nginx_config
            exit 0
            ;;
        *) echo "Выход..."
            exit 0
            ;;
    esac
