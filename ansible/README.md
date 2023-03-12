# ansible

## Setup

```sh
# Proxmox initial node setup
mkdir -p ~/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4EyUDgrYVt9W5oEDK6qKCsDSck2XnAtlDeH65PB2sCEGY5BbvGL66CZ3nJPikCz8viwVZ4i03PtElpNl12ECtYWysJGavzRpeI/hFHpom4l5qWBI/PtkLEROmhvX59UROpU2IoPJ2WuqBNm3B0KwI6+uaETNDG1/NczAEquxOa7vBlfe+uZb5ngoTmw4pMJ0GZPvVOx6AdfzOsygbT6VIP3l0DYOsYsw19QFjoKQv6ZqGhUKZZG8nfExC3MgqjZZJkyHefEkKVaL75H7wT/z52/MVWIPitHwNTuCFtTmJ0hmg4YkrlScd4BHuzjudD0I0HvlIDeSJN4mnBcrz2mLMMx4yni8yEQ5GfTcK/erdZeubUw7o5OqFYjX5c3PnqGvmxUiiHIv4GhyCoWtvctBVUkaZNx1lLef5BNXumOHQEhWwpRRZzzIwrSVRxc1SRZUFqY9MW7udxDuQdMkt7pDqWCNCfKalJEH2oV/XEFsHtYcVc7EfNEaeyBl6qgfUaODfgiA+Qr5ulYOvW/W6SdojKHuAMnIq7KVV1fSYeJ/CB1esRiqAN4z75umibZ5e7kvP740B1VUqVZmyBfcJ1dB+eTzVDlAvMJtmnIdCoT/5jrFSwprSembq0IomI9HHOl53CsHNLiNscYQwdAc2U2JM9yMn0mowzTYSqjH2gra/VQ==' >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chown -R root:root ~/.ssh

# edit /etc/ssh/sshd_config

# restart ssh
systemctl restart ssh
```

```ini
# /etc/ssh/sshd_config

PermitRootLogin prohibit-password
ChallengeResponseAuthentication no
PubKeyAuthentication yes
PasswordAuthentication no
```

## Commands

- `ansible-playbook main.yml`
- add `-vvvv` for debugging

## References

- https://www.nathancurry.com/blog/14-ansible-deployment-with-proxmox/
- [Automate EVERYTHING with Ansible! (Ansible for Beginners)](https://www.youtube.com/watch?v=w9eCU4bGgjQ)
- [Jeff Geerling Ansible 101](https://www.youtube.com/playlist?list=PL2_OBreMn7FqZkvMYt6ATmgC0KAGGJNAN)
- https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-automate-initial-server-setup-on-ubuntu-22-04
- https://gist.github.com/nickleefly/b5fa141305e0845406db132997d95a36
- https://techviewleo.com/list-of-ansible-os-family-distributions-facts/
- ssh issues
  - https://unix.stackexchange.com/questions/675370/why-ssh-service-doesn-t-start-automatically-during-boot-despite-being-enabled-by
  - https://askubuntu.com/questions/1109934/ssh-server-stops-working-after-reboot-caused-by-missing-var-run-sshd/1110843#1110843
  - https://forum.proxmox.com/threads/ssh-server-restart-needed-after-package-upgrades.111855/
  - https://forum.proxmox.com/threads/ssh-doesnt-work-as-expected-in-lxc.54691/page-2#post-451843