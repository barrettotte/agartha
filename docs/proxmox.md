# Proxmox

## Hardware

- AMD Ryzen 5 5600X; AM4, 6 core, 3.7GHz, 65W
- Gigabyte B550 Aurus Elite AX V2; AM4 socket, Supports ECC/Non-ECC Unbuffered DDR4
- 2 x Corsair Vengeance LPX 32GB DDR4 3200
- 1 x Samsung 980 Pro 1TB NVMe SSD
- 6 x Western Digital 3TB Blue HDD; 5400 RPM
- 9207-8i HBA LSI RAID controller card; IT Mode
- Sapphire Radeon HD6450; 1GB DDR3
- Intel I350 4 Port Gigabit NIC; PCI Express 2.1 x4
- Corsair RM750x 750 W Gold PSU

## Setup

- Download [Proxmox VE ISO installer](https://www.proxmox.com/en/downloads/item/proxmox-ve-7-3-iso-installer)
- Create bootable USB with Rufus and boot into it
- Install Proxmox to SDD (`ext4`)
- Config
  - IP Address - `10.42.10.4`
  - Hostname - `babylon.agartha`
  - Gateway/DNS - `10.42.10.1`
- updated packages
- made new user in PAM realm with admin access

## VLAN

Make Proxmox VLAN aware: System > Network > `vmbr0` > check VLAN aware

TODO: virtual NICs?

## Backups

TODO: scheduled backups

## Misc

### Subscription Fixes

Comment out line in `/etc/apt/sources.list.d/pve-enterprise.list` to stop update error
while trying to pull from enterprise repository.

[Remove Proxmox Subscription Notice](https://johnscs.com/remove-proxmox51-subscription-notice/)

```sh
sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
```

Note: Updates will probably re-enable this
