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