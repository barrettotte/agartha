# Ansible

## Setup

```sh
# install

sudo apt update
sudo apt install python3-pip
pip3 install passlib

sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

ansible --version
```

### WSL2 Fixes

```sh
# fix for WSL2

ansible all --list-hosts
# [WARNING]: Ansible is being run in a world writable directory (/mnt/x/repos/infra/ansible), ignoring it as an ansible.cfg source.

# when WSL2 mounts drives, it doesn't know about unix permissions by default for some reason...so have to enable it

sudo -e /etc/wsl.conf
```

```ini
# /etc/wsl.conf

[automount]
options = "metadata"
```

```powershell
# restart WSL2
wsl --shutdown; Start-Sleep -Seconds 10; wsl
```

```sh
# fix permissions for all repos (rwxrwx---)
sudo chmod -R 770 /mnt/x/repos
```

### Test Inventory

```ini
# inventory

[agartha]
unifi.agartha
babylon.agartha
sumer.agartha
octoprint.agartha
pihole.agartha
truenas.agartha

[proxmox]
babylon.agartha
sumer.agartha
```

```sh
# tests

# test inventory lists
ansible all --list-hosts
ansible proxmox --list-hosts
```

### Install Collections

```sh
# install collections

ansible-galaxy collection install ansible.posix
```

### Prep for Init Users Playbook

```sh
# setup ansible service user ssh keypair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ansible_id_rsa

python3 -c 'import crypt; print(crypt.crypt("This is my Password", "$1$SomeSalt$"))'

# on remote
#   /etc/ssh/sshd_config -> PermitRootLogin prohibit-password
#   systemctl restart ssh
```

### Test connections

```sh
# test connectivity to inventory
ansible all -m ping

# return information about servers
ansible babylon.agartha -m setup
```

## Playbooks

- `ansible-playbook ./playbooks/playbook.yml --user ansible --ask-become-pass -i inventory.yml`
- `ansible-playbook ./playbooks/main/init-docker.yml -i inventory.yml`
- use variables from file - `--extra-vars "@some_file.yaml"`
- debug root connection - `ansible-playbook ./playbooks/test/ping.yml -i inventory.yml -vvvv -k`

## Setup Debian Docker Machines

```sh
#!/bin/bash

ansible-playbook ./playbooks/main/init-root-ssh.yml -i inventory.yml -k
ansible-playbook ./playbooks/main/init-users.yml -i inventory.yml
ansible-playbook ./playbooks/main/init-docker.yml -i inventory.yml
```

## Roles

- `ansible-galaxy install -r requirements.yml`

## Ansible Vault

- `ansible-vault encrypt vars/secrets.yml`
- `ansible-playbook playbook.yml --vault-password-file ~/.ansible/vault-password

## References

- [Automate EVERYTHING with Ansible! (Ansible for Beginners)](https://www.youtube.com/watch?v=w9eCU4bGgjQ)
- [Jeff Geerling Ansible 101](https://www.youtube.com/playlist?list=PL2_OBreMn7FqZkvMYt6ATmgC0KAGGJNAN)
- https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-automate-initial-server-setup-on-ubuntu-22-04
- https://gist.github.com/nickleefly/b5fa141305e0845406db132997d95a36
- https://techviewleo.com/list-of-ansible-os-family-distributions-facts/
