# Checklist

Sanity checklist for setting up/configuring machines

## Steps

The goal is to get as much of this into ansible as possible...eventually.

- [ ] update/upgrade, reboot if needed
- [ ] install ssh and sudo if not exists
- [ ] personal non-root user
- [ ] ansible service user
- [ ] docker service user (if needed)
- [ ] user ssh pubkey setup
- [ ] user sudo access
- [ ] `/etc/ssh/sshd_config` - no password auth, pubkey auth, no challenge response
- [ ] `/etc/network/interfaces` - static IP and DNS
- [ ] verify hostname - `hostname`, set with `sudo hostnamectl set-hostname HOST`
- [ ] verify hostname - `/etc/hosts`
- [ ] verify timezone - `timedatectl`, set with `sudo timedatectl set-timezone America/New_York`
- [ ] verify NTP - `systemctl status systemd-timesyncd`, config in `/etc/systemd/timesyncd.conf`
- [ ] install QEMU guest agent (VM only) - `sudo apt-get install qemu-guest-agent` and reboot
- [ ] firewall
- [ ] fail2ban
- [ ] logging, either promtail (loki) container or something like `syslog-ng`
- [ ] metrics, node-exporter (prometheus) container/systemd
- [ ] rsync backups? Probably just for non-VM/LXC machines

## Machines Checked

- [ ] athens
- [ ] babylon
- [ ] carthage
- [ ] euphrates
- [ ] giza
- [ ] jericho
- [ ] pihole
- [ ] octoprint
- [ ] opnsense
- [ ] rhodes
- [ ] sumer
- [ ] tigris
- [ ] truenas
- [ ] unifi
