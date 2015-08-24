# Install and configure the kube-proxy

## node0

```
ssh node0
```

Download the kube-proxy pod:

```
sudo curl -O https://kuar.io/kube-proxy-pod.yaml
```

Configure the master flag (our API server runs on node0):

```
PROJECT_ID=node0
```

```
sudo sed -i -e "s/node0.c.PROJECT_ID.internal/${PROJECT_ID}/g;" kube-proxy-pod.yaml
```

```
cat kube-proxy-pod.yaml
```

Start the kube-proxy service:

```
sudo cp kube-proxy-pod.yaml /etc/kubernetes/manifests
```

Verify:

```
docker ps
```

Check iptables (search for rules with 'kubernetes' comments):

```
sudo iptables -vL -n -t nat
```

### node1

```
ssh node1
```

Repeat the steps from above.
