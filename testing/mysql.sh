#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/archive.sh

clear

echo -e "${COLOR_GREEN}####################"$LINE"####################"

echo -e "${COLOR_YELLOW}"Введите значение переменной тестовой переменной:" $COLOR_NC"
read -p "test: " test

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewUserInfo${COLOR_NC} ${COLOR_YELLOW}(#1-USER)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewUserInfo $test
echo -e "${COLOR_LIGHT_RED}${COLOR_NC}"

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewAllUsers${COLOR_NC} ${COLOR_YELLOW}(#без параметров)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewAllUsers
echo -e "${COLOR_LIGHT_RED}${COLOR_NC}"


echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewAllUsersByContainName${COLOR_NC} ${COLOR_YELLOW}(#1-USER)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewAllUsersByContainName $test
echo -e "${COLOR_LIGHT_RED}${COLOR_NC}"

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewBasesByTextContain${COLOR_NC} ${COLOR_YELLOW}(#1-часть имени базы)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewBasesByTextContain $test
echo -e "${COLOR_LIGHT_RED}${COLOR_NC}"

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewBasesByUsername${COLOR_NC} ${COLOR_YELLOW}(#1-USER)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewBasesByUsername $test
echo -e "${COLOR_LIGHT_RED}${COLOR_NC}"

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewAllBases${COLOR_NC} ${COLOR_YELLOW}(#без параметров)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewAllBases
echo -e "${COLOR_LIGHT_RED}${COLOR_NC}"



read -p "Нажмите Enter Для продолжения. Для выхода - Ctrl+C"
$0