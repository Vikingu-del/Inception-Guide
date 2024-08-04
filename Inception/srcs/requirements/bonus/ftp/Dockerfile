FROM alpine:3.19.2

RUN apk update && \
    apk add --no-cache vsftpd

# Copy entrypoint script and configuration file
COPY tools/ftp-entrypoint.sh /usr/local/bin/ftp-entrypoint.sh
COPY conf/vsftpd.conf /tmp/vsftpd.conf

# Set permissions
RUN chmod +x /usr/local/bin/ftp-entrypoint.sh

ENTRYPOINT ["ftp-entrypoint.sh"]