#!/bin/bash
source /etc/profile
source ~/.bashrc
echo ''
echo -e "${COLOR_GREEN} ===Просмотр списка бэкапов===${COLOR_NC}"

echo '1: Бэкапы за сегодняшний день'
echo '2: Бэкапы за вчерашний день'
echo '3: Бэкапы за последнюю неделю'
echo '4: Указать дату'
echo '5: Указать диапазон дат'


echo '0: Назад'
echo 'q: Выход'
echo ''
echo -n 'Выберите пункт меню:'

while read
    do
        case "$REPLY" in
        "1")  $SCRIPTS/system/backup/show/show_today.sh $1;;
        "2")  $SCRIPTS/system/backup/show/show_yestoday.sh $1;;
		"3")  $SCRIPTS/system/backup/show/show_week.sh $1;;
		"4")  $SCRIPTS/system/backup/show/show_range.sh $1;;
		"5")  $SCRIPTS/system/backup/show/show_range_input.sh $1;;
		"0")  $SCRIPTS/.menu/menu_backup.sh $1;  break;;
        "q"|"Q")  break 2;; 
         *) echo -n "Команда не распознана: ('$REPLY'). Повторите ввод:" >&2;;
        esac
    done
