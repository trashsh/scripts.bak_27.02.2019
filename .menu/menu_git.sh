#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Управление Git===${COLOR_NC}"

echo '1: Push remote'
echo '2: Git remote view'
echo '3: Git commit'

echo '0: Назад'
echo '/: Выход'
echo ''
echo -n 'Выберите пункт меню:'
read item
case "$item" in
        1) $SCRIPTS/git/git_remote_push.sh $1
            ;;
        2) $SCRIPTS/git/git_remote_view.sh $1
            ;;
		3) $SCRIPTS/git/git_commit.sh $1
            ;;
        0)  echo ''
            $MYFOLDER/scripts/menu $1
            ;;
        /) echo "Выход..."
            exit 0
            ;;
esac