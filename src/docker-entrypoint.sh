#!/bin/bash

set -e

function generate_configs() {
  echo "Generating postfix configurations for ${PRIMARY_DOMAIN}"
  envsubst '\$PRIMARY_DOMAIN \$RELAY_IP \$MYHOSTNAME \$RELAY_DOMAINS' < templates/main.cf > /etc/postfix/main.cf
  cp templates/transport /etc/postfix/transport
  postmap /etc/postfix/transport

  cp /etc/postfix/master.cf /etc/postfix/master.cf.orig
  envsubst '\$PRIMARY_DOMAIN \$RELAY_IP' < templates/master.cf > /etc/postfix/master.cf
  echo "All configurations generated for ${PRIMARY_DOMAIN}"
}

if [ "$1" = 'postfix' ]; then
  echo "------------------------------------------"
  echo "Starting mail server with:"
  echo "    PRIMARY_DOMAIN=${PRIMARY_DOMAIN}"
  echo "    RELAY_IP=${RELAY_IP}"
  echo "    MYHOSTNAME=${MYHOSTNAME}"
  echo "------------------------------------------"

  if [[ ! -f conf_gen_done.txt ]] || [[ $(< conf_gen_done.txt) != "${PRIMARY_DOMAIN}" ]]; then
    generate_configs
    echo "${PRIMARY_DOMAIN}" > conf_gen_done.txt
  else
    echo "Configurations already generated for ${PRIMARY_DOMAIN}, preserving."
  fi
  exec "$@"
fi

exec "$@"