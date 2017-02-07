# docker-parentalproxy

Builds on top of [sameersbn/docker-squid](https://github.com/sameersbn/docker-squid), adds [squidguard](http://www.squidguard.org/) with [Shallalist](http://www.shallalist.de/categories.html) blacklists and a local [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) server to enforce Google SafeSearch as well as Youtube and Bing safe searching.

Does not include WPAD autoconfiguration services.

Requires `--cap-add=NET_ADMIN` for `dnsmasq` to work.

Exposes only the squid proxy port. Can be combined with an [OpenVPN container](dperson/openvpn-client) if required. The sample below shows it using that with another container named `vpn`:
```
docker run -it \
        --name=parentalproxy \
        --restart=always \
        --net=container:vpn \
        --cap-add=NET_ADMIN \
        -d \
        linkdata/docker-parentalproxy
```
