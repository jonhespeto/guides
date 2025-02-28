Rename usb network interface (too long name like enx62b7708d274b)

【Solution step by step】

## Add systemd.link file as a way of renaming NICs

```bash
cd /etc/systemd/network/
```

link file must be shaped like [priority]-[interface-name].link
the priority is significantly important
the interface name must be started with "en" so as to be recognized by PVE
MACAddress is the mac address of the original NIC
Type=ether makes sure the Debian only modify the name of physical NIC
Name is the new name of the NIC

```bash
nano 10-eth0.link
```
```
[Match]
MACAddress=b8:ce:f6:32:2a:6e
Type=ether

[Link]
Name=eth0
```

## Update the initramfs
### Copy the link files into the initramfs
```bash
udevadm control --reload
udevadm trigger
update-initramfs -u -k all
```

## Replace the items of out-dated network interfaces name with new ones 
### So that the items can be reflected to the PVE GUI and can be bound to vmbrs

```bash
nano /etc/network/interfaces
```
```
auto lo
iface lo inet loopback

iface eth0 inet manual

auto vmbr0
iface vmbr0 inet static
        address 192.168.21.236/24
        gateway 192.168.21.240
        bridge-ports eth0
        bridge-stp off
        bridge-fd 0
```
