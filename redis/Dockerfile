FROM redis:alpine

COPY rediscluster.conf /etc/redis/rediscluster.conf

EXPOSE 6379
ENTRYPOINT redis-server /etc/redis/rediscluster.conf