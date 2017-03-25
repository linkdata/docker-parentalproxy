#!/bin/bash
set -e

### return_route: add a route back to your network, so that return traffic works
# Arguments:
#   network) a CIDR specified network range
# Return: configured return route
return_route() { local gw network="$1"
    gw=$(ip route | awk '/default/ {print $3}')
    ip route add to $network via $gw dev eth0
}

### usage: Help
# Arguments:
#   none)
# Return: Help text
usage() { local RC=${1:-0}

    echo "Usage: ${0##*/} [-opt] [command]
Options (fields in '[]' are optional, '<>' are required):
    -h          This help
    -r \"<network>\" CIDR network (IE 192.168.1.0/24)
                required arg: \"<network>\"
                <network> add a route to (allows replies)
" >&2
    exit $RC
}

while getopts ":hr:" opt; do
    case "$opt" in
        h) usage ;;
        r) return_route "$OPTARG" ;;
        "?") echo "Unknown option: -$OPTARG"; usage 1 ;;
        ":") echo "No argument value for option: -$OPTARG"; usage 2 ;;
    esac
done
shift $(( OPTIND - 1 ))

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
