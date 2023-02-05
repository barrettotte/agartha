# Switch

## Setup

- disconnect switch from Opnsense and connect PC to switch
- defaults to `192.168.0.1`
- on PC set ethernet adapter to `192.168.0.2`, toggle ethernet connection
- default credentials: `admin/admin`
- reset admin password
- set static IP to `10.42.0.2`
- on PC set ethernet adapter back to automatic, toggle ethernet connection
- log into switch at `10.42.0.2`
- layer 3 routing added interfaces for VLAN (temp)
  - VLAN10 10.42.0.2 (management?)
  - VLAN20 10.42.20.2 (home)

## Ports

TODO:

01. VLAN 10 (management)
02. Opnsense trunk port (All VLANs)
03. LAN access port (VLAN 0)
04. x
05. x
06. x
07. x
08. TP-Link Archer A7 router (VLAN 0) TODO:
09. x
10. x
11. x
12. x
13. x
14. Proxmox - babylon; VLAN 30 (services)
15. x
16. Proxmox - babylon; VLAN 10 (management)
17. VLAN 25 (guest)
18. Proxmox - sumer; VLAN 10 (management)
19. x
20. Octoprint; VLAN 20 (home)
21. VLAN 20 (home)
22. x
23. Main PC; VLAN 20 (home)
24. x
