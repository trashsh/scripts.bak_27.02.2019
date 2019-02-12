#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/archive.sh

clear

echo -e "${COLOR_GREEN}####################"$LINE"####################"

echo -e "${COLOR_YELLOW}"Введите каталог выгрузки бэкапов:" $COLOR_NC"
read -p "path: " path

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbBackupBases${COLOR_NC} ${COLOR_YELLOW}(#1-PATH)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbBackupBases $path
echo -e "${COLOR_LIGHT_RED}${COLOR_NC}"







read -p "Нажмите Enter Для продолжения. Для выхода - Ctrl+C"
$0