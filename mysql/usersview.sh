#!/bin/bash
source /etc/profile
source ~/.bashrc

echo -e "${COLOR_YELLOW}Перечень пользователей mysql ${COLOR_YELLOW}"
mysql -e "SELECT User,Host FROM mysql.user;"

			$MENU/menu_sql_users.sh



