# ntopng

install plugins `os-ntopng` and `os-redis`

- https://github.com/ntop/ntopng/blob/dev/doc/README.geolocation.md
- https://www.maxmind.com/en/geolite2/signup

geo ip data not working

- https://forum.opnsense.org/index.php?topic=17533.0
- https://forum.opnsense.org/index.php?topic=10733.0

scp over `ntopng-update-geoip.sh`

Can't seem to find map in menu, but can navigate to it directly - `/lua/hosts_geomap.lua`
But, no data is shown...

`/usr/local/bin/ntopng-geoip2update.sh` also exists, but doesn't have updated URLs with license keys...

hmm not working...screw it. Uninstalled `os-ntopng` and `os-redis`
