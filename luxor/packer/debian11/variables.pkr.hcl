# required

variable "proxmox_api_token_id" {
  type        = string
  description = "Proxmox API token ID"
}

variable "proxmox_api_token_secret" {
  type        = string
  description = "Proxmox API token secret"
  sensitive   = true
}

variable "root_password_hash" {
  type        = string
  description = "Default password for root user"
  sensitive   = true
}

variable "ssh_pubkey" {
    type        = string
    description = "SSH public key"
}

variable "template_id" {
  type        = string
  description = "ID for VM template"
}

variable "template_name" {
  type        = string
  description = "Identifier for VM template"
}

variable "proxmox_node" {
  type        = string
  description = ""
}

variable "proxmox_api_url" {
  type        = string
  description = ""
}

variable "iso_file" {
  type        = string
  description = "URL to iso file"
}

variable "cloud_init_storage_pool" {
  type        = string
  description = ""
}

variable "disk_storage_pool" {
  type        = string
  description = ""
}

# optional

variable "template_description" {
  type        = string
  default     = "Debian 11 cloud-init"
  description = "Description of VM template"
}

variable "ssh_username" {
  type        = string
  description = ""
  default     = "packer"
}

variable "ssh_password" {
  type        = string
  description = ""
  sensitive   = true
  default     = "packer"
}

variable "cores" {
  type        = string
  description = ""
  default     = "2"
}

variable "disk_format" {
  type        = string
  description = "Format of OS disk"
  default     = "raw"

  validation {
    condition     = contains(["raw", "cow", "qcow", "qed", "qcow2", "vmdk", "cloop"], var.disk_format)
    error_message = "Disk format must be 'raw', 'cow', 'qcow', 'qed', 'qcow2', 'vmdk', or 'cloop'."
  }
}

variable "disk_type" {
  type        = string
  description = "The type of disk device to add."
  default     = "scsi"

  validation {
    condition     = contains(["ide", "sata", "scsi", "virtio"], var.disk_type)
    error_message = "Disk type must be 'ide', 'sata', 'scsi', or 'virtio'."
  }
}

variable "disk_size" {
  type        = string
  description = "Size of OS diskk with size suffix (K, M, G)."
  default     = "16G"
  
  validation {
    condition     = can(regex("^\\d+[GMK]$", var.disk_size))
    error_message = "The disk size must be a number with a size suffix (K, M, G)."
  }
}

variable "cpu_type" {
  type        = string
  description = ""
  default     = "kvm64"
}

variable "memory" {
  type        = string
  description = "Amount of memory in megabytes"
  default     = "2048"
}

variable "os" {
  type        = string
  description = "Operating system family"
  default     = "l26"
}

variable "network_bridge" {
  type        = string
  description = "Network bridge"
  default     = "vmbr0"
}

variable "network_vlan" {
  type        = string
  description = "VLAN tag"
  default     = ""
}
