# Packer

## Install

```sh
# https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```

## Proxmox Setup

```sh
# setup packer Proxmox user

# add new role and user for packer
pveum useradd packer@pve
pveum passwd packer@pve
pveum roleadd packer -privs "VM.Config.Disk VM.Config.CPU VM.Config.Memory Datastore.AllocateSpace Datastore.AllocateTemplate Sys.Modify VM.Config.Options VM.Allocate VM.Audit VM.Console VM.Config.CDROM VM.Config.Network VM.PowerMgmt VM.Config.HWType VM.Monitor"
pveum aclmod / -user packer@pve -role packer
# taken from https://github.com/hashicorp/packer/issues/8463#issuecomment-726844945

# NOTE: ended up making a root token...
#
# The user above is missing some permission and doesn't seem to be documented...
#   error => proxmox.debian-11: Error updating template: 403 Permission check failed (/vms/900, VM.Config.Cloudinit)
```

Create new API token - Datacenter > Permissions > API Tokens

- User: packer@pve
- Token ID: packer
- Privilege Separation: unchecked (token permissions identical to user)

Record API token ID and secret in credentials file

## Build VM Templates

- build all VM templates - `make all`
- build all Debian-11 templates - `make debian-11`
- build single VM template - `make vm900`

## Misc

```sh
# verify machine id different on clones
cat /etc/machine-id

# check cloud init logs
less /var/log/cloud-init.log   
less /var/log/cloud-init-output.log

# verify cloud init files
ls /var/lib/cloud-init/

# note: user-data needs to be put in /var/lib/cloud/instance/user-data.txt
```

## References

- https://www.youtube.com/watch?v=1nf3WOEFq1Y
- https://developer.hashicorp.com/packer/guides/automatic-operating-system-installs/preseed_ubuntu
- https://github.com/romantomjak/packer-proxmox-template
- https://www.debian.org/releases/stable/example-preseed.txt
- https://github.com/ChristianLempa/boilerplates/tree/main/packer/proxmox
