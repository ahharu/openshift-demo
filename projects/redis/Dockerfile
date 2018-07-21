FROM alpine:3.6
LABEL maintainer "Alex Ruiz - ahharu@ahharu.com"

EXPOSE 6379
ENTRYPOINT ["/entrypoint.sh"]
VOLUME ["/data"]
WORKDIR /data

COPY filesystem /

ENV REDIS_VERSION=4.0.10
ENV REDIS_PASSWORD default-password

RUN set -exo pipefail \
&& apk add --no-cache --virtual .build-deps \
  build-base \
  linux-headers \
  openssl \
  wget \
  libssh2 \
  libcurl \
&& wget -O /usr/local/bin/gosu https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 \
&& chmod +x /usr/local/bin/gosu \
&& cd /tmp \
&& wget http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz \
&& tar xzf redis-${REDIS_VERSION}.tar.gz \
&& cd /tmp/redis-${REDIS_VERSION} \
&& make \
&& make install \
&& cp redis.conf /etc/redis.conf \
&& sed -i -e 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis.conf \
&& adduser -D redis \
&& apk del .build-deps \
&& rm -rf /tmp/*

CMD ["sh", "-c", "exec redis-server --requirepass \"$REDIS_PASSWORD\""]
