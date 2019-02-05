#fix phpmyadmin error
sudo sed -i "s/|\s*\((count(\$analyzed_sql_results\['select_expr'\]\)/| (\1)/g" /usr/share/phpmyadmin/libraries/sql.lib.php

source $SCRIPTS/external_scripts/dev-shell-essentials-master/dev-shell-essentials.sh