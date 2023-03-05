#!/bin/bash
# Install dependencies

set -e

ssh_pub_key =
personal_user = barrett

apt install sudo

sudo apt update
sudo apt upgrade -y

sudo apt install curl gnupg software-properties-common python3-pip -y
pip3 install passlib

wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update

sudo apt install packer ansible terraform -y

# setup personal user

sudo adduser $personal_user
sudo usermod -aG sudo $personal_user

mkdir -p /home/$personal_user/.ssh
echo "$ssh_pub_key" >> /home/$personal_user/.ssh/authorized_keys
chmod 700 /home/$personal_user/.ssh
chmod 600 /home/$personal_user/.ssh/authorized_keys
chown -R $personal_user:$personal_user /home/$personal_user/.ssh
