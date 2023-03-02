#!/bin/bash
# Pull DNS records from pihole

SSH_USER=barrett
PIHOLE=pihole.agartha
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

rsync -avzhe ssh --progress "$SSH_USER@$PIHOLE:/etc/pihole/custom.list" "$SCRIPT_DIR/dns-custom.list"
rsync -avzhe ssh --progress "$SSH_USER@$PIHOLE:/etc/dnsmasq.d/05-pihole-custom-cname.conf" "$SCRIPT_DIR/dns-cnames.conf"
