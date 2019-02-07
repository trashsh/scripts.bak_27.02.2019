#!/bin/bash
source /etc/profile
source ~/.bashrc
source /my/scripts/info/mysql/mysql_info.sh
source /my/scripts/info/php/php_info.sh
source /my/scripts/info/site_info/site_info.sh
source /my/scripts/info/users_info/users_info.sh
source /my/scripts/info/backups_info/backups_info.sh

name=$1

viewGroupFtpAccessAll					#Вывод всех пользователей группы ftp-access
viewGroupFtpAccessByName $name			#Вывод всех пользователей группы ftp-access с указанием части имени пользователя ($1-user)
viewGroupSshAccessAll					#Вывод всех пользователей группы ssh-access
viewGroupSshAccessByName $name			#Вывод всех пользователей группы ssh-access с указанием части имени пользователя ($1-user)
viewGroupUsersAccessAll					#Вывод всех пользователей группы users
viewGroupUsersAccessByName $name		#Вывод всех пользователей группы users с указанием части имени пользователя ($1-user)
viewGroupAdminAccessAll					#Вывод всех пользователей группы admin-access
viewGroupAdminAccessByName $name		#Вывод всех пользователей группы admin-access с указанием части имени пользователя ($1-user)
viewGroupSudoAccessAll					#Вывод всех пользователей группы sudo
viewGroupSudoAccessByName $name			#Вывод пользователей группы sudo с указанием части имени пользователя ($1-user)
viewUserInGroupByName $name				#Вывод групп, в которых состоит указанный пользователь ($1-user)		

viewMysqlDb_all 			#отобразить список всех баз данных mysql
viewMysqlDbByUser  $name		#отобразить список всех баз данных, владельцем которой является пользователь mysql $1_*		 	($1-user)
viewMysqlDbByName 	 $name	#отобразить список всех баз данных mysql с названием, содержащим переменную $1		 			($1-user)
viewMysqlUsers			#отобразить список всех пользователей баз данных mysql
viewMysqlUsersByName $name		#отобразить список всех пользователей баз данных mysql, содержащих в названии переменную $1		($1-user)
#viewMysqlAllInfo			#отобразить всю информацию по mysql-базам

viewFtpAccess	$name			#отобразить реквизиты доступа к серверу FTP ($1-user)
viewSshAccess	$name			#отобразить реквизиты доступа к серверу SSH  ($1-user)
viewMysqlAccess	$name		#отобразить реквизиты доступа к серверу MYSQL  ($1-user)
viewSiteConfigsByName	$name	#Вывод перечня сайтов указанного пользователя (конфиги веб-сервера)  ($1-user)
viewSiteFoldersByName	$name	#Вывод перечня сайтов указанного пользователя  ($1-user)

viewPHPVersion

viewBackupsToday 
viewBackupsYestoday
viewBackupsWeek
viewBackupsRange
viewBackupsRangeInput