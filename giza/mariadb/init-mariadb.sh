#!/bin/bash

mysql -uroot -p$MARIADB_ROOT_PASSWORD <<-EOF
    CREATE DATABASE IF NOT EXISTS giza;
    CREATE USER IF NOT EXISTS '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';
    GRANT ALL ON giza.* TO '$MARIADB_USER'@'%';
    FLUSH PRIVILEGES;
    
    CREATE DATABASE IF NOT EXISTS nextcloud;
    CREATE USER IF NOT EXISTS '$MARIADB_NEXTCLOUD_USER'@'%' IDENTIFIED BY '$MARIADB_NEXTCLOUD_PASSWORD';
    GRANT ALL ON nextcloud.* TO '$MARIADB_NEXTCLOUD_USER'@'%';
    FLUSH PRIVILEGES;
EOF
