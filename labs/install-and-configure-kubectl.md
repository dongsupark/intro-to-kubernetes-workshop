# Install and configure the kubectl CLI

## Install kubectl

### laptop

#### Linux

```
curl -o kubectl https://kuar.io/linux/kubectl
chmod +x kubectl
sudo cp kubectl /usr/local/bin/kubectl
```

#### OS X

```
curl -o kubectl https://kuar.io/darwin/kubectl
chmod +x kubectl
sudo cp kubectl /usr/local/bin/kubectl
```

### Configure kubectl

Download the client credentials and CA cert:

```
vagrant ssh node0 -- "cat ~/admin-key.pem" > admin-key.pem
vagrant ssh node0 -- "cat ~/admin.pem" > admin.pem
vagrant ssh node0 -- "cat ~/ca.pem" > ca.pem
``` 

Create the workshop cluster config:

```
kubectl config set-cluster workshop \
--certificate-authority=ca.pem \
--embed-certs=true \
--server=https://172.17.8.101:6443
```

Add the admin user credentials:

```
kubectl config set-credentials admin \
--client-key=admin-key.pem \
--client-certificate=admin.pem \
--embed-certs=true
```

Configure the workshop context:

```
kubectl config set-context workshop \
--cluster=workshop \
--user=admin
```

```
kubectl config use-context workshop
```

```
kubectl config view
```

### Explore the kubectl CLI

Check the health status of the cluster components:

```
kubectl get cs
```

List pods:

```
kubectl get pods
```

List nodes:

```
kubectl get nodes
```

List services:

```
kubectl get services
```
