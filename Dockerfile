FROM alpine:3.9

RUN set -ex && \
 apk add --no-cache --virtual .fetch-deps \
 curl

RUN set -ex && \
 apk add --no-cache --virtual .needed-deps \
 bash \
 git \
 ruby-dev \
 curl \
 netcat

RUN adduser -D herokuser

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN set -ex && \
 apk add --no-cache --virtual \
 shadow

RUN ["usermod", "-s", "/bin/bash", "herokuser"]

RUN set -ex && \
 apk del shadow

USER herokuser

RUN set -ex && \
    gem uninstall dpl-heroku -a && \
    gem uninstall dpl -a && \
    gem install dpl-heroku -v 1.10.6

ENTRYPOINT ["docker-entrypoint.sh"]

RUN dpl --provider=heroku --version

