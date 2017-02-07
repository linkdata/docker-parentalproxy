#!/bin/bash
set -e

mkdir -p /var/lib/squidguard/db

if [  "${UPDATE_BLACKLIST_URL}" != "" ]; then
	sudo wget -O backlist.tar.gz ${UPDATE_BLACKLIST_URL} \
 		&& tar -xzf backlist.tar.gz -C /var/lib/squidguard/db \
 		&& rm backlist.tar.gz
fi

chown proxy:proxy /var/lib/squidguard/db -R

# run original squid start script
exec /sbin/entrypoint.sh
