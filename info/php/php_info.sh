#!/bin/bash
source /etc/profile
source ~/.bashrc
#Вывод информации php

declare -x -f viewPHPVersion

#отобразить версию php
viewPHPVersion(){
	echo ""
	echo "Версия PHP:"
	php -v
	echo ""
}

