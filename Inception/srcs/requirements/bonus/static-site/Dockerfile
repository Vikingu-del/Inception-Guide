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
