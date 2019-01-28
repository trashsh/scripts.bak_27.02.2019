
echo "proftpd settings"
sed -i -e "s/# DefaultRoot/DefaultRoot/" /etc/proftpd/proftpd.conf
sed -i -e "s/Port\t\t\t\t21/Port\t\t\t\t10081/" /etc/proftpd/proftpd.conf
echo '/bin/false' >> /etc/shells
#AuthUserFile /etc/proftpd/ftpd.passwd
service proftpd restart


