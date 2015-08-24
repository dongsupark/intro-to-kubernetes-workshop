# Creating and managing services

* Create a service using the kubectl cli tool
* Map a service to pod lables

### Listing Services

```
kubectl get services
```

### Creating Services

```
curl https://raw.githubusercontent.com/kelseyhightower/intro-to-kubernetes-workshop/master/kubernetes-configs/inspector-svc.yaml
```

```
kubectl create -f https://raw.githubusercontent.com/kelseyhightower/intro-to-kubernetes-workshop/master/kubernetes-configs/inspector-svc.yaml
```

#### Validation
```
kubectl describe service inspector
```

##### laptop

```
curl 172.17.8.101:36000
```

```
curl 172.17.8.102:36000
```
