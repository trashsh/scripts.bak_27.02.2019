#!/bin/bash
source /etc/profile
source ~/.bashrc

echo "Install nagios3"
sudo apt-get install nagios3 nagios-nrpe-plugin
echo "backup nagios"
sudo cp -R /etc/nagios3 $BACKUPFOLDER_EMPTY/
sudo cp -R /etc/nagios-plugins/ $BACKUPFOLDER_EMPTY/