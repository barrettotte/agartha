variable proxmox_secrets {
  type = map(object({
    api_token_id     = string
    api_token_secret = string
  }))
  sensitive = true
}

variable "ci_passwords" {
  type      = map(string)
  sensitive = true
}
