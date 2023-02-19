# carthage

LXC with various docker containers

## Setup

- debian, 16GB storage, 4GB RAM, 2 cores, vmbr1, 10.42.30.25
- see `install.sh` and mount NFS via `/etc/fstab`

truenas NFS service enable NFSv4

setup NFS share `/mnt/mesopotamia/nfs/carthage-docker`
  - `/portainer-data`
allow only 10.42.30.0/24, 10.42.30.25
