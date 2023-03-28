# WSL

Random fixes or tweaks needed for my WSL environment.

## Static/Matching MAC Address

- https://github.com/microsoft/WSL/issues/5352
- copy over `/etc/wsl.conf` and `/etc/wsl.mac`
- `sudo chmod 755 /etc/wsl.mac`
- restart wsl, should now have `eth0` (static MAC) and `eth1`

## Drive Metadata

```sh
# noticed when running ansible

ansible all --list-hosts
# [WARNING]: Ansible is being run in a world writable directory (/mnt/x/repos/infra/ansible), ignoring it as an ansible.cfg source.
```

When WSL2 mounts drives, it doesn't know about unix permissions by default for some reason...so have to enable it.

Copy over `/etc/wsl.conf`, automount.options fixes this

```powershell
# restart WSL2
wsl --shutdown; Start-Sleep -Seconds 10; wsl
```

```sh
# fix permissions for all repos (rwxrwx---)
sudo chmod -R 770 /mnt/x/repos
```

## NFS mount

```ini
# /etc/fstab
truenas-service.agartha:/mnt/mesopotamia/nfs/media /mnt/media nfs rw,soft,intr,nfsvers=4 0 0
```

```sh
sudo apt install nfs-common

sudo mount -av
```