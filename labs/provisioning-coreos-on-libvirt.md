# Provisioning CoreOS on libvirt
 
In this lab you will provision two libvirt instances (node0 and node1) running CoreOS.

## Provision 2 libvirt instances

### Prepare a ssh key pair

You need at least one key pair of private and public key, to be used for ssh
authentications for coreos nodes.

```
sudo mkdir -p /root/.ssh
sudo chmod 755 /root/.ssh
sudo cp -a /path/to/coreos/keys/.ssh/core /root/.ssh/id_rsa
sudo cp -a /path/to/coreos/keys/.ssh/core.pub /root/.ssh/id_rsa.pub
sudo chmod 600 /root/.ssh/id_rsa
```

### Provision CoreOS using the bash script 

```
sudo libvirt/deploy_k8s_ws_cluster.sh 2
```

### Verify

```
sudo virsh list
```
