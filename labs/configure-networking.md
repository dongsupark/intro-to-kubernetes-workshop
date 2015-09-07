# Configuring the Network

In this lab you will configure the network between node0 and node1 to ensure cross host connectivity. You will also ensure containers can communicate across hosts and reach the internet.

### Create network routes between Docker on node0 and node1

```
gcloud compute routes create default-route-10-200-0-0-24 \
  --destination-range 10.200.0.0/24 \
  --next-hop-instance node0
```
```
gcloud compute routes create default-route-10-200-1-0-24 \
  --destination-range 10.200.1.0/24 \
  --next-hop-instance node1
```

```
gcloud compute routes list
```

### Getting Containers Online

```
gcloud compute ssh node0 \
  --command "sudo iptables -t nat -A POSTROUTING ! -d 10.0.0.0/8 -o ens4v1 -j MASQUERADE"
```

```
gcloud compute ssh node1 \
  --command "sudo iptables -t nat -A POSTROUTING ! -d 10.0.0.0/8 -o ens4v1 -j MASQUERADE"
```

### Confirm networking

#### Terminal 1

```
gcloud compute ssh node0
```
```
docker run -t -i --rm busybox /bin/sh
```

```
ip -f inet addr show eth0
```

```
4: eth0: <BROADCAST,UP,LOWER_UP> mtu 1460 qdisc noqueue state UP group default 
    inet 10.200.0.2/24 scope global eth0
       valid_lft forever preferred_lft forever
```

#### Terminal 2

```
gcloud compute ssh node1
```

```
docker run -t -i --rm busybox /bin/sh
```

The IP address you ping should match that output by the command `ip -f inet addr show eth0`

```
ping -c 3 10.200.0.2
```

```
ping -c 3 google.com
```

Exit both busybox instances.
