#!/bin/bash
set -e

# Check if it's the first run to configure MySQL
if [ ! -e /etc/firstrun ]; then
    cat << EOF | sudo tee -a /etc/my.conf.d/mariadb-server.cnf
[mysqld]
bind-address=0.0.0.0
skip-networking=0
EOF
    sudo touch /etc/.firstrun fi
# Initialize MySQL data directory if it's not initialized
if [ ! -e /var/lib/mysql/.firstmount ]; then
    sudo mysql_install_db --datadir=/var/lib/mysql --skip-test-db --user=mysql --group=mysql --auth-root-authentication-method=socket >/dev/null>/dev/null
    # Start MySQL server to perform initial setup
    sudo mysqld_safe --skip-networking --skip-grant-tables &
    mysql_pid=$!
    # Wait for MySQL to start
    sleep 5
    # Run MySQL commands to create database and user
    cat << EOF | mysql --protocol=socket -u root
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF
    # Shutdown MySQL server after setup
    sudo mysqladmin shutdown
    # Mark first mount complete
    sudo touch /var/lib/mysql/.firstmount
fi
# Start MySQL server normally
exec mysqld_safe --skip-networking
