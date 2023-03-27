module "athens" {
  source = "./modules/vm"

  vm_id         = 201
  vm_name       = "athens"
  vm_desc       = "management and network monitoring"
  static_ipv4   = "10.42.10.25"
  vm_template   = local.debian11_vm
  gateway       = local.network_configs["manage"]["gateway"]
  nic           = local.network_configs["manage"]["nic"]
  disk_location = local.vm_storage
  ci_user       = local.ansible_user
  ci_password   = var.ci_passwords["athens"]
  ssh_pub_key   = local.ansible_ssh_pubkey
  dns           = local.pihole_dns
  domain        = local.agartha_domain
  
  proxmox_node             = local.primary_proxmox_node
  proxmox_api_url          = local.proxmox_api_urls[local.primary_proxmox_node]
  proxmox_api_token_id     = var.proxmox_secrets[local.primary_proxmox_node]["api_token_id"]
  proxmox_api_token_secret = var.proxmox_secrets[local.primary_proxmox_node]["api_token_secret"]
}

module "carthage" {
  source = "./modules/vm"

  vm_id         = 202
  vm_name       = "carthage"
  vm_desc       = "logs and metrics"
  static_ipv4   = "10.42.30.25"
  vm_template   = local.debian11_vm
  gateway       = local.network_configs["service"]["gateway"]
  nic           = local.network_configs["service"]["nic"]
  disk_location = local.vm_storage
  ci_user       = local.ansible_user
  ci_password   = var.ci_passwords["carthage"]
  ssh_pub_key   = local.ansible_ssh_pubkey
  dns           = local.pihole_dns
  domain        = local.agartha_domain

  proxmox_node             = local.primary_proxmox_node
  proxmox_api_url          = local.proxmox_api_urls[local.primary_proxmox_node]
  proxmox_api_token_id     = var.proxmox_secrets[local.primary_proxmox_node]["api_token_id"]
  proxmox_api_token_secret = var.proxmox_secrets[local.primary_proxmox_node]["api_token_secret"]
}

module "giza" {
  source = "./modules/vm"

  vm_id         = 203
  vm_name       = "giza"
  vm_desc       = "general services"
  static_ipv4   = "10.42.30.26"
  vm_template   = local.debian11_vm
  gateway       = local.network_configs["service"]["gateway"]
  nic           = local.network_configs["service"]["nic"]
  disk_location = local.vm_storage
  ci_user       = local.ansible_user
  ci_password   = var.ci_passwords["giza"]
  ssh_pub_key   = local.ansible_ssh_pubkey
  dns           = local.pihole_dns
  domain        = local.agartha_domain

  memory = 8192
  disk_size = "32G"
  
  proxmox_node             = local.primary_proxmox_node
  proxmox_api_url          = local.proxmox_api_urls[local.primary_proxmox_node]
  proxmox_api_token_id     = var.proxmox_secrets[local.primary_proxmox_node]["api_token_id"]
  proxmox_api_token_secret = var.proxmox_secrets[local.primary_proxmox_node]["api_token_secret"]
}

module "jericho" {
  source = "./modules/vm"

  vm_id         = 204
  vm_name       = "jericho"
  vm_desc       = "web proxy"
  static_ipv4   = "10.42.30.27"
  vm_template   = local.debian11_vm
  gateway       = local.network_configs["service"]["gateway"]
  nic           = local.network_configs["service"]["nic"]
  disk_location = local.vm_storage
  ci_user       = local.ansible_user
  ci_password   = var.ci_passwords["jericho"]
  ssh_pub_key   = local.ansible_ssh_pubkey
  dns           = local.pihole_dns
  domain        = local.agartha_domain
  
  proxmox_node             = local.primary_proxmox_node
  proxmox_api_url          = local.proxmox_api_urls[local.primary_proxmox_node]
  proxmox_api_token_id     = var.proxmox_secrets[local.primary_proxmox_node]["api_token_id"]
  proxmox_api_token_secret = var.proxmox_secrets[local.primary_proxmox_node]["api_token_secret"]
}

module "rhodes" {
  source = "./modules/vm"

  vm_id         = 205
  vm_name       = "rhodes"
  vm_desc       = "torrenting"
  static_ipv4   = "10.42.35.25"
  vm_template   = local.debian11_vm
  gateway       = local.network_configs["torrent"]["gateway"]
  nic           = local.network_configs["torrent"]["nic"]
  disk_location = local.vm_storage
  ci_user       = local.ansible_user
  ci_password   = var.ci_passwords["rhodes"]
  ssh_pub_key   = local.ansible_ssh_pubkey
  dns           = local.pihole_dns
  domain        = local.agartha_domain

  disk_size = "24G"
  
  proxmox_node             = local.primary_proxmox_node
  proxmox_api_url          = local.proxmox_api_urls[local.primary_proxmox_node]
  proxmox_api_token_id     = var.proxmox_secrets[local.primary_proxmox_node]["api_token_id"]
  proxmox_api_token_secret = var.proxmox_secrets[local.primary_proxmox_node]["api_token_secret"]
}
