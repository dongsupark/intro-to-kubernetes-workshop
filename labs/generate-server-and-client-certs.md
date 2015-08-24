# Generate Server and Client Certs

In this labs you will use cfssl to generate client and server TLS certs.

## Generate the kube-apiserver server cert

### node0

```
ssh node0
```

Create a CSR for the API server:

```
cat <<EOF > apiserver-csr.json
{
  "CN": "HOSTNAME",
  "hosts": [
    "127.0.0.1",
    "EXTERNAL_IP",
    "HOSTNAME"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "API Server",
      "ST": "Oregon"
    }
  ]
}
EOF
```

### Customize apiserver-csr.json

Get the PROJECT_ID:

```
PROJECT_ID=$(hostname -f)
```

Get the EXTERNAL_IP:

```
EXTERNAL_IP=$(hostname -i)
```

Substitute the PROJECT_ID:

```
sed -i -e "s/HOSTNAME/${PROJECT_ID}/g;" apiserver-csr.json
```

Substitute the EXTERNAL_IP:

```
sed -i -e "s/EXTERNAL_IP/${EXTERNAL_IP}/g;" apiserver-csr.json
```

### Generate the API server private key and TLS cert

```
cfssl gencert \
-ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-profile=server \
apiserver-csr.json | cfssljson -bare apiserver
```

Results

```
apiserver-key.pem
apiserver.csr
apiserver.pem
```

## Generate the admin client cert 

```
cat <<EOF > admin-csr.json
{
  "CN": "admin",
  "hosts": [""],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Cluster Admins",
      "ST": "Oregon"
    }
  ]
}
EOF
```

```
cfssl gencert \
-ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-profile=client \
admin-csr.json | cfssljson -bare admin
```

Results

```
admin-key.pem
admin.csr
admin.pem
```
