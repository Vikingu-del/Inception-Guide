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