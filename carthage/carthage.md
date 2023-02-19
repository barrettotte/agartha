# carthage

LXC with various docker containers

## Setup

- debian, 16GB storage, 4GB RAM, 2 cores, vmbr1, 10.42.30.25

```sh
# Docker engine setup
# https://docs.docker.com/engine/install/debian/

apt-get update
apt-get upgrade

apt-get install ca-certificates curl gnupg lsb-release
mkdir -m 0755 -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## Docker Volumes NFS

- https://www.youtube.com/watch?v=eKAQiYu4NyI
- https://www.truenas.com/community/threads/core-docker-and-nfs.100568/

truenas NFS service enable NFSv4

setup NFS share `/mnt/mesopotamia/nfs/carthage-docker`
  - `/portainer-data`
allow only 10.42.30.0/24, 10.42.30.25

```sh
apt update && apt -y install nfs-common fuse-overlayfs
systemctl stop docker && systemctl stop docker.socket
mkdir -p /mnt/nfs

# /etc/fstab
service.truenas.agartha:/mnt/mesopotamia/nfs/carthage/docker /mnt/nfs nfs rw,soft,intr,nfsvers=4,rsize=8192,wsize=8192,timeo=14 0 0

# test
mount -v -t nfs 10.42.30.21:/mnt/mesopotamia/nfs/carthage/docker /mnt/nfs

# mount.nfs: mount(2): Operation not permitted
# ...
# mount.nfs: portmap query failed: RPC: Remote system error - No route to host

# https://theorangeone.net/posts/mount-nfs-inside-lxc/
```

Have to use **PRIVILEGED** containers
also...trueNAS NFS service enable `NFSv3 ownership model for NFSv4`

## Portainer

```sh
# portainer
# https://docs.portainer.io/start/install-ce/server/docker/linux

docker volume create portainer_data

docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data portainer/portainer-ce:latest

# https://10.42.30.25:9443/
```

Environments > local > Public IP = `carthage.agartha`

https://github.com/stefanprodan/dockprom

## Loki

```sh
# Install Grafana Loki docker driver
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions

# verify install
docker plugin ls
```

```jsonc
// change default logging driver

// etc/docker/daemon.json
{
  "log-driver": "loki",
  "log-opts": {
    "loki-url": "http://localhost:3100/loki/api/v1/push",
    "loki-batch-size": "400"
  }
}
```

```sh
# restart docker daemon
systemctl restart docker
```

## Misc

```sh
docker compose up -d

docker volume rm $(docker volume ls)
```
