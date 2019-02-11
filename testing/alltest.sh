#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/archive.sh

clear
clear

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewUserInfo${COLOR_NC} ${COLOR_YELLOW}(#1-USER)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewUserInfo $1
echo -e "${COLOR_LIGHT_RED}==========================================${COLOR_NC}"

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewAllUsers${COLOR_NC} ${COLOR_YELLOW}(#без параметров)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewAllUsers
echo -e "${COLOR_LIGHT_RED}==========================================${COLOR_NC}"


echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewAllUsersByContainName${COLOR_NC} ${COLOR_YELLOW}(#1-USER)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewAllUsersByContainName $1
echo -e "${COLOR_LIGHT_RED}==========================================${COLOR_NC}"

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewBasesByTextContain${COLOR_NC} ${COLOR_YELLOW}(#1-часть имени базы)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewBasesByTextContain $1
echo -e "${COLOR_LIGHT_RED}==========================================${COLOR_NC}"

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewBasesByUsername${COLOR_NC} ${COLOR_YELLOW}(#1-USER)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewBasesByUsername $1
echo -e "${COLOR_LIGHT_RED}==========================================${COLOR_NC}"

echo -e "${COLOR_LIGHT_RED}=========${COLOR_GREEN}dbViewAllBases${COLOR_NC} ${COLOR_YELLOW}(#без параметров)${COLOR_NC}${COLOR_LIGHT_RED}===========${COLOR_NC}"
dbViewAllBases
echo -e "${COLOR_LIGHT_RED}==========================================${COLOR_NC}"
