source "proxmox-iso" "debian11" {
  proxmox_url              = var.proxmox_api_url
  node                     = var.proxmox_node
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true # self-signed cert bypass

  vm_id                = var.template_id
  vm_name              = var.template_name
  template_description = var.template_description

  qemu_agent = true
  onboot     = true

  disks {
    disk_size    = var.disk_size
    format       = var.disk_format
    storage_pool = var.disk_storage_pool
    type         = var.disk_type
    io_thread    = true
  }
  scsi_controller = "virtio-scsi-single"

  cores   = var.cores
  sockets = 1
  memory  = var.memory
  os      = var.os

  network_adapters {
    model    = "virtio"
    bridge   = var.network_bridge
    firewall = "false"
    vlan_tag = var.network_vlan
  }

  iso_file    = var.iso_file
  unmount_iso = true

  cloud_init              = true
  cloud_init_storage_pool = var.cloud_init_storage_pool

  # local http server to serve files during proxmox VM setup...remember to add to firewall rules!
  http_directory    = "${path.root}/http"
  http_bind_address = "0.0.0.0"
  http_port_min     = 8802
  http_port_max     = 8802

  # Boot commands
  boot         = "order=scsi0;ide2;net0"
  # boot         = null
  boot_command = ["<esc><wait>auto preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait><enter>"]
  boot_wait    = "10s"
  machine      = "q35"

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "20m"
}
