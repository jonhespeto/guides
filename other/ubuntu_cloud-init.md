First download QCow2 UEFI/GPT Bootable disk image with linux-kvm KVM optimised kernel

#### Link for 22.04

https://cloud-images.ubuntu.com/jammy/current/

#### Create the VM via CLI
```
qm create 5000 --memory 2048 --core 2 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
cd /var/lib/vz/template/iso/




```