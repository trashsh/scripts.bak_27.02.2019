#!/bin/bash
source $SCRIPTS/include/include.sh

#userAddSystem
#dbViewUserInfo $1 $2
#echo $?

#dbUseradd $1 $2 $3 $4 $5
viewUserInGroupUsersByPartName $1 $2
echo $?


