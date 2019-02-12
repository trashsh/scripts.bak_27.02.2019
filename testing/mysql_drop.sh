#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/archive.sh

clear

echo -e "${COLOR_GREEN}####################"$LINE"####################"

dbViewAllBases


echo -e "${COLOR_YELLOW}"Введите название базы данных переменной:" $COLOR_NC"
read -p "test: " var1

echo -e "${COLOR_YELLOW}Введите подтверждение (drop): $COLOR_NC"
read -p "test: " var2

dbDropBase $var1 $var2

dbViewAllBases