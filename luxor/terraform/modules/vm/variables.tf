# required

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_node" {
  type = string
}

variable "vm_template" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "vm_name" {
  type = string
}

variable "vm_desc" {
  type = string
}

variable "static_ipv4" {
  type = string
}

variable "gateway" {
  type = string
}

variable "nic" {
  type = string
}

variable "disk_location" {
  type = string
}

variable "ci_user" {
  type = string
}

variable "ci_password" {
  type      = string
  sensitive = true
}

variable "ssh_pub_key" {
  type = string
}

variable "dns" {
  type = string
}

variable "domain" {
  type = string
}

# optional

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 4096
}

variable "disk_size" {
  type    = string
  default = "16G"
}

variable "vlan_tag" {
  type    = number
  default = null
}
