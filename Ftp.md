# Guide how to set FTP Docker Container

## Table Of Contents
- [What Is FTP](#what-is-ftp)
- [FTP Dockerfile](#ftp-dockerfile)
- [Ftp Configuration Files](#ftp-configuration-files)
- [Ftp Entrypoint Script](#ftp-entrypoint-script)
- [Setting Up Other Containers](#setting-up-other-containers)

---

## What Is FTP

### Introduction
File Transfer Protocol (FTP) is one of the oldest and most widely used protocols for transferring files over the internet. It allows users to upload, download, and manage files on remote servers. FTP is a client-server protocol, which means it requires a client to initiate a connection to a server to transfer files.

### History and Evolution
FTP was developed in the early 1970s, making it one of the first protocols used for data transfer. Initially, it was designed to facilitate file sharing between computers on the ARPANET, the precursor to the modern internet. Over the years, FTP has evolved, incorporating new features and improvements to enhance security and functionality.

### How FTP Works

FTP operates on a client-server model. Here’s a simplified breakdown of how it works:

1. Connection Establishment</br> The client initiates a connection to the FTP server using an FTP client application.
2. Authentication</br> The server requires the client to authenticate, usually with a username and password.
3. Commands and Responses</br> The client sends FTP commands to the server, and the server responds accordingly. Common commands include LIST to list files, RETR to retrieve files, and STOR to store files.
4. Data Transfer</br> Files are transferred between the client and server using either the active or passive mode. In active mode, the server initiates the data connection to the client, whereas in passive mode, the client initiates the data connection to the server.
5. Connection Termination</br> Once the file transfer is complete, the client closes the connection.

### Key Features of FTP
- Authentication</br> FTP supports both anonymous and authenticated access. Anonymous access allows users to connect without a username and password, while authenticated access requires valid credentials.
- File Operations</br> FTP allows a variety of file operations, including uploading, downloading, renaming, deleting, and changing file permissions.
- Directory Navigation</br> Users can navigate the directory structure on the server, similar to how they would on a local file system.
- Transfer Modes</br> FTP supports two transfer modes: ASCII mode for text files and binary mode for non-text files.

### Security Considerations
While FTP is widely used, it has several security limitations:
- Plain Text Transmission</br>Traditional FTP transmits data, including usernames and passwords, in plain text, making it vulnerable to interception.
- No Encryption</br>FTP does not provide built-in encryption, leaving data exposed during transfer.

To address these issues, secure variants of FTP have been developed:
- FTPS (FTP Secure)</br>FTPS adds support for SSL/TLS encryption, providing a secure channel for data transfer.
- SFTP (SSH File Transfer Protocol)</br>SFTP, often confused with FTP, is actually a different protocol that operates over the SSH (Secure Shell) protocol, providing secure file transfer.

### Common Uses of FTP
- Website Management</br>Web developers use FTP to upload and manage website files on web servers.
- File Sharing</br>Organizations use FTP to share large files that are not suitable for email.
- Backup and Synchronization</br>FTP is used to back up data and synchronize files between local and remote systems.

### Popular FTP Clients and Servers
- Clients

    - FileZilla</br> A popular, open-source FTP client with a user-friendly interface.
    - Cyberduck</br> A versatile client that supports FTP, SFTP, and other protocols.
    - WinSCP</br> A Windows-based client that supports FTP, SFTP, and SCP.

- Servers
    
    - vsftpd</br> A secure and fast FTP server for Unix-based systems.
    - ProFTPD</br> A highly configurable FTP server with a modular design.
    - FileZilla Server</br> An open-source FTP server for Windows.

In our Inception project we are going to use vsftpd.

### Conclusion
FTP remains a vital tool for file transfer, despite its age and security limitations. Understanding its basic principles and secure alternatives can help users and organizations efficiently and safely transfer files across the internet. Whether you're managing a website, sharing files, or performing backups, FTP and its secure variants continue to be reliable solutions for data transfer needs.

---

## FTP Dockerfile

For the bonus services we will have to create another folder called bonus inside the requirements directory

    mkdir -p ~/Inception/src/requirements/bonus

And create inside id the specific folder for FTP

    mkdir -p ~/Inception/src/requirements/bonus/ftp

Vim into the docker file

    vim ~/Inception/src/requirements/bonus/ftp/Dockerfile

And write the following content inside it:

```dockerfile
FROM alpine:3.19.2

RUN apk update && \
    apk add --no-cache vsftpd

# Copy entrypoint script and configuration file
COPY tools/ftp-entrypoint.sh /usr/local/bin/ftp-entrypoint.sh
COPY conf/vsftpd.conf /tmp/vsftpd.conf

# Set permissions
RUN chmod +x /usr/local/bin/ftp-entrypoint.sh

ENTRYPOINT ["ftp-entrypoint.sh"]
```

Explanation for each line:

1. Specify the Base Image

```dockerfile
FROM alpine:3.19.2
```

This line specifies the base image for your Docker container. alpine:3.19.2 refers to Alpine Linux version 3.19.2, a lightweight and efficient Linux distribution known for its minimal size. Using a specific version ensures that your container environment remains consistent.

2. Run Command
```dockerfile
RUN apk update && \
    apk add --no-cache vsftpd
```
- `RUN apk update`: This updates the package index in the Alpine Linux package manager (apk), ensuring it has the latest information about available packages.
- `apk add --no-cache vsftpd`: This installs the vsftpd package, which is a secure and fast FTP server. The `--no-cache` option prevents the caching of the package index, reducing the size of the Docker image.

3. Copying the configuration files and executable scripts
```dockerfile
COPY tools/ftp-entrypoint.sh /usr/local/bin/ftp-entrypoint.sh
COPY conf/vsftpd.conf /tmp/vsftpd.conf
```
- `COPY tools/ftp-entrypoint.sh /usr/local/bin/ftp-entrypoint.sh`: This copies the `ftp-entrypoint.sh` script from the tools directory on the host machine to `/usr/local/bin/` inside the container. The script will be used as the entry point for the container.
- `COPY conf/vsftpd.conf /tmp/vsftpd.conf`: This copies the `vsftpd.conf` configuration file from the `conf` directory on the host machine to the `/tmp` directory inside the container. This file contains the configuration settings for the `vsftpd FTP server`.

4. Set permissions
```dockerfile
RUN chmod +x /usr/local/bin/ftp-entrypoint.sh
```

`RUN chmod +x /usr/local/bin/ftp-entrypoint.sh`: This changes the permissions of the `ftp-entrypoint.sh` script to make it executable. The `+x` flag adds the execute permission to the script.

5. Set the entrypoint script
```dockerfile
ENTRYPOINT ["ftp-entrypoint.sh"]
```
`ENTRYPOINT ["ftp-entrypoint.sh"]`: This sets the `ftp-entrypoint.sh` script as the entry point for the container. When the container starts, it will execute this script. The entry point script typically contains commands to initialize and run the main application or service in the container, in this case, the `vsftpd FTP server`.


### Summary

This Dockerfile sets up an FTP server using vsftpd on Alpine Linux. It performs the following steps:
- Uses Alpine Linux 3.19.2 as the base image for its lightweight and efficient characteristics.
- Updates the package list and installs the vsftpd package without caching the package index to keep the image size small.
- Copies an entrypoint script and a configuration file into the container.
- Sets the entrypoint script as executable to ensure it can be run when the container starts.
- Defines the entrypoint script to be executed upon container start, allowing for necessary setup and configuration of the vsftpd server.
- This setup ensures a lightweight, efficient, and properly configured FTP server running in a containerized environment.

---

## Ftp Configuration Files

### Why we need a configuration file

A configuration file is essential for the proper operation and customization of the FTP server. It allows administrators to define the behavior, security, and features of the server. With a configuration file, you can specify various settings such as user permissions, logging, file transfer modes, and more. This ensures that the server runs according to your specific requirements and security policies.

### Prepare the configuration file

Create the conf directory inside ftp

    mkdir -p ~/Inception/srcs/requirements/ftp/conf

Vim into vsftpd.conf inside conf directory

    vim ~/Inception/srcs/requirements/ftp/conf/vsftpd.conf

To see what I have written inside go and check this file [vsftpd.conf](Inception/srcs/requirements/bonus/ftp/conf/vsftpd.conf) since is to long alongside with the comments. </br>
We can still check what is active by cating inside and greping all the lines which are not comments by this command

    cat ~/Inception/src/requirements/bonus/ftp/conf/vsftpd.conf | grep ^[^#] 

And we will see this lines 

    anonymous_enable=YES
    local_enable=YES
    write_enable=YES
    dirmessage_enable=YES
    xferlog_enable=YES
    connect_from_port_20=YES
    ftpd_banner=Welcome to FTP server of inception!
    chroot_local_user=YES
    allow_writeable_chroot=YES
    user_sub_token=$USER
    local_root=/var/www/html
    listen=YES
    listen_port=21
    listen_address=0.0.0.0
    seccomp_sandbox=NO
    pasv_enable=YES
    pasv_min_port=21000
    pasv_max_port=21010
    userlist_enable=YES
    userlist_file=/etc/vsftpd.userlist
    userlist_deny=NO

Explanation for each line in the vsftpd.conf file:

1. `anonymous_enable=YES`: Allows anonymous FTP access, meaning users can log in without a username and password. This can be useful for public file sharing but poses a security risk.

2. `local_enable=YES`: Allows local system users to log in to the FTP server using their username and password.

3. `write_enable=YES`: Enables FTP commands that change the filesystem, such as upload, delete, and rename. This is necessary for users to upload files or make changes to existing files on the server.

4. `dirmessage_enable=YES`: Enables directory-specific messages. When a user enters a directory, a message from a .message file within that directory is displayed.

5. `xferlog_enable=YES`: Enables logging of file uploads and downloads. This is important for monitoring and auditing file transfer activities.

6. `connect_from_port_20=YES`: Ensures that PORT mode FTP data connections originate from port 20. This is a requirement for some FTP clients and firewalls.

7. `ftpd_banner=Welcome to FTP server of inception!`: Customizes the welcome message displayed to users when they connect to the FTP server.

8. `chroot_local_user=YES`: Chroots local users to their home directory, restricting their access to the rest of the filesystem. This enhances security by isolating users in their own directories.

9. `allow_writeable_chroot=YES`: Allows writable chroot directories. Without this, users wouldn't be able to write to their own chrooted directories.

10. `user_sub_token=$USER`: Specifies a token that will be replaced with the actual username in the local_root directive.

11. `local_root=/var/www/html`: Sets the root directory for local users to /var/www/html. This can be combined with user_sub_token to set user-specific directories.

12. `listen=YES`: Enables the server to run in standalone mode and listen on IPv4 sockets.

13. `listen_port=21`: Specifies the port on which the FTP server will listen for incoming connections. Port 21 is the default port for FTP.

14. `listen_address=0.0.0.0`: Binds the FTP server to all available IP addresses on the machine.

15. `seccomp_sandbox=NO`: Disables the seccomp sandbox, which is a security feature that limits the system calls that the FTP server can make. Disabling this can increase performance but reduces security.

16. `pasv_enable=YES`: Enables passive mode, which is necessary for users behind NAT or firewalls to connect to the FTP server.

17. `pasv_min_port=21000` and `pasv_max_port=21010`: Defines the range of ports used for passive mode connections. This range must be open in the firewall to allow passive connections.

18. `userlist_enable=YES`, `userlist_file=/etc/vsftpd.userlist`, `userlist_deny=NO`: 
    - `userlist_enable=YES`: Enables the use of a user list for controlling access.
    - `userlist_file=/etc/vsftpd.userlist`: Specifies the path to the user list file.
    - `userlist_deny=NO`: When set to NO, only users listed in the user list file are allowed access.


If you want to learn more about it and what other options you can activate, check at [Linux Manual Page](https://linux.die.net/man/5/vsftpd.conf).

## Ftp Entrypoint Script

Create the tools directory inside the ftp directory

    mkdir -p ~/Inception/srcs/requirements/ftp/tools

And vim into the ftp-entrypoint.sh

    vim ~/Inception/srcs/requirements/ftp/tools/ftp-entrypoint.sh

Write inside

```sh
#!/bin/sh
if [ ! -f "/etc/vsftpd/vsftpd.conf.bak" ]; then

        mkdir -p /var/www/html
        cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
        mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

        # ADD ftp user, change the password and give the ownershipf of wordpress folder recursively
        adduser $FTP_USER --disabled-password
        echo "$FTP_USER:$FTP_PASSWORD" | chpasswd &> null
        chown -R $FTP_USER /var/www/html
        echo $FTP_USER | tee -a /etc/vsftpd.userlist &> /dev/null
fi
echo "FTP started on :21"
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
```

Here's an explanation of the provided entrypoint script for setting up and starting the FTP service:

```sh
#!/bin/sh
```
This shebang line specifies that the script should be run using the /bin/sh shell.

```sh
if [ ! -f "/etc/vsftpd/vsftpd.conf.bak" ]; then
```
This conditional checks if a backup of the vsftpd configuration file does not already exist. If the backup file does not exist, the following block of commands will be executed.

```sh
        mkdir -p /var/www/html
```
This command creates the /var/www/html directory if it doesn't already exist. The -p option ensures that any missing parent directories are also created.

```sh
        cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
```
This command creates a backup of the original vsftpd configuration file by copying it to vsftpd.conf.bak. This backup can be useful if you need to restore the original configuration later.

```sh
        mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf
```
This command moves the custom vsftpd configuration file from the temporary location /tmp/vsftpd.conf to its correct location /etc/vsftpd/vsftpd.conf, replacing the default configuration.

```sh
        adduser $FTP_USER --disabled-password
```
This command adds a new FTP user specified by the environment variable FTP_USER. The --disabled-password option adds the user without prompting for a password interactively.

```sh
        echo "$FTP_USER:$FTP_PASSWORD" | chpasswd &> null
```
This command sets the password for the newly created FTP user using the FTP_PASSWORD environment variable. The password is passed through a pipe to the chpasswd command, which updates the password for the user. The output is redirected to null to suppress any messages.

```sh
        chown -R $FTP_USER /var/www/html
```
This command changes the ownership of the /var/www/html directory and all its contents to the FTP user. The -R option ensures that ownership is changed recursively for all files and subdirectories.

```sh
        echo $FTP_USER | tee -a /etc/vsftpd.userlist &> /dev/null
```
This command appends the FTP user's name to the /etc/vsftpd.userlist file, which contains the list of users allowed to connect to the FTP server. The tee command ensures that the user's name is both displayed and appended to the file. The output is redirected to null to suppress any messages.

```sh
fi
```
This marks the end of the conditional block that is executed only if the backup configuration file does not exist.

```sh
echo "FTP started on :21"
```
This command prints a message indicating that the FTP server has started on port 21.

```sh
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
```
This command starts the vsftpd service using the specified configuration file /etc/vsftpd/vsftpd.conf.

### Summary
This entrypoint script for the FTP container performs the following steps:

1. Creates Necessary Directories: Ensures the existence of the /var/www/html directory.
2. Backs Up Configuration: Creates a backup of the original vsftpd configuration file.
3. Replaces Configuration: Moves a custom configuration file to replace the default vsftpd configuration.
4. Adds FTP User: Creates a new FTP user with a specified username and password.
5. Sets Directory Ownership: Changes the ownership of the /var/www/html directory to the new FTP user.
6. Updates User List: Appends the new FTP user to the list of allowed users.
7. Starts FTP Server: Prints a startup message and initiates the vsftpd service using the specified configuration.
8. This setup ensures that the FTP server is properly configured and ready to serve files, with the appropriate user permissions and custom configurations.

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