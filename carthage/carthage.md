# carthage

LXC with various docker containers

## Setup

- debian, 16GB storage, 4GB RAM, 2 cores, vmbr1, 10.42.30.25
- dependencies
- `apt-get update`
- `apt-get upgrade -y`
- `nano /etc/ssh/sshd_config` - `PermitRootLogin prohibit-password`

```ini
# /etc/network/interfaces
source /etc/network/interfaces.d/*
auto lo
iface lo inet loopback

allow-hotplug enp6s18
iface enp6s18 inet static
    address 10.42.30.25/24
    gateway 10.42.30.1
    dns-nameservers 10.42.30.10
    dns-search agartha
```

`ansible-playbook ../ansible/playbooks/main/carthage.yml`

## References

- https://zeigren.com/posts/monitoring_prometheus_loki/
