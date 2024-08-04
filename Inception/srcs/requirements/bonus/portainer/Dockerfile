FROM alpine:3.19.2

RUN     apk update && \
                apk upgrade && \
                apk add --no-cache curl

WORKDIR /app

RUN curl -L https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz -o portainer.tar.gz \
    && tar xzf portainer.tar.gz \
    && rm portainer.tar.gz

# CMD ["sleep", "infinity"]
# Expose the Portainer port (default is 9000)
EXPOSE 9443 8000 9000

# Set the entry point to start Portainer
ENTRYPOINT ["./portainer/portainer"]
