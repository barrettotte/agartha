#!/bin/bash
# sync local DNS files with pihole

set -e

ssh_user=root
pihole=pihole.agartha

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
script_name=$(basename $BASH_SOURCE)
usage="usage: ${script_name%.*} [push|pull]"

if [ "$#" -ne 1 ]; then
    echo Not enough arguments passed.
    echo $usage
    exit 1
fi

action=$1

if [ $action == 'push' ]; then
    echo Pushing to $pihole...
    scp $script_dir/dns-custom.list $ssh_user@$pihole:/etc/pihole/custom.list
    scp $script_dir/dns-cnames.conf $ssh_user@$pihole:/etc/dnsmasq.d/05-pihole-custom-cname.conf
elif [ $action == 'pull' ]; then
    echo Pulling from $pihole...
    scp $ssh_user@$pihole:/etc/pihole/custom.list $script_dir/dns-custom.list
    scp $ssh_user@$pihole:/etc/dnsmasq.d/05-pihole-custom-cname.conf $script_dir/dns-cnames.conf
else
    echo Invalid action $action
    echo $usage
    exit 1
fi

scp $src $dest

echo DNS sync done.
