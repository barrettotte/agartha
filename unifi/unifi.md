# Unifi

## Setup

- create Ubiquiti account
- setup MFA
- https://gist.github.com/davecoutts/5ccb403c3d90fcf9c8c4b1ea7616948d?permalink_comment_id=4240092#gistcomment-4240092
- LXC Debian 11.3
- 2GB RAM, 512MB swap, 1 Core, 8GB disk
- network `en01`, static IP `10.42.10.8`

```sh
apt update
apt install --yes gnupg wget haveged

# Unifi repository
wget -qO- https://dl.ui.com/unifi/unifi-repo.gpg \
  | tee /usr/share/keyrings/unifi-archive-keyring.gpg > /dev/null

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/unifi-archive-keyring.gpg] \
  https://www.ui.com/downloads/unifi/debian stable ubiquiti" \
  | tee /etc/apt/sources.list.d/100-ubnt-unifi.list > /dev/null

# MongoDB repository
wget -qO- https://www.mongodb.org/static/pgp/server-3.6.asc \
  | gpg --dearmor -o /usr/share/keyrings/mongodb-org-server-3.6-archive-keyring.gpg > /dev/null

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/mongodb-org-server-3.6-archive-keyring.gpg] \
  https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/3.6 multiverse" \
  | tee /etc/apt/sources.list.d/mongodb-org-3.6.list > /dev/null

# Java
mkdir /etc/systemd/system/unifi.service.d

printf "[Service]\nEnvironment=\"JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64\"\n" \
  | tee /etc/systemd/system/unifi.service.d/10-override.conf > /dev/null

apt update
apt install --yes openjdk-11-jre-headless

# Workaround issue where jsvc expects to find libjvm.so at lib/amd64/server/libjvm.so
ln -s /usr/lib/jvm/java-11-openjdk-amd64/lib/ /usr/lib/jvm/java-11-openjdk-amd64/lib/amd64

# MongoDB
apt install --yes mongodb-org-server
systemctl enable mongod.service
systemctl start mongod.service

# Unifi
apt install --yes unifi
apt clean

# Post-install check
systemctl status --no-pager --full mongod.service unifi.service
wget --no-check-certificate -qO- https://localhost:8443/status | python3 -m json.tool

journalctl --no-pager --unit unifi.service
cat /usr/lib/unifi/logs/server.log
cat /usr/lib/unifi/logs/mongod.log
``` 

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
