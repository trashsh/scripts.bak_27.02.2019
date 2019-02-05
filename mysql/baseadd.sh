#!/bin/bash
source /etc/profile
source ~/.bashrc

cat << EOF | mysql mydatabase
CREATE DATABASE $1;
EOF

