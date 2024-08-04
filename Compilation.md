# Guide how to set Docker Network

## Table Of Contents
- [What Is Docker Compose](#what-is-docker-compose)
- [Inception Docker Compose File](#inception-docker-compose-file)
- [Inception Makefile](#inception-makefile)
- [Compile Inception](#compile-inception)
- [Setting Up Other Containers](#setting-up-other-containers)

---

## What Is Docker Compose

### Introduction
Docker Compose is a powerful tool in the Docker ecosystem that enables you to manage multi-container applications with ease. Instead of handling each container individually, Docker Compose lets you define a complete application stack in a single YAML file, known as the docker-compose.yml file. This file specifies all the services, networks, and volumes your application needs, allowing you to start, stop, and manage your entire application stack with simple commands

### Core Features
1. Declarative Configuration</br>
One of WordPress’s most praised features is its user-friendly interface. With a simple and intuitive dashboard, users can easily create and manage content without needing extensive technical knowledge. The platform supports a visual editor and a block-based editor (Gutenberg), making content creation and editing straightforward.

2. Simplified Commands</br>
WordPress offers a vast repository of themes that allow users to change the appearance of their site without altering the underlying code. These themes are designed to be customizable, enabling users to modify layouts, colors, fonts, and more to match their branding and style.

3. Multi-Container Orchestration</br>
Plugins are an integral part of WordPress, extending its functionality and allowing users to add features such as SEO optimization, social media integration, and e-commerce capabilities. With thousands of free and premium plugins available, users can tailor their WordPress sites to meet specific needs.

4. Environment Management</br>
WordPress is highly flexible, accommodating a range of website types from blogs and portfolios to business sites and online stores. It supports a range of custom post types and taxonomies, and its scalability ensures that it can grow with your website, handling everything from small personal sites to large enterprise-level applications.

5. Isolation and Portability</br>
As an open-source platform, WordPress benefits from a vibrant community of developers, designers, and enthusiasts. This community contributes to a vast repository of documentation, forums, and tutorials, making it easier for users to find solutions to common issues and to receive support.

### Conclusion
Docker Compose is an essential tool for managing multi-container Docker applications. It simplifies the configuration, deployment, and management of complex applications by using a single YAML file to define all components. With Docker Compose, you can streamline development workflows, improve consistency across environments, and manage applications more efficiently. Whether you're building a small application or a large-scale system, Docker Compose provides the tools you need to handle containerized services with ease.

## Inception Docker Compose File
If you have not created yet the file type

    vim ~/Inception/srcs/docker-compose.yml

And write inside

```yml
services:
  mariadb:
    container_name: mariadb
    init: true
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
    env_file:
      - .env
    build: requirements/mariadb
    volumes:
      - mariadb:/var/lib/mysql
    networks:
      - docker-network
    image: mariadb
  nginx:
    container_name: nginx
    init: true
    restart: always
    environment:
      - DOMAIN_NAME=${DOMAIN_NAME}
    env_file:
      - .env
    build: requirements/nginx
    ports:
      - "443:443" #https
    volumes:
      - wordpress:/var/www/html 
    networks:
      - docker-network
    depends_on:
      - wordpress
      - mariadb
    image: nginx
  wordpress:
    container_name: wordpress
    init: true
    restart: always
    environment:
      - DOMAIN_NAME=${DOMAIN_NAME}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - WORDPRESS_TITLE=${WORDPRESS_TITLE}
      - WORDPRESS_ADMIN_USER=${WORDPRESS_ADMIN_USER}
      - WORDPRESS_ADMIN_PASSWORD=${WORDPRESS_ADMIN_PASSWORD}
      - WORDPRESS_ADMIN_EMAIL=${WORDPRESS_ADMIN_EMAIL}
      - WORDPRESS_USER=${WORDPRESS_USER}
      - WORDPRESS_PASSWORD=${WORDPRESS_PASSWORD}
      - WORDPRESS_EMAIL=${WORDPRESS_EMAIL}
      - REDIS_HOST=redis
      - REDIS_PORT=6379
    build: requirements/wordpress
    volumes:
      - wordpress:/var/www/html
    networks:
      - docker-network
    depends_on:
      - mariadb
      - redis
    image: wordpress
  redis:
    build: ./requirements/bonus/redis
    container_name: redis
    restart: always
    networks:
      - docker-network
    image: redis
  ftp:
    build: ./requirements/bonus/ftp
    container_name: ftp
    restart: always
    env_file:
      - .env
    environment:
      - FTP_USER=${FTP_USER}
      - FTP_PASSWORD=${FTP_PASSWORD}
      - WORDPRESS_DIR=${WORDPRESS_DIR}
    volumes:
      - wordpress:/var/www/html
    ports:
      - "21:21"
      - "21000-21010:21000-21010"
    networks:
      - docker-network
    depends_on:
      - wordpress
    image: ftp
  adminer:
    build: ./requirements/bonus/adminer
    container_name: adminer
    restart: always
    depends_on:
      - mariadb
    ports:
      - "8080:8080"
    networks:
      - docker-network
    image: adminer
  static-site:
    container_name: static-site
    build: ./requirements/bonus/static-site
    restart: always
    ports:
      - "80:80"
    image: static-site
  portainer:
    build: ./requirements/bonus/portainer
    container_name: portainer
    ports:
      - "8000:8000"
      - "9443:9443"
      - "9000:9000"
    networks:
      - docker-network
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer:/data
    image: portainer
    restart: always

volumes:
  mariadb:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${HOME}/data/mariadb
  wordpress:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${HOME}/data/wordpress
  portainer:
    driver_opts:
      o: bind
      type: none
      device: ${HOME}/data/portainer

networks:
  docker-network:
    name: docker-network
    driver: bridge
```

1. mariadb Service
    - container_name</br>Names the container mariadb for easier reference.
    - init</br>Ensures the container is initialized properly, handling zombie processes.
    - restart</br>Configures the container to restart automatically if it crashes or the Docker daemon restarts.
    - environment</br>Sets environment variables for the MySQL database credentials and configuration.
    - env_file</br>Loads environment variables from a .env file for sensitive data like passwords.
    - build</br>Specifies the path to the Dockerfile for building the mariadb image.
    - volumes</br>Mounts a named volume mariadb to persist database data.
    - networks</br>Connects the container to the docker-network network.
    - image</br>Uses the mariadb image from Docker Hub.

2. nginx Service:

    - container_name</br>Names the container nginx.
    - init</br>Ensures proper initialization.
    - restart</br>Always restarts the container on failure.
    - environment</br>Sets the DOMAIN_NAME environment variable.
    - env_file</br>Loads additional environment variables from .env.
    - build</br>Path to the Dockerfile for building the nginx image.
    - ports</br>Maps port 443 on the host to port 443 on the container for HTTPS.
    - volumes</br>Mounts the wordpress volume to serve the website files.
    - networks</br>Connects to docker-network.
    - depends_on</br>Ensures nginx starts only after wordpress and mariadb.
    - image</br>Uses the nginx image.

3. wordpress Service:

    - container_name</br>Names the container wordpress.
    - init</br>Ensures proper initialization.
    - restart</br>Configures auto-restart on failure.
    - environment</br>Sets various WordPress and database environment variables.
    - build</br>Path to the Dockerfile for building the wordpress image.
    - volumes</br>Mounts the wordpress volume to serve the WordPress files.
    - networks</br>Connects to docker-network.
    - depends_on</br>Ensures wordpress starts only after mariadb and redis.
    - image</br>Uses the wordpress image.

4. redis Service:
    - container_name</br>Names the container redis.
    - restart</br>Configures auto-restart.
    - build</br>Path to the Dockerfile for building the redis image.
    - networks</br>Connects to docker-network.
    - image</br>Uses the redis image.

5. ftp Service:
    - container_name</br>Names the container ftp.
    - restart</br>Configures auto-restart.
    - env_file</br>Loads FTP-related environment variables from .env.
    - environment</br>Sets FTP user credentials and WordPress directory.
    - volumes</br>Mounts the wordpress volume.
    - ports</br>Maps ports 21 for FTP and 21000-21010 for passive FTP connections.
    - networks</br>Connects to docker-network.
    - depends_on</br>Ensures ftp starts only after wordpress.
    - image</br>Uses the ftp image.

6. adminer Service:
    - container_name</br>Names the container adminer.
    - restart</br>Configures auto-restart.
    - depends_on</br>Ensures adminer starts only after mariadb.
    - ports</br>Maps port 8080 for Adminer web interface.
    - networks</br>Connects to docker-network.
    - image</br>Uses the adminer image.

7. static-site Service:
    - container_name</br>Names the container static-site.
    - build</br>Path to the Dockerfile for building the static-site image.
    - restart</br>Configures auto-restart.
    - ports</br>Maps port 80 for serving static content.
    - image</br>Uses the static-site image.

8. portainer Service:
    - container_name</br>Names the container portainer.
    - build</br>Path to the Dockerfile for building the portainer image.
    - ports</br>Maps ports 8000, 9443, and 9000 for Portainer's web interface.
    - networks</br>Connects to docker-network.
    - volumes</br>Mounts Docker socket and Portainer data volumes.
    - image</br>Uses the portainer image.
    - restart</br>Configures auto-restart.

9. Volumes</br>
Volumes are defined to persist data and ensure that it is not lost when containers are stopped or removed:

    - mariadb: Stores MySQL data.
    - wordpress: Stores WordPress files.
    - portainer: Stores Portainer data.

---

## Inception Makefile

Vim inside the root directory for Makefile

    vim ~/Inception/Makefile

And how I have orchestrated all the compilation is like below:

```makefile
DOCKER_COMPOSE_FILE := ./srcs/docker-compose.yml
ENV_FILE := srcs/.env
DATA_DIR := $(HOME)/data
WORDPRESS_DATA_DIR := $(DATA_DIR)/wordpress
MARIADB_DATA_DIR := $(DATA_DIR)/mariadb
PORTAINER_DATA_DIR := $(DATA_DIR)/portainer

name = inception

all: create_dirs make_dir_up

build: create_dirs make_dir_up_build

down:
	@printf "Stopping configuration ${name}...\n"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) down

re: down create_dirs make_dir_up_build

clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -a
	@sudo rm -rf $(WORDPRESS_DATA_DIR)/*
	@sudo rm -rf $(MARIADB_DATA_DIR)/*
	@sudo rm -rf $(PORTAINER_DATA_DIR)/*

fclean: down
	@printf "Total clean of all configurations docker\n"
#	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf $(WORDPRESS_DATA_DIR)/*
	@sudo rm -rf $(MARIADB_DATA_DIR)/*
	@sudo rm -rf $(PORTAINER_DATA_DIR)/*

logs:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) logs -f

.PHONY: all build down re clean fclean logs create_dirs make_dir_up make_dir_up_build

create_dirs:
	@printf "Creating data directories...\n"
	@mkdir -p $(WORDPRESS_DATA_DIR)
	@mkdir -p $(MARIADB_DATA_DIR)
	@mkdir -p $(PORTAINER_DATA_DIR)

make_dir_up:
	@printf "Launching configuration ${name}...\n"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d

make_dir_up_build:
	@printf "Building configuration ${name}...\n"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build
```

A Makefile is used to automate tasks and manage project builds. In the context of Docker and Docker Compose, a Makefile can simplify the process of starting, stopping, cleaning, and managing Docker containers. Here's a detailed breakdown of the provided Makefile:

1. Variables
- DOCKER_COMPOSE_FILE: Path to the Docker Compose file.
```makefile
DOCKER_COMPOSE_FILE := ./srcs/docker-compose.yml
```
- ENV_FILE: Path to the environment file containing environment variables.
```makefile
ENV_FILE := srcs/.env
```
- DATA_DIR: Base directory for storing persistent data.
```makefile
DATA_DIR := $(HOME)/data
```
- WORDPRESS_DATA_DIR: Directory for WordPress data.
```makefile
WORDPRESS_DATA_DIR := $(DATA_DIR)/wordpress
```
- MARIADB_DATA_DIR: Directory for MariaDB data.
```makefile
MARIADB_DATA_DIR := $(DATA_DIR)/mariadb
```
- PORTAINER_DATA_DIR: Directory for Portainer data.
```makefile
PORTAINER_DATA_DIR := $(DATA_DIR)/portainer
```
- name: A variable to store the name of the configuration.
```makefile
name = inception
```
2. Targets
- all: Default target that creates necessary directories and starts the Docker Compose services.
```makefile
all: create_dirs make_dir_up
```
- build: Creates directories and starts the Docker Compose services with build.
```makefile
build: create_dirs make_dir_up_build
```
- down: Stops the Docker Compose services and removes the containers.
```makefile
down:
    @printf "Stopping configuration ${name}...\n"
    @docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) down
```
- re: Restarts the configuration by stopping, creating directories, and building services.
```makefile
re: down create_dirs make_dir_up_build
```
- clean: Stops the services, prunes Docker system to free up space, and removes data from directories.
```makefile
clean: down
    @printf "Cleaning configuration ${name}...\n"
    @docker system prune -a
    @sudo rm -rf $(WORDPRESS_DATA_DIR)/*
    @sudo rm -rf $(MARIADB_DATA_DIR)/*
    @sudo rm -rf $(PORTAINER_DATA_DIR)/*
```
- fclean: Completely cleans up all Docker configurations, including stopping all containers, removing networks, and volumes.
```makefile
fclean: down
    @printf "Total clean of all configurations docker\n"
    @docker system prune --all --force --volumes
    @docker network prune --force
    @docker volume prune --force
    @sudo rm -rf $(WORDPRESS_DATA_DIR)/*
    @sudo rm -rf $(MARIADB_DATA_DIR)/*
    @sudo rm -rf $(PORTAINER_DATA_DIR)/*
```
- logs: Displays the logs of all running Docker Compose services.
```makefile
logs:
    @docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) logs -f
```
3. Additional Targets
- create_dirs: Creates the necessary directories for data storage.
````makefile
create_dirs:
    @printf "Creating data directories...\n"
    @mkdir -p $(WORDPRESS_DATA_DIR)
    @mkdir -p $(MARIADB_DATA_DIR)
    @mkdir -p $(PORTAINER_DATA_DIR)
````
- make_dir_up: Launches Docker Compose services in detached mode.
```makefile
make_dir_up:
    @printf "Launching configuration ${name}...\n"
    @docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d
```
- make_dir_up_build: Builds and starts Docker Compose services in detached mode.
```makefile
make_dir_up_build:
    @printf "Building configuration ${name}...\n"
    @docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build
```
- Phony Targets
.PHONY: Specifies that these targets are not files but commands. It prevents Make from being confused by files with the same names.
```makefile
.PHONY: all build down re clean fclean logs create_dirs make_dir_up make_dir_up_build
```
### Summary
This Makefile provides a set of commands to manage Docker containers and volumes effectively. It simplifies the process of setting up, building, and cleaning up Docker services. With targets to create directories, start services, clean up data, and display logs, it ensures a streamlined workflow for managing the Inception project.

---

## Compile Inception

Clone the repo into the virtual machine as specified in this article [Setting up the system and the virtual machine](README.md#table-of-contents)

    https://github.com/Vikingu-del/Inception-Guide.git

Allow all the exposed ports for each service for example:

    iptables -A INPUT -p tcp --dport 8080 -j ACCEPT

To make it able to search by eseferi.42.fr (`eseferi` my username) change the dns by running 

    sudo echo "127.0.0.1   username.42.fr" >> /etc/hosts


run make

    make

Install firefox

    apk update && apk add firefox

Open the browser and type:

    https://username.42.fr

And have fun exploring.

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