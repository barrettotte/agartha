resource "proxmox_vm_qemu" "vm_qemu_cloudinit" {
  target_node = var.proxmox_node
  vmid        = var.vm_id
  name        = var.vm_name
  desc        = var.vm_desc

  clone      = var.vm_template
  full_clone = true
  onboot     = true # start when PVE node starts
  oncreate   = true # start after creation
  agent      = 1    # enable qemu-guest-agent

  automatic_reboot = true

  sockets = 1
  cores   = var.cores
  memory  = var.memory

  qemu_os = "l26"
  scsihw  = "virtio-scsi-single"
  hotplug = "network,disk,usb"

  network {
    bridge = var.nic
    model  = "virtio"
    tag    = var.vlan_tag
  }

  disk {
    backup   = true
    cache    = "none"
    discard  = "on"
    file     = "vm-${var.vm_id}-disk-0"
    format   = "raw"
    iothread = 1
    size     = var.disk_size
    slot     = 0
    ssd      = 1
    storage  = var.disk_location
    type     = "scsi"
    volume   = "${var.disk_location}:vm-${var.vm_id}-disk-0"
  }

  ipconfig0    = "ip=${var.static_ipv4}/24,gw=${var.gateway}"
  nameserver   = var.dns
  searchdomain = var.domain

  # cloudinit
  os_type    = "cloud-init"
  ciuser     = var.ci_user
  cipassword = var.ci_password
  sshkeys    = var.ssh_pub_key

  lifecycle {
    ignore_changes = [
      network, # MAC address is generated on every apply
      disk,
      qemu_os,
    ]
  }
}
