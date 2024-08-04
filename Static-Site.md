# Guide how to set Static-Site Docker Container

## Table Of Contents
- [Static Site Dockerfile](#static-site-dockerfile)
- [Static Site Entrypoint Script](#static-site-entrypoint-script)
- [Setting Up Other Containers](#setting-up-other-containers)

---

## Static Site Dockerfile

For the bonus services we will have to create another folder called bonus inside the requirements directory

    mkdir -p ~/Inception/src/requirements/bonus

And create inside directory the specific folder for the static-site

    mkdir -p ~/Inception/src/requirements/bonus/static-site

Vim into the docker file

    vim ~/Inception/src/requirements/bonus/static-site/Dockerfile

Now this implementation might be different from the way you want to work on your own static website, but in my case is like below and I will explain why:

```dockerfile
# Use the official Alpine Image
FROM alpine:3.19.2

# Install dependencies
RUN apk update && apk add --no-cache nginx
# Set working directory for application code

# Copy nginx configuration
COPY tools/static-site-entrypoint.sh usr/local/bin/
RUN chmod +x usr/local/bin/static-site-entrypoint.sh

# Remove default Nginx index.html and copy built static files to Nginx directory
RUN mkdir -p /usr/share/nginx/html

COPY rocketProject/ /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

ENTRYPOINT [ "static-site-entrypoint.sh" ]
```

Explanation for each line:

1. Specify the Base Image

```dockerfile
FROM alpine:3.19.2
```
 This line specifies the base image for your Docker container. alpine:3.19.2 refers to Alpine Linux version 3.19.2, a lightweight and efficient Linux distribution known for its minimal size. Using a specific version ensures that your container environment remains consistent.

2. Setting the Arguments
```dockerfile
RUN apk update && apk add --no-cache nginx
```
This command updates the Alpine package index and installs Nginx without caching the intermediate files (--no-cache), which helps keep the image size smaller. Nginx will be used as the web server to serve your static site. We are not using the nginx service we prepared before hand because in the subject's requirements is specified that our website is running seperately.

3. Set Working Directory for Application Code
```dockerfile
WORKDIR /app
```
Normally, you would set a working directory for where the application code will be placed. This can be done using the WORKDIR command. For this Dockerfile, the static files are directly copied to the Nginx directory.

4. Copy Nginx Configuration Script
```dockerfile
COPY tools/static-site-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/static-site-entrypoint.sh

```
- `COPY tools/static-site-entrypoint.sh /usr/local/bin/`: Copies the `static-site-entrypoint.sh` script from the local `tools` directory to `/usr/local/bin/` in the container. This script will be used to configure and start Nginx.
- `RUN chmod +x /usr/local/bin/static-site-entrypoint.sh`: Grants execute permissions to the `static-site-entrypoint.sh script`, ensuring it can be run as a command.

4. Remove Default Nginx Index Page and Copy Static Files
```dockerfile
RUN mkdir -p /usr/share/nginx/html
COPY rocketProject/ /usr/share/nginx/html/
```
- `RUN mkdir -p /usr/share/nginx/html`: Creates the directory `/usr/share/nginx/html` where Nginx expects to find the static site files. The `-p` flag ensures that the directory is created along with any necessary parent directories.
- `COPY rocketProject/ /usr/share/nginx/html/`: Copies the contents of the rocketProject directory from the local machine to the `/usr/share/nginx/html/` directory in the container. This is where the static files of your website are placed.

5. Expose Port
```dockerfile
EXPOSE 80
```
Informs Docker that the container will listen on port 80 at runtime. This is the default port for HTTP traffic and is used by Nginx to serve web content.

6. Set the Entrypoint
```dockerfile
ENTRYPOINT [ "static-site-entrypoint.sh" ]
```
Specifies the default command to run when the container starts. The `static-site-entrypoint.sh` script is used to start and configure Nginx. By setting this script as the entry point, Docker will execute it as the main process of the container.

### Summary

This Dockerfile sets up a container to serve a static website using Nginx on Alpine Linux. It installs Nginx, copies configuration scripts, and places the static site files into the appropriate directory. The container exposes port 80 for HTTP traffic and uses an entrypoint script to start Nginx. This setup ensures that your static site is served efficiently in a lightweight environment.

## Static Site Entrypoint Script

Create first the tool directory

    mkdir -p ~/Inception/srcs/requirements/bonus/static-site/tools/

Vim inside entrypoint

    vim ~/Inception/srcs/requirements/bonus/static-site/tools/nginx-entrypoint.sh

And we can see my configuration

```bash
#!/bin/sh

# Create Nginx configuration file
cat << EOF > /etc/nginx/http.d/default.conf
server {
    listen 80;
    root /usr/share/nginx/html;

    location / {
        include /etc/nginx/mime.types;
        try_files \$uri \$uri/ /index.html;
    }

    location ~* \.(?:jpg|jpeg|gif|png|ico|svg)$ {
        expires 7d;
        add_header Cache-Control "public";
    }

    location ~* \.(?:css|js)$ {
        add_header Cache-Control "no-cache, public, must-revalidate, proxy-revalidate";
    }
}
EOF

# Start Nginx in the foreground
exec nginx -g 'daemon off;'
nginx -t
```

Which basically just writes inside default configuration file of nginx how I want the setup for my website and executes this 2 commands after:
- `exec nginx -g 'daemon off;'` </br>
This command starts the Nginx web server with the exec command, which replaces the current shell process with the Nginx process. The `-g 'daemon off;'` option tells Nginx to run in the foreground rather than as a background daemon. Running Nginx in the foreground is particularly useful in containerized environments (like Docker) where the main process needs to stay active to keep the container running.
- `nginx -t`</br>
This command tests the Nginx configuration for syntax errors and other issues. The `-t` option tells Nginx to check the configuration file for correctness without actually starting the server. This is a crucial step in ensuring that any changes made to the Nginx configuration will not cause the server to fail when it is restarted or reloaded.

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