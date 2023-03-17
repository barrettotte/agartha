# Misc

## Useful Commands

- sanity check open ports - `sudo nmap -sS EDGE_ROUTER_GATEWAY_IP`
- check eth port speed - `sudo ethtool eth0 | grep -i speed`
- monitor CPU usage - `top -aSH`
- disk usage by folder - `du -h / | less`
- check port - `nc -zv 10.42.30.26 22`

## Domain Transfer

- previous registrar - iwebfusion
- new registrar Cloudflare
- https://my.iwebfusion.net/knowledgebase/33/How-do-I-transfer-my-domain-name.html
- https://developers.cloudflare.com/registrar/get-started/transfer-domain-to-cloudflare/

## Docker

- remove all volumes - `docker volume rm $(docker volume ls -q) > /dev/null 2>&1`
- remove all containers - `docker container rm $(docker ps -qa) > /dev/null 2>&1`
- force recreate on container `docker compose up -d --force-recreate CONTAINER`
- view how image was built `docker history --human --no-trunc influxdb:2.6-alpine --format '{{.CreatedBy}}'`

## SSH Init

```sh
# install ssh
sudo apt-get install openssh-server

# add new user

sudo adduser USER
sudo usermod -aG sudo USER
```

```sh
# setting up new user with ssh pubkey auth

mkdir -p /home/USER/.ssh
echo 'PUBLIC_KEY' >> /home/USER/.ssh/authorized_keys
chmod 700 /home/USER/.ssh
chmod 600 /home/USER/.ssh/authorized_keys
chown -R USER:USER /home/USER/.ssh

# alternatively:
ssh-keygen
```

```sh
# on client
ssh-copy-id USER@SERVER
```

```ini
# /etc/ssh/sshd_config

PermitRootLogin prohibit-password
# PubKeyAuthentication yes
ChallengeResponseAuthentication no
PasswordAuthentication no
```

`systemctl restart ssh`

## Static IP

```ini
# /etc/network/interfaces
source /etc/network/interfaces.d/*

auto lo
iface lo inet loopback

allow-hotplug enp6s18
iface enp6s18 inet static
    address 10.42.?.?/24
    gateway 10.42.?.1
    dns-nameservers 10.42.30.10
    dns-search agartha
```

reboot

## Firewall

```sh
# base firewall
sudo ufw status

sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh
sudo ufw enable
```

```sh
# fail2ban
sudo apt install fail2ban

sudo cp /etc/fail2ban/fail2ban.{conf,local}
sudo cp /etc/fail2ban/jail.{conf,local}

# configure fail2ban files, see below

sudo systemctl restart fail2ban

# verify
sudo systemctl status fail2ban
sudo fail2ban-client status
sudo fail2ban-client status sshd
tail -f /var/log/fail2ban.log
```

```ini
# /etc/fail2ban/fail2ban.local
loglevel = INFO
logtarget = /var/log/fail2ban.log
```

```ini
# /etc/fail2ban/jail.local
bantime = 10m
findtime = 10m
maxretry = 5
backend = auto # or systemd for ubuntu
```

## Logging/Metrics Non-Docker

TODO: https://gist.github.com/jarek-przygodzki/735e15337a3502fea40beba27e193b04

## NFS

```ini
# /etc/fstab

service.truenas.agartha:/mnt/mesopotamia/nfs/proxmox/docker /mnt/docker nfs rw,soft,intr,nfsvers=4,rsize=8192,wsize=8192,timeo=14 0 0
```
