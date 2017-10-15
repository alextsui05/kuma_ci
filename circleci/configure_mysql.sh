#!/bin/bash
tee -a /etc/mysql/my.cnf << EOF
[mysqld]
innodb_ft_min_token_size = 2
EOF
service mysql restart
