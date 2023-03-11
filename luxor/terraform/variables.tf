# secrets

variable "proxmox_babylon_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_babylon_api_token_secret" {
  type      = string
  sensitive = true
}

variable "proxmox_sumer_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_sumer_api_token_secret" {
  type      = string
  sensitive = true
}
