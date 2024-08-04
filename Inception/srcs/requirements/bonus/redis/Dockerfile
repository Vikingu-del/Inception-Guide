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