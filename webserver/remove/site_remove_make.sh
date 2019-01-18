#!/bin/bash
#удаление сайта
source /etc/profile
source ~/.bashrc
# $1 - домен ($1), $2 - путь к каталогу, $3 - имя пользователя

#проверка на наличие параметров запуска
if [ -n "$1" ] && [ -n "$2" ] && [ -n "$3" ]
then

user_domain=$3_$1

#проверка пользователя на существование
    grep "$3:" /etc/passwd >/dev/null
    if [ $? -ne 0 ]; then
         echo 'Пользователь не найден и не будет удален'
		echo -n -e "напишите ${COLOR_BLUE}"yes"${COLOR_NC} для удаления домена ${COLOR_GREEN}$1${COLOR_NC}, каталога ${COLOR_GREEN}$2${COLOR_NC} БЕЗ пользователя ${COLOR_GREEN}$3${COLOR_NC} или любой символ для отмены : "
        #удаление каталога без существования пользователя
        read -p yesdeldomain
        #Получено подтверждение на удаление пользователя и каталога
            if [[ $yesdeldomain = "yes" ]]
                then
                #удаление файлов без пользователя
                    a2dissite $user_domain.conf

                    # remove the symlink in the sites-enabled directory
                    if [ -f "$NGINXENABLED"/"$user_domain.conf" ] ; then
                           sudo rm "$NGINXENABLED"/"$user_domain.conf"
                    fi

                    # remove the config in the sites-available directory
                    if [ -f "$NGINXAVAILABLE"/"$user_domain.conf" ] ; then
                            sudo rm "$NGINXAVAILABLE"/"$user_domain.conf"
                    fi

                    # remove the symlink in the sites-enabled directory
                    if [ -f "$APACHEENABLED"/"$user_domain.conf" ] ; then
                            sudo rm "$APACHEENABLED"/"$user_domain.conf"
                    fi

                    # remove the config in the sites-available directory
                    if [ -f "$APACHEAVAILABLE"/"$user_domain.conf" ] ; then
                            sudo rm "$APACHEAVAILABLE"/"$user_domain.conf"
                    fi

                    # remove the access log apache
                    if [ -f $2/logs/error_apache.log ] ;  then
                            sudo rm $2/logs/error_apache.log
                    fi

                    # remove the error log
                    if [ -f $2/logs/access_apache.log ] ;  then
                            sudo rm $2/logs/access_apache.log
                    fi

                    # remove the access log nginx
                    if [ -f $2/logs/access_nginx.log ] ;  then
                            sudo rm $2/logs/access_nginx.log
                    fi

                    # remove the error log
                    if [ -f $2/logs/error_nginx.log ] ;  then
                            sudo rm $2/logs/error_nginx.log
                    fi

                    sudo systemctl reload nginx
                    sudo systemctl reload apache2

                    sudo rm -Rfv $2

                   echo "Удаление домена $1 завершено"
                   $MENU/menu_site.sh

                   exit 0
            else
            #Подтверждение на удаление пользователя и каталога не получено
                echo "Удаление отменено"
                $MENU/menu_site.sh
                exit 0
            fi


    $MENU/menu_site.sh
    else
    #Пользователь существует
        read -p "напишите "yes" для удаления домена $1, каталога $2 и пользователя $3_$1 или любой символ для отмены : " yesdeldomain
        #Получено подтверждение на удаление пользователя и каталога
            if [[ $yesdeldomain = "yes" ]]
                then
                    sudo userdel $3_$1
                    echo "Пользователь $user удален"

                    sudo a2dissite $user_domain.conf

                    # remove the symlink in the sites-enabled directory
                    if [ -f "$NGINXENABLED"/"$user_domain.conf" ] ; then
                            sudo rm "$NGINXENABLED"/"$user_domain.conf"
                    fi

                    # remove the config in the sites-available directory
                    if [ -f "$NGINXAVAILABLE"/"$user_domain.conf" ] ; then
                            sudo rm "$NGINXAVAILABLE"/"$user_domain.conf"
                    fi

                    # remove the symlink in the sites-enabled directory
                    if [ -f "$APACHEENABLED"/"$user_domain.conf" ] ; then
                            sudo rm "$APACHEENABLED"/"$user_domain.conf"
                    fi

                    # remove the config in the sites-available directory
                    if [ -f "$APACHEAVAILABLE"/"$user_domain.conf" ] ; then
                            sudo rm "$APACHEAVAILABLE"/"$user_domain.conf"
                    fi

                    # remove the access log apache
                    if [ -f $2/logs/error_apache.log ] ;  then
                            sudo rm $2/logs/error_apache.log
                    fi

                    # remove the error log
                    if [ -f $2/logs/access_apache.log ] ;  then
                            sudo rm $2/logs/access_apache.log
                    fi

                    # remove the access log nginx
                    if [ -f $2/logs/access_nginx.log ] ;  then
                            rm $2/logs/access_nginx.log
                    fi

                    # remove the error log
                    if [ -f $2/logs/error_nginx.log ] ;  then
                            sudo rm $2/logs/error_nginx.log
                    fi

                    sudo systemctl reload nginx
                    sudo systemctl reload apache2

                    sudo rm -Rfv $2
                    echo "Удаление домена $1 и пользователя $3 завершено"
                    $MENU/menu_site.sh
                    exit 0
            else
            #Подтверждение на удаление пользователя и каталога не получено
                echo "Удаление отменено"
                $MENU/menu_site.sh
                exit 0
            fi
    fi


else
    clear
    echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: домен, путь к каталогу, имя пользователя."
    echo "Например domain.ru /home/webusers/lamer/domain.ru user"
    echo "Список доменов на сервере пользователя $USER:"
    ls $HOMEPATHWEBUSERS/$USER
    echo -n "Для запуска основного меню напишите \"y\", для выхода - любой другой символ: "
    read item
    case "$item" in
        y|Y) echo "Ввели «y», продолжаем..."
            $MYFOLDER/scripts/menu
            ;;
        *) echo "Выход..."
            exit 0
            ;;
    esac
fi
