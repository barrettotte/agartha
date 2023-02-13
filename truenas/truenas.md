# TrueNAS

## Setup

- If using SAS HBA card in IT mode - make sure IOMMU enabled in BIOS
- download ISO, make VM
- 2 core, 32GB storage, 24GB RAM
- q35 machine
- add PCI device: HBA card, rombar=0, pcie=1
- network `vmbr1` (services)
- https://www.truenas.com/docs/core/gettingstarted/corehardwareguide/#memory-cpu-and-network-considerations

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

## SMB Shares

- create dataset
- edit permissions > use ACL manager
- use preset RESTRICTED
- apply user and group
- create SMB share

NOTE: When testing adding user to group on Windows, disconnect all SMB shares.
It seems like having an open SMB share causes issues with updating permissions or something.
Relog into Windows to update permissions.

## TrusNAS Misc Config

- Network > Interfaces 
  - `vtnet0` > `10.42.10.21`
  - `vtnet1` > `10.42.30.21`
- System > General
  - Web Interface IPv4 Address: `10.42.10.21`
  - Enable Web Interface HTTP -> HTTPS Redirect

## References

- [TrueNAS Core: Configuring Shares, Permissions, Snapshots & Shadow Copies](https://www.youtube.com/watch?v=QIdy6sR0HrI)
- [How to create Virtual Machine on Proxmox with TrueNAS storage](https://www.youtube.com/watch?v=WWhyqPO1bZg)
