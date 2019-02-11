#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Тестирование===${COLOR_NC}"

echo '1: Общий тест'

echo '0: Назад'
echo 'q: Выход'
echo ''
echo -n 'Выберите пункт меню:'

while read
    do
        case "$REPLY" in
        "1")  sudo /my/scripts/testing/alltest.sh $1; break;;

		"0")  $MYFOLDER/scripts/menu $1;  break;;
        "q"|"Q")  exit 0;; 
         *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2;;
        esac
    done

exit 0