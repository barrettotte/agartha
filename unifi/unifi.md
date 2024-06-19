# Unifi

## Setup

- create Ubiquiti account
- setup MFA
- https://gist.github.com/davecoutts/5ccb403c3d90fcf9c8c4b1ea7616948d?permalink_comment_id=4240092#gistcomment-4240092
- LXC Debian 11.3
- 2GB RAM, 1GB swap, 1 Core, 4GB disk
- network `en01`, static IP `10.42.10.8`

https://florianmuller.com/setup-a-self-hosted-unifi-controller-on-a-hardened-proxmox-lxc-ubuntu-container

see `install-unifi.sh`

Alternative to try in future: 
https://community.ui.com/questions/UniFi-Installation-Scripts-or-UniFi-Easy-Update-Script-or-UniFi-Lets-Encrypt-or-UniFi-Easy-Encrypt-/ccbc7530-dd61-40a7-82ec-22b17f027776

## Wireless AP

- Find access point IP
- Unifi AP > Settings
  - static IP: `10.42.10.13`
  - subnet: `255.255.255.0`
  - gateway: `10.42.10.1`
  - DNS: `10.42.30.10`, `8.8.8.8`
- Settings > Networks
  - name: `home`, VLAN: `20`, DHCP: `10.42.20.1`
  - name: `guest`, VLAN: `25`, DHCP: `10.42.25.1`
  - name: `iot`, VLAN: `50`, DHCP: `10.42.50.1`
- Settings > WiFi
  - SSID: `agartha-home`, network: `home`
  - SSID: `agartha-guest`, network: `guest`
  - SSID: `agartha-iot`, network: `iot`
- Settings > System
  - Advanced > Disable Device Authentication

## Reset Admin Password

- https://cwl.cc/2020/10/resetting-a-unifi-controllers-admin-password.html
- https://stackoverflow.com/questions/67310229/unifi-contoller-password-reset

```sh
# dependencies
apt-get install -y mongodb-org whois

# find admin account
mongo --port 27117 ace --eval "db.admin.find().forEach(printjson);"

# reset admin password to 'password', make sure admin.name matches what was found in prior step
mongo -port 27117 ace --eval 'db.admin.update( { name: "administrator" }, {$set: { x_shadow: "$6$9Ter1EZ9$lSt6/tkoPguHqsDK0mXmUsZ1WE2qCM4m9AQ.x9/eVNJxws.hAxt2Pe8oA9TFB7LPBgzaHBcAfKFoLpRQlpBiX1" } } );'

# confirm able to login to admin panel

# reset password to specified value
# (salt for UniFi mongo install is 9Ter1EZ9$lSt6)
mkpasswd --method=sha-512 --salt=9Ter1EZ9$lSt6 NEW_PASSWORD

# update admin account with new hashed password
mongo -port 27117 ace --eval 'db.admin.update({ "_id" : ObjectId("MY_ADMIN_OBJECT_ID")},{$set: {"x_shadow" : "PASSWORD_HASH_FROM_MKPASSWD"}})'

# should now be able to login with new password
```

### Opnsense

- Add firewall rule to `home` interface
  - source: `10.42.20.13`
  - destination: `10.42.10.8`

### Switch

- L2 Features > VLAN > 802.1Q VLAN
- Port Config > Port 9 - PVID: 10
- VLAN Config
  - 1: Remove port 9
  - 10: Add untagged port 9
  - 20: Add tagged port 9
  - 25: Add tagged port 9
  - 50: Add tagged port 9

### Misc

- SSH to access point; default creds `ubnt/ubnt`
- `set-inform http://10.42.10.8:8080/inform`
