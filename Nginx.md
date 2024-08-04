# Guide how to set Nginx Docker Container

## Table Of Contents
- [What Is Nginx](#what-is-nginx)
- [Nginx Dockerfile](#nginx-dockerfile)
- [Nginx Entrypoint Script](#nginx-entrypoint-script)
- [Setting Up Other Containers](#setting-up-other-containers)

## What Is Nginx

1. Introduction
Nginx (pronounced "engine-x") is a high-performance web server and reverse proxy server renowned for its speed, stability, and low resource usage. Originally created by Igor Sysoev in 2002, Nginx has grown into one of the most popular web servers in the world. This article will explore what Nginx is, how it works, and why it has become a staple in modern web infrastructure.

2. Overview
Nginx is a versatile server software that performs several critical functions:

- Web Server: Serves static content and handles HTTP requests.
- Reverse Proxy: Distributes requests to backend servers, improving load balancing and fault tolerance.
- Load Balancer: Distributes incoming network traffic across multiple servers.
- Caching Server: Reduces the load on backend servers by caching frequently accessed content.
- Mail Proxy: Handles mail protocols like IMAP, POP3, and SMTP.

3. Core Features
Nginx offers the following core features:

- High Performance: Nginx is designed to handle high traffic with minimal resource consumption. Its asynchronous, event-driven architecture allows it to manage thousands of concurrent connections efficiently.
- Scalability: Its modular design and support for load balancing enable it to scale horizontally across multiple servers. This makes it suitable for both small sites and large-scale applications.
- Reliability: With built-in features for failover and load balancing, Nginx ensures high availability and reliability for web applications.
- Configurability: Nginx configurations are highly flexible, allowing for fine-tuned control over server behavior, including URL routing, security settings, and caching policies.
- Security: Nginx includes numerous security features such as SSL/TLS support, rate limiting, and denial of service protection to secure web applications from various threats.

4. How Nginx Works
Nginx uses an event-driven architecture to handle requests. Unlike traditional servers that use a thread-per-request model, Nginx handles requests asynchronously, which allows it to process multiple requests in parallel with minimal resource overhead.

- Event-Driven Architecture: Nginx processes requests using a non-blocking approach. This means that it can handle multiple requests simultaneously without waiting for each request to complete.
- Worker Processes: Nginx operates using worker processes that handle incoming requests. Each worker can manage thousands of connections, thanks to the event-driven model.
- Configuration: Nginx configurations are specified in plain text files, usually located in /etc/nginx/nginx.conf. These configurations allow you to define server blocks, location blocks, and other directives to control how Nginx handles requests.

5. Common Use Cases
Nginx is commonly used in the following scenarios:

- Serving Static Content: Nginx excels at serving static files such as HTML, CSS, and JavaScript. It efficiently handles high volumes of requests for static assets.
- Reverse Proxy and Load Balancing: Nginx is commonly used as a reverse proxy to distribute client requests to backend servers, improving performance and reliability.
- SSL Termination: Nginx can offload SSL/TLS encryption and decryption from backend servers, improving their performance and simplifying certificate management.
- Caching: By caching responses, Nginx reduces the load on backend servers and speeds up content delivery to users.
- API Gateway: Nginx can act as an API gateway, routing requests to different backend services and providing authentication, logging, and rate limiting.

6. Nginx vs. Apache
Nginx and Apache are two widely used web servers, each with its own strengths and weaknesses:

- Performance: Nginx is generally faster and more efficient than Apache, especially under high traffic conditions, due to its event-driven architecture.
- Resource Usage: Nginx has a smaller memory footprint compared to Apache, making it suitable for resource-constrained environments.
- Configuration: Nginx configurations are often considered simpler and more intuitive than Apache’s, though this can be subjective based on user experience.
- Modularity: Apache's modularity is highly flexible, allowing for a wide range of extensions and modules, while Nginx’s modules are mostly compiled into the server.

7. Getting Started with Nginx
To start using Nginx, Normally we should follow the steps below, which they are just to show how the installation is done but dont do anything yet because we will install them from the Dockerfile:

- Installation: Install Nginx using your operating system’s package manager. For example, on Ubuntu, you can use:
```bash
sudo apt update
sudo apt install nginx
```
- Configuration: Edit the configuration file located at /etc/nginx/nginx.conf to set up server blocks, location blocks, and other directives.
- Starting and Stopping: Use systemd to start, stop, and manage the Nginx service:
```bash
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
```
- Testing: Ensure that your Nginx server is running by visiting http://localhost in your web browser.

8. Conclusion
Nginx has become a crucial component in modern web architecture due to its performance, scalability, and versatility. Whether you’re serving static files, handling high volumes of traffic, or acting as a reverse proxy, Nginx offers a robust and efficient solution. Understanding its features and how it operates can help you make the most of this powerful web server in your projects.

Feel free to delve deeper into Nginx’s documentation and community resources to explore its full capabilities and keep up with best practices.
Here is a link for Nginx documentation where you can have a look in many configuration files and how to set it up, if you want to read more by yourself: https://nginx.org/en/docs/

## Nginx Dockerfile

Navigate to the directory where Nginx's Dockerfile is located and open it with vim:

```bash
vim ~/Inception/srcs/requirements/nginx/Dockerfile
```

And write the following content inside it:

```dockerfile
# Use the specified version of Alpine
FROM alpine:3.19.2

# Install Nginx, OpenSSL, and Bash
RUN apk update && \
    apk add nginx openssl bash

# Copy the executable script for Nginx configuration
COPY tools/nginx-entrypoint.sh /usr/local/bin/

# Change permissions of the executable file and create necessary directories
RUN chmod +x /usr/local/bin/nginx-entrypoint.sh && \
    mkdir -p /etc/nginx/ssl

# Set the entrypoint script for the container
ENTRYPOINT [ "nginx-entrypoint.sh" ]
```

Explanation for each line:

1. Use the specified version of Alpine

```dockerfile
FROM alpine:3.19.2
```

This line specifies the base image for your Docker container. `alpine:3.19.2` refers to Alpine Linux version 3.19.2. Alpine Linux is a minimal, efficient, and lightweight distribution that is commonly used as a base image in Docker containers. By choosing a specific version, you ensure that the container environment remains consistent and predictable.

2. Install Nginx, OpenSSL, and Bash

```dockerfile
RUN apk update && \
    apk add nginx openssl bash
```

This `RUN` command performs two actions:

- `apk update` updates the Alpine package index to ensure you are installing the latest available versions of the packages.
- `apk add nginx openssl bash` installs Nginx, OpenSSL (for handling SSL/TLS), and Bash (a shell for scripting and command execution) in the container. Nginx is a high-performance web server, OpenSSL provides SSL/TLS support, and Bash is used for scripting purposes.

3. Copy the executable script for Nginx configuration

```dockerfile
COPY tools/nginx-entrypoint.sh /usr/local/bin/
```

This command copies the `nginx-entrypoint.sh` script from the `tools` directory on the host machine to the `/usr/local/bin/` directory inside the container. This script will be used to initialize the Nginx configuration when the container starts. Placing it in `/usr/local/bin/` ensures it is accessible for execution.

4. Change permissions of the executable file and create necessary directories

```dockerfile
RUN chmod +x /usr/local/bin/nginx-entrypoint.sh && \
    mkdir -p /etc/nginx/ssl
```

This `RUN` command performs two actions:

- `chmod +x /usr/local/bin/nginx-entrypoint.sh` sets the execute permission on the `nginx-entrypoint.sh` script, allowing it to be run as a program.
- `mkdir -p /etc/nginx/ssl` creates the `/etc/nginx/ssl` directory, which is used to store SSL/TLS certificates and keys for secure communications.

5. Set the entrypoint script for the container

```dockerfile
ENTRYPOINT [ "nginx-entrypoint.sh" ]
```

The `ENTRYPOINT` directive specifies the `nginx-entrypoint.sh` script as the main process to be executed when the container starts. This script typically sets up necessary configurations, initializes services, and runs Nginx. By using `ENTRYPOINT`, you ensure that this script runs every time the container is launched, establishing the desired configuration and behavior for the container.

Summary: This Dockerfile sets up an Nginx container using Alpine Linux as the base image. It installs Nginx, OpenSSL, and Bash, copies and configures an entrypoint script, adjusts permissions, and prepares directories for SSL certificates. The `ENTRYPOINT` directive ensures that the entrypoint script is executed on container start, which configures and launches Nginx appropriately. This setup provides a solid foundation for running Nginx in a containerized environment, with SSL/TLS support and custom initialization scripts. Adjustments may be required based on specific project needs or security considerations.

## Nginx Entrypoint Script

To configure Nginx as a Docker container, navigate and open with vim nginx-entrypoint.sh:

    vim ~/Inception/srcs/requirements/nginx/tools/nginx-entrypoint.sh

And you can use the following entrypoint script to write it inside:

```bash
#!/bin/bash
set -e

# On the first container run, generate a certificate and configure the server
if [ ! -e /etc/.firstrun ]; then
    # Generate a certificate for HTTPS
    openssl req -x509 -days 365 -newkey rsa:2048 -nodes \
        -out '/etc/nginx/ssl/cert.crt' \
        -keyout '/etc/nginx/ssl/cert.key' \
        -subj "/CN=$DOMAIN_NAME" \
         >/dev/null 2>/dev/null

    # Configure nginx to serve static WordPress files and to pass PHP requests
    # to the WordPress container's php-fpm process
    cat << EOF >> /etc/nginx/http.d/default.conf
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name $DOMAIN_NAME;

    ssl_certificate /etc/nginx/ssl/cert.crt;
    ssl_certificate_key /etc/nginx/ssl/cert.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;

    root /var/www/html;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ [^/]\.php(/|\$) {
        try_files \$fastcgi_script_name =404;

        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        fastcgi_split_path_info ^(.+\.php)(/.*)\$;
        include fastcgi_params;
    }
}
EOF
    touch /etc/.firstrun
fi

exec nginx -g 'daemon off;'

```

**Explanation:** 

`openssl` command generates a new self-signed SSL certificate:
- `-x509` specifies that the output should be in X.509 format.
- `-days 365` sets the certificate validity to 365 days.
- `-newkey rsa:2048` creates a new RSA key with a 2048-bit length.
- `-nodes` ensures that the private key is not encrypted with a passphrase.
- `-out '/etc/nginx/ssl/cert.crt'` specifies the output file for the certificate.
- `-keyout '/etc/nginx/ssl/cert.key'` specifies the output file for the private key.
- `-subj "/CN=$DOMAIN_NAME"` sets the subject field of the certificate with the common name (CN) as `$DOMAIN_NAME`.
- `>/dev/null 2>/dev/null` suppresses the output and error messages.

---

Generating the configuration file needed for Nginx Web Server.

```bash
cat << EOF >> /etc/nginx/http.d/default.conf
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name $DOMAIN_NAME;

    ssl_certificate /etc/nginx/ssl/cert.crt;
    ssl_certificate_key /etc/nginx/ssl/cert.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;

    root /var/www/html;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ [^/]\.php(/|\$) {
        try_files \$fastcgi_script_name =404;

        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        fastcgi_split_path_info ^(.+\.php)(/.*)\$;
        include fastcgi_params;
    }
}
EOF
```

**Explanation:** This block of code appends a new Nginx server configuration to the `/etc/nginx/http.d/default.conf` file using a `cat` here-document:
- `listen 443 ssl http2;` and `listen [::]:443 ssl http2;` configure Nginx to listen on port 443 for HTTPS traffic and enable HTTP/2.
- `server_name $DOMAIN_NAME;` sets the server name to the value of the `$DOMAIN_NAME` environment variable.
- `ssl_certificate` and `ssl_certificate_key` specify the paths to the SSL certificate and private key files.
- `ssl_protocols` and `ssl_ciphers` configure SSL/TLS protocols and ciphers for secure connections.
- `root /var/www/html;` sets the document root directory for static files.
- `index index.php index.html index.htm;` specifies the order of index files to serve.
- `location /` block handles static files and redirects to `index.php` for dynamic requests.
- `location ~ [^/]\.php(/|\$)` block handles PHP requests, forwarding them to the `wordpress` container's PHP processor on port 9000.

---

**touch /etc/.firstrun**

**Explanation:** This command creates the `/etc/.firstrun` file as a flag to indicate that the initialization steps have already been performed. This prevents the script from running the certificate generation and configuration steps again on subsequent container starts.

---

**exec nginx -g 'daemon off;'**

**Explanation:** The `exec` command replaces the current shell process with the Nginx process. `nginx -g 'daemon off;'` starts Nginx in the foreground (instead of as a daemon), which is necessary for Docker containers to keep the main process running. This ensures that Nginx remains active and serves requests.

---

**Summary:** This script is designed to configure an Nginx container for the first time it is run. It generates a self-signed SSL certificate, configures Nginx to handle HTTPS traffic and serve WordPress content, and sets up necessary server configurations. The script ensures that these setup tasks are only performed once by checking for the presence of a flag file. After completing the configuration, it starts Nginx in the foreground to keep the container running.

---

For environment variables Already explained at Mariadb Set up article.

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