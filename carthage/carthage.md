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

```sh
# compose

docker compose up -d
```

https://github.com/stefanprodan/dockprom

## Misc

```sh
docker volume rm $(docker volume ls)
```