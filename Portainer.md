# Guide how to set Portainer Docker Container
My choice on the extra service required by the subject

## Table Of Contents
- [What Is Portainer](#what-is-portainer)
- [Portainer Dockerfile](#portainer-dockerfile)
- [Setting Up Other Containers](#setting-up-other-containers)

---

## What Is Portainer

### Introduction
Portainer is a powerful, open-source management tool designed to simplify the management of Docker environments and Kubernetes clusters. It provides a user-friendly web interface that makes it easier for users to handle containerized applications and orchestrate services without needing extensive command-line knowledge.

### Core Features
1. User-Friendly Interface</br> Portainer offers an intuitive web-based graphical user interface (GUI) that allows users to manage Docker and Kubernetes environments effortlessly. This GUI provides access to various features and settings, making container management more accessible for users who prefer visual tools over command-line interactions.

2. Comprehensive Docker Management</br> With Portainer, users can manage Docker containers, images, networks, and volumes. It allows for quick deployment of containers, monitoring of container health, and easy management of Docker Compose stacks. This makes it a valuable tool for both development and production environments.

3. Kubernetes Integration</br> Portainer supports Kubernetes, allowing users to manage and deploy applications on Kubernetes clusters with ease. Users can handle Kubernetes resources like pods, services, and deployments directly from the Portainer interface.

4. Multi-Environment Support</br> Portainer can manage multiple Docker environments and Kubernetes clusters from a single interface. This centralized management capability simplifies operations across different environments and infrastructure setups.

5. Role-Based Access Control (RBAC)</br> Portainer offers role-based access control, allowing administrators to define user roles and permissions. This ensures that users have appropriate access levels based on their responsibilities, enhancing security and management efficiency.

6. Monitoring and Logs</br> Portainer provides monitoring features that display container resource usage and performance metrics. It also supports log management, allowing users to view and analyze container logs from within the Portainer interface.

7. Snapshot and Backup Management</br> Users can create snapshots and backups of their Docker and Kubernetes environments through Portainer. This feature helps in disaster recovery and ensures that configurations and data are protected.
8. Easy Installation and Setup</br> Portainer is designed to be easy to install and set up. It can be deployed as a Docker container itself, making it straightforward to integrate into existing Docker environments.

### Use Cases
1. Development Environments</br> Developers can use Portainer to quickly spin up and manage development containers, simplifying the process of testing and deploying applications.
2. Production Monitoring</br> Portainer's monitoring and logging features make it a valuable tool for maintaining and troubleshooting production environments.
3. Education and Training</br> Portainer's intuitive interface is beneficial for teaching and training purposes, helping newcomers learn about container management in a visual and interactive manner.
4. Operational Efficiency</br> For organizations with multiple Docker or Kubernetes environments, Portainer provides a centralized platform for managing and orchestrating services, improving operational efficiency.

### Conclusion
Portainer is a versatile management tool for Docker and Kubernetes, offering a user-friendly web interface to manage containerized applications and services. It simplifies the complexities of container management, supports multiple environments, and enhances operational efficiency through features like role-based access control, monitoring, and backup management. Whether for development, production, or training purposes, Portainer streamlines container management and orchestration, making it an invaluable tool for modern IT operations.

---

## Portainer Dockerfile

For the bonus services we will have to create another folder called bonus inside the requirements directory

    mkdir -p ~/Inception/src/requirements/bonus

And create inside the specific folder for portainer

    mkdir -p ~/Inception/src/requirements/bonus/portainer

Vim into the docker file

    vim ~/Inception/src/requirements/bonus/portainer/Dockerfile

And write the following content inside it:

```dockerfile
FROM alpine:3.19.2

RUN     apk update && \
                apk upgrade && \
                apk add --no-cache curl

WORKDIR /app

RUN curl -L https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz -o portainer.tar.gz \
    && tar xzf portainer.tar.gz \
    && rm portainer.tar.gz

# CMD ["sleep", "infinity"]
# # Expose the Portainer port (default is 9000)
EXPOSE 9443 8000 9000

# # Set the entry point to start Portainer
ENTRYPOINT ["./portainer/portainer"]
```

Explanation for each line:

1. Specify the Base Image

```dockerfile
FROM alpine:3.19.2
```

 This line specifies the base image for your Docker container. alpine:3.19.2 refers to Alpine Linux version 3.19.2, a lightweight and efficient Linux distribution known for its minimal size. Using a specific version ensures that your container environment remains consistent.

2. Updating the packages
```dockerfile
RUN apk update && \
    apk upgrade && \
    apk add --no-cache curl
```
- `apk update`: Updates the package index to ensure that the latest package versions are available.
- `apk upgrade`: Upgrades all installed packages to their latest versions.
- `apk add --no-cache curl`: Installs the `curl` utility without caching the intermediate package index files. `curl` is used to download files from the internet.

3. Setting the working directory
```dockerfile
WORKDIR /app
```
Sets the working directory inside the container to `/app`. All subsequent commands (like `RUN`, `COPY`, etc.) will be executed from this directory. This is useful for organizing files and ensuring that commands are run in the correct context.

5.  Download Portainer
```dockerfile
RUN curl -L https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz -o portainer.tar.gz \
    && tar xzf portainer.tar.gz \
    && rm portainer.tar.gz
```
- Uses `curl` to download the Portainer binary release from GitHub. The `-L` flag tells `curl` to follow any redirects.
- `-o portainer.tar.gz` saves the downloaded file as `portainer.tar.gz`.
- `tar xzf portainer.tar.gz` extracts the contents of the tarball.
- `rm portainer.tar.gz` removes the tarball file after extraction to save space.

6. Expose Ports
```dockerfile
EXPOSE 9443 8000 9000
```
This instruction informs Docker that the container will listen on ports 9443, 8000, and 9000. These ports are used by Portainer for its web interface and API. The EXPOSE instruction does not publish the ports but serves as documentation and allows networking between containers.

7. Set Entrypoint
```dockerfile
ENTRYPOINT ["./portainer/portainer"]
```
Sets the command that will be executed when the container starts. In this case, it runs the Portainer executable (./portainer/portainer). This is the main application that will run within the container, starting Portainer when the container is launched.

### Summary

This Dockerfile creates a container image for Portainer, using Alpine Linux as the base. It updates the package index, installs curl, downloads and extracts the Portainer binary, and sets up the container to expose necessary ports. The ENTRYPOINT is configured to run the Portainer application when the container starts. This setup provides a minimal and efficient way to deploy Portainer in a Docker environment.

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