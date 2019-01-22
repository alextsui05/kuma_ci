#!/bin/bash

# Start mysql
# mysqld_safe -D
/usr/sbin/mysqld --basedir=/usr --datadir=/var/lib/mysql --plugin-dir=/usr/lib/mysql/plugin --user=mysql -D --log-error=/var/log/mysql/error.log --pid-file=/var/run/mysqld/mysqld.pid --socket=/var/run/mysqld/mysqld.sock
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start mysql server: $status"
  exit $status
fi

sudo -E -u kuma /bin/bash
