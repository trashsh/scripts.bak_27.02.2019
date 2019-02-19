#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/archive.sh

clear

echo -e "${COLOR_GREEN}####################"$LINE"####################${COLOR_NC}"
dbViewAllBases

echo -e "${COLOR_YELLOW}"Введите название базы данных:" $COLOR_NC"
read -p "BASE: " BASE

dbShowTables $BASE