source "file" "preseed" {
  content = templatefile("${path.root}/templates/preseed.cfg.pkrtpl", {
    ssh_username      = var.ssh_username
    ssh_password_hash = bcrypt(var.ssh_password)
    ssh_pubkey        = var.ssh_pubkey
  })
  target = "${path.root}/http/preseed.cfg"
}
