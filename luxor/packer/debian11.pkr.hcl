source "proxmox-iso" "debian11" {
  proxmox_url = var.proxmox_api_url
  username    = var.proxmox_api_token_id
  token       = var.proxmox_api_token_secret

  insecure_skip_tls_verify = true # self-signed cert bypass

  node                 = var.proxmox_node
  vm_id                = var.template_id
  vm_name              = var.template_name
  template_description = var.template_description

  qemu_agent = true
  onboot     = true

  disks {
    disk_size    = var.disk_size
    format       = var.disk_format
    storage_pool = var.disk_storage_pool
    type         = "scsi"
    io_thread    = true

    # Discard is disabled by default and not in Packer provider yet - https://github.com/hashicorp/packer-plugin-proxmox/issues/69
    # SSD emulation is also not configurable via Packer yet
    #
    # This will slow down clone...
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
  http_directory    = "${path.root}/debian11/http"
  http_bind_address = "0.0.0.0"
  http_port_min     = 8802
  http_port_max     = 8802

  # Boot commands
  boot         = "order=scsi0;ide2;net0"
  boot_command = ["<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
  boot_wait    = "10s"
  machine      = "q35"

  ssh_username = var.ssh_username
  ssh_password = var.ssh_temp_password # changed during cloudinit
  ssh_timeout  = "20m"
}

build {
  name    = "debian11"
  sources = ["source.proxmox-iso.debian11"]

  # Clean up machine to prepare for template conversion
  provisioner "shell" {
    inline = [
      # clear machine-id; https://wiki.debian.org/MachineId
      "truncate -s 0 /etc/machine-id",
      "rm /var/lib/dbus/machine-id",
      "ln -s /etc/machine-id /var/lib/dbus/machine-id",

      # change root password
      "echo 'root:${var.root_password_hash}' | chpasswd -e",

      # add cloud init config
      "echo 'datasource_list: [ NoCloud, ConfigDrive, None ]' > /etc/cloud/cloud.cfg.d/99_pve.cfg",
      "chmod 644 /etc/cloud/cloud.cfg.d/99_pve.cfg",

      # misc cleaning
      "rm /etc/ssh/ssh_host_*",
      "apt-get -y autoremove --purge",
      "apt-get -y clean",
      "apt-get -y autoclean",
      "cloud-init clean",
      "sync"
    ]
  }

  provisioner "file" {
    source      = "${path.root}/debian11/http/cloud.cfg"
    destination = "/etc/cloud/cloud.cfg"
  }
}
