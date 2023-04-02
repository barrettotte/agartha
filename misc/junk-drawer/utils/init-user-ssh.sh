#!/bin/bash

# init personal user ssh access via public key

ssh_user=barrett
ssh_pubkey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4EyUDgrYVt9W5oEDK6qKCsDSck2XnAtlDeH65PB2sCEGY5BbvGL66CZ3nJPikCz8viwVZ4i03PtElpNl12ECtYWysJGavzRpeI/hFHpom4l5qWBI/PtkLEROmhvX59UROpU2IoPJ2WuqBNm3B0KwI6+uaETNDG1/NczAEquxOa7vBlfe+uZb5ngoTmw4pMJ0GZPvVOx6AdfzOsygbT6VIP3l0DYOsYsw19QFjoKQv6ZqGhUKZZG8nfExC3MgqjZZJkyHefEkKVaL75H7wT/z52/MVWIPitHwNTuCFtTmJ0hmg4YkrlScd4BHuzjudD0I0HvlIDeSJN4mnBcrz2mLMMx4yni8yEQ5GfTcK/erdZeubUw7o5OqFYjX5c3PnqGvmxUiiHIv4GhyCoWtvctBVUkaZNx1lLef5BNXumOHQEhWwpRRZzzIwrSVRxc1SRZUFqY9MW7udxDuQdMkt7pDqWCNCfKalJEH2oV/XEFsHtYcVc7EfNEaeyBl6qgfUaODfgiA+Qr5ulYOvW/W6SdojKHuAMnIq7KVV1fSYeJ/CB1esRiqAN4z75umibZ5e7kvP740B1VUqVZmyBfcJ1dB+eTzVDlAvMJtmnIdCoT/5jrFSwprSembq0IomI9HHOl53CsHNLiNscYQwdAc2U2JM9yMn0mowzTYSqjH2gra/VQ=='

mkdir -p /home/$ssh_user/.ssh
echo $ssh_pubkey >> /home/$ssh_user/.ssh/authorized_keys

chmod 700 /home/$ssh_user/.ssh
chmod 600 /home/$ssh_user/.ssh/authorized_keys
chown -R $ssh_user:$ssh_user /home/$ssh_user/.ssh

sed -i 's/^#?PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart ssh
