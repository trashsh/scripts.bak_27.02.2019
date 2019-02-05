#!/bin/bash
#удаление сайта
source /etc/profile
source ~/.bashrc
#$1-$USERNAME process; $2 - домен ($2), $3 - путь к каталогу, $4 - имя пользователя

#проверка на наличие параметров запуска
if [ -n "$2" ] && [ -n "$3" ] && [ -n "$4" ]
then

user_domain=$4_$2

#проверка пользователя на существование
    grep "$4:" /etc/passwd >/dev/null
    if [ $? -ne 0 ]; then
         echo 'Пользователь не найден и не будет удален'
		echo -n -e "напишите \"${COLOR_BLUE}yes${COLOR_NC}\" для удаления домена ${COLOR_GREEN}$2${COLOR_NC}, каталога ${COLOR_GREEN}$3${COLOR_NC} БЕЗ пользователя ${COLOR_GREEN}$4${COLOR_NC} или любой символ для отмены : "
        #удаление каталога без существования пользователя
        read -p yesdeldomain
        #Получено подтверждение на удаление пользователя и каталога
            if [[ $yesdeldomain = "yes" ]]
                then
                #удаление файлов без пользователя
                    a2dissite $user_domain.conf

                    
                    if [ -f "$NGINXENABLED"/"$user_domain.conf" ] ; then
                           sudo rm "$NGINXENABLED"/"$user_domain.conf"
                    fi

                    
                    if [ -f "$NGINXAVAILABLE"/"$user_domain.conf" ] ; then
                            sudo rm "$NGINXAVAILABLE"/"$user_domain.conf"
                    fi

                    
                    if [ -f "$APACHEENABLED"/"$user_domain.conf" ] ; then
                            sudo rm "$APACHEENABLED"/"$user_domain.conf"
                    fi

                    
                    if [ -f "$APACHEAVAILABLE"/"$user_domain.conf" ] ; then
                            sudo rm "$APACHEAVAILABLE"/"$user_domain.conf"
                    fi

                    
                    if [ -f $3/logs/error_apache.log ] ;  then
                            sudo rm $3/logs/error_apache.log
                    fi

                    
                    if [ -f $3/logs/access_apache.log ] ;  then
                            sudo rm $3/logs/access_apache.log
                    fi

                    
                    if [ -f $3/logs/access_nginx.log ] ;  then
                            sudo rm $3/logs/access_nginx.log
                    fi

                    
                    if [ -f $3/logs/error_nginx.log ] ;  then
                            sudo rm $3/logs/error_nginx.log
                    fi

                    sudo systemctl reload nginx
                    sudo systemctl reload apache2

                    sudo rm -Rfv $3

                   echo "Удаление домена $2 завершено"
                   $MENU/site.sh $1

                   exit 0
            else
            #Подтверждение на удаление пользователя и каталога не получено
                echo "Удаление отменено"
                $MENU/site.sh $1
                exit 0
            fi


    $MENU/site.sh $1
    else
    #Пользователь существует
        echo -n -e "напишите "yes" для удаления домена $2, каталога $3 и пользователя $4_$2 или любой символ для отмены : " 
		read yesdeldomain
		
		
        #Получено подтверждение на удаление пользователя и каталога
            if [[ $yesdeldomain = "yes" ]]
                then
                    sudo userdel $4_$2
                    echo "Пользователь $user удален"

                    sudo a2dissite $user_domain.conf

                    
                    if [ -f "$NGINXENABLED"/"$user_domain.conf" ] ; then
                            sudo rm "$NGINXENABLED"/"$user_domain.conf"
                    fi

                    
                    if [ -f "$NGINXAVAILABLE"/"$user_domain.conf" ] ; then
                            sudo rm "$NGINXAVAILABLE"/"$user_domain.conf"
                    fi

                    
                    if [ -f "$APACHEENABLED"/"$user_domain.conf" ] ; then
                            sudo rm "$APACHEENABLED"/"$user_domain.conf"
                    fi

                    
                    if [ -f "$APACHEAVAILABLE"/"$user_domain.conf" ] ; then
                            sudo rm "$APACHEAVAILABLE"/"$user_domain.conf"
                    fi

                    
                    if [ -f $3/logs/error_apache.log ] ;  then
                            sudo rm $3/logs/error_apache.log
                    fi

                    
                    if [ -f $3/logs/access_apache.log ] ;  then
                            sudo rm $3/logs/access_apache.log
                    fi

                    
                    if [ -f $3/logs/access_nginx.log ] ;  then
                            rm $3/logs/access_nginx.log
                    fi

                    
                    if [ -f $3/logs/error_nginx.log ] ;  then
                            sudo rm $3/logs/error_nginx.log
                    fi

                    sudo systemctl reload nginx
                    sudo systemctl reload apache2

                    sudo rm -Rfv $3
                    echo "Удаление домена $2 и пользователя $4 завершено"
                    $MENU/site.sh $1
                    exit 0
            else
            #Подтверждение на удаление пользователя и каталога не получено
                echo "Удаление отменено"
                $MENU/site.sh $1
                exit 0
            fi
    fi


else
    clear
    echo "--------------------------------------"
    echo "Параметры запуска не найдены. Необходимы параметры: домен, путь к каталогу, имя пользователя."
    echo "Например domain.ru /home/webusers/lamer/domain.ru user"
    echo "Список доменов на сервере пользователя $1:"
    ls $HOMEPATHWEBUSERS/$1
    echo -n "Для запуска основного меню напишите \"y\", для выхода - любой другой символ: "
    read item
    case "$item" in
        y|Y) echo "Ввели «y», продолжаем..."
            $MYFOLDER/scripts/menu $1
            ;;
        *) echo "Выход..."
            exit 0
            ;;
    esac
fi
