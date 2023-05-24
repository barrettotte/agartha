# rhodes

Debian VM with Docker containers for torrenting services.

## Transmission

Test VPN successful - `echo "vpn=$(docker exec transmission-openvpn curl -s https://api.ipify.org), home=$(curl -s https://api.ipify.org)"`

In `transmission.env` `DISABLE_PORT_UPDATER=yes` is needed because apparently US-based PIA servers don't allow port forwarding?
