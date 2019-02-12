#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/archive.sh

clear

echo -e "${COLOR_GREEN}####################"$LINE"####################"

dbViewAllBases
echo -e "${COLOR_YELLOW}"Введите название базы данных:" $COLOR_NC"
read -p "BASE: " BASE
echo -e "${COLOR_YELLOW}"Введите CHARACTERSET:" $COLOR_NC"
read -p "CHARACTERSET: " CHARACTERSET
echo -e "${COLOR_YELLOW}"Введите COLLATE:" $COLOR_NC"
read -p "COLLATE: " COLLATE

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbCreateBase${COLOR_NC} ${COLOR_YELLOW}(#$1-dbname, $2-CHARACTER SET (например utf8), $3-COLLATE (например utf8_general_ci))${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbCreateBase $BASE $CHARACTERSET $COLLATE
dbViewAllBases



read -p "Нажмите Enter Для продолжения. Для выхода - Ctrl+C"
