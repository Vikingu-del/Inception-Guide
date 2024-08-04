# Guide how to set Wordpress Docker Container

## Table Of Contents
- [What Is Wordpress](#what-is-wordpress)
- [Wordpress Dockerfile](#wordpress-dockerfile)
- [Wordpress Entrypoint Script](#wordpress-entrypoint-script)
- [Setting Up Other Containers](#setting-up-other-containers)

---

## What Is Wordpress

1. Introduction
In the realm of content management systems (CMS), WordPress stands out as a dominant force, powering over 40% of the web. This article delves into what WordPress is, its core features, and why it has become the go-to choice for millions of websites. </br></br>
What is WordPress?
WordPress is an open-source content management system (CMS) designed for creating, managing, and publishing digital content. Originally launched in 2003 as a blogging platform, WordPress has evolved into a versatile CMS that supports a wide range of websites, from personal blogs to complex e-commerce sites.

2. Core Features
    - Ease of Use
    One of WordPress’s most praised features is its user-friendly interface. With a simple and intuitive dashboard, users can easily create and manage content without needing extensive technical knowledge. The platform supports a visual editor and a block-based editor (Gutenberg), making content creation and editing straightforward.

    - Customizable Themes
    WordPress offers a vast repository of themes that allow users to change the appearance of their site without altering the underlying code. These themes are designed to be customizable, enabling users to modify layouts, colors, fonts, and more to match their branding and style.

    - Plugins
    Plugins are an integral part of WordPress, extending its functionality and allowing users to add features such as SEO optimization, social media integration, and e-commerce capabilities. With thousands of free and premium plugins available, users can tailor their WordPress sites to meet specific needs.

    - Flexibility and Scalability
    WordPress is highly flexible, accommodating a range of website types from blogs and portfolios to business sites and online stores. It supports a range of custom post types and taxonomies, and its scalability ensures that it can grow with your website, handling everything from small personal sites to large enterprise-level applications.

    - Community and Support
    As an open-source platform, WordPress benefits from a vibrant community of developers, designers, and enthusiasts. This community contributes to a vast repository of documentation, forums, and tutorials, making it easier for users to find solutions to common issues and to receive support.

    - Search Engine Optimization (SEO)
    WordPress is built with SEO in mind, offering various features and plugins to enhance search engine visibility. From SEO-friendly permalinks to XML sitemaps and meta tags, WordPress provides the tools needed to optimize content for search engines.

    - Security
    Security is a critical concern for any website, and WordPress takes it seriously. The platform regularly releases updates to address vulnerabilities, and a range of security plugins can help protect against threats such as malware and unauthorized access. It’s also essential for users to implement best practices such as using strong passwords and keeping themes and plugins updated.

3. How WordPress Works
At its core, WordPress is built on PHP and MySQL. It operates on a web server and interacts with a MySQL database to manage and retrieve content. When a user visits a WordPress site, the server processes the request, retrieves data from the database, and uses PHP to generate the HTML content displayed in the user’s browser.

4. WordPress.org vs. WordPress.com
WordPress.org is the self-hosted version of WordPress. Users download the WordPress software and install it on their own web hosting server. This option provides greater control and flexibility, allowing users to customize their site fully and install any plugins or themes they choose.
WordPress.com is a hosted service that offers a simpler setup with less customization compared to the self-hosted version. It is managed by Automattic, the company behind WordPress.com, and includes options for free and paid plans with varying levels of features and support.

5. Conclusion
WordPress has transformed from a simple blogging tool into a powerful and flexible CMS, used by millions of websites worldwide. Its ease of use, extensive customization options, and robust community support make it an ideal choice for both beginners and experienced web developers. Whether you’re building a personal blog or a sophisticated e-commerce platform, WordPress provides the tools and resources needed to create and manage a successful website.

---

## Wordpress Dockerfile

Navigate to the directory where Nginx's Dockerfile is located and open it with vim:

```bash
vim ~/Inception/srcs/requirements/wordpress/Dockerfile
```

And write the following content inside it:

```dockerfile
FROM alpine:3.19.2

RUN apk update && apk add bash curl mariadb-client icu-data-full ghostscript \
        imagemagick openssl php82 php82-fpm php82-phar php82-json php82-mysqli \
        php82-curl php82-dom php82-exif php82-fileinfo php82-pecl-igbinary \
        php82-pecl-imagick php82-intl php82-mbstring php82-openssl \
        php82-xml php82-zip php82-iconv php82-shmop php82-simplexml php82-sodium \
        php82-xmlreader php82-zlib php82-tokenizer
RUN cd /usr/local/bin && \
    curl -o wp -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp
COPY tools/wordpress-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/wordpress-entrypoint.sh

ENTRYPOINT [ "wordpress-entrypoint.sh" ]
```

Explanation for each line:

1. Specify the Base Image

```dockerfile
FROM alpine:3.19.2
```

 This line specifies the base image for your Docker container. alpine:3.19.2 refers to Alpine Linux version 3.19.2, a lightweight and efficient Linux distribution known for its minimal size. Using a specific version ensures that your container environment remains consistent.

2. Install Dependencies

```dockerfile
RUN apk update && apk add bash curl mariadb-client icu-data-full ghostscript \
        imagemagick openssl php82 php82-fpm php82-phar php82-json php82-mysqli \
        php82-curl php82-dom php82-exif php82-fileinfo php82-pecl-igbinary \
        php82-pecl-imagick php82-intl php82-mbstring php82-openssl \
        php82-xml php82-zip php82-iconv php82-shmop php82-simplexml php82-sodium \
        php82-xmlreader php82-zlib php82-tokenizer
```

This `RUN` command updates the Alpine package index (apk update) and installs a comprehensive set of packages needed for running WordPress:

- `bash`: A Unix shell and command language.
- `curl`: A tool to transfer data from or to a server.
- `mariadb-client`:  A client for interacting with MariaDB databases.
- `icu-data-full`: International Components for Unicode (ICU) data for handling internationalization.
- `ghostscript` and `imagemagick`:  Tools for processing and converting image formats.
- `openssl`: A toolkit for SSL/TLS and general cryptography.
- `php82` and related extensions: Provide PHP version 8.2 and its various modules, essential for running WordPress and interacting with databases, files, and more.

3.  Install WP-CLI

```dockerfile
RUN cd /usr/local/bin && \
    curl -o wp -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp
```

This `RUN` command performs the following actions:

- `cd /usr/local/bin`: Changes the working directory to `/usr/local/bin`, a standard location for executable binaries.
- `curl -o wp -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar`: Downloads the WP-CLI (WordPress Command Line Interface) tool from the official source. WP-CLI is a command-line tool for managing WordPress installations.
- `chmod +x wp`: Makes the wp file executable.

4. Copy and Set Up the Entry Point Script

```dockerfile
COPY tools/wordpress-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wordpress-entrypoint.sh
```

- `COPY tools/wordpress-entrypoint.sh /usr/local/bin/`: Copies the `wordpress-entrypoint.sh` script from the host machine into the container's `/usr/local/bin/ directory`. This script will be used to initialize and start WordPress.
- `RUN chmod +x /usr/local/bin/wordpress-entrypoint.sh`: Sets executable permissions on the `wordpress-entrypoint.sh script`, ensuring it can be run when the container starts.

5. Set the Entry Point

```dockerfile
ENTRYPOINT [ "nginx-entrypoint.sh" ]
```

The `ENTRYPOINT` directive specifies the script (`wordpress-entrypoint.sh`) that should be executed when the container starts. This script typically includes initialization tasks, such as configuring the WordPress environment, setting up the database connection, and starting the PHP-FPM server.

### Summary:
This Dockerfile sets up an Alpine Linux-based container for running WordPress with the following features:
- Installs a range of dependencies required for WordPress and PHP functionality.
- Downloads and installs WP-CLI for managing WordPress from the command line.
- Copies and sets up an entry point script to handle container initialization.
- Defines the entry point to ensure the WordPress environment is correctly initialized and started.
This setup ensures that your WordPress instance is prepared and ready to serve content efficiently in a containerized environment. Adjustments might be needed based on specific use cases or additional configurations.

---

## Wordpress Entrypoint Script

To configure Wordpress as a Docker container, navigate and open with vim nginx-entrypoint.sh:

    vim ~/Inception/srcs/requirements/wordpress/tools/wordpress-entrypoint.sh

And you can use the following entrypoint script to write it inside:

```bash
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
```

**Explanation:** 

- `#!/bin/bash`: This shebang indicates that the script should be run using the Bash shell.
- `set -e` : This option ensures that the script exits immediately if any command exits with a non-zero status. This helps in preventing the script from continuing when an error occurs, which is useful for debugging and ensuring script reliability.
- `cd /var/www/html`: This command changes the working directory to /var/www/html, which is the typical directory where WordPress files are stored in the container. All subsequent commands will operate in this directory.

---

Configure PHP-FPM on the First Run:
```bash
    if [ ! -e /etc/.firstrun ]; then
        sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf
        touch /etc/.firstrun
    fi
```
**Explanation:**
- `if [ ! -e /etc/.firstrun ]; then`: Checks if the file `/etc/.firstrun` does not exist. This file serves as a flag to indicate whether this is the first run of the container.
- `sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php82/php-fpm.d/www.conf`: Uses `sed` to update the PHP-FPM configuration file (`www.conf`). It changes the listen directive from `127.0.0.1:9000` (which binds PHP-FPM to localhost) to `9000` (which allows connections from other containers).
- `touch /etc/.firstrun`: Creates the `/etc/.firstrun` file to mark that the initial configuration has been done. This prevents the PHP-FPM configuration step from being run again.

---

Download and Configure WordPress on the First Volume Mount

```bash
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
```
- `if [ ! -e .firstmount ]; then`: Checks if the file `.firstmount` does not exist. This file is used to determine if this is the first time the volume has been mounted.
- `mariadb-admin ping --protocol=tcp --host=mariadb -u "$MYSQL_USER" --password="$MYSQL_PASSWORD" --wait >/dev/null 2>/dev/null`: Waits for the MariaDB service to be ready by continuously pinging it. The `>/dev/null 2>/dev/null` part suppresses output and errors.
- `if [ ! -f wp-config.php ]; then`: Checks if WordPress is already configured by looking for the `wp-config.php` file.
- `wp core download --allow-root || true`: Downloads the latest WordPress core files. The `|| true` ensures that the script continues even if the download fails (e.g., if WordPress is already downloaded).
- `wp config create --allow-root ...`: Creates a `wp-config.php` file with database connection details and other configurations.
- `wp config set ...`: Sets additional configurations for WordPress, such as Redis caching settings and filesystem method. (YOU CAN REMOVE LINES WITH WP CONFIG SET IF YOU ARE NOT DOING REDIS CACHE WHICH IS A SERVICE REQUIRED IN THE BONUS)
- `wp core install --allow-root ...`: Installs WordPress and sets up the site with the provided parameters.
- `if ! wp user get "$WORDPRESS_USER" --allow-root > /dev/null 2>&1; then ...`: Checks if a specific WordPress user exists and creates it if it does not.
- `chmod o+w -R /var/www/html/wp-content`: Ensures that the wp-content directory is writable by all users. This is often necessary for WordPress to manage uploads and plugins.
- `touch .firstmount`: Creates the `.firstmount` file to mark that the volume has been mounted and the WordPress installation has been handled.
- `exec /usr/sbin/php-fpm82 -F`: Starts the PHP-FPM service in the foreground (-F). The `exec` command replaces the current shell process with the `php-fpm82` process, which is the main process of the container. This ensures that the PHP-FPM service is the primary process running and will handle incoming PHP requests.
- `Environment variables` used in this script are explained at Mariadb Article and they are inside .env file
---

## Setting Up Other Containers
Check the other links below for setting up the other services

1. Mandatory
    - [Setting up the system and the virtual machine](README.md#table-of-contents)
    - [Mariadb container set up](Mariadb.md#table-of-contents)
    - [Nginx container set up](Nginx.md#table-of-contents)
    - [Wordpress container set up](Wordpress.md#table-of-contents)
2. Bonus
    - [Redis](Redis.md#table-of-contents)
    - [Ftp](Ftp.md#table-of-contents)
    - [Adminer](Adminer.md#table-of-contents)
    - [Portainer](Portainer.md#table-of-contents)
    - [Static Site](Static-Site.md#table-of-contents)
3. DockerCompose and Makefile
    - [Running our Docker Network](Compilation.md#table-of-contents)
4. Project Subject
    - [Inceptrion's Subject](Inception.pdf)