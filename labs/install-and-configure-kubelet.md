# Install and configure the Kubelet

## node1

```
ssh node1
```

Download the kubelet unit file:

```
sudo curl https://kuar.io/kubelet.service \
  -o /etc/systemd/system/kubelet.service
```

Configure the api-servers flag (our API server run on node0):

```
PROJECT_ID=node0
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

#### laptop

```
kubectl get nodes
```
