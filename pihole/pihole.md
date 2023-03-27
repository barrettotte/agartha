# Pihole

VLAN 30 (services)

## Setup

- LXC container
  - Ubuntu 22, 8GB disk, 1 core, 512MB RAM
  - `vmbr1` (services), static IP `10.42.30.10/24`
- `apt update && apt upgrade -y`
- `apt install curl`
- https://github.com/pi-hole/pi-hole/#one-step-automated-install
  - `curl -sSL https://install.pi-hole.net | bash`
- Wizard; defaults
- `pihole -a -p`
- Web UI: 
  - Settings > DNS > Interface Settings > Respond only on interface `eth0`
  - Set since pihole is in a separate VLAN
  - Tools > Update Gravity

## Update

`pihole -up`

## Opnsense

- Firewall > New Floating Rule
  - Interface: `LAN,guest,home,management,services`
  - Protocol: `TCP/UDP`
  - Source: `This Firewall`
  - Destination Port Range: `DNS`
  - Category: `Pihole`
- Services > DHCPv4 > [interface]
  - DNS servers `10.42.30.10`, `8.8.8.8`
- System > Settings > General > Networking
  - DNS servers: `10.42.30.10`, `8.8.8.8`, `8.8.4.4`
  - DNS server options: uncheck Allow DNS server list to be overridden by DHCP/PPP on WAN
  - Note: this didn't seem to work for some reason...Pihole was not receiving DNS requests

## Unbound DNS

https://docs.pi-hole.net/guides/dns/unbound/

- `apt install unbound`
- `nano /etc/unbound/unbound.conf.d/pi-hole.conf`, add contents of `./pi-hole.conf`
- `service unbound restart`
- `dig pi-hole.net @127.0.0.1 -p 5335`
- Web UI: 
  - Settings > DNS
  - Uncheck upstream DNS (Google,Cloudflare,etc)
  - add and enable Pihole Unbound DNS to Upstream DNS Servers - `127.0.0.1#5335`

TODO: init pihole playbook
