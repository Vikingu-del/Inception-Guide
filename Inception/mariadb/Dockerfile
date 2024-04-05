# Use the specified version of Alpine
FROM alpine:3.18

# Set the maintainer
LABEL maintainer="Erik <rk.seferi@gmail.com>"

# Install MariaDB
RUN apk update && apk --no-cache add mariadb mariadb-client

# Copy the custom configuration files
COPY conf/my.config /etc/mysql/my.cnf
COPY conf/init.sql /tmp/init.sql

# Expose the default MySQL port
EXPOSE 3306

# Define the entry point
CMD ["mysqld", "--user=mysql", "--init-file=/tmp/init.sql"]
