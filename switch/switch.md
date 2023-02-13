# Switch

## General

- trunk ports = tagged (multi-VLAN on one single port)
- access ports = untagged (doesn't know about VLAN tags)
- Link Aggregation Group (LAG) - increase throughput of traffic

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

| Port | Description            | VLANs    |
| ---- | ---------------------- | -------- |
| 1    | emergency access       | 10       |
| 2    | OPNSense trunk         | ALL      |
| 3    |                        |          |
| 4    |                        |          |
| 5    |                        |          |
| 6    |                        |          |
| 7    |                        |          |
| 8    |                        |          |
| 9    | tigris (wireless AP)   | 20,25,50 |
| 10   |                        |          |
| 11   |                        |          |
| 12   |                        |          |
| 13   |                        |          |
| 14   | babylon (proxmox)      | 30       |
| 15   |                        |          |
| 16   | babylon (proxmox)      | 10       |
| 17   | test guest             | 25       |
| 18   | sumer (proxmox)        | 10       |
| 19   |                        |          |
| 20   | octoprint              | 20       |
| 21   | home access            | 20       |
| 22   |                        |          |
| 23   | Barrett-PC             | 20       |
| 24   |                        |          |
| 25   |                        | 5        |
| 26   |                        | 5        |
| 27   |                        | 5        |
| 28   |                        | 5        |
