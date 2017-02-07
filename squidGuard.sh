#!/bin/bash
set -e

mkdir -p ${SQUIDGUARD_DB_DIR}

if [  "${SQUIDGUARD_BLACKLIST_URL}" != "" ]; then
	sudo wget -O backlist.tar.gz ${SQUIDGUARD_BLACKLIST_URL} \
 		&& tar -xzf backlist.tar.gz -C /var/lib/squidguard/db \
 		&& rm backlist.tar.gz
fi

chown ${SQUID_USER}:${SQUID_USER} ${SQUIDGUARD_DB_DIR} -R

exec /sbin/entrypoint.sh
