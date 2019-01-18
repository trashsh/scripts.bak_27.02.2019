#!/bin/bash
#просмотр удаленных репозиториев
source /etc/profile
source ~/.bashrc

clear
echo -e "\n ${COLOR_YELLOW} Список удаленных репозиториев:${COLOR_NC}"
git remote -v
echo ""
$SCRIPTS/.menu/menu_git.sh
