# Valheim

- https://valheim.fandom.com/wiki/Valheim_Dedicated_Server
- https://valheim.fandom.com/wiki/Hosting_Servers
- https://cloud.linode.com/linodes/create?type=One-Click\
  - Dedicated CPU, 4 cores, 2GB RAM
  - Debian 10
  - add SSH pub key
  - $30 / month
- https://www.linode.com/blog/linode/valheim-dedicated-server-linode/
- https://github.com/lloesche/valheim-server-docker

Consider a different provider in the future and containerize the whole thing.

## Config

```ini
# /etc/ssh/sshd_config

PasswordAuthentication no
AddressFamily inet
```

```sh
sudo systemctl restart sshd
```

## Manual Backups

```sh
find / -name *valheim*

# renamed valheim server pdf because I was too dumb to figure out scp with spaces
scp USER@SERVER_IP:"~/serverfiles/valheim-server.pdf" .
```

```ini
# .env
VALHEIM_USER=user
VALHEIM_SERVER=1.1.1.1
```

## Ports

```sh
netstat -lntu

# 22:   ssh
# 2457: valheim
```