source: https://github.com/fultonj/antelope/blob/main/docs/hci.md

#steps:

************************************************
------ install_yamls with operators for openstack, ceph, edpm and other services

1. sudo su - manoj

2. passwd manoj

3. in /etc/sudoers, add "manoj   ALL=(ALL)       NOPASSWD: ALL"

4. sudo dnf update -y

5. sudo dnf install python3 git-core make gcc -y

6. git clone https://github.com/openstack-k8s-operators/install_yamls ~/install_yamls

7. cd ~/install_yamls/devsetup

pull secret from: https://console.redhat.com/openshift/create/local

CPUS=10 MEMORY=26000 DISK=80 make crc

crc config view

export PATH=$PATH:/home/manoj/bin

#ssh -i ~/.crc/machines/crc/id_ecdsa core@192.168.130.11   # check the crc vm

sudo dnf install -y ansible-core

make download_tools

eval $(crc oc-env)

oc login -u kubeadmin -p 12345678 https://api.crc.testing:6443


make crc_attach_default_interface   # crc_attach_default_interface attaches enp6s0 interface which is required by NETWORK_ISOLATION=true without this, we see below error during make openstack

                               oc wait nncp -l osp/interface=enp6s0 --for condition=available --timeout=240s
                               error: timed out waiting for the condition on nodenetworkconfigurationpolicies/enp6s0-crc-74q6p-master-0
                               make: *** [Makefile:1767: nncp] Error 1


export LIBGUESTFS_BACKEND=direct

cd ..

make crc_storage

make input
make input

make openstack        #NETWORK_ISOLATION=false make openstack

make openstack_deploy         #NETWORK_ISOLATION=false make openstack_deploy


oc apply -f edpm-ansible-storage.yaml   
   - if it exists or else  create nfs access to edpm-ansible https://github.com/fultonj/antelope/blob/main/docs/notes/nfs.md
   - 'Update a CR to use the extraVol' maybe skipped as it is added to dataplane CR (data.yaml) in hci_pre_ceph kustomization
oc get pv,pvc | grep edpm-ansible


for i in 0 1 2; do EDPM_COMPUTE_SUFFIX=$i make edpm_compute; done
for i in 0 1 2; do EDPM_COMPUTE_SUFFIX=$i make edpm_compute_repos; done   (deprecated when tried on nov7)
#probably repo-setup (dataplane-deployment-repo-setup-openstack-edpm-2w2r4) takes care

 deploy_prep:
pushd ~/install_yaml
DATAPLANE_CHRONY_NTP_SERVER=clock.redhat.com DATAPLANE_TOTAL_NODES=3 DATAPLANE_SINGLE_NODE=false make edpm_deploy_prep

Note: if your antelope repo is updated, you can directly run 'oc create -f data.yaml'
TARGET=$HOME/antelope/crs/data_plane/base/deployment.yaml
oc kustomize out/openstack/dataplane/cr > $TARGET


pushd ~/antelope/crs/
kustomize build data_plane/overlay/storage-mgmt > deployment.yaml

diff -u $TARGET deployment.yaml
mv deployment.yaml $TARGET


kustomize build data_plane/overlay/hci-pre-ceph > data.yaml



remove OpenStackDataPlaneDeployment content from data.yaml as shown below 

-apiVersion: dataplane.openstack.org/v1beta1
-kind: OpenStackDataPlaneDeployment
-metadata:
-  name: openstack-edpm
-  namespace: openstack
-spec:
-  nodeSets:
-  - openstack-edpm


oc create -f data.yaml

oc create -f deployments/deployment-pre-ceph.yaml


##install ceph
https://github.com/fultonj/antelope/blob/main/docs/hci.md#install-ceph-on-edpm-nodes






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







