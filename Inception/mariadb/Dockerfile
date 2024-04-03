# Use the specified version of Alpine
FROM alpine:3.18.6

# Install MariaDB
RUN apk --no-cache add mariadb mariadb-client

# Copy the custom configuration file (if any)
COPY my.cnf /etc/mysql/my.cnf

# Expose the default MariaDB port
EXPOSE 3306

# Set the default command to launch MariaDB
CMD ["mysqld_safe"]

