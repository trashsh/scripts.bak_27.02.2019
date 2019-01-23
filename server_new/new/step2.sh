sed -i '$ a \\nBanner /etc/banner'  /etc/ssh/sshd_config
cp $TEMPLATES/ssh/banner/banner /etc/banner
chown root:root /etc/banner
chmod 644 /etc/banner

echo "ssh settings"
sed -i -e "s/PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i -e "s/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/" /etc/ssh/sshd_config
sed -i -e "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/" /etc/ssh/sshd_config
sed -i -e "s/#AuthorizedKeysFile/AuthorizedKeysFile/" /etc/ssh/sshd_config
sed -i '$ a \\nAllowGroups ssh-access'  /etc/ssh/sshd_config


groupadd ssh-access
usermod -G ssh-access -a root
usermod -G ssh-access -a $USERLAMER