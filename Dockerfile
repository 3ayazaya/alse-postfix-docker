FROM registry.astralinux.ru/library/alse:1.7.4

ENV DEPS \
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
    && apt-get --quiet --quiet clean \
    && rm --recursive --force /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER root
WORKDIR /root

COPY src/templates templates/
COPY src/docker-entrypoint.sh ./
RUN chmod +x ./docker-entrypoint.sh

VOLUME ["/var/log", "/var/spool/postfix"]
EXPOSE 25/TCP 587/TCP
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["postfix", "-v", "start-fg"]