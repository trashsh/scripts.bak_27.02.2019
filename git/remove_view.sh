#!/bin/bash
#просмотр удаленных репозиториев
#$1-$USERNAME process
source /etc/profile
source ~/.bashrc

cd $SCRIPTS
echo -e "\n${COLOR_YELLOW}Список удаленных репозиториев:${COLOR_NC}"
git remote -v
echo ""
$MENU/git.sh $1