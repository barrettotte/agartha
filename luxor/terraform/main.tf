# 
# https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/resources/vm_qemu.md#disk-block
#
#  device-mapper: resume ioctl on  (253:10) failed: Invalid argument
#   Unable to resume ssd0-vm--900--disk--0 (253:10).
# TASK ERROR: clone failed: can't refresh LV '/dev/ssd0/vm-900-disk-0' for activation:   Failed to reactivate ssd0/vm-900-disk-0.

module "athens" {
  source = "./modules/vm"

  proxmox_api_url          = local.proxmox_babylon_api_url
  proxmox_api_token_id     = var.proxmox_babylon_api_token_id
  proxmox_api_token_secret = var.proxmox_babylon_api_token_secret

  proxmox_node = local.proxmox_babylon
  vm_template  = local.debian11_vm
  vm_id        = 201
  vm_name      = "athens"
  vm_desc      = "management and network monitoring"
  static_ipv4  = "10.42.10.25"
  gateway      = local.manage_gw
  nic          = local.manage_nic
}

module "carthage" {
  source = "./modules/vm"

  proxmox_api_url          = local.proxmox_babylon_api_url
  proxmox_api_token_id     = var.proxmox_babylon_api_token_id
  proxmox_api_token_secret = var.proxmox_babylon_api_token_secret

  proxmox_node = local.proxmox_babylon
  vm_template  = local.debian11_vm
  vm_id        = 202
  vm_name      = "carthage"
  vm_desc      = "logs/metrics"
  static_ipv4  = "10.42.30.25"
  gateway      = local.service_gw
  nic          = local.service_nic
}

module "giza" {
  source = "./modules/vm"

  proxmox_api_url          = local.proxmox_babylon_api_url
  proxmox_api_token_id     = var.proxmox_babylon_api_token_id
  proxmox_api_token_secret = var.proxmox_babylon_api_token_secret

  proxmox_node = local.proxmox_babylon
  vm_template  = local.debian11_vm
  vm_id        = 203
  vm_name      = "giza"
  vm_desc      = "general services"
  static_ipv4  = "10.42.30.26"
  gateway      = local.service_gw
  nic          = local.service_nic
}

module "jericho" {
  source = "./modules/vm"

  proxmox_api_url          = local.proxmox_babylon_api_url
  proxmox_api_token_id     = var.proxmox_babylon_api_token_id
  proxmox_api_token_secret = var.proxmox_babylon_api_token_secret

  proxmox_node = local.proxmox_babylon
  vm_template  = local.debian11_vm
  vm_id        = 204
  vm_name      = "jericho"
  vm_desc      = "web proxy"
  static_ipv4  = "10.42.30.27"
  gateway      = local.service_gw
  nic          = local.service_nic
}

module "rhodes" {
  source = "./modules/vm"

  proxmox_api_url          = local.proxmox_babylon_api_url
  proxmox_api_token_id     = var.proxmox_babylon_api_token_id
  proxmox_api_token_secret = var.proxmox_babylon_api_token_secret

  proxmox_node = local.proxmox_babylon
  vm_template  = local.debian11_vm
  vm_id        = 205
  vm_name      = "rhodes"
  vm_desc      = "torrenting"
  static_ipv4  = "10.42.35.25"
  gateway      = local.torrent_gw
  nic          = local.torrent_nic
}

# Error: clone failed: can't refresh LV '/dev/ssd0/vm-900-disk-0' for activation:   Failed to reactivate ssd0/vm-900-disk-0.
# │ 
# │   with module.carthage.proxmox_vm_qemu.vm_qemu_cloudinit,
# │   on modules/vm/main.tf line 6, in resource "proxmox_vm_qemu" "vm_qemu_cloudinit":
# │    6: resource "proxmox_vm_qemu" "vm_qemu_cloudinit" {
