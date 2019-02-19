#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/archive.sh

clear

echo -e "${COLOR_GREEN}####################"$LINE"####################"

echo -e "${COLOR_YELLOW}"Введите название базы данных:" $COLOR_NC"
read -p "BASE: " VAR1
echo -e "${COLOR_YELLOW}"Введите имя пользователя:" $COLOR_NC"
read -p "VAR2: " VAR2
echo -e "${COLOR_YELLOW}"Введите SERVER:" $COLOR_NC" 
read -p "VAR3: " VAR3
dbSetFullAccessToBase $VAR1 $VAR2 $VAR3




read -p "Нажмите Enter Для продолжения. Для выхода - Ctrl+C"
