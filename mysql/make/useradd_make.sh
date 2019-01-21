#!/bin/bash
#$1-user; $2-pass
source /etc/profile
source ~/.bashrc

mysql -e "CREATE USER '$1'@'localhost' IDENTIFIED BY '$2';"