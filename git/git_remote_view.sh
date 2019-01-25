#!/bin/bash
#просмотр удаленных репозиториев
#$1-$USERNAME
source /etc/profile
source ~/.bashrc

echo -e "\n ${COLOR_YELLOW} Список удаленных репозиториев:${COLOR_NC}"
git remote -v
echo ""
$MENU/menu_git.sh $1