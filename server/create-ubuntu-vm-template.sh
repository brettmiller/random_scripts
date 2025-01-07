#!/usr/bin/env bash

# create a cloud-init template vm
# figured out from https://github.com/UntouchedWagons/Ubuntu-CloudInit-Docs

# Download, resize image first
# #wget -q https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
# qemu-img resize noble-server-cloudimg-amd64.img 8G

# before `sudo qm set 8001 --cicustom ...` the vendor cloud-init config snippet should be placed in the
# referenced storage location (currently local:snippets - /var/lib/vz/snippets/)

sudo qm create 8001 --name "ubuntu-2404-cloudinit-template" --ostype l26 \
    --memory 1024 \
    --agent 1 \
    --bios ovmf \
    --machine q35 \
    --efidisk0 proxmox:0,pre-enrolled-keys=0 \
    --cpu host \
    --socket 1 \
    --cores 1 \
    --vga serial0 --serial0 socket \
    --net0 virtio,bridge=vmbr0
sudo qm importdisk 8001 noble-server-cloudimg-amd64.img proxmox
sudo qm set 8001 --scsihw virtio-scsi-pci --virtio0 proxmox:vm-8001-disk-1,discard=on
sudo qm set 8001 --boot order=virtio0
sudo qm set 8001 --scsi1 local:cloudinit
#sudo qm set 8001 --cicustom "user=local:snippets/user_data.yaml,network=local:snippets/net_data.yaml,vendor=local:snippets/cloud-config-vendor.yaml"
sudo qm set 8001 --cicustom "vendor=local:snippets/cloud-config-vendor.yaml"
sudo qm set 8001 --tags ubuntu-template,24.04,cloudinit
sudo qm template 8001

