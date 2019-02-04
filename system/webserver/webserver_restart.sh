#!/bin/bash
source /etc/profile
source ~/.bashrc

sudo /etc/init.d/apache2 restart
sudo /etc/init.d/nginx restart