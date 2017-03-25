#!/bin/bash
set -e

mkdir -p ${SQUIDGUARD_DB_DIR}
sed -i "s#http://localhost/block.html#${SQUIDGUARD_BLOCK_URL}#" /etc/squidguard/squidGuard.conf

if [  "${SQUIDGUARD_BLACKLIST_URL}" != "" ]; then
	sudo wget -O blacklist.tar.gz ${SQUIDGUARD_BLACKLIST_URL} \
 		&& tar -xzf blacklist.tar.gz -C /var/lib/squidguard/db \
 		&& rm blacklist.tar.gz \
		&& squidGuard -C all
fi

chown ${SQUID_USER}:${SQUID_USER} ${SQUIDGUARD_DB_DIR} -R

/usr/sbin/dnsmasq

exec /sbin/entrypoint.sh
