# Opnsense

## Hardware

Originally used https://store.minisforum.com/products/minisforum-gk41-mini-pc

- Intel Celeron J4125 (AES-NI supported)
- 8GB DDR4 RAM, 128GB SSD
- 2x Realtek RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller

Switched to intel NIC-based mini PC - https://www.amazon.com/gp/product/B09J4H9ZXY

- Intel Celeron J4125 (AES-NI supported)
- 8GB DDR RAM, 128GB SSD
- 4x Intel 2.5gigabit ethernet ports

## Setup

- Using Opnsense 22.7
- Download [Opnsense Installer amd64 vga image](https://opnsense.org/download/)
- Uncompress img and flash to USB with Rufus
- default credentials: `installer/opnsense`
- install
  - ZFS
  - Stripe (only have 1 SSD currently)
  - ZFS Configuration to SSD (`ada0`)
  - Change root password
- Primary DNS 8.8.8.8
- Secondary DNS 9.9.9.9
- Add user admin account
  - change login shell
  - add user to `admins` group
  - paste SSH key into authorized keys for passwordless login
- System > Settings > Administration
  - enable secure shell
  - sudo - `Ask password`
- Firmware > Updates
- Wizard - set IP to `10.42.0.1`

## Firewall

https://www.youtube.com/watch?v=kYFNa_zpeII

- firewall > aliases > new > RFC1918
  - type Network(s) 192.168.0.0/16,172.16.0.0/12,10.0.0.0/8
  - statistics=yes

## Opnsense to Edge Router

https://homenetworkguy.com/how-to/use-opnsense-router-behind-another-router/

- when Opnsense behind another router, need to enable private networks and bogon networks
- consider adding static IP to ISP router for my Opnsense box
- consider Services > Query Forwarding > Use System Nameservers - enable
- consider System > General > Networking > DNS server options = enable
- this also shows how to configure firewall rules for out of network devices (might be useful for media server sharing with family)

## CrowdSec

- https://homenetworkguy.com/how-to/install-and-configure-crowdsec-on-opnsense/
- https://homenetworkguy.com/how-to/configure-intrusion-detection-opnsense/
- https://docs.crowdsec.net/docs/getting_started/install_crowdsec_opnsense/#remote-lapi-setup-optional

## WAN isn't 1000M ?

```sh
pciconf -lv re0 # Realtek RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
pciconf -lv re1 # Realtek RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller

ifconfig re0 # Ethernet autoselect (1000baseT <full-duplex>)
ifconfig re1 # Ethernet autoselect (100baseTX <full-duplex>)

sysctl hw.pci.enable_msi # 1
sysctl hw.pci.enable_msix # 1
```

https://forum.opnsense.org/index.php?topic=26589.0

install plugin `os-realtek-re` and reboot...no change

## Plugins

- `os-api-backup` - download config.xml file
- `os-node_exporter` - promtheus export
- `os-crowdsec` - security engine
- `os-ntopng` - traffic analysis
- `os-theme-rebellion` - dark theme

## Performance Tuning

https://teklager.se/en/knowledge-base/opnsense-performance-optimization/

- System > Settings > Tunables
  - Spectre/Meltdown disable
  - 

## SSL Certs

Setup domain, need to stop using self-signed certs.

- Installed `os-acme-client` plugin
- Services > ACME Client
  - Settings > Enabled plugin
  - Accounts > Add account
    - Name: Let's Encrypt
    - Email: Email
    - CA: Let's Encrypt
  - Challenge Types > Add Challenge Type
    - Name: Cloudflare
    - Challenge Type: DNS-01
    - DNS Service: CloudFlare.com
    - CF Account ID: Cloudflare account id (in URI after logging into cloudflare dashboard)
    - CF API Token: Cloudflare API key
  - Automations > Add Automation
    - Name: Restart web UI
    - Run Command: Restart OPNsense Web UI
  - Certificates > Add Certificate
    - Common Name: `*.agartha.barrettotte.com`
    - Alt Names: `*.barrettotte.com`
    - ACME Account: Let's Encrypt
    - Auto Renewal: yes
    - Renewal Interval: 60
    - Automations: Restart web UI

System > Settings

- Protocol: HTTPS
- SSL Certificate: `*.agartha.barrettotte.com (ACME Client)`
- HTTP Redirect: yes
