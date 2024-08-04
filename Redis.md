# Guide how to set Redis Docker Container

## Table Of Contents
- [What Is Redis](#what-is-redis)
- [Redis Dockerfile](#redis-dockerfile)
- [Setting Up Other Containers](#setting-up-other-containers)

---

## What Is Redis

1. Introduction
Redis, short for Remote Dictionary Server, is an open-source, in-memory data structure store used as a database, cache, and message broker. It supports a variety of data structures such as strings, hashes, lists, sets, sorted sets with range queries, bitmaps, hyperloglogs, geospatial indexes, and streams.

2. Core Features
    - In-Memory Storage </br>
    Redis stores data in memory, which allows for extremely fast read and write operations compared to traditional disk-based databases. This makes Redis an excellent choice for use cases requiring low latency and high throughput.

    - Data Persistence </br>
    Although Redis is an in-memory database, it offers various persistence mechanisms. You can configure Redis to save the dataset to disk every once in a while, append-only file mode (AOF), or a combination of both.

    - Data Structures </br>
    Redis supports a wide array of data structures, enabling complex data manipulation. The primary structures include:

        - Strings: </br> Simple key-value pairs.
        - Hashes: </br> Maps of fields and values, similar to JSON objects.
        - Lists: </br> Ordered collections of strings, useful for tasks like message queues.
        - Sets: </br> Unordered collections of unique strings.
        - Sorted Sets: </br> Sets ordered by a score, useful for ranking systems.
        - Bitmaps: </br> Compact data structure used for bitwise operations.
        - HyperLogLogs: </br> Probabilistic data structures used for counting unique elements.
        - Streams: </br> Logs of entries with an automatic ID, useful for event sourcing.

    - Atomic Operations </br>
    All operations in Redis are atomic, which ensures that each command is completed entirely or not at all, maintaining data consistency.

    - Replication </br>
    Redis supports master-slave replication, allowing data to be replicated to any number of slave servers. This ensures high availability and fault tolerance.

    - High Availability with Redis Sentinel </br>
    Redis Sentinel provides high availability and monitoring. It can automatically failover to a replica in case the master fails.

    - Sharding </br>
    Redis supports partitioning data across multiple Redis instances, enabling horizontal scaling and improving performance for large datasets.

    - Extensibility </br>
    With the ability to write Lua scripts for execution in Redis, you can extend its capabilities and perform complex operations directly within the database.

    - Pub/Sub Messaging </br>
    Redis has a built-in Publish/Subscribe messaging system, making it suitable for real-time messaging and notification systems.

    - Geospatial Indexes: </br>
    Redis supports geospatial data, allowing you to perform radius queries, making it ideal for location-based applications.

3. Use Cases of Redis

    - Caching </br> Redis is widely used as a caching layer to reduce the load on traditional databases and improve application response times.

    - Session Store </br> Due to its fast performance, Redis is an excellent choice for storing user sessions in web applications.

    - Real-Time Analytics </br> The ability to perform quick read and write operations makes Redis suitable for real-time data analytics.

    - Message Queues </br> Redis can act as a message broker, facilitating communication between different parts of a distributed application.

    - Leaderboard/Counting Systems </br> The sorted sets data structure is perfect for implementing leaderboards, counters, and other ranking systems.

    - Geos-patial Applications </br> Redis's support for geospatial indexes allows for efficient location-based searches and services.

4. Getting Started with Redis </br>
    To get started with Redis, you can follow these basic steps, which are not for the Inception, because we have to install everything from the Docker file, but is important to know in advance:

    - Installation: Install Redis on your machine. You can download it from the official Redis website or use a package manager.

        ```sh
        sudo apt-get install redis-server   # For Debian-based systems
        ```
        Start the Redis Server: Start the Redis server using the following command.

        ```sh
        redis-server
        ```
        Connecting to Redis: Use the Redis CLI to connect to the Redis server and execute commands.

        ```sh
        redis-cli
        ```
        Basic Commands: Learn and experiment with basic Redis commands.

        ```sh
        SET mykey "Hello, Redis!"
        GET mykey
        ```
5. Conclusion </br>
    Redis's versatility, high performance, and wide range of features make it a popular choice for developers looking to enhance their applications with fast and reliable data storage solutions. Whether you are building a simple cache or a complex distributed system, Redis provides the tools you need to achieve your goals.

---

## Redis Dockerfile

For the bonus services we will have to create another folder called bonus inside the requirements directory

    mkdir -p ~/Inception/src/requirements/bonus

And create inside id the specific folder for Redis

    mkdir -p ~/Inception/src/requirements/bonus/redis

Vim into the docker file

    vim ~/Inception/src/requirements/bonus/redis/Dockerfile

And write the following content inside it:

```dockerfile
FROM alpine:3.18

ARG WP_REDIS_PASSWORD

ENV WP_REDIS_PASSWORD=${WP_REDIS_PASSWORD}

RUN apk update && \
        apk upgrade && \
        apk add --no-cache redis && \
        sed -i \
                -e "s|bind 127.0.0.1|#bind 127.0.0.1|g" \
                -e "s|# maxmemory <bytes>|maxmemory 20mb|g" \
                /etc/redis.conf && \
        echo "maxmemory-policy allkeys-lru" >> /etc/redis.conf

EXPOSE 6379

CMD ["redis-server", "--protected-mode", "no"]
```

Explanation for each line:

1. Specify the Base Image

```dockerfile
FROM alpine:3.19.2
```

 This line specifies the base image for your Docker container. alpine:3.19.2 refers to Alpine Linux version 3.19.2, a lightweight and efficient Linux distribution known for its minimal size. Using a specific version ensures that your container environment remains consistent.

2. Setting the Arguments
```dockerfile
ARG WP_REDIS_PASSWORD
```
This line defines a build-time argument WP_REDIS_PASSWORD. It allows the passing of a Redis password during the Docker build process.

3. Setting the ENV variable
```dockerfile
ENV WP_REDIS_PASSWORD=${WP_REDIS_PASSWORD}
```
This line sets an environment variable WP_REDIS_PASSWORD inside the container to the value of the build-time argument WP_REDIS_PASSWORD. This makes the Redis password available to the container during runtime.

4. Install Dependencies
```dockerfile
RUN apk update && \
        apk upgrade && \
        apk add --no-cache redis && \
        sed -i \
                -e "s|bind 127.0.0.1|#bind 127.0.0.1|g" \
                -e "s|# maxmemory <bytes>|maxmemory 20mb|g" \
                /etc/redis.conf && \
        echo "maxmemory-policy allkeys-lru" >> /etc/redis.conf
```

This `RUN` command updates the Alpine package index (apk update) and installs a comprehensive set of packages needed for running Redis:

- `apk update && apk upgrade`:  Updates the package index and upgrades any installed packages to the latest version.
- `apk add --no-cache redis`:  Installs the Redis package without caching the package index, which saves space.
- `sed -i -e "s|bind 127.0.0.1|#bind 127.0.0.1|g" -e "s|# maxmemory <bytes>|maxmemory 20mb|g" /etc/redis.conf`: Modifies the Redis configuration file (`/etc/redis.conf`) using `sed`. Specifically, it:
    - Comments out the `bind 127.0.0.1` line to allow Redis to listen on all network interfaces.
    - Sets the `maxmemory` directive to `20mb` to limit the maximum memory usage of Redis to 20MB.
- `echo "maxmemory-policy allkeys-lru" >> /etc/redis.conf`: Appends the line `maxmemory-policy allkeys-lru` to the Redis configuration file. This sets the eviction policy to `allkeys-lru`, meaning that when Redis reaches the memory limit, it will evict the least recently used keys to make room for new data.

4. Exposing the port
```dockerfile
EXPOSE 6379
```
This line tells Docker to expose port `6379`, which is the default port that Redis listens on. This makes the port accessible from outside the container.

5.  Specifin a comand with its argumes
```dockerfile
CMD ["redis-server", "--protected-mode", "no"]
```
This line specifies the command to run when the container starts. It runs the redis-server with the `--protected-mode no` option. By default, Redis enables protected mode when not bound to localhost. This command disables protected mode, allowing connections from any IP address, which is necessary for containers in some network setups.

### Summary

This Dockerfile creates a Redis container based on Alpine Linux. It allows for setting a Redis password through a build-time argument and environment variable. It updates and upgrades the Alpine packages, installs Redis, and configures it to listen on all network interfaces, set a memory limit, and use an allkeys-LRU eviction policy. Finally, it exposes the Redis port and starts the Redis server with protected mode disabled.

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