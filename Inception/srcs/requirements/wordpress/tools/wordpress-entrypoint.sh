#!/bin/bash
set -e
cd /var/www/html

# Configure PHP-FPM on the first run
if [ ! -e /etc/.firstrun ]; then
    sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf
    touch /etc/.firstrun
fi

# On the first volume mount, download and configure WordPress
if [ ! -e .firstmount ]; then
    # Wait for MariaDB to be ready
    mariadb-admin ping --protocol=tcp --host=mariadb -u "$MYSQL_USER" --password="$MYSQL_PASSWORD" --wait >/dev/null 2>/dev/null

    # Check if WordPress is already installed
    if [ ! -f wp-config.php ]; then
        echo "Installing WordPress..."

        # Download and configure WordPress
        wp core download --allow-root || true
        wp config create --allow-root \
            --dbhost=mariadb \
            --dbuser="$MYSQL_USER" \
            --dbpass="$MYSQL_PASSWORD" \
            --dbname="$MYSQL_DATABASE"
        wp config set WP_REDIS_HOST redis
        wp config set WP_REDIS_PORT 6379 --raw
        wp config set WP_CACHE true --raw
        wp config set FS_METHOD direct
        wp core install --allow-root \
            --skip-email \
            --url="$DOMAIN_NAME" \
            --title="$WORDPRESS_TITLE" \
            --admin_user="$WORDPRESS_ADMIN_USER" \
            --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
            --admin_email="$WORDPRESS_ADMIN_EMAIL"

        # Create a regular user if it doesn't already exist
        if ! wp user get "$WORDPRESS_USER" --allow-root > /dev/null 2>&1; then
            wp user create "$WORDPRESS_USER" "$WORDPRESS_EMAIL" --role=author --user_pass="$WORDPRESS_PASSWORD" --allow-root
        fi
    else
        echo "WordPress is already installed."
    fi
    chmod o+w -R /var/www/html/wp-content
    touch .firstmount
fi

# Start PHP-FPM
exec /usr/sbin/php-fpm82 -F