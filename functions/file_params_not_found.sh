#!/bin/bash
#source /etc/profile
#source ~/.bashrc
#Вывод сообщения с предложением запуска указанного в параметре 3 меню

declare -x -f FileParamsNotFound

FileParamsNotFound(){
echo -n -e "${COLOR_YELLOW}$2 ${COLOR_BLUE}\"y\"${COLOR_YELLOW}, для выхода введите ${COLOR_BLUE}\"n\"${COLOR_NC}:"
	while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) echo "$3"
				$3 $1;
					break;;
			n|N)  break;;
			esac
		done
		
}
