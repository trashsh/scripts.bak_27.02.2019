#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/archive.sh

clear

echo -e "${COLOR_GREEN}####################"$LINE"####################"


dbViewAllUsers


echo -e "${COLOR_YELLOW}"Введите пользователя:" $COLOR_NC"
read -p "BASE: " VAR1


dbDropUser $VAR1 drop
dbViewAllUsers




read -p "Нажмите Enter Для продолжения. Для выхода - Ctrl+C"
