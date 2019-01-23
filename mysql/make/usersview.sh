#!/bin/bash
source /etc/profile
source ~/.bashrc

echo -e "${COLOR_YELLOW}Перечень пользователей mysql ${COLOR_NC}"
mysql -e "SELECT User,Host FROM mysql.user;"

