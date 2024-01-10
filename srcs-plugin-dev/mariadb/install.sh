#!/bin/bash
WORDPRESS_DATABASE_NAME=wordpress
MARIADB_USER=user_mariadb
MARIADB_USER_PASSWORD=user_mariadb_password
MARIADB_ROOT_PASSWORD=rootPasswordThisIs

apt-get update && apt-get upgrade -y

# Install MariaDB
apt-get install -y mariadb-server mariadb-client

# Check if /run/mysqld directory exists, create if it doesn't
if [ ! -d /run/mysqld ]; then
    echo "Setting up MariaDB"
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
    chown -R mysql:mysql /var/lib/mysql

    # Initialize MariaDB database
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

    # Create initial SQL commands to secure MariaDB and set up Wordpress database
    cat << EOF > /tmp/init.sql
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';

CREATE DATABASE $WORDPRESS_DATABASE_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$MARIADB_USER'@'%' IDENTIFIED by '$MARIADB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON $WORDPRESS_DATABASE_NAME.* TO '$MARIADB_USER'@'%';
FLUSH PRIVILEGES;
EOF

    # Use the initial SQL file to set up the database
    mariadb --user=mysql --bootstrap < /tmp/init.sql
    rm /tmp/init.sql

    # Configure MariaDB to listen on all interfaces
    sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
    sed -i '/skip-networking/s/^#//g' /etc/mysql/mariadb.conf.d/50-server.cnf
fi

echo "MariaDB setup complete. Starting MariaDB server..."

# Start MariaDB server
systemctl start mariadb
systemctl enable mariadb

echo "MariaDB server started."

