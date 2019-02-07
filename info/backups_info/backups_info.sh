#!/bin/bash
source /etc/profile
source ~/.bashrc
#Вывод информации о бэкапах

declare -x -f viewBackupsToday 
declare -x -f viewBackupsYestoday
declare -x -f viewBackupsWeek
declare -x -f viewBackupsRange
declare -x -f viewBackupsRangeInput

viewBackupsToday(){
	echo ""
	DATE=$(date +%Y%m%d)
	if [ -d "$BACKUPFOLDER_DAYS"/"$DATE"/"mysql" ] ; then
		echo -e "${COLOR_YELLOW}"Список бэкапов за сегодня - $DATE" ${COLOR_NC}"
		echo -e "${COLOR_BROWN}"$BACKUPFOLDER_DAYS/$DATE/mysql:" ${COLOR_NC}"
		ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
	else
		echo -e "${COLOR_RED}Бэкапы mysql за $(date --date today "+%Y.%m.%d") отсутствуют${COLOR_NC}"
	fi	

}

viewBackupsYestoday(){
	echo ""
	DATE=$(date --date yesterday "+%Y%m%d")
	 if [ -d "$BACKUPFOLDER_DAYS"/"$DATE"/"mysql" ] ; then
		echo -e "${COLOR_YELLOW}"Список бэкапов за сегодня - $DATE" ${COLOR_NC}"
		echo -e "${COLOR_BROWN}"$BACKUPFOLDER_DAYS/$DATE/mysql:" ${COLOR_NC}"
		ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
	else
		echo -e "${COLOR_RED}Бэкапы mysql за $(date --date yesterday "+%Y.%m.%d") отсутствуют${COLOR_NC}"
	fi
}


viewBackupsWeek(){
	echo ""
	TODAY=$(date +%Y%m%d)
	DATE=$(date --date='7 days ago' "+%Y%m%d")
	echo -e "$COLOR_YELLOW"Список бэкапов за Неделю - $DATE-$TODAY" $COLOR_NC"

	for ((i=0; i<7; i++)) 
	do 
		DATE=$(date --date=''$i' days ago' "+%Y%m%d");
		if [ -d "$BACKUPFOLDER_DAYS"/"$DATE" ] ; then
			echo -e "$COLOR_BROWN"$DATE:" $COLOR_NC"
			ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
		fi
	done	
}

viewBackupsRange(){
echo ''
echo -e -n "$COLOR_BLUE"Укажите дату в формате yyyymmdd:" $COLOR_NC"
read DATE
 if [ -d "$BACKUPFOLDER_DAYS"/"$DATE"/"mysql" ] ; then
    echo -e "$COLOR_YELLOW"Список бэкапов $(date --date $DATE "+%Y.%m.%d")" $COLOR_NC"
	echo -e "$COLOR_BROWN"$DATE - Базы данных mysql:" $COLOR_NC"
	ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
 else
	echo -e "$COLOR_REDБэкапы mysql за $(date --date $DATE "+%Y.%m.%d") отсутствуют$COLOR_NC"
 fi
}

viewBackupsRangeInput(){
echo ''
echo -e -n "$COLOR_BLUE"Укажите первую дату диапазона в формате yyyymmdd:" $COLOR_NC"
read DATE1
echo -e -n "$COLOR_BLUE"Укажите последнюю дату диапазона в формате yyyymmdd:" $COLOR_NC"
read DATE2
echo -e "$COLOR_YELLOW"Список бэкапов $(date --date $DATE1 "+%Y.%m.%d") - $(date --date $DATE2 "+%Y.%m.%d")" $COLOR_NC"

start_ts=$(date -d "$DATE1" '+%s')
end_ts=$(date -d "$DATE2" '+%s')
range=$(( ( end_ts - start_ts )/(60*60*24) ))
echo -e "$COLOR_BROWN" Базы данных mysql:" $COLOR_NC"
n=0
for ((i=0; i<${range#-}+1; i++)) 
do 
	DATE=$(date --date=''$i' days ago' "+%Y%m%d");
	if [ -d "$BACKUPFOLDER_DAYS"/"$DATE" ] ; then
		echo -e "$COLOR_BROWN"$DATE:" $COLOR_NC"
		ls -l $BACKUPFOLDER_DAYS/$DATE/mysql
		n=$(($n+1))
	fi

done
echo $n	
}
