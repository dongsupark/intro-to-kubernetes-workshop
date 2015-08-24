# Intro to Kubernetes Workshop

Kubernetes Version: 1.0.3

The slides from this workshop are hosted [online](http://go-talks.appspot.com/github.com/kelseyhightower/intro-to-kubernetes-workshop/slides/talk.slide#1)

## Course Outline

### libvirt

#### Labs

  * [Install libvirt](labs/install-libvirt.md)

### Kubernetes base infrastructure

#### Labs

  * [Provision CoreOS Cluster](labs/provisioning-coreos-on-libvirt.md)
  * [Install and configure Docker](labs/install-and-configure-docker.md)
  * [Configure Networking](labs/configure-networking.md)

### PKI infrastructure

#### Labs

  * [Initialize a certificate authority](labs/initialize-a-certificate-authority.md)
  * [Generate server and client certs](labs/generate-server-and-client-certs.md)

### Provision the Controller Node

#### Labs

  * [Install and configure the Kubernetes controller](labs/kuberentes-controller-pod.md)

### Provision the Kubernetes clients

#### Labs

  * [Install and configure the kubectl CLI](labs/install-and-configure-kubectl.md)
  * [Deploy the Web UI](labs/cluster-add-on-ui.md)

### Provision the Worker Nodes

#### Labs

  * [Install and configure the kubelet](labs/install-and-configure-kubelet.md)
  * [Install and configure the kube-proxy](labs/install-and-configure-kube-proxy.md)

### Managing Applications with Kubernetes

#### Labs

  * [Creating and managing pods](labs/pods.md)
  * [Creating and managing replication controllers](labs/replication-controllers.md)
  * [Creating and managing services](labs/services.md)
  * [Exposing services with nginx](labs/exposing-services-with-nginx.md)
  * [Rolling updates](labs/rolling-updates.md)

### Cluster Add-ons

#### Labs

  * [DNS](labs/cluster-add-on-dns.md)

## Links

  * [Kubernetes](http://googlecloudplatform.github.io/kubernetes)
  * [gcloud Tool Guide](https://cloud.google.com/sdk/gcloud)
  * [Docker](https://docs.docker.com)
  * [CoreOS](https://coreos.com)
  * [etcd](https://coreos.com/docs/distributed-configuration/getting-started-with-etcd)
  * [nginx](http://nginx.org)

### Tips

#### Deploy two virtual CoreOS nodes with `node0` and `node1` names:

```
sudo libvirt/deploy_k8s_ws_cluster.sh 2
```

#### Deploy two virtual CoreOS nodes with `node0` and `node1` names and custom path to SSH public key:

```
sudo libvirt/deploy_k8s_ws_cluster.sh 2 ~/.ssh/my_custom_ssh_key.pub
```

#### Deploy single virtual CoreOS node with `customname` name:

```
sudo libvirt/deploy_k8s_ws_cluster.sh customname
```

#### Destroy and delete all virtual CoreOS nodes with `node[0-9]` name mask:

```
sudo libvirt/remove_k8s_ws_cluster.sh
```

#### Destroy and delete virtual CoreOS nodes with `customname` name:

```
sudo libvirt/remove_k8s_ws_cluster.sh customname
```

#### Clean-up kubectl config file:

```
rm -rf ~/.kube
```
