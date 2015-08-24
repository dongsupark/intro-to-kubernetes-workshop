# Exposing Services with Nginx

### Provision nginx

```
sudo libvirt/deploy_k8s_ws_cluster.sh nginx
```

### Prep 

```
sudo virsh list
```

### Configure nginx

```
ssh nginx
```

```
git clone https://github.com/kelseyhightower/intro-to-kubernetes-workshop.git
```

Review the nginx vhost configuration:

```
cat intro-to-kubernetes-workshop/nginx/inspector.conf
```

Substitute the project and server name:

```
sed -i -e "s/.c.PROJECT_ID.internal//g;s/inspector.PROJECT_ID.io/nginx/g;" intro-to-kubernetes-workshop/nginx/inspector.conf
```

```
cat intro-to-kubernetes-workshop/nginx/inspector.conf
```

Copy the vhost configuration:

```
sudo mkdir -p /etc/nginx/conf.d
```

```
sudo cp intro-to-kubernetes-workshop/nginx/inspector.conf  /etc/nginx/conf.d/
```

### Start nginx

```
sudo docker run -d --net=host \
  -v /etc/nginx/conf.d:/etc/nginx/conf.d \
  nginx
```

### Testing 

#### laptop

Visit 

```
http://nginx
```

Every page refresh should show different MAC and IP address:

```
http://nginx/net
```
