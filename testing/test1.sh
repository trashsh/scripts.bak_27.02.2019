#!/usr/bin/env bash

FileParamsNotFound(){
echo -n -e "${COLOR_YELLOW}$2 ${COLOR_BLUE}\"y\"${COLOR_YELLOW}, для выхода введите ${COLOR_BLUE}\"n\"${COLOR_NC}:"
	while read
		do
			echo -n ": "
			case "$REPLY" in
			y|Y) echo "$2"
				$3 $1;
					break;;
			n|N)  break;;
			esac
		done

}