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

## IDS/IPS

- Suricata, CrowdSec
- services > Intrusion Detection
  - 
- https://homenetworkguy.com/how-to/install-and-configure-crowdsec-on-opnsense/
- https://homenetworkguy.com/how-to/configure-intrusion-detection-opnsense/

## Netflow

- System > Firmware > Plugins > os-ntopng
- Reporting > Netflow
  - Listening interfaces: `home,iot,LAN,management,services,WAN`
  - WAN interfaces: `WAN`
  - Capture local: yes

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
