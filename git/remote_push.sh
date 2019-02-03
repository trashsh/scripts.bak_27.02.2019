#!/bin/bash
#просмотр удаленных репозиториев
#$1-$USERNAME
source /etc/profile
source ~/.bashrc

clear
echo -e "\n ${COLOR_YELLOW} Push to github.com & Bitbucket.org:${COLOR_NC}"
git remote -v
sudo git remote add github https://trashsh@github.com/trashsh/scripts.git
sudo git remote add bitbucket https://gothundead@bitbucket.org/gothundead/scripts.git
sudo git push github master
sudo git push bitbucket master
echo ""
$SCRIPTS/.menu/git.sh $1
