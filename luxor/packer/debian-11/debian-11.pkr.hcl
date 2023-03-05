# provision debian-11 VM template on proxmox

# optional variables

variable "vm_name" {
  type = string
  default = "debian-11.6.0-amd64"
}

variable "iso_file" {
  type = string
  default = "local:iso/debian-11.6.0-amd64-netinst.iso"
}

variable "cloud_init_storage_pool" {
  type = string
  default = "ssd0"
}

variable "cores" {
  type = string
  default = "2"
}

variable "disk_format" {
  type = string
  default = "raw"
}

variable "disk_size" {
  type = string
  default = "16G"
}

variable "disk_storage_pool" {
  type = string
  default = "ssd0"
}

variable "disk_storage_pool_type" {
  type = string
  default = "lvm"
}

variable "cpu_type" {
  type = string
  default = "kvm64"
}

variable "memory" {
  type = string
  default = "2048"
}

variable "os" {
  type = string
  default = "l26"
}

variable "network_bridge" {
  type = string
  default = "vmbr1"
}

variable "network_vlan" {
  type = string
  default = ""
}

variable "ssh_username" {
  type = string
  default = "root"
}

variable "ssh_temp_password" {
  type = string
  default = "packer"
}

# required variables

variable "root_password_hash" {
  type = string
  sensitive = true
}

variable "vm_id" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
}


source "proxmox-iso" "debian-11" {
  proxmox_url = var.proxmox_api_url
  username = var.proxmox_api_token_id
  token = var.proxmox_api_token_secret

  insecure_skip_tls_verify = true # self-signed cert bypass

  node = var.proxmox_node
  vm_id = var.vm_id
  vm_name = var.vm_name
  template_description = "Debian 11 cloud-init template. Built on ${formatdate("YYYY-MM-DD hh:mm:ss ZZZ", timestamp())}"

  qemu_agent = true

  disks {
    disk_size = var.disk_size
    format = var.disk_format
    io_thread = true
    storage_pool = var.disk_storage_pool
    storage_pool_type = var.disk_storage_pool_type
    type = "scsi"
  }
  scsi_controller = "virtio-scsi-single"

  cores = var.cores
  sockets = 1
  memory = var.memory
  os = var.os

  network_adapters {
    model = "virtio"
    bridge = var.network_bridge
    firewall = "false"
    vlan_tag = var.network_vlan
  }

  iso_file = var.iso_file
  unmount_iso = true

  cloud_init = true
  cloud_init_storage_pool = var.cloud_init_storage_pool

  # local http server to serve files during proxmox VM setup...remember to add to firewall rules!
  http_directory = "${path.root}/http"
  http_bind_address = "0.0.0.0"
  http_port_min = 8802
  http_port_max = 8802

  # Boot commands
  boot_command = ["<esc><wait>auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<enter>"]
  boot_wait = "10s"

  ssh_username = var.ssh_username
  ssh_password = var.ssh_temp_password # changed during cloudinit
  ssh_timeout = "20m"
}

build {
  name = "debian-11"
  sources = ["source.proxmox-iso.debian-11"]

  # Clean up machine to prepare for templating
  provisioner "shell" {
    inline = [
      # clear machine-id; https://wiki.debian.org/MachineId
      "truncate -s 0 /etc/machine-id",
      "rm /var/lib/dbus/machine-id",
      "ln -s /etc/machine-id /var/lib/dbus/machine-id",

      # change root password
      "echo 'root:${var.root_password_hash}' | chpasswd -e",

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
    source = "${path.root}/http/cloud.cfg"
    destination = "/etc/cloud/cloud.cfg"
  }
}
