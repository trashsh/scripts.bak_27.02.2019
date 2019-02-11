#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/mysql.sh
source $SCRIPTS/functions/archive.sh
source /my/scripts/functions/mysql.sh

dbBackupBasesOneUser $1 $2