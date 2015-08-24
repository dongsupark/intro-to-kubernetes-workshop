# Provisioning CoreOS on libvirt
 
In this lab you will provision two libvirt instances (node0 and node1) running CoreOS.

## Provision 2 libvirt instances

### Provision CoreOS using the bash script 

```
sudo libvirt/deploy_k8s_ws_cluster.sh 2
```

### Verify

```
sudo virsh list
```
