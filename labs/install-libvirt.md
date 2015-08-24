# Install libvirt 

## Install the libvirt

Follow the instructions to install libvirt.

### Debian based distributives

```
sudo apt-get install libvirt-bin virtinst qemu-kvm virt-manager git
sudo service libvirt-bin start
echo 'nameserver 192.168.122.1' | sudo tee -a /etc/resolvconf/resolv.conf.d/head && sudo resolvconf -u
```

### Fedora based distributives


```
TODO
```
