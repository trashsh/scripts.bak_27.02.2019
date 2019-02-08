#!/bin/bash
source /etc/profile
source ~/.bashrc
source $SCRIPTS/functions/archive.sh

tar_folder_structure "/my/1/" "/my/back1/2.tar.gz"
echo "12323"