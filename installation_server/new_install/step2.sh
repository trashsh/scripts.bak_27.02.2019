#fix phpmyadmin error
sudo sed -i "s/|\s*\((count(\$analyzed_sql_results\['select_expr'\]\)/| (\1)/g" /usr/share/phpmyadmin/libraries/sql.lib.php


sed -i '$ a source $SCRIPTS/functions/file_params_not_found.sh'  /root/.bashrc
sed -i '$ a source $SCRIPTS/external_scripts/dev-shell-essentials-master/dev-shell-essentials.sh'  root/.bashrc
source ~/.bashrc
source /etc/profile