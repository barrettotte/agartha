#!/bin/bash
# Install unifi
# https://gist.github.com/davecoutts/5ccb403c3d90fcf9c8c4b1ea7616948d?permalink_comment_id=4240092#gistcomment-4240092

apt update
apt install --yes gnupg wget haveged

# Unifi repository
wget -qO- https://dl.ui.com/unifi/unifi-repo.gpg \
  | tee /usr/share/keyrings/unifi-archive-keyring.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/unifi-archive-keyring.gpg] \
  https://www.ui.com/downloads/unifi/debian stable ubiquiti" \
  | tee /etc/apt/sources.list.d/100-ubnt-unifi.list > /dev/null

# MongoDB repository
wget -qO- https://www.mongodb.org/static/pgp/server-3.6.asc \
  | gpg --dearmor -o /usr/share/keyrings/mongodb-org-server-3.6-archive-keyring.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/mongodb-org-server-3.6-archive-keyring.gpg] \
  https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/3.6 multiverse" \
  | tee /etc/apt/sources.list.d/mongodb-org-3.6.list > /dev/null

# Init Unifi directory
mkdir /etc/systemd/system/unifi.service.d

# Java
printf "[Service]\nEnvironment=\"JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64\"\n" \
  | tee /etc/systemd/system/unifi.service.d/10-override.conf > /dev/null

apt update
apt install --yes openjdk-11-jre-headless

# Workaround issue where jsvc expects to find libjvm.so at lib/amd64/server/libjvm.so
ln -s /usr/lib/jvm/java-11-openjdk-amd64/lib/ /usr/lib/jvm/java-11-openjdk-amd64/lib/amd64

# MongoDB
apt install --yes mongodb-org-server
systemctl enable mongod.service
systemctl start mongod.service

# Unifi
apt install --yes unifi
apt clean

# Post-install check
systemctl status --no-pager --full mongod.service unifi.service
wget --no-check-certificate -qO- https://localhost:8443/status | python3 -m json.tool

journalctl --no-pager --unit unifi.service
cat /usr/lib/unifi/logs/server.log
cat /usr/lib/unifi/logs/mongod.log

# Misc Dependencies
apt-get install -y mongodb-org whois

# TODO: convert to ansible playbook!