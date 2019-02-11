#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/archive.sh

dbCreateUser $1 $2 $3
