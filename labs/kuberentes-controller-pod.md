# Install and configure the Kubernetes controller

## Install and configure the Kubelet

### node0

```
vagrant ssh node0
```

Download the kubelet unit file:

```
sudo curl https://kuar.io/kubelet.service \
  -o /etc/systemd/system/kubelet.service
```

Configure the api-servers flag:

```
PROJECT_ID=$(hostname -f)
```

```
sudo sed -i -e "s/node0.c.PROJECT_ID.internal/${PROJECT_ID}/g;" /etc/systemd/system/kubelet.service
```

```
cat /etc/systemd/system/kubelet.service
```

```
sudo systemctl daemon-reload
sudo systemctl enable kubelet
sudo systemctl start kubelet
```

### Verify

```
sudo systemctl status kubelet
```

## Deploy the Kubernetes Controller

```
sudo mkdir -p /etc/kubernetes/manifests
sudo mkdir -p /var/run/kubernetes
sudo mkdir -p /var/lib/etcd
```

Copy certs

```
sudo cp apiserver-key.pem apiserver.pem ca.pem ca-key.pem /var/run/kubernetes/
```

Download the controller pod manifest:

```
sudo curl -o /etc/kubernetes/manifests/kube-controller-pod.yaml \
  https://kuar.io/kube-controller-pod.yaml
```

Verify:

```
docker ps
```
