FROM registry.astralinux.ru/library/alse:1.7.4

ENV DOCKERIZE_VERSION v0.7.0

ENV DEPS \
    wget \
    gettext-base \
    postfix \
    mailutils \
    ca-certificates \
    procmail \
    sasl2-bin

RUN apt-get update --quiet --quiet \
    && apt-get upgrade --quiet --quiet

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install --quiet --quiet --yes \
    --no-install-recommends --no-install-suggests \
    $DEPS \
    && wget -O - https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz | tar xzf - -C /usr/local/bin \
    && apt-get --quiet --quiet clean \
    && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER root
WORKDIR /root

COPY src/templates templates/
COPY src/docker-entrypoint.sh ./
RUN chmod +x ./docker-entrypoint.sh

VOLUME ["/var/spool/postfix"]
EXPOSE 25/TCP 587/TCP 465/TCP

STOPSIGNAL SIGKILL
CMD ["bash", "docker-entrypoint.sh"]