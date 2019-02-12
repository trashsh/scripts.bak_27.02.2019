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
dbCreateUser ${test}_user ${test}_user 1
echo -e "${COLOR_YELLOW}user: ${COLOR_YELLOW}${test}_user ;${COLOR_YELLOW}pass: ${COLOR_YELLOW}${test}_user ,${COLOR_YELLOW}type: ${COLOR_YELLOW}user${COLOR_NC}"
dbCreateUser ${test}_adm ${test}_adm 2
echo -e "${COLOR_YELLOW}user: ${COLOR_YELLOW}${test}_adm ;${COLOR_YELLOW}pass: ${COLOR_YELLOW}${test}_amd ,${COLOR_YELLOW}type: ${COLOR_YELLOW}admin${COLOR_NC}"
dbCreateUser ${test}_admgrant ${test}_admgrant 3
echo -e "${COLOR_YELLOW}user: ${COLOR_YELLOW}${test}_admgrant ;${COLOR_YELLOW}pass: ${COLOR_YELLOW}${test}_admgrant ,${COLOR_YELLOW}type: ${COLOR_YELLOW}admin with grant${COLOR_NC}"


read -p "Нажмите Enter Для продолжения. Для выхода - Ctrl+C"
