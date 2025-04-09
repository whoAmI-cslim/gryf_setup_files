## Purpose
- The files within this directory are the needed binaries to interact with Openshift. This includes the oc and kubectl binaries. 

## Download URL
- Run this to download the binaries:

```
wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz

tar -xvf openshift-client-linux.tar.gz .

curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl

```

- Copy these into the usr's bin folder. 

```
cp ./oc /usr/local/bin/oc
cp ./kubectl /usr/local/bin/kubectl
```
