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
network_bridge    = "vmbr0"

cloud_init_storage_pool = "ssd0"

ssh_pubkey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4EyUDgrYVt9W5oEDK6qKCsDSck2XnAtlDeH65PB2sCEGY5BbvGL66CZ3nJPikCz8viwVZ4i03PtElpNl12ECtYWysJGavzRpeI/hFHpom4l5qWBI/PtkLEROmhvX59UROpU2IoPJ2WuqBNm3B0KwI6+uaETNDG1/NczAEquxOa7vBlfe+uZb5ngoTmw4pMJ0GZPvVOx6AdfzOsygbT6VIP3l0DYOsYsw19QFjoKQv6ZqGhUKZZG8nfExC3MgqjZZJkyHefEkKVaL75H7wT/z52/MVWIPitHwNTuCFtTmJ0hmg4YkrlScd4BHuzjudD0I0HvlIDeSJN4mnBcrz2mLMMx4yni8yEQ5GfTcK/erdZeubUw7o5OqFYjX5c3PnqGvmxUiiHIv4GhyCoWtvctBVUkaZNx1lLef5BNXumOHQEhWwpRRZzzIwrSVRxc1SRZUFqY9MW7udxDuQdMkt7pDqWCNCfKalJEH2oV/XEFsHtYcVc7EfNEaeyBl6qgfUaODfgiA+Qr5ulYOvW/W6SdojKHuAMnIq7KVV1fSYeJ/CB1esRiqAN4z75umibZ5e7kvP740B1VUqVZmyBfcJ1dB+eTzVDlAvMJtmnIdCoT/5jrFSwprSembq0IomI9HHOl53CsHNLiNscYQwdAc2U2JM9yMn0mowzTYSqjH2gra/VQ=="
