#/bin/bash

dockerize -template templates/main.cf.tmpl:/etc/postfix/main.cf \
-template templates/master.cf.tmpl:/etc/postfix/master.cf \
-template templates/transport.tmpl:/etc/postfix/transport

postmap /etc/postfix/transport

echo "------------------------------------------"
echo "Starting mail server with:"
echo "    PRIMARY_DOMAIN=${PRIMARY_DOMAIN}"
echo "    MYHOSTNAME=${MYHOSTNAME}"
echo "------------------------------------------"

dockerize postfix -v start-fg