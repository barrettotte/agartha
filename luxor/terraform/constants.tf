locals {
  network_configs = {
    "manage" = {
      nic     = "vmbr0"
      gateway = "10.42.10.1"
    }
    "service" = {
      nic     = "vmbr1"
      gateway = "10.42.30.1"
    }
    "torrent" = {
      nic     = "vmbr2"
      gateway = "10.42.35.1"
    }
    "lab" = {
      nic     = "vmbr3"
      gateway = "10.42.40.1"
    }
  }

  proxmox_api_urls = {
    "babylon" = "https://10.42.10.52:8006/api2/json"
    "sumer" = "https://10.42.10.53:8006/api2/json"
  }

  primary_proxmox_node = "babylon"
  pihole_dns           = "10.42.30.10"
  agartha_domain       = ".agartha"
  vm_storage           = "ssd0"
  debian11_vm          = "debian11"
  ansible_user         = "ansible"
  ansible_ssh_pubkey   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4EyUDgrYVt9W5oEDK6qKCsDSck2XnAtlDeH65PB2sCEGY5BbvGL66CZ3nJPikCz8viwVZ4i03PtElpNl12ECtYWysJGavzRpeI/hFHpom4l5qWBI/PtkLEROmhvX59UROpU2IoPJ2WuqBNm3B0KwI6+uaETNDG1/NczAEquxOa7vBlfe+uZb5ngoTmw4pMJ0GZPvVOx6AdfzOsygbT6VIP3l0DYOsYsw19QFjoKQv6ZqGhUKZZG8nfExC3MgqjZZJkyHefEkKVaL75H7wT/z52/MVWIPitHwNTuCFtTmJ0hmg4YkrlScd4BHuzjudD0I0HvlIDeSJN4mnBcrz2mLMMx4yni8yEQ5GfTcK/erdZeubUw7o5OqFYjX5c3PnqGvmxUiiHIv4GhyCoWtvctBVUkaZNx1lLef5BNXumOHQEhWwpRRZzzIwrSVRxc1SRZUFqY9MW7udxDuQdMkt7pDqWCNCfKalJEH2oV/XEFsHtYcVc7EfNEaeyBl6qgfUaODfgiA+Qr5ulYOvW/W6SdojKHuAMnIq7KVV1fSYeJ/CB1esRiqAN4z75umibZ5e7kvP740B1VUqVZmyBfcJ1dB+eTzVDlAvMJtmnIdCoT/5jrFSwprSembq0IomI9HHOl53CsHNLiNscYQwdAc2U2JM9yMn0mowzTYSqjH2gra/VQ=="
}
