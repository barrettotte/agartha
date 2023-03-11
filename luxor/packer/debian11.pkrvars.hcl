proxmox_node    = "babylon"
proxmox_api_url = "https://10.42.10.52:8006/api2/json"

template_id          = "900"
template_name        = "debian11"
template_description = "Debian 11 cloud-init template"
iso_file             = "local:iso/debian-11.6.0-amd64-netinst.iso"

disk_storage_pool = "ssd0"
disk_size         = "16G"
cores             = "2"
memory            = "2048"
network_bridge    = "vmbr1"

cloud_init_storage_pool = "ssd0"
