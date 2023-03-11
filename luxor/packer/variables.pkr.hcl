# required

variable "root_password_hash" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "template_id" {
  type = string
}

variable "template_name" {
  type = string
}

variable "template_description" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_api_url" {
  type = string
}

variable "iso_file" {
  type = string
}

variable "cloud_init_storage_pool" {
  type = string
}

variable "disk_storage_pool" {
  type = string
}

# optional

variable "cores" {
  type    = string
  default = "2"
}

variable "disk_format" {
  type    = string
  default = "raw"
}

variable "disk_size" {
  type    = string
  default = "16G"
}

variable "cpu_type" {
  type    = string
  default = "kvm64"
}

variable "memory" {
  type    = string
  default = "2048"
}

variable "os" {
  type    = string
  default = "l26"
}

variable "network_bridge" {
  type    = string
  default = "vmbr1"
}

variable "network_vlan" {
  type    = string
  default = ""
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_temp_password" {
  type    = string
  default = "packer"
}
