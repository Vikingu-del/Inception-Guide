# Inception-Guide
Learn to set up Docker containers &amp; Nginx with Alpine Linux. Follow our step-by-step guide for a seamless setup process. Start hosting your apps confidently!

# Choosing between Alpin Linux and Debian

Based on the requirements and considerations outlined in the project specifications, the best choice in my opinion will be Alpin Linux. Here's why:

➊ Performance

    Alpine Linux is known for its small size and minimalistic approach, which results in smaller Docker images compared to Debian.
    Since performance matters are emphasized in project requirements, choosing Alpine can help optimize resource usage and improve
    container performance.
➋ Security

    Alpine Linux is designed with security in mind and has a smaller attack surface compared to Debian. This aligns well with the
    security considerations mentioned in the project requirements.
➌ Docker Image Building

    We are required to write our own Dockerfiles and build Docker images ourself. Alpine's simplicity and minimalism can make it
    easier to create lightweight and efficient Docker images.
➍ TLS Configuration with NGINX

    Our project requires setting up an NGINX container with TLSv1.2 or TLSv1.3 only. Since Alpine Linux provides NGINX packages and
    has a smaller footprint, it may be easier to configure and manage NGINX with Alpine.
➎ Volume and Network Configuration

    Alpine Linux support Docker volume and network configurations just like Debian, so there shouldn't be any significant differences
    in setting upvolumes and networks between the two distributions.
➏ Project Requirements

    Our project specifications do not explicitly favor Debian over Alpine or vice versa. Both distributions meet the project's
    requirments, but Alpine's smaller size, security features, and suitability for containerized environments make it a strong 
    candidate for this project.

Therefore, based on the outlined project requirements and considerations, Alpine Linux would be the recommended choice from my side to
use for your Docker containers.

# STEP1: Dowload the VirtualBox

If you do not have installed VirtualBox you can go at this link https://www.virtualbox.org/ and download it. We will need to use 
it to install the operating system we want to use.

In case you are using Ubuntu 22.04 and want to dowload it from terminal follow this lines to download:

➊ Update Package Lists</br>
Before installing any new software, it's a good idea to update your package lists to ensure you get the latest versions of available software.

    sudo apt update

➋ Install Required Dependencies</br>
VirtualBox requires some dependencies to be installed. Run the following command to install them:

    sudo apt install build-essential dkms linux-headers-$(uname -r)

➌ Add VirtualBox Repository</br>
Next, add the VirtualBox repository to your system. This is necessary to get the latest version of VirtualBox.

    sudo add-apt-repository multiverse

➍ Download and Import Oracle public key

    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc

➎ Move the key to the trusted keyring directory

    sudo mv oracle_vbox_2016.asc /etc/apt/trusted.gpg.d/

➏ Add VirtualBox Repository

    sudo add-apt-repository "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"

➐ Update Package Lists

    sudo apt update

➑ Install VirtualBox

    sudo apt install virtualbox

➒ Optional: Install VirtualBox Extension Pack

    wget https://download.virtualbox.org/virtualbox/6.1.30/Oracle_VM_VirtualBox_Extension_Pack-6.1.30.vbox-extpack
sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.1.30.vbox-extpack

Start VirtualBox

    virtualbox

If it doesn't accept the command type

    sudo apt install virtualbox-qt

And the you can start virtual from terminal

    virtualbox

# STEP2: Install Alpin

➊ Download Alpine Linux ISO</br>

	Go to the Alpine Linux downloads page where we have the release branches: https://alpinelinux.org/releases/, so we can dowload 
	the penultimate stable version of Alpine Download the ISO image suitable for your VirtualBox virtual machine (e.g., x86_64).
	The penultimate stable version means not the last stable version but the second stable version.
![Click the penulminate bersion](photos/InstallAlpin/3.18-stable.png)

➋ So now we go here https://alpinelinux.org/downloads/ scroll down in the end of the page and click at "Older releases are found <u>here</u>"

![Click here](photos/InstallAlpin/Clickhere.png)

➌ Since we saw that the latest stable version was 3.18 we click on that

![Choose 3.18](photos/InstallAlpin/Prenimableversion.png)

➍ Within the "release/" directory, you'll find what we need.

![Click on release](photos/InstallAlpin/ClickOnRelease.png)

➎ Look for the appropriate subdirectory containing the packages for the x86_64 architecture. (Well this is mos suitable in my case).

![alpin architectur](photos/InstallAlpin/x86_64.png)

➏ You'll see a list of files corresponding to different Alpine Linux packages. Look for the ISO image file, which typically has a name 
like "alpine-virt-3.18.0-x86_64.iso  " or similar.
alpine-virt-3.18.0-x86_64.iso   - This is the standard edition of Alpine Linux version 3.18 for x86_64 architecture. It is a 190MB ISO file.

![Download iso image](photos/InstallAlpin/DownloadIsoImage.png)

➌ Virtualbox setting up

Open virtualbox and press ate the New section

![press New](photos/InstallAlpin/pressNew.png)

It will open a window where you have to fill the filds for the name and OS like below and press 
continue

![Name and operating system](photos/InstallAlpin/NameAndOs.png)

Now it will require the memory to allocate.
We'll need to allocate memory within VirtualBox for our virtual machine. Here's a summary:

-NGINX Container: Allocate between 128MB to 256MB of memory.</br>
-WordPress Container: Allocate between 512MB to 1GB of memory.</br>
-MariaDB Container: Allocate between 256MB to 512MB of memory.</br>
-Considering these recommendations and the overall memory requirements, you'll need at least 1GB to 2GB of memory for your virtual machine in total. This should provide enough resources for Inception project, assuming a relatively small to medium workload.

In VirtualBox, you can allocate memory when creating a new virtual machine or adjust it later in the 
virtual machine settings. Aim for a total allocation that is within the range mentioned above and 
fits your available system resources on your Pc. Adjustments can always be made based on performance 
and resource usage during testing and deployment.

![Choose RAM memory](photos/InstallAlpin/memorySize.png)

Choose Create a virtual hard disk now

![Create virtual hard disk now](photos/InstallAlpin/CreateAVirtualHardiskNow.png)

Choose first option since we downloaded an ISO file

![Dynamically allocated](photos/InstallAlpin/DymaicAllocated.png)

For Hard Disk Memory 30 GB is more than enough for this project

![Hard Disk Memory](photos/InstallAlpin/HardDiskMemory.png)

Now you should see something like below

![VB inception view](photos/InstallAlpin/Inception.png)

Now we have to choose the disk file we downloaded by going to 1.settings, 2.storage 3.Empty and at the atributes we click at the disk icon and click choose disk file

![Choose a disk file](photos/InstallAlpin/ChooseDiskFile.png)

Choose the alpin disk image we dowloaded in the beggining

![Choose alpin disk image file](photos/InstallAlpin/AlpinDiskImage.png)

In the image above there is the latest image iso, but I changed that later as I explained
previosly in this tutorial, depended from the time you are doing this project you have to choose always
the second latest stable version starting with virt for your virtual machine.

Start Machine

![Start Machine](photos/InstallAlpin/StartMachine.png)

Press Start

![Start](photos/InstallAlpin/Start.png)

when it oppen the screen it will ask for the local host login where you initially have to put root

![Type root](photos/InstallAlpin/typeroot.png)

Use the setup-alpine command to configure Alpine Linux after installation
It will first ask for keyboard layout. Choose us and then again us

![Choose keyboard layout](photos/InstallAlpin/KeyboardLayout.png)

After it will promt asking for the Hostname and the interface, and if we want to do any manual configuration of the network which we will put no
because nothing is not required. Choose for hostname eseferi.42.fr. Follow the example below:

![Hostname and Interface](photos/InstallAlpin/interface.png)

A new password is required for the root, and confirmation for it

![Password](photos/InstallAlpin/password.png)

TimeZone is required, since I'm in Germany I typed Europe and then Berlin

![TimeZone](photos/InstallAlpin/TimeZone.png)

Then it will be the sections of Proxy, Network Time Protocol and APK Mirror every default is ok so proceed by typing enter for each one of them 

![Proxy, Network Time Protocol and APK Mirror](photos/InstallAlpin/APKmirror.png)

If you have something like the format below for the mirror 

![mirrors](photos/InstallAlpin/mirror.de.leaseweb.net.png)

you can type more and choose f which means Detect and add fastest mirror from above list

![fastest mirror](photos/InstallAlpin/fasterstmirror.png)

Follow like below for the user section

![User](photos/InstallAlpin/User.png)

Add disk section we will type sda and that we would like to use it as sys, so we can use the disk as the root filesystem. This option will 
set up the disk in a traditional manner suitable for a small infrastructure composed of different services as specified in the project requirements.

![Disk](photos/InstallAlpin/DiskandInstall.png)

Remove first the iso file before reboot so it will reboot base on what we did not based on the ISO image file

![Remove iso file](photos/InstallAlpin/RemoveIsoFile.png)

After type Reboot and you shoould see and sign in like below, with user and the password we set before

![sign in](photos/InstallAlpin/eseferi42.png)

Now lets install doas (is replacement for sudo comand) and configure it if you want to configure. or if you want sudo follow the next foto

	apk update - update the package index to ensure you get the latest version of sudo
	apk add doas - install doas
	vi /etc/doas.conf

![Doas configuration](photos/InstallAlpin/Doas.png)

	vi /etc/apk/repositories
	Uncomment alpine.mirror.wearetriple. om/v3/18/community

![Uncomment alpine.mirror.wearetriple. om/v3/18/community](photos/InstallAlpin/uncomment_communityline.png)

	apk update
	apk add sudo

Installatation and Configuration of SSH

🔒 SSH, or Secure Shell, is both a protocol and a program used for remote access to servers. It establishes a secure channel, encrypting all data exchanged between the client and server. This ensures confidentiality and integrity, making SSH a vital tool for secure remote administration and file transfer. It is installed by default from the installation, also OpenSSh.

Now we have to eddit with vi or if you want nano firs

	sudo apk update
	sudo apk add nano
	sudo nano /etc/ssh/sshd_config

Or if you want with vi
	sudo vi /etc/ssh/sshd_config 
	
provided by OpenSSH to this link
https://exampleconfig.com/view/openssh-alpine3-etc-ssh-sshd_config. if it is empty 
try to reinstall openssh with this command 

	sudo apk add --force openssh

After opening the file we should uncomment the port and make it 4242 and uncomment PermitRootLogin and set it to no

![Configure sshd_config](photos/InstallAlpin/Uncommentport.png)

Now we must edit the file /etc/ssh/ssh_config by uncommenting the port

	sudo vi /etc/ssh_config/
	
![Configure ssh_config](photos/InstallAlpin/ConfigureSsh_config.png)

Finally we need to restart the ssh service 

	sudo rc-service sshd restart

![restart sshd](photos/InstallAlpin/restartssh.png)

To check if it is listening from 4242 we can see with this command

	netstat -tuln | grep 4242

![Listening in port 4242](photos/InstallAlpin/Listeningfrom42.png)

Now lets go and add the port 4242 to our vm

![Add port on vm](photos/InstallAlpin/ADDportonVM.png)

And press on the button to add a port

![port 4242 added](photos/InstallAlpin/4242added.png)

Now lets connect with ssh from our terminal. Open terminal and type

	ssh localhost -p 4242

![Connect with local host](photos/InstallAlpin/sshlocalhostconnection.png)

If you instead get an error like this below

![Error ssh](photos/InstallAlpin/errorssh.png)

Go and type in the terminal 

	nano ~/.ssh/known_hosts

And delite the line that start with local host

![Delete line that start with host](photos/InstallAlpin/linetodelete.png)

save and try again

	ssh localhost -p 4242

![Fixed ssh error](photos/InstallAlpin/savedsshconnect.png)

Super you are connected now lets continue with the next steps.

Now I suggest to you before continuing to the next step to research a little bit for docker containers at this link https://docs.docker.com/manuals/.

![Docker guide](photos/InstallDocker/Dockerguide.png)

# STEP2: Install Docker and Docker Compose

A little bit of theory now:

### Docker

Docker is a platform as a service (PaaS) tool that utilizes OS-level virtualization to deploy software in containers. These containers are lightweight and allow applications to operate efficiently in diverse environments, isolated from one another.

### Background

Containers encapsulate their own software, libraries, and configuration files, communicating through well-defined channels while sharing the services of a single operating system kernel. This shared kernel reduces resource usage compared to traditional virtual machines.

### Operation

Docker utilizes various interfaces to access Linux kernel virtualization features. It packages applications and dependencies into virtual containers that can run on Linux, Windows, or macOS, enabling flexibility in deployment locations. Resource isolation features like cgroups and kernel namespaces allow containers to run within a single Linux instance.

### Components

The Docker software offering comprises:

1. Software
Docker daemon (dockerd) manages containers and handles container objects, while the Docker client (docker) provides a command-line interface (CLI) for user interaction.

2. Objects
Docker objects include images, containers, and services, providing a standardized environment for running applications.

		Docker containers are encapsulated environments for running applications, managed via the Docker API or CLI.

		Docker images are read-only templates used to build containers.

		Docker services enable scaling across multiple Docker daemons, forming a swarm of cooperating daemons.

		Registries: Docker registries store and distribute Docker images, with Docker Hub being the primary public registry. Registries allow for image download ("pull") and upload ("push") operations.

### Tools

1. Docker Compose: Defines and runs multi-container Docker applications using YAML configuration files. It simplifies container creation and startup processes.

2. Docker Swarm: Provides native clustering functionality for Docker containers, turning multiple Docker engines into a single virtual Docker engine.

3. Docker Volume: Facilitates data management for Docker containers, enabling data persistence and sharing between containers.

First update Alpine, if you downloaded and using sudo you can use sudo instead of doas

![Update and upgrade apk](photos/InstallDocker/upgradeapk.png)

Go sudo nano /etc/apk/repositories and uncomment the commented repos 



Install Docker and Docker Compose

	sudo apk add docker docker-compose

![Uncomment the repos](photos/InstallDocker/uncomment_repos.png)

apk update
If you want to understand why we uncomented the repos read this note below taken from this website https://docs.genesys.com/Documentation/System/latest/DDG/InstallationofDockeronAlpineLinux

![note](photos/InstallDocker/note.png)

run

	sudo apk add --update docker openrc

![Install docker](photos/InstallDocker/rundDockeropenrc.png)

To start the Docker daemon at boot, run

	sudo rc-update add docker boot

or

	rc-update add docker default

Execute 

	service docker status 
	
to ensure the status is running. If it is stoped type

	sudoe service docker start

and check again 

	service docker status

Connecting to the Docker daemon through its socket requires you to add yourself to the docker group

	sudo addgroup username docker

To use Docker Compose, we have to install it:

	sudo apk add docker-cli-compose

![install docker compose](photos/InstallDocker/installdockercompose.png)

Naming Docker Images and Services:

Each Docker image must have the same name as its corresponding service. For example, if you have a service named nginx, the Docker image for that service should also be named nginx.


Based on project guidelines, it's better to set up MariaDB first before setting up NGINX and the other services. Here's why:

#### Dependency Order

MariaDB is a fundamental component as it serves as the database backend for your WordPress website. Therefore, it makes sense to set up the database first before configuring other services that rely on it.

#### Data Volume

You need to set up volumes for the WordPress database and website files. Since MariaDB manages the database, you should create the volume for the database first to ensure it's properly configured and accessible before configuring the volume for the website files.

#### Configuration Interdependencies

Configuring MariaDB may require specific settings or initializations that could be referenced or utilized by other services like NGINX or WordPress. By setting up MariaDB first, you ensure that these configurations are in place before configuring other services.

Therefore, the suggested order would be:

1. Set up MariaDB.
2. Set up NGINX.
3. Set up WordPress and other services (if applicable), ensuring they are configured to interact with MariaDB as needed.
4. Configure volumes for the database and website files accordingly.

## Some Research

<h3>What is Docker file?</h3>
<p>
	The Dockerfile employs DSL (Domain Specific Language) and comprises directives for building a Docker image. It delineates the steps to efficiently craft an image. When developing your application, ensure the Dockerfile's sequence aligns with the Docker daemon's execution, as it processes instructions sequentially, from top to bottom
</p>
<h3>What is Docker Image?</h3>
<p>
	An artifact representing multiple layers and serving as a lightweight, self-contained executable package is referred to as a Docker image. It encapsulates all necessary components to execute software, encompassing the code, runtime, libraries, environment variables, and configuration files.
</p>
<h3>What is Docker Container?</h3>
<p>
	A container is a live instance of a Docker image at runtime. It operates as an isolated environment, containing all the dependencies and configurations required for the application it hosts. Containers streamline both development and deployment processes, enhancing efficiency by ensuring the application runs independently from the host environment.
</p>

### Dockerfile Commands/Instructions

1. **FROM**
	- Represents the base image(OS), which is the command that is executed first before any other commands.
	- **Syntax:**
		```
		FROM <ImageName>
		```
	- **Example:** 
		The base image will be alpine: 3.18 Operating System.
		```
		FROM alpine: 3.18
		```

2. **COPY**
	- The COPY command in Dockerfile is utilized to copy files or directories from the host machine into the Docker image during the build process.
	- **Syntax:**
		```
		COPY <Source> <Destination>
		```
	- **Example:**
		Let's say we have a custom configuration file called "nginx.conf" located in the "conf" directory of our project. We want to include this configuration file into our NGINX Docker image:
		```
		COPY conf/nginx.conf /etc/nginx/nginx.conf
		```

3. **ADD**
	- The ADD command in Dockerfile serves the purpose of downloading files from remote HTTP/HTTPS sources and adding them to the Docker image during the build process.
	- **Syntax:**
		```
		ADD <URL>
		```
	- **Example:**
		Suppose we need to include the WordPress installation package directly from its official website into our Docker image:
		```
		ADD https://wordpress.org/latest.tar.gz /var/www/html/wordpress.tar.gz
		```
	- In this example:
		- "https://wordpress.org/latest.tar.gz" is the URL of the latest WordPress installation package.
		- "/var/www/html/wordpress.tar.gz" is the destination path within the Docker image where we want to store the downloaded WordPress package.

4. **RUN**
	- The RUN command in Dockerfile enables us to execute shell commands and scripts during the image build process. These commands are executed within the container environment, allowing us to perform various tasks like installing packages, configuring software, or setting up the environment.
	- **Syntax:**
		```
		RUN <Command + ARGS>
		```
	- **Example:**
		Suppose we need to install necessary software dependencies for our Alpine-based MariaDB container:
		```
		RUN apk update && apk add --no-cache mariadb mariadb-client
		```
	- In this example:
		- "apk update" updates the package index before installing.
		- "apk add --no-cache" installs MariaDB server and MariaDB client without caching the index and keeping the image size minimal.

5. **CMD**
	- The CMD instruction in a Dockerfile defines the default command to be executed when the container starts. It specifies the executable and any arguments that should be passed to it. If a Docker container is started without specifying a command, the command specified by CMD will be executed by default.
	- **Syntax:**
		```
		CMD [command + args]
		```
	- **Example:**
		Let's say we want to set the default command for a container running a custom Python script:
		```
		CMD ["python", "app.py"]
		```
	- In our project, to specify the default command for starting the MariaDB server:
		```
		CMD ["mysqld", "--user=mysql", "--init-file=/tmp/init.sql"]
		```
	- This command starts the MariaDB server with the specified options and initializes it with the SQL commands provided in the init.sql file.

6. **ENTRYPOINT**
	- The ENTRYPOINT instruction in a Dockerfile configures a container to run as an executable. When a Docker container is started, the command or script specified by ENTRYPOINT is executed. Unlike CMD, the command specified by ENTRYPOINT cannot be overridden by specifying a command at runtime.
	- **Syntax:**
		```
		ENTRYPOINT [command + args]
		```
	- **Example:**
		For instance, to configure a container to run a custom script named run.sh:
		```
		ENTRYPOINT ["./run.sh"]
		```
	- In our project, to define the entrypoint for starting the MariaDB server:
		```
		ENTRYPOINT ["mysqld"]
        ```

7. **MAINTAINER**
	- The MAINTAINER command in a Dockerfile allows us to specify the author or owner of the Dockerfile.

	- **Syntax:** 
		```
		MAINTAINER <AuthorName>
		```
  
	- **Example:** 
		Setting the author for the image.
		```
		MAINTAINER Erik <eseferi.student@42wolfsburg.de>
		```


## Write the Dockerfile for MariaDB:

Create a file named Dockerfile in a directory called mariadb. This file will contain instructions for building the MariaDB image. Here's a basic example:

Install MariaDB
Go to home directory and inside the user create a folder inception and inside we will create the folder src and and the Makefile

	sudo mkdir inception

Inside Inception go and create all the folders and files inside exactly in the same way as described in the subject, meaning also their rights.

![Project structure](photos/InstallDocker/MariaDb/projectstructure.png)

1. Which means inside the root directory which I choosed home inside my VM:

	sudo mkdir srcs && sudo touch Makefile
		
2. Navigate to srcs 

		cd srcs && sudo touch docker-compose.yml .env  && sudo mkdir requirements

3. Navigate to requirements

		cd requirements && sudo mkdir bonus mariadb nginx tools wordpress

4. Inside MariaDB

		cd mariadb && sudo mkdir conf tools && sudo touch Dockerfile .dockerignore

5. Inside nginx

		cd ../nginx && sudo mkdir conf tools && sudo touch Dockerfile .dockerignore

 6. We navigate back and check if the structure is the same

		cd ../../../ && ls -alR

If you can see everything is structured in the way it should be, except that the rights of the directories and files are not the same as in the subject lets go and change them:

Changing Owner and Permissions

1. Change Owner

		sudo chown -R eseferi:eseferi srcs
		sudo chown -R eseferi:eseferi .
		sudo chown -R eseferi:eseferi ..

2. Change Permissions

		sudo chmod 775 .
		sudo chmod 1777 ..
		sudo chmod 664 Makefile
		sudo chmod 775 srcs

Explanation
Change Owner:

The first three commands change the owner and group of directories.
sudo chown -R eseferi:eseferi srcs: Changes ownership of srcs directory.
sudo chown -R eseferi:eseferi .: Changes ownership of the current directory and its contents.
sudo chown -R eseferi:eseferi ..: Changes ownership of the parent directory and its contents.
Change Permissions:

The next commands adjust directory and file permissions.
sudo chmod 775 .: Sets permissions of the current directory to allow read, write, and execute for the owner and group, and read and execute for others.
sudo chmod 1777 ..: Sets permissions of the parent directory with a sticky bit, allowing only the owner or root to delete or rename files.
sudo chmod 664 Makefile: Sets permissions of the Makefile to allow read and write for the owner and group, and read-only for others.
sudo chmod 775 srcs: Sets permissions of the srcs directory to allow read, write, and execute for the owner and group, and read and execute for others.

![Change ownership and rights of the file](photos/InstallDocker/MariaDb/Changeownership.png)

The same you did here navigate to all the files and directory and change the ownerships and the rights of the file.

![The way to structure the directories and files](photos/InstallDocker/MariaDb/Followcommandstostructure.png)

So now we should have a final look like below:

![Final look of the structure](photos/InstallDocker/MariaDb/finallook.png)

Navigate to the Docker file inside mariadb And write:

	# Use the specified version of Alpine
	FROM alpine:3.18

	# Set the maintainer
	LABEL maintainer="Erik <rk.seferi@gmail.com> "

	# Install MariaDB
	RUN apk update && apk --no-cache add mariadb mariadb-client

	# Copy the custom configuration files
	COPY conf/my.cnf /etc/mysql/my.cnf
	COPY conf/init.sql /tmp/init.sql

	# Expose the default MySQL port
	EXPOSE 3306

	# Define the entry point
	CMD ["mysqld", "--user=mysql", "--init-file=/tmp/init.sql"]

![Write inside dockerfile inside mariadb](photos/InstallDocker/MariaDb/nanoDockerfilemariadb.png)


	FROM alpine:3.18: This line specifies the base image for your Docker container. In this case, it pulls the Alpine Linux image with version 3.18 from the Docker Hub registry. Alpine Linux is a lightweight Linux distribution, and version 3.18 is the specific version chosen for this Docker image.

	LABEL maintainer="Erik <rk.seferi@gmail.com>": This line sets metadata for the Docker image. It adds a label indicating the maintainer of the image, which is typically the person responsible for maintaining and updating the image. In this case, the maintainer is specified as "Erik" with the email address "rk.seferi@gmail.com".

	RUN apk update && apk --no-cache add mariadb mariadb-client: This line executes commands during the Docker image build process. It uses the apk package manager, which is specific to Alpine Linux, to update the package repository (apk update) and then install the mariadb and mariadb-client packages without caching (--no-cache). This command installs MariaDB server and client tools into the Docker image.

	COPY conf/my.cnf /etc/mysql/my.cnf: This line copies a file from the host machine into the Docker image. It takes the my.cnf file located in the conf directory of your project on the host machine and places it into the /etc/mysql directory within the Docker image. The my.cnf file typically contains custom configurations for MariaDB.

	COPY conf/init.sql /tmp/init.sql: Similar to the previous line, this line copies the init.sql file from the host machine into the Docker image. It places the file into the /tmp directory within the Docker image. The init.sql file usually contains SQL statements that will be executed when MariaDB starts up for the first time.

	EXPOSE 3306: This line informs Docker that the container will listen on port 3306 at runtime. However, it doesn't actually publish the port. It's more of a documentation to let users know which ports are intended to be exposed.

	CMD ["mysqld", "--user=mysql", "--init-file=/tmp/init.sql"]: This line specifies the default command to run when the container starts. It starts the MariaDB server (mysqld) with the specified options (--user=mysql for running as the MySQL user and --init-file=/tmp/init.sql to execute the initialization SQL script). This command initializes MariaDB with custom settings from the init.sql file.

	These lines collectively define the Dockerfile for building a Docker image that includes MariaDB server with custom configurations and initialization script, based on Alpine Linux version 3.18.

Lets create the conf directory

	cd mariadb
	sudo mkdir conf

Edit my.cnf like below

	sudo nano conf/my.cnf
	

![Edit my.cnf](photos/InstallDocker/MariaDb/nanoConfMy.conf.png)

Let's go through each line:
1. [client-server]:

	This is a section header in the MySQL/MariaDB configuration file, indicating that the following configurations are relevant to both the MySQL/MariaDB client and server.

socket=/var/lib/mysql/mysql.sock

	This line specifies the location of the Unix socket file that the MySQL/MariaDB client and server use for local connections. The Unix socket allows communication between the client and server processes on the same machine.

port=3306

	This line specifies the port number on which the MySQL/MariaDB server listens for incoming connections. By default, MySQL/MariaDB uses port 3306 for TCP connections.

2. [mysqld]

	This is another section header, indicating that the following configurations are specific to the MySQL/MariaDB server daemon (mysqld).

bind-address=0.0.0.0

	This line specifies the network interface IP address to which the MySQL/MariaDB server should bind. In this case, 0.0.0.0 means the server will listen on all available network interfaces.

skip-networking=false

	This line specifies whether networking support is enabled for the MySQL/MariaDB server. When set to false, it means networking support is enabled, allowing the server to accept remote connections over the network.

datadir=/var/lib/mysql

	This line specifies the directory where MySQL/MariaDB stores its data files, including databases and tables. By default, the data directory is /var/lib/mysql.

3. [mariadb]

	This is a section header specific to MariaDB, indicating that the following configurations are relevant to MariaDB-specific settings.

log_warnings=4
	This line specifies the level of verbosity for logging warnings in MariaDB. In this case, 4 indicates a high level of verbosity, meaning more detailed warnings will be logged.

log_error=/var/log/mysql/mariadb.err
	This line specifies the path to the error log file for MariaDB. Any errors encountered by the MariaDB server will be logged to this file located at /var/log/mysql/mariadb.err.

These configurations help define the behavior of the MySQL/MariaDB client and server, including how they communicate, where data is stored, and how logging is handled. They are essential for ensuring the proper functioning and management of the MySQL/MariaDB database server.
	
<b><i>Now lets edit conf/init.sql file</i></b>	
	
	sudo nano conf/init.sql

Edit the file like below

![Edit init.sql](photos/InstallDocker/MariaDb/nanoInitsql.png)

<p>The init.sql file contains SQL commands that are executed when the MariaDB server container starts up. Let's break down each line:</p>

1. USE mysql;: This line specifies that subsequent SQL commands will be executed in the context of the mysql database. It ensures that the following commands apply to the mysql system database, which stores user accounts, privileges, and other administrative information.

2. CREATE DATABASE IF NOT EXISTS wordpress;: This command creates a new database named wordpress if it doesn't already exist. The IF NOT EXISTS clause ensures that the database is only created if it doesn't already exist.

3. CREATE USER IF NOT EXISTS 'wordpress'@'%' IDENTIFIED BY 'secret';: This command creates a new user named wordpress with the password 'secret' who is allowed to connect from any host ('%'). The IF NOT EXISTS clause ensures that the user is only created if they don't already exist.

4. GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';: This command grants all privileges on the wordpress database to the wordpress user from any host ('%'). This allows the wordpress user to perform any operation on the wordpress database.

5. FLUSH PRIVILEGES;: This command reloads the grant tables, applying any changes made to user privileges immediately. It ensures that the privileges granted to the wordpress user take effect immediately.

6. ALTER USER 'root'@'localhost' IDENTIFIED BY 'wordpress';: This command changes the password for the root user when connecting from localhost to 'wordpress'. This is typically done for security reasons, ensuring that the default root password is not used and is replaced with a more secure password.

<p>Overall, the init.sql file initializes the MariaDB server by creating a database for WordPress, creating a user with appropriate privileges to access that database, and ensuring that the necessary privileges are granted and applied immediately. Additionally, it updates the password for the root user for improved security. </p>