#!/bin/bash

# sync local repo directory with remote machine
#
# Used mainly to sync docker compose/config from local to remote without
# needing to commit, push, and pull my git repo repeatedly.

# TODO: convert to ansible playbook

set -e

ssh_user=ansible
domain=.agartha
machines=(athens carthage giza jericho luxor rhodes)

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
repo_dir=$(builtin cd "$script_dir/../"; pwd)
script_name=$(basename $BASH_SOURCE)
usage="usage: ${script_name%.*} [push|pull] [MACHINE|all]"

# pull/push from/to machine via scp
# usage: sync ACTION MACHINE
sync() {
    if [ $action == 'push' ]; then
        echo Pushing to $2$domain...
        scp -r $repo_dir/$2 $ssh_user@$2$domain:/home/$ssh_user
    elif [ $action == 'pull' ]; then
        echo Pulling from $2$domain...
        scp -r $ssh_user@$2$domain:/home/$ssh_user/$2 $repo_dir
    else
        echo Invalid action $1
        echo $usage
        exit 1
    fi
}

if [ "$#" -ne 2 ]; then
    echo Not enough arguments passed.
    echo $usage
    exit 1
fi

action=$1
target_machine=$2

if printf '%s\0' "${machines[@]}" | grep -Fxqz -- $target_machine; then
    sync $action $target_machine
elif [ $target_machine == 'all' ]; then
    for machine in "${machines[@]}"; do
        sync $action $machine
    done
else
    echo Machine not found.
    echo '  Available machines: '${machines[*]}
    exit 1
fi

echo Repo sync done.
