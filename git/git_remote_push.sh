#!/bin/bash
#просмотр удаленных репозиториев
source /etc/profile
source ~/.bashrc

clear
echo -e "\n ${COLOR_YELLOW} Push to github.com & Bitbucket.org:${COLOR_NC}"
git remote -v
sudo git remote add origin https://trashsh@github.com/trashsh/myserv.git
sudo git remote add bitbucket https://gothundead@bitbucket.org/gothundead/myserv.git
sudo git push origin master
sudo git push bitbucket master
echo ""
$SCRIPTS/.menu/menu_git.sh
