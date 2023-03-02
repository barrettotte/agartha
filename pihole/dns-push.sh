#!/bin/bash
# Push DNS records to pihole

SSH_USER=barrett
PIHOLE=pihole.agartha
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

rsync -avzhe ssh --progress "$SCRIPT_DIR/dns-custom.list" "$SSH_USER@$PIHOLE:/etc/pihole/custom.list" 
rsync -avzhe ssh --progress "$SCRIPT_DIR/dns-cnames.conf" "$SSH_USER@$PIHOLE:/etc/dnsmasq.d/05-pihole-custom-cname.conf" 