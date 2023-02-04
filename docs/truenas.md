# TrueNAS

## Setup

- download ISO, make VM; 32GB storage, 8GB RAM
- add hard disks
  - `lsblk -o +MODEL,SERIAL`
  - `ls /dev/disk/by-id`
  - `qm set <vm-id> -scsi<n> /dev/disk/by-id/<hdd-id>,serial=<hdd-serial>`
- created ZFS pool RAIDZ1 with 6 3TB disks -> ~12TB storage

TODO: LAG groups?
