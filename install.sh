#!/bin/bash

set -e
set -x

sudo apt-get update

# tools

sudo apt-get install -y python-pip
sudo apt-get install -y jq
sudo apt-get install -y nfs-common

sudo pip install awscli

# docker

sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo systemctl enable docker
sudo service docker restart
sudo gpasswd -a ubuntu docker

# docker-compose

sudo curl -L "https://github.com/docker/compose/releases/download/1.12.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# cloud-compose

sudo mkdir -p /var/lib/cloud-compose
sudo cp /tmp/cloud-compose.sh /usr/local/sbin/cloud-compose.sh
sudo chmod a+x /usr/local/sbin/cloud-compose.sh
sudo cp /tmp/rc.local /etc/rc.local
sudo chmod a+x /etc/rc.local

# upgrade

sudo apt-get -y upgrade