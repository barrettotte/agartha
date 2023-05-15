build {
  sources = [
    "source.file.preseed",
    "source.proxmox-iso.debian11",
  ]

  provisioner "file" {
    source      = "${path.root}/http/cloud.cfg"
    destination = "/tmp/99_pve.cfg"
  }

  # Packages and config
  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo env {{ .Vars }} {{ .Path }};"
    inline = [
      "apt-get update",
      "apt-get install -y sudo cloud-init cloud-guest-utils parted",

      # "echo 'datasource_list: [ NoCloud, ConfigDrive, None ]' > /etc/cloud/cloud.cfg.d/99_pve.cfg",
      "sudo cp /tmp/99_pve.cfg /etc/cloud/cloud.cfg.d/99_pve.cfg",
      # "sudo chmod 644 /etc/cloud/cloud.cfg.d/99_pve.cfg",

      # clear machine-id; https://wiki.debian.org/MachineId
      "truncate -s 0 /etc/machine-id",
      "rm /var/lib/dbus/machine-id",
      "ln -s /etc/machine-id /var/lib/dbus/machine-id",

      # change root password
      "echo 'root:${var.root_password_hash}' | chpasswd -e",

      # allow root ssh pubkey access
      # "mkdir -p /root/.ssh",
      # "echo '${var.ssh_pubkey}' > /root/.ssh/authorized_keys",
      # "chmod -R 700 /root/.ssh",
      # "chmod -R 600 /root/.ssh/authorized_keys",
      # "chown -R root:root /root/.ssh",

      # finish cleaning
      "apt-get clean -y",
    ]
  }

  # Cleanup and disable packer provisioner access
  provisioner "shell" {
    environment_vars = [
      "SSH_USERNAME=${var.ssh_username}"
    ]
    skip_clean      = true
    execute_command = "chmod +x {{ .Path }}; sudo env {{ .Vars }} {{ .Path }}; rm -f {{ .Path }}"
    inline = [
      "shred -u /etc/ssh/*_key /etc/ssh/*_key.pub",
      "unset HISTFILE; rm -rf /home/*/.*history /root/.*history",
      "passwd -d $SSH_USERNAME",
      "passwd -l $SSH_USERNAME",
      "rm -rf /home/$SSH_USERNAME/.ssh/authorized_keys",
      "rm -rf /etc/sudoers.d/packer",
    ]
  }
}