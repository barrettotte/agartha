
#   device-mapper: resume ioctl on  (253:10) failed: Invalid argument
#   Unable to resume ssd0-vm--900--disk--0 (253:10).
# TASK ERROR: clone failed: can't refresh LV '/dev/ssd0/vm-900-disk-0' for activation:   Failed to reactivate ssd0/vm-900-disk-0.

# device-mapper: resume ioctl on failed: Invalid argument
# https://support.hpe.com/hpesc/public/docDisplay?docId=c03744232&docLocale=en_US

# note: could it be trying to use cloud_init drive instead of 16G disk by accident?

resource "proxmox_vm_qemu" "vm_qemu_cloudinit" {
  target_node = var.proxmox_node
  vmid        = var.vm_id
  name        = var.vm_name
  desc        = var.vm_desc

  clone      = var.vm_template
  full_clone = true
  sshkeys    = var.ssh_pub_key
  onboot     = true # start when PVE node starts
  oncreate   = true # start after creation
  agent      = 1 # enable qemu-guest-agent

  sockets = 1
  cores   = var.cores
  memory  = var.memory

  qemu_os          = "l26"
  scsihw           = "virtio-scsi-single"
  hotplug          = "network,disk,usb"
  automatic_reboot = true

  network {
    bridge = var.nic
    model  = "virtio"
    tag    = var.vlan_tag
  }

  ipconfig0    = "ip=${var.static_ipv4}/24,gw=${var.gateway}"
  nameserver   = var.dns_server
  searchdomain = var.search_domain

  # cloudinit
  os_type = "cloud-init"
  ciuser  = var.default_user

  lifecycle {
    ignore_changes = [
      ciuser,
      sshkeys,
      network
    ]
  }

  # note: PCI passthrough doesn't seem to be available...will complete in later in-between step
  # VM Configuration - https://pve.proxmox.com/pve-docs/qm.1.html
  # qm set VMID -hostpci0 00:02.0
  # qm set VMID -hostpci0 02:00,pcie=on,x-vga=on
}
