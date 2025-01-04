#!/usr/bin/env bash
#
# Script to install Cockpit for Samba management on Ubuntu (24.04/Noble)

# Dummy NetworkManager interface. Hack b/c Cockpit wants to see an Interface in NetworkManager,
# but newer Ubuntu's use systemd-networkd/netplan
sudo nmcli con add type dummy con-name fake ifname fake0 ip4 192.0.2.0/24 gw4 192.0.2.1

# install Samba and Cockpit (get newest from backports)
sudo apt install -y samba
sudo apt install -y -t noble-backports cockpit

# install the 45Drives repo for Cockpit modules, then install modules
curl -sSL https://repo.45drives.com/setup | sudo bash
sudo apt update
sudo apt install -y cockpit-file-sharing cockpit-identities

# cockpit-file-sharing enables NFS, disable
sudo systemctl stop nfs-kernel-server
sudo systemctl disable nfs-kernel-server

echo "May need to reboot for dummy NetworkManager interface to show up"
