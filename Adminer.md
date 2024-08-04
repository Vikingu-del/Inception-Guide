# Guide how to set Adminer Docker Container

## Table Of Contents
- [What Is Adminer](#what-is-adminer)
- [Adminer Dockerfile](#adminer-dockerfile)
- [Setting Up Other Containers](#setting-up-other-containers)

---

## What Is Adminer

### Introduction
Adminer is a powerful and user-friendly database management tool designed to simplify the management of various database systems through a web interface. It provides a streamlined alternative to more complex database management solutions, offering a range of features that cater to both novice and experienced users. This article explores Adminer’s key features, benefits, and use cases, illustrating why it is a valuable tool for database administration.

### Core Features
1. Support for Multiple Databases </br>
Adminer supports a wide range of database systems, including MySQL, PostgreSQL, SQLite, MS SQL, and Oracle. This versatility makes it a valuable tool for managing different types of databases from a single interface.

2. User-Friendly Interface </br>
The web-based interface of Adminer is designed to be intuitive and easy to navigate. Users can perform complex database operations with just a few clicks, making it accessible even for those with limited technical expertise.

3. Database Management </br>
Adminer allows users to manage database schemas, tables, columns, indexes, and relationships. Users can create, modify, and delete database objects directly from the interface.

4. Data Management </br>
With Adminer, users can easily perform CRUD (Create, Read, Update, Delete) operations on database records. It provides a straightforward way to insert, edit, and delete data within tables.

5. Query Execution </br>
Adminer includes a SQL query editor that supports running custom SQL queries. Users can execute queries, view results, and analyze data without needing a separate SQL client.

6. Security Features </br>
Adminer includes security features to protect database access. Users can manage permissions, set up access controls, and ensure that sensitive data is handled securely.

7. Lightweight and Fast </br>
Adminer is known for its lightweight design, which results in fast load times and efficient performance. Unlike some other database management tools, Adminer does not require extensive server resources.

### Benefits of Using Adminer

1. Simplicity </br> Adminer’s simple and clean interface reduces the complexity of database management tasks, allowing users to focus on their work without getting bogged down by intricate details.

2. Flexibility </br> The tool’s support for multiple database systems means that users can manage different types of databases without needing multiple tools.

3. Efficiency </br> Adminer’s lightweight nature ensures that it runs smoothly even on servers with limited resources, making it an efficient choice for managing databases.

### Use Cases
1. Development and Testing</br>
Developers use Adminer to manage and test databases during application development. Its ease of use allows for quick modifications and testing of database changes.
2. Database Administration</br>
Database administrators benefit from Adminer’s comprehensive management features, which streamline tasks such as schema updates, data management, and query execution.
3. Educational Purposes</br>
Adminer is an excellent tool for teaching database concepts. Its user-friendly interface helps students grasp database management principles without getting overwhelmed.
4. Small to Medium-Sized Projects</br>
For small to medium-sized projects, Adminer provides all the necessary functionality without the overhead of more complex database management systems.

### Installation and Setup
Adminer can be installed quickly and easily on a web server. It requires minimal setup, usually involving uploading the Adminer PHP file to your server and configuring access settings. The tool is available as a single PHP file, which simplifies deployment and maintenance

### Conclusion
Adminer is a versatile and efficient database management tool that offers a range of features suitable for various use cases. Its support for multiple databases, user-friendly interface, and lightweight design make it a valuable asset for developers, administrators, and educators alike. Whether you are managing a single database or handling multiple database systems, Adminer provides a streamlined solution for effective database management.

---

## Adminer Dockerfile

For the bonus services we will have to create another folder called bonus inside the requirements directory

    mkdir -p ~/Inception/src/requirements/bonus

And create inside the specific folder for adminer

    mkdir -p ~/Inception/src/requirements/bonus/adminer

Vim into the docker file

    vim ~/Inception/src/requirements/bonus/adminer/Dockerfile

And write the following content inside it:

```dockerfile
FROM alpine:3.19.2

ARG PHP_VERSION=82

RUN     apk update && \
                apk upgrade && \
                apk add --no-cache php${PHP_VERSION} \
        php${PHP_VERSION}-common \
        php${PHP_VERSION}-session \
        php${PHP_VERSION}-iconv \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-mysqli \
                php${PHP_VERSION}-imap \
                php${PHP_VERSION}-cgi \
                php${PHP_VERSION}-pdo \
                php${PHP_VERSION}-pdo_mysql \
                php${PHP_VERSION}-soap \
                php${PHP_VERSION}-posix \
                php${PHP_VERSION}-gettext \
                php${PHP_VERSION}-ldap \
                php${PHP_VERSION}-ctype \
                php${PHP_VERSION}-dom \
                php${PHP_VERSION}-simplexml \
                wget

WORKDIR /var/www

RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
    mv adminer-4.8.1.php index.php && chown -R root:root /var/www/

EXPOSE 8080

CMD     [ "php82", "-S", "[::]:8080", "-t", "/var/www" ]
```

Explanation for each line:

1. Specify the Base Image

```dockerfile
FROM alpine:3.19.2
```

 This line specifies the base image for your Docker container. alpine:3.19.2 refers to Alpine Linux version 3.19.2, a lightweight and efficient Linux distribution known for its minimal size. Using a specific version ensures that your container environment remains consistent.

2. Setting the Arguments
```dockerfile
ARG PHP_VERSION=82
```
This line declares a build-time argument named `PHP_VERSION` with a default value of 82. This allows you to specify a different PHP version when building the Docker image by overriding this argument.

3. Install Dependencies and PHP extensions
```dockerfile
RUN apk update && \
    apk upgrade && \
    apk add --no-cache php${PHP_VERSION} \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-session \
    php${PHP_VERSION}-iconv \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-mysqli \
    php${PHP_VERSION}-imap \
    php${PHP_VERSION}-cgi \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-pdo_mysql \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-posix \
    php${PHP_VERSION}-gettext \
    php${PHP_VERSION}-ldap \
    php${PHP_VERSION}-ctype \
    php${PHP_VERSION}-dom \
    php${PHP_VERSION}-simplexml \
    wget

```

- `apk update && apk upgrade`: Updates the Alpine package index and upgrades all installed packages to their latest versions.
- `apk add --no-cache`: Installs the specified packages without caching the intermediate files, reducing the image size.
- PHP and extensions: Installs the specified PHP version and various PHP extensions, such as `php${PHP_VERSION}-mysqli` for MySQL database support, `php${PHP_VERSION}-gd` for image processing, `php${PHP_VERSION}-curl` for HTTP requests, and others required for PHP applications.
- `wge`t: Installs the wget utility for downloading files from the web.


4. Set Working Directory
```dockerfile
WORKDIR /var/www
```
Sets the working directory inside the container to `/var/www`. This is where the subsequent commands will be executed, and where files will be placed.

5.  Download Adminer
```dockerfile
RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
    mv adminer-4.8.1.php index.php && chown -R root:root /var/www/
```
- `wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php`: Downloads the Adminer PHP file from the specified URL.
- `mv adminer-4.8.1.php index.php`: Renames the downloaded Adminer file to `index.php`. This makes it the default file served by PHP's built-in server.
- `chown -R root:root /var/www/`: Changes the ownership of the `/var/www/` directory to the root user and group.

6. Expose Port
```dockerfile
EXPOSE 8080
```
Informs Docker that the container will listen on port 8080 at runtime. This port will be used for serving the Adminer application.

7. Set Command
```dockerfile
CMD [ "php82", "-S", "[::]:8080", "-t", "/var/www" ]
```
Specifies the default command to run when the container starts. Here, it uses the PHP built-in server (php82) to serve files from the /var/www directory on port 8080. The -S [::]:8080 option tells PHP to listen on all network interfaces ([::]), and -t /var/www specifies the document root directory.

### Summary

This Dockerfile sets up a lightweight PHP environment on Alpine Linux with Adminer. It installs PHP and necessary extensions, downloads and configures Adminer, and exposes port 8080 for web access. The Dockerfile should be corrected to use a single FROM statement (alpine:3.19.2), ensuring consistency and proper base image specification. The resulting Docker image provides a simple setup for running Adminer with PHP's built-in server, suitable for development and lightweight use cases.

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