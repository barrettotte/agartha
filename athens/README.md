# athens

Debian VM with Docker containers for management and network monitoring services.

## file-browser

- default creds: `admin / admin`

## cloudbeaver

- `/#/admin`
- NOTE: have to manually log in as admin and enable reverse proxy setting...can't find the setting for some reason

## NUT server

- `CyberPower OR1500LCDRT2U` - USB-A to babylon
- `CyberPower CP1500AVRLCD` - USB-A to babylon

```sh
lsusb | grep "Cyber Power"
# Bus 003 Device 002: ID 0764:0601 Cyber Power System, Inc. PR1500LCDRT2U UPS
# Bus 001 Device 007: ID 0764:0501 Cyber Power System, Inc. CP1500 AVR UPS

```

## References

- https://dbeaver.com/docs/cloudbeaver/Server-configuration/
