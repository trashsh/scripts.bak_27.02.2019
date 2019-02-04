#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Просмотр списка пользователей/групп===${COLOR_NC}"

echo "1: Члены группы \"Users\""
echo "2: Члены группы \"sudo\""
echo "3: Члены группы \"ssh-access\""
echo "4: Список групп конкретного пользователя"
echo "0: Назад"
echo "q: Выход"
echo ""
echo -n 'Выберите пункт меню:'

while read
    do
        case "$REPLY" in
        "1")  $SCRIPTS/users/make/usersview/users.sh $1;;
		"2")  $SCRIPTS/users/make/usersview/sudo.sh $1;;
		"3")  $SCRIPTS/users/make/usersview/ssh-access.sh $1;;
		"4")  $SCRIPTS/users/make/usersview/useringroup.sh $1;;
		"0")  $SCRIPTS/.menu/user.sh $1;  break;;
        "q"|"Q")  break 2;; 
         *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2;;
        esac
    done
