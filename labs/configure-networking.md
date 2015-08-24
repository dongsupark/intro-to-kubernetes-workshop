# Configuring the Network

In this lab you will configure the network between node0 and node1 to ensure cross host connectivity. You will also ensure containers can communicate across hosts and reach the internet.

### Create network routes between Docker on node0 and node1

```
core@node0 ~ $ sudo ip route add 10.200.1.0/24 via $(ping -c1 node1 | awk -F'[()]' '/64 bytes/ { print $2}') dev eth0
```
```
core@node1 ~ $ sudo ip route add 10.200.0.0/24 via $(ping -c1 node0 | awk -F'[()]' '/64 bytes/ { print $2}') dev eth0
```

```
core@node0 ~ $ ip route
```
```
core@node1 ~ $ ip route
```

### Getting Containers Online

```
ssh node0 \
  "sudo iptables -t nat -A POSTROUTING ! -d 10.0.0.0/8 -o eth0 -j MASQUERADE"
```

```
ssh node1 \
  "sudo iptables -t nat -A POSTROUTING ! -d 10.0.0.0/8 -o eth0 -j MASQUERADE"
```

### Confirm networking

#### Terminal 1

```
ssh node0
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
ssh node1
```

```
docker run -t -i --rm busybox /bin/sh
```

```
ping -c 3 10.200.0.2
```

```
ping -c 3 google.com
```

Exit both busybox instances.
