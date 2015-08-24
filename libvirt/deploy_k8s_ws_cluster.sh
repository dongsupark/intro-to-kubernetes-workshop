#!/bin/bash -e

usage() {
  echo "Usage: $0 %k8s_cluster_size%|%single_node_name% [%pub_key_path%]"
}

print_green() {
  echo -e "\e[92m$1\e[0m"
}

spawn_node() {
  COREOS_HOSTNAME="$1"
  if [ ! -d $LIBVIRT_PATH/$COREOS_HOSTNAME/openstack/latest ]; then
    mkdir -p $LIBVIRT_PATH/$COREOS_HOSTNAME/openstack/latest || (echo "Can not create $LIBVIRT_PATH/$COREOS_HOSTNAME/openstack/latest directory" && exit 1)
  fi

  if [ ! -f $LIBVIRT_PATH/coreos_${CHANNEL}_qemu_image.img ]; then
    (curl $IMAGE_URL | bzcat > $LIBVIRT_PATH/coreos_${CHANNEL}_qemu_image.img) || (wget $IMAGE_URL -O - | bzcat > $LIBVIRT_PATH/coreos_${CHANNEL}_qemu_image.img) || (echo "Cannot download CoreOS image" && exit 1)
  fi

  if [ ! -f $LIBVIRT_PATH/$COREOS_HOSTNAME.qcow2 ]; then
    qemu-img create -f qcow2 -b $LIBVIRT_PATH/coreos_${CHANNEL}_qemu_image.img $LIBVIRT_PATH/$COREOS_HOSTNAME.qcow2
  fi

  sed "s#%PUB_KEY%#$PUB_KEY#g;\
       s#%HOSTNAME%#$COREOS_HOSTNAME#g" $USER_DATA_TEMPLATE > $LIBVIRT_PATH/$COREOS_HOSTNAME/openstack/latest/user_data

  virt-install --connect qemu:///system \
         --import \
         --name $COREOS_HOSTNAME \
         --ram $RAM \
         --vcpus $CPUs \
         --os-type=linux \
         --os-variant=virtio26 \
         --disk path=$LIBVIRT_PATH/$COREOS_HOSTNAME.qcow2,format=qcow2,bus=virtio \
         --filesystem $LIBVIRT_PATH/$COREOS_HOSTNAME/,config-2,type=mount,mode=squash \
         --vnc \
         --noautoconsole
}

if [ "$1" == "" ]; then
  echo "Cluster size or node name is empty"
  usage
  exit 1
fi

NODENAME=false

if ! [[ "$1" =~ ^[0-9]+$ ]]; then
  echo "'$1' is not a number"
  if [[ "$1" =~ ^(([a-zA-Z]|[a-zA-Z][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$ ]]; then
    echo "Will create single node with the '$1' name"
    NODENAME=true
  else
    echo "Invalid node name. Should not start from digit and should contain only letters and numbers"
    usage
    exit 1
  fi
else
  if [[ "$1" -lt "2" ]]; then
    echo "'$1' is lower than 2 (minimal k8s cluster size)"
    usage
    exit 1
  fi
fi

CDIR=$(cd `dirname $0` && pwd)
LIBVIRT_PATH=/var/lib/libvirt/images/coreos
USER_DATA_TEMPLATE=$CDIR/k8s-node.yaml
CHANNEL=stable
IMAGE_URL=http://${CHANNEL}.release.core-os.net/amd64-usr/current/coreos_production_qemu_image.img.bz2
RAM=512
CPUs=1
NODENAME_OR_SEQ=$1

if [ ! -d $LIBVIRT_PATH ]; then
  mkdir -p $LIBVIRT_PATH || (echo "Can not create $LIBVIRT_PATH directory" && exit 1)
fi

if [ ! -f $USER_DATA_TEMPLATE ]; then
  echo "Cannot find $USER_DATA_TEMPLATE template"
  exit 1
fi

if [[ -z $2 || ! -f $2 ]]; then
  echo "SSH public key path is not specified"
  if [ -n $HOME ]; then
    PUB_KEY_PATH="$HOME/.ssh/id_rsa.pub"
  else
    echo "Can not determine home directory for SSH pub key path"
    exit 1
  fi

  print_green "Will use default path to SSH public key: $PUB_KEY_PATH"
  if [ ! -f $PUB_KEY_PATH ]; then
    echo "Path $PUB_KEY_PATH doesn't exist"
    exit 1
  fi
else
  PUB_KEY_PATH=$2
  print_green "Will use this path to SSH public key: $PUB_KEY_PATH"
fi

PUB_KEY=$(cat $PUB_KEY_PATH)

if $NODENAME; then
   spawn_node "$NODENAME_OR_SEQ"
else
  for SEQ in $(seq 1 $NODENAME_OR_SEQ); do
    NODE_SEQ=$[SEQ-1]
    spawn_node "node$NODE_SEQ"
  done
fi

print_green "Add these strings into your ~/.ssh/config file:"

if $NODENAME; then
  echo "Host $NODENAME_OR_SEQ
   User core
   IdentityFile $PUB_KEY_PATH
   StrictHostKeyChecking no
   UserKnownHostsFile ~/.ssh/known_hosts.k8s"
  print_green "And use 'ssh $1' to access your Kubernetes cluster"
else
  for SEQ in $(seq 1 $NODENAME_OR_SEQ); do
    NODE_SEQ=$[SEQ-1]

    echo "Host node$NODE_SEQ
   User core
   IdentityFile $PUB_KEY_PATH
   StrictHostKeyChecking no
   UserKnownHostsFile ~/.ssh/known_hosts.k8s"
  done
  print_green "And use 'ssh node0' to access your Kubernetes cluster"
fi
