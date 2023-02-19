#!/bin/bash

apt-get update
apt-get upgrade -y

apt-get install ca-certificates curl gnupg lsb-release nfs-common
mkdir -m 0755 -p /etc/apt/keyrings

# Docker (https://docs.docker.com/engine/install/debian/)
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# NFS
# TODO: add item to /etc/fstab
mount -av
du -sh /mnt/nfs
