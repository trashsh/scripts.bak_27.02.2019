#!/bin/bash

declare -x -f functionName #Описание функции: ($1-Описание первого параметра ; $2-второго ; $3-третьго ; $4-четвертого ; $5-пятого ;)

#
#Описание функции
#$1-Описание первого параметра ; $2-второго ; $3-третьго ; $4-четвертого ; $5-пятого ;
functionName() {
    #Проверка существования каталога "/my/scritps"
    if [ -d /my/scritps ] ; then
        #Каталог "/my/scritps" существует
        #Проверка существования файла "/etc/profile"
        if [ -f /etc/profile ] ; then
            #Файл "/etc/profile" существует

            #Файл "/etc/profile" существует (конец)
        else
            #Файл "/etc/profile" не существует
            echo -e "${COLOR_RED}Файл ${COLOR_GREEN}\"/etc/profile\"${COLOR_RED}не существует${COLOR_NC}"
            #Файл "/etc/profile" не существует (конец)
        fi
        #Конец проверки существования файла "/etc/profile"

        #Каталог "/my/scritps" существует (конец)
    else
        #Каталог "/my/scritps" не существует

        #Каталог "/my/scritps" не существует (конец)
    fi
    #Конец проверки существования каталога "/my/scritps"

}