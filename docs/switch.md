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

01. emergency management access port (VLAN 10)
02. Opnsense trunk port (All VLANs)
03. x
04. x
05. x
06. x
07. x
08. TP-Link Archer A7 router (VLAN 20)
09. x
10. x
11. x
12. x
13. x
14. x
15. x
16. Proxmox (VLAN 10)
17. x
18. x
19. Main PC (VLAN 20)
20. Octoprint (VLAN 50)
21. x
22. x
23. x
24. x
