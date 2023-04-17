# TrueNAS

## Setup

- If using SAS HBA card in IT mode - make sure IOMMU enabled in BIOS
- download ISO, make VM
- 2 core, 32GB storage, 24GB RAM
- q35 machine
- add PCI device: HBA card, rombar=0, pcie=1
- network `vmbr1` (services)
- https://www.truenas.com/docs/core/gettingstarted/corehardwareguide/#memory-cpu-and-network-considerations
- set Start/Shutdown order to 1

```sh
# add disks manually that aren't on HBA

lsblk -o +MODEL,SERIAL
ls /dev/disk/by-id
qm set VM_ID -scsi# /dev/disk/by-id/HDD_ID,serial=HDD_SERIAL
```

### ZFS Pool

- created ZFS pool RAIDZ2 `storage0`
  - 10 3TB disks -> 21.82 TB
- https://www.youtube.com/watch?v=M4DLChRXJog

## Shares

### SMB

- create dataset
- edit permissions > use ACL manager
- use preset RESTRICTED
- apply user and group
- create SMB share

NOTE: When testing adding user to group on Windows, disconnect all SMB shares.
It seems like having an open SMB share causes issues with updating permissions or something.
Relog into Windows to update permissions.

### NFS

- Setting up NFS for docker volume
  - All dirs
  - Maproot user = root, Maproot group = wheel
- also needed to enable `NMFSv3 ownership model for NFSv4` for docker volumes...not sure why

`/mesopotamia/nfs/proxmox/docker/`

### iSCSI

- Wizard
- Setup two zvols: `proxmox/proxmox-shared-0` and `proxmox/proxmox-shared-1` each 500GB
- Block device config
  - name: `proxmox-shared-0`
  - extent type: Device
  - device: `storage0/proxmox/proxmox-shared-0` 500GB
  - sharing platform: Modern OS
- Portal
  - auth method: CHAP
  - auth group: new -> ID=10,User=proxmox-shared-0
  - ip address: `10.42.30.21:3260`, `10.42.10.21:3260`
- Initiator
  - Initiators: left blank
  - Authorized Networks: `10.42.30.0/24`, `10.42.10.0/24`
- See proxmox notes for next steps

## TrusNAS Misc Config

- Network > Interfaces 
  - `vtnet0` > `10.42.10.21`
  - `vtnet1` > `10.42.30.21`
- System > General
  - Web Interface IPv4 Address: `10.42.10.21`
  - Enable Web Interface HTTP -> HTTPS Redirect

## Logging/Metrics

### Graphite Metrics

- setup graphite-exporter container to convert graphite metrics to prometheus
- report CPU as percent
- hostname=carthage.agartha:2003
- graph age in months = 12
- number of graph points 1200

### Syslogs To Loki

- System > Advanced > Syslog
  - use FQDN for logging
  - Syslog level=Debug
  - Syslog server=syslog.carthage.agartha
  - Syslog transport=UDP

## Configuration Backup

Manually, go to System > General > Save Config

TODO: script to backup config periodically

## InfluxDB

I couldn't get graphite-exporter working, but if I just use Telegraf I can use one less container and stop losing my mind.
In TrueNAS, set graphite exporter url to influxdb instance.

- https://blog.victormendonca.com/2020/10/28/how-to-install-telegraf-on-freenas/
- https://www.reddit.com/r/homelab/comments/8c7o2c/telegraf_on_freenas/

## References

- [TrueNAS Core: Configuring Shares, Permissions, Snapshots & Shadow Copies](https://www.youtube.com/watch?v=QIdy6sR0HrI)
- [How to create Virtual Machine on Proxmox with TrueNAS storage](https://www.youtube.com/watch?v=WWhyqPO1bZg)
