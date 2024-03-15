source: https://github.com/fultonj/antelope/blob/main/docs/hci.md

openshift local / crc (code ready containers) : single node openshift (based on openshift 4.x) / All-in-one

see this : https://access.redhat.com/documentation/en-us/red_hat_codeready_containers/1.5/html-single/getting_started_guide/index#getting-started-with-codeready-containers_gsg

CRC using single vm which works as both master and worker

minishift (simillar to minikube) : based on openshift 3.x

## Reference docs:

https://docs.engineering.redhat.com/display/~ykarel/Deploy+Openstack+Operators

https://github.com/openstack-k8s-operators/install_yamls/tree/main/devsetup

ahishek sessions: https://docs.google.com/spreadsheets/d/1_72Bem2-C6RIYXddohRosaFWyy-4qWMZxyo076sZMZw/edit#gid=0

gorkas steps: https://docs.google.com/spreadsheets/d/1HfhJQeMCgzmBKEzrg6a-Jkow-RYzvFBI6CGHoXuQIWQ/edit#gid=757678200

rhoso_doc: https://docs.google.com/document/d/1xQS4Q6Zs80YVgl2zC9uN6378zE9lYw9ve0PX-M_wJkg/edit#heading=h.p6p5hnls2qbg





## Steps:

Note: install_yamls have operators for openstack, ceph, edpm and other services

### Create CRC vm
```
 sudo su - manoj
 passwd manoj
 in /etc/sudoers, add "manoj   ALL=(ALL)       NOPASSWD: ALL"
 sudo dnf update -y
 sudo dnf install python3 git-core make gcc -y
 git clone https://github.com/openstack-k8s-operators/install_yamls ~/install_yamls
 cd ~/install_yamls/devsetup
 pull secret from: https://console.redhat.com/openshift/create/local to .
 #deploy OCP
 CPUS=10 MEMORY=26000 DISK=80 make crc      #crc vm is created here, day1 ops are completed
 crc config view
 export PATH=$PATH:/home/manoj/bin
 #ssh -i ~/.crc/machines/crc/id_ecdsa core@192.168.130.11   # check the crc vm
```
### Install tools/dependencies and login to crc vm 
```
 sudo dnf install -y ansible-core
 make download_tools
 eval $(crc oc-env)
 oc login -u kubeadmin -p 12345678 https://api.crc.testing:6443
 # only one crc vm and crc network is created earlier in make crc, below step attaches new interface and adds a dhcp entry 
 make crc_attach_default_interface
```
 Note: crc_attach_default_interface attaches enp6s0 interface which is required by NETWORK_ISOLATION=true without this, we see below error during make openstack
                               oc wait nncp -l osp/interface=enp6s0 --for condition=available --timeout=240s
                               error: timed out waiting for the condition on nodenetworkconfigurationpolicies/enp6s0-crc-74q6p-master-0
                               make: *** [Makefile:1767: nncp] Error 1

### Deploy openstack controlplane

```
export LIBGUESTFS_BACKEND=direct
cd ..
make crc_storage
make input
make input
make openstack  # this is simillar to deploying undercloud where openshift nmstate, cert, metallb operator is deployed
#make openstack NETWORK_ISOLATION=false make openstack
make openstack_deploy
#make openstack_deploy NETWORK_ISOLATION=false make openstack_deploy
oc apply -f edpm-ansible-storage.yaml   
```
Note:
   - if it exists or else  create nfs access to edpm-ansible https://github.com/fultonj/antelope/blob/main/docs/notes/nfs.md
   - 'Update a CR to use the extraVol' maybe skipped as it is added to dataplane CR (data.yaml) in hci_pre_ceph kustomization
   - A persistent volume (PV) is a piece of storage in the Kubernetes cluster, while a persistent volume claim (PVC) is a request for storage
```
oc get pv,pvc | grep edpm-ansible
for i in 0 1 2; do EDPM_COMPUTE_SUFFIX=$i make edpm_compute; done
for i in 0 1 2; do EDPM_COMPUTE_SUFFIX=$i make edpm_compute_repos; done   (deprecated when tried on nov7)
```
#probably repo-setup (dataplane-deployment-repo-setup-openstack-edpm-2w2r4) takes care

### Dataplane deploy_prep:
```
pushd ~/install_yaml
DATAPLANE_CHRONY_NTP_SERVER=clock.redhat.com DATAPLANE_TOTAL_NODES=3 DATAPLANE_SINGLE_NODE=false make edpm_deploy_prep
```
Note: if your antelope repo is updated, you can directly run 'oc create -f data.yaml'

### Ensure you have base deployment.yaml for deploying epdm
```
TARGET=$HOME/antelope/crs/data_plane/base/deployment.yaml
oc kustomize out/openstack/dataplane/cr > $TARGET
pushd ~/antelope/crs/
kustomize build data_plane/overlay/storage-mgmt > deployment.yaml

diff -u $TARGET deployment.yaml
mv deployment.yaml $TARGET
```
### pre-ceph customized dataplane
```
kustomize build data_plane/overlay/hci-pre-ceph > data.yaml
```
remove OpenStackDataPlaneDeployment content from data.yaml as shown below 
```
-apiVersion: dataplane.openstack.org/v1beta1
-kind: OpenStackDataPlaneDeployment
-metadata:
-  name: openstack-edpm
-  namespace: openstack
-spec:
-  nodeSets:
-  - openstack-edpm
```
The CR data.yml  contains only OpenStackDataPlane NodeSet and not a Deployment.
```
oc create -f data.yaml

oc create -f deployments/deployment-pre-ceph.yaml
```
Note: pre-ceph will remove few 

### install ceph
Note: ensure to do exports every time you use a new tab to run ceph playbook
https://github.com/fultonj/antelope/blob/main/docs/hci.md#install-ceph-on-edpm-nodes

observe ceph logs here
[cloud-admin@edpm-compute-0 ~]$ vi /var/log/ceph/cephadm.log




# observation:

- clone glance-operator before glance pv creation
- controlplane base deployment.yaml missing

 [manoj@shark13 out]$ TARGET=/home/manoj/antelope/crs/control_plane/base/deployment.yaml
[manoj@shark13 out]$ pwd
/home/manoj/install_yamls/out
[manoj@shark13 out]$ kustomize build openstack/openstack/cr/ > $TARGET

and then run

kustomize build control_plane/overlay/ceph | sed "s/_FSID_/${FSID}/" > control.yaml



login to edpm node:  ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ~/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa cloud-admin@192.168.122.100







