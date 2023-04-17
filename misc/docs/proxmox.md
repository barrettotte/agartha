# Proxmox

## Hardware

### Babylon

- AMD Ryzen 5 5600X; AM4, 6 core, 3.7GHz, 65W
- Gigabyte B550 Aurus Elite AX V2; AM4 socket, Supports ECC/Non-ECC Unbuffered DDR4
- 2 x Corsair Vengeance LPX 32GB DDR4 3200
- 1 x Samsung 980 Pro 1TB NVMe SSD
- 6 x Western Digital 3TB Blue HDD; 5400 RPM
- 9207-8i HBA LSI RAID controller card; IT Mode
- Sapphire Radeon HD6450; 1GB DDR3
- Intel I350 4 Port Gigabit NIC; PCI Express 2.1 x4
- Corsair RM750x 750 W Gold PSU

### Sumer

- Dell Optiplex 7010
- Intel i5-3570 3.4GHz
- 4 x 4GB DDR3 1600

## Setup

- Download [Proxmox VE ISO installer](https://www.proxmox.com/en/downloads/item/proxmox-ve-7-3-iso-installer)
- Create bootable USB with Rufus and boot into it
- Install Proxmox to SDD (`ext4`)
- Config
  - IP Address - `10.42.10.52`
  - Hostname - `babylon.agartha`
  - Gateway/DNS - `10.42.10.1`
- updated packages
- `apt install sudo`
- made new user in PAM realm with admin access

### PCI Passthrough

- https://pve.proxmox.com/wiki/Pci_passthrough
  - essentially, passing PCI device through to VM requires IOMMU isolation
  - otherwise I think it passes the whole IOMMU to the VM and bricks everything on the hypervisor until reboot
- enable IOMMU support and ACS support in BIOS

(proxmox shell)

https://wiki.henryzhou.com/docs/system/proxmox/

```ini
# enable IOMMU

# /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on pcie_acs_override=downstream,multifunction"
```

```sh
update-grub
```

```ini
# add kernel modules

# /etc/modules
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

```sh
update-initramfs -u -k all
reboot now
```

- check if IOMMU enabled - `dmesg | grep -e DMAR -e IOMMU`
- check if IOMMUI interrupt remapping supported - `dmesg | grep 'remapping'`
- `find /sys/kernel/iommu_groups/ -type l`
- processor needs to have support for ACS, Ryzen 5 should be all set

NOTE: video card passthrough has some extra step...not sure if needed yet (maybe for jellyfin?)

## Backups

- after setting up TrueNAS, add SMB storage
- Backup > add
  - General
    - storage: SMB share (`backups`)
    - schedule: every sunday 04:00
    - Selection mode: all
    - Send email to: email
    - Email: On failure only
  - Retention > Keep Last: 3
  - Note Template: `{{node}}-{{guestname}} ({{vmid}})`
- on first setup, run now
- Backups to NFS
  - `mkdir -p /mnt/tmpdir`
  - add `tmpdir: /mnt/tmpdir` to `/etc/vzdump.conf`
  - https://forum.proxmox.com/threads/permission-denied-while-doing-a-backup-for-vm-that-is-stored-in-a-directory.94344/

## Misc

- When creating a VM, consider changing disk Async IO to native or threads

### Subscription Fixes

[node] > Updates > Repository
  - disable enterprise proxmox repo
  - add proxmox no-subscription repo

[Remove Proxmox Subscription Notice](https://johnscs.com/remove-proxmox51-subscription-notice/)

```sh
# Note: This probably gets removed after updating

sed -Ezi.bak "s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js && systemctl restart pveproxy.service
```

Note: Updates will probably re-enable this

### InfluxDB Metric Server

- Datacenter > Metric Server
- Add
  - server=influxdb.carthage.agartha
  - port=8086
  - protocol=http
  - organization=agartha
  - bucket=proxmox
  - token=API_TOKEN

## SSL Certs

https://3os.org/infrastructure/proxmox/lets-encrypt-cloudflare/#instalaion-and-configuration

- Datacenter > ACME
- Add account
- Add ACME DNS Plugin
  - id: acme-cloudflare
  - DNS API: Cloudflare Managed DNS
  - CF_ACCOUNT_ID: Cloudflare account ID
  - CF_Email: email
  - CF_TOKEN: Cloudflare API token

- Select PVE server > System > Certificates
  - Add ACME domain
    - Challenge Type: DNS
    - Plugin: acme-cloudflare
    - Domain: *.agartha.barrettotte.com

hmm not doing this for now...

## External GPU

`lspci -k | grep -A 2 -i "VGA"`

BIOS settings:

- Miscellaneous
  - PCIEX16 Slot Configuration = gen3
  - PCIe Slot Configuration = gen3

(got from old crypto mining notes)
