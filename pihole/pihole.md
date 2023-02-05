# Pihole

VLAN 30 (services)

## Setup

- LXC container - Ubuntu 22
- `adduser barrett`
- `adduser barrett sudo`
- `su barrett`
- `sudo apt update && sudo apt upgrade -y`
- `sudo apt install curl`
- https://github.com/pi-hole/pi-hole/#one-step-automated-install
  - `curl -sSL https://install.pi-hole.net | bash`
- Wizard
- `pihole -a -p`
- Web UI: 
  - Settings > DNS > Interface Settings > Respond only on interface `eth0`
  - Set since pihole is in a separate VLAN

## Opnsense

- Firewall > New Floating Rule
  - Interface: `LAN,guest,home,management,services`
  - Protocol: `TCP/UDP`
  - Source: `This Firewall`
  - Destination Port Range: `DNS`
  - Category: `Pihole`
- System > Settings > General > Networking
  - DNS servers: `10.42.30.10`, `8.8.8.8`, `8.8.4.4`
  - DNS server options: uncheck  Allow DNS server list to be overridden by DHCP/PPP on WAN

## Unbound DNS

https://docs.pi-hole.net/guides/dns/unbound/

- `sudo apt install unbound`
- `sudo nano /etc/unbound/unbound.conf.d/pi-hole.conf`, add contents of `./pi-hole.conf`
- `sudo service unbound restart`
- `dig pi-hole.net @127.0.0.1 -p 5335`
- Web UI: 
  - Settings > DNS
  - Uncheck upstream DNS (Google,Cloudflare,etc)
  - add and enable Pihole Unbound DNS to Upstream DNS Servers - `127.0.0.1#5335`
