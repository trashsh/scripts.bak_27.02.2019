#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/archive.sh
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/other.sh
source $SCRIPTS/functions/site.sh

source $SCRIPTS/functions/users.sh


#UserAddToGroupSudo $1
#UserShowGroup $1

fileExistWithInfo $1 $2