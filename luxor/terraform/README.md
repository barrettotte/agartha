# Terraform

## Install

```sh
# https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt-get install terraform
```

## Proxmox Setup

```sh
# setup terraform Proxmox user
# https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md

# add new role and user for terraform
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt"
pveum useradd terraform-prov@pve
pveum passwd terraform-prov@pve

# add terraform user to new role
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

Create new API token - Datacenter > Permissions > API Tokens

- User: terraform-prov@pve
- Token ID: terraform
- Privilege Separation: unchecked (token permissions identical to user)

Record API token ID and secret in terraform credentials file

## Commands

- `terraform init`
- `terraform validate`
- `terraform plan`
- `terraform apply -auto-approve`
- `terraform destroy`

## References

- https://github.com/Telmate/terraform-provider-proxmox
  - https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md
- https://developer.hashicorp.com/terraform/tutorials
