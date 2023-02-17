# TODO:

- FreeBSD support (truenas)
  - https://docs.ansible.com/ansible/2.6/user_guide/playbooks_conditionals.html
  - init users
  - update
- proxmox setup new node
- update Pihole
- setup unifi
- setup switch
- setup Opnsense
- setup Octoprint
- setup 
- replace secrets.yml files with HashiCorp Vault lookups

## Run Playbooks

## Init Users

After this playbook is run, should no longer need to use root user.

```sh
### remote
# /etc/ssh/sshd_config
#   PermitRootLogin yes
systemctl restart ssh

### local
ansible-playbook ./playbooks/test/ping.yml --user=root
ansible-playbook ./playbooks/init/users/init-users.yml
```

## Other

- test connections - `ansible-playbook ./playbooks/test/ping.yml`
- update Debian-based servers - `ansible-playbook ./playbooks/update/update-debian.yml`
