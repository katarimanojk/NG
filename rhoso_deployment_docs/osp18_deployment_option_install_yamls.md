
# Deploy openstack controlplane

```
export LIBGUESTFS_BACKEND=direct
cd ..
make crc_storage
make input
make input

make openstack #openshift nmstate, cert-manager, metallb operators are deployed
(or)
NETWORK_ISOLATION=false make openstack

make openstack_deploy
(or)
# if you want to configure cinder to use lvm as backend, create the below CR and use it during 'make openstack_deploy'
oc kustomize https://github.com/openstack-k8s-operators/cinder-operator.git/config/samples/backends/lvm/iscsi?ref=main > ~/openstack-deployment.yaml
OPENSTACK_CR=~/openstack-deployment.yaml make openstack_deploy
(or)
NETWORK_ISOLATION=false make openstack_deploy

#wait for control plane deployment to finish
# oc -n openstack get osctlplane
```

# Other optimizations of control plane (optional):
```
base CR: https://github.com/openstack-k8s-operators/openstack-operator/blob/main/config/samples/base/openstackcontrolplane/core_v1beta1_openstackcontrolplane.yaml
with network isolation CR: https://github.com/openstack-k8s-operators/openstack-operator/blob/main/config/samples/core_v1beta1_openstackcontrolplane_galera_network_isolation.yaml
with ceph: https://github.com/openstack-k8s-operators/openstack-operator/blob/main/config/samples/core_v1beta1_openstackcontrolplane_network_isolation_ceph.yaml 


deploy ceph in in controlplane as a pod (not recommended)

#make ceph


curl -o /tmp/core_v1beta1_openstackcontrolplane_network_isolation_ceph.yaml https://raw.githubusercontent.com/openstack-k8s-operators/openstack-operator/main/config/samples/core_v1beta1_openstackcontrolplane_network_isolation_ceph.yaml
FSID=$(oc get secret ceph-conf-files -o json | jq -r '.data."ceph.conf"' | base64 -d | grep fsid | sed -e 's/fsid = //') && echo $FSID
sed -i "s/_FSID_/${FSID}/" /tmp/core_v1beta1_openstackcontrolplane_network_isolation_ceph.yaml
oc apply -f /tmp/core_v1beta1_openstackcontrolplane_network_isolation_ceph.yaml
```

# Dataplane deployment:
```
cd ~/install_yamls/devsetup
for i in 0 1 2; do EDPM_COMPUTE_SUFFIX=$i make edpm_compute; done

cd ~/install_yamls/
make edpm_deploy

#wait for data plane deployment to finish
# oc -n openstack get osdpns
# oc -n openstack get osdpd
# oc -n openstack get pods -l app=openstackansibleee
```













