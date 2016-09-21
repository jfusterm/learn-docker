#!/bin/bash

set -e 

# Function that will create /dev/sdc1
function part_disk {
fdisk -u /dev/sdc <<PART > /dev/null
n
p
1


w
PART
}

# Set DNS server
echo nameserver 8.8.8.8 > /etc/resolv.conf

# Install Docker requirements
apt-get update
apt-get install -y apt-transport-https ca-certificates linux-image-extra-$(uname -r) linux-image-extra-virtual
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial $3" > /etc/apt/sources.list.d/docker.list
apt-get update

# Install Docker
if [ $4 == "latest" ]; then
	apt-get install -y docker-engine
else
	apt-get install -y docker-engine=$4-0~xenial
fi

usermod -aG docker ubuntu

# Stop Docker Engine
systemctl stop docker

# Prepare /var/lib/docker
rm -fr /var/lib/docker/*

if [ $1 == "btrfs" ]; then
	part_disk
	mkfs.btrfs -f /dev/sdc1
	mount -t btrfs /dev/sdc1 /var/lib/docker
	echo "/dev/sdc1    /var/lib/docker    btrfs    defaults    0 0" >> /etc/fstab
elif [ $1 == "zfs" ]; then
	apt-get install -y zfs
	zpool create -f zroot /dev/sdc
	zfs create -o mountpoint=/var/lib/docker zroot/docker
	mkdir /var/lib/docker/zfs
else
	part_disk
	mkfs.ext4 -F /dev/sdc1
	mount -t ext4 /dev/sdc1 /var/lib/docker
	echo "/dev/sdc1    /var/lib/docker    ext4    defaults    0 0" >> /etc/fstab
fi

# Set Docker Engine configuration file
sed -i "s/STORAGE-DRIVER/$2/g" /tmp/daemon.json
mv /tmp/daemon.json /etc/docker

# Prepare the motd file
if [ -f /tmp/motd ]; then
	rm -f /etc/update-motd.d/*
	mv /tmp/motd /etc/update-motd.d/
	chmod +x /etc/update-motd.d/motd
fi

# Cleaning packages
apt-get clean

# Start Docker Engine
systemctl start docker
