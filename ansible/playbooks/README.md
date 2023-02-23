# Ansible

## Init Users

After this playbook is run, should no longer need to use root user.

```sh
### remote
# /etc/ssh/sshd_config
#   PermitRootLogin prohibit-password
# TODO: add this step to proxmox debian-lxc setup
systemctl restart ssh

### local
ansible-playbook ./playbooks/test/ping.yml --user=root
ansible-playbook ./playbooks/init/users/init-users.yml
```

## Setup Machines

```sh
# Setup carthage.agartha

ansible-playbook ./playbooks/init/init-users.yml --limit carthage.agartha
ansible-playbook ./playbooks/test/ping.yml --limit carthage.agartha
ansible-playbook ./playbooks/init/init-docker.yml --limit carthage.agartha
```

## Misc

- test connections - `ansible-playbook ./playbooks/test/ping.yml`
- update Debian-based servers - `ansible-playbook ./playbooks/update/update-debian.yml`
- limiting to one host - `ansible-playbook ./playbooks/init/init-docker.yml --limit carthage.agartha`

`ssh-copy-id -i ~/.ssh/id_rsa.pub user@host`
