# Configuring the Network

In this lab you will configure the network between node0 and node1 to ensure cross host connectivity. You will also ensure containers can communicate across hosts and reach the internet.

### Create network routes between Docker on node0 and node1

```
core@node0 ~ $ sudo ip route add 10.200.1.0/24 via 172.17.8.102 dev eth1
```
```
core@node1 ~ $ sudo ip route add 10.200.0.0/24 via 172.17.8.101 dev eth1
```

```
core@node0 ~ $ ip route
```
```
core@node1 ~ $ ip route
```

### Getting Containers Online

```
vagrant ssh node0 \
  -- "sudo iptables -t nat -A POSTROUTING ! -d 10.0.0.0/8 -o eth1 -j MASQUERADE"
```

```
vagrant ssh node1 \
  -- "sudo iptables -t nat -A POSTROUTING ! -d 10.0.0.0/8 -o eth1 -j MASQUERADE"
```

### Confirm networking

#### Terminal 1

```
vagrant ssh node0
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
vagrant ssh node1
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
