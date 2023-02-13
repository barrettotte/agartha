# Playbooks

- init users; TODO: FreeBSD support
- TODO: proxmox setup new node
- TODO: patch Debian and FreeBSD
- TODO: update Pihole
- TODO: setup unifi
- TODO: setup switch
- TODO: setup octoprint
- TODO: replace secrets.yml files with HashiCorp Vault lookups

## Run Playbooks

## Init Users

After this playbook is run, should no longer need to use root user.

```sh
### remote
# /etc/ssh/sshd_config
#   PermitRootLogin yes
systemctl restart ssh

### local
ansible-playbook ./playbooks/test/ping.yml -i inventory.yml --user=root
ansible-playbook ./playbooks/init/users/init-users.yml -i inventory.yml --user=root
```
