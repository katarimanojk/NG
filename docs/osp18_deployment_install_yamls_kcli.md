

[mkatari@dell-7625-02 ~]$ time kcli create cluster openshift --paramfile /home/mkatari/rhoso-cluster.yml rhoso
Deploying on client local
Deploying cluster rhoso
Using stable version
Downloading openshift-install from https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-4.16
Move downloaded openshift-install somewhere in your PATH if you want to reuse it
Using installer version 4.16.12
Using image rhcos-416.94.202406251923-0-openstack.x86_64.qcow2
INFO Consuming Install Config from target directory 
WARNING Making control-plane schedulable by setting MastersSchedulable to true for Scheduler cluster settings 
INFO Manifests created in: /home/mkatari/.kcli/clusters/rhoso/manifests and /home/mkatari/.kcli/clusters/rhoso/openshift 
INFO Consuming Worker Machines from target directory 
INFO Consuming Master Machines from target directory 
INFO Consuming OpenShift Install (Manifests) from target directory 
INFO Consuming Common Manifests from target directory 
INFO Consuming Openshift Manifests from target directory 
INFO Ignition-Configs created in: /home/mkatari/.kcli/clusters/rhoso and /home/mkatari/.kcli/clusters/rhoso/auth 
Using keepalived virtual_router_id 191
Using 192.168.131.9 for api vip....
Deploying bootstrap
Deploying Vms...
Merging ignition data from existing /home/mkatari/.kcli/clusters/rhoso/bootstrap.ign for rhoso-bootstrap
Creating dns entry for rhoso-bootstrap.openshift.local in network ocpnet
Waiting 5 seconds to grab ip...
Waiting 5 seconds to grab ip...
Creating hosts entry. Password for sudo might be asked
rhoso-bootstrap deployed on local
Deploying ctlplanes
Deploying Vms...
Merging ignition data from existing /home/mkatari/.kcli/clusters/rhoso/ctlplane.ign for rhoso-ctlplane-0
Adding a reserved ip entry for ip 192.168.131.10 and mac aa:aa:aa:aa:bb:04
Creating dns entry for rhoso-ctlplane-0.openshift.local in network ocpnet
Creating hosts entry. Password for sudo might be asked
rhoso-ctlplane-0 deployed on local
Merging ignition data from existing /home/mkatari/.kcli/clusters/rhoso/ctlplane.ign for rhoso-ctlplane-1
Adding a reserved ip entry for ip 192.168.131.11 and mac aa:aa:aa:aa:bb:06
Creating dns entry for rhoso-ctlplane-1.openshift.local in network ocpnet
Creating hosts entry. Password for sudo might be asked
rhoso-ctlplane-1 deployed on local
Merging ignition data from existing /home/mkatari/.kcli/clusters/rhoso/ctlplane.ign for rhoso-ctlplane-2
Adding a reserved ip entry for ip 192.168.131.12 and mac aa:aa:aa:aa:bb:08
Creating dns entry for rhoso-ctlplane-2.openshift.local in network ocpnet
Creating hosts entry. Password for sudo might be asked
rhoso-ctlplane-2 deployed on local
INFO Waiting up to 20m0s (until 10:01AM EDT) for the Kubernetes API at https://api.rhoso.openshift.local:6443... 
INFO API v1.29.8+f10c92d up                       
INFO Waiting up to 45m0s (until 10:27AM EDT) for bootstrapping to complete... 
INFO It is now safe to remove the bootstrap resources 
INFO Time elapsed: 18m52s                         
Launching install-complete step. It will be retried twice in case of timeout
INFO Waiting up to 40m0s (until 10:40AM EDT) for the cluster at https://api.rhoso.openshift.local:6443 to initialize... 
INFO Waiting up to 30m0s (until 10:39AM EDT) to ensure each cluster operator has finished progressing... 
INFO All cluster operators have completed progressing 
INFO Checking to see if there is a route at openshift-console/console... 
INFO Install complete!                            
INFO To access the cluster as the system:admin user when using 'oc', run 'export KUBECONFIG=/home/mkatari/.kcli/clusters/rhoso/auth/kubeconfig' 
INFO Access the OpenShift web-console here: https://console-openshift-console.apps.rhoso.openshift.local 
INFO Login to the console with user: "kubeadmin", and password: "JaGiJ-92fjk-oSE9X-mZfeI" 
INFO Time elapsed: 9m53s                          
Deleting rhoso-bootstrap
Deleting host entry. sudo password might be asked

real    29m19.574s
user    0m9.287s
sys 0m1.963s





[mkatari@dell-7625-02 ~]$ sudo virsh list --all
 Id   Name               State
----------------------------------
 2    rhoso-ctlplane-0   running
 3    rhoso-ctlplane-1   running
 4    rhoso-ctlplane-2   running

[mkatari@dell-7625-02 ~]$ 

[mkatari@dell-7625-02 ~]$ oc get nodes
NAME                               STATUS   ROLES                         AGE   VERSION
rhoso-ctlplane-0.openshift.local   Ready    control-plane,master,worker   35m   v1.29.8+f10c92d
rhoso-ctlplane-1.openshift.local   Ready    control-plane,master,worker   34m   v1.29.8+f10c92d
rhoso-ctlplane-2.openshift.local   Ready    control-plane,master,worker   34m   v1.29.8+f10c92d
[mkatari@dell-7625-02 ~]$ 

[mkatari@dell-7625-02 ~]$ oc get all
Warning: apps.openshift.io/v1 DeploymentConfig is deprecated in v4.14+, unavailable in v4.10000+
NAME                 TYPE           CLUSTER-IP   EXTERNAL-IP                            PORT(S)   AGE
service/kubernetes   ClusterIP      172.30.0.1   <none>                                 443/TCP   38m
service/openshift    ExternalName   <none>       kubernetes.default.svc.cluster.local   <none>    33m
[mkatari@dell-7625-02 ~]$ 


[mkatari@dell-7625-02 ~]$ oc version
Client Version: 4.16.9
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: 4.16.12
Kubernetes Version: v1.29.8+f10c92d
[mkatari@dell-7625-02 ~]$ 

[mkatari@dell-7625-02 ~]$ oc cluster-info
Kubernetes control plane is running at https://api.rhoso.openshift.local:6443

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
[mkatari@dell-7625-02 ~]$


[mkatari@dell-7625-02 ~]$ oc get services
NAME         TYPE           CLUSTER-IP   EXTERNAL-IP                            PORT(S)   AGE
kubernetes   ClusterIP      172.30.0.1   <none>                                 443/TCP   43m
openshift    ExternalName   <none>       kubernetes.default.svc.cluster.local   <none>    38m
[mkatari@dell-7625-02 ~]$ 


all namespaces after ocp : kcli-* or openshift-*
oc_get_pods_allnamespaces.md

# RHOSO


[mkatari@dell-7625-02 ~]$ oc get -n openshift-network-operator deployment/network-operator
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
network-operator   1/1     1            1           4h39m
[mkatari@dell-7625-02 ~]$ 
[mkatari@dell-7625-02 ~]$ oc patch network.operator cluster -p \
  '{"spec": {"defaultNetwork":{"ovnKubernetesConfig":{"gatewayConfig": {"ipForwarding": "Global", "routingViaHost": true}}}}}' --type=merge
network.operator.openshift.io/cluster patched
[mkatari@dell-7625-02 ~]$ 
[mkatari@dell-7625-02 ~]$ 
[mkatari@dell-7625-02 ~]$ oc get clusteroperator/network
NAME      VERSION   AVAILABLE   PROGRESSING   DEGRADED   SINCE   MESSAGE
network   4.16.12   True        True          False      4h36m   DaemonSet "/openshift-ovn-kubernetes/ovnkube-node" update is rolling out (1 out of 3 updated)





[mkatari@dell-7625-02 install_yamls]$ CINDER_MC_BASE=https://raw.githubusercontent.com/openstack-k8s-operators/cinder-operator/main/config/samples/backends/bases
[mkatari@dell-7625-02 install_yamls]$ oc apply \
  -f ${CINDER_MC_BASE}/iscsid/iscsid.yaml \
  -f ${CINDER_MC_BASE}/multipathd/multipathd.yaml \
  -f ${CINDER_MC_BASE}/nvmeof/nvme-fabrics.yaml
machineconfig.machineconfiguration.openshift.io/99-master-cinder-enable-iscsid created
machineconfig.machineconfiguration.openshift.io/99-master-cinder-enable-multipathd created
machineconfig.machineconfiguration.openshift.io/99-master-cinder-load-nvmeof created
[mkatari@dell-7625-02 install_yamls]$ 
[mkatari@dell-7625-02 install_yamls]$ 
[mkatari@dell-7625-02 install_yamls]$ 
[mkatari@dell-7625-02 install_yamls]$ 
[mkatari@dell-7625-02 install_yamls]$ oc get nodes --field-selector spec.unschedulable=false -l node-role.kubernetes.io/worker -o jsonpath="{.items[0].metadata.name}"
rhoso-ctlplane-1.openshift.local[mkatari@dell-7625-02 install_yamls]$ oc get nodes
NAME                               STATUS                     ROLES                         AGE     VERSION
rhoso-ctlplane-0.openshift.local   Ready,SchedulingDisabled   control-plane,master,worker   4h43m   v1.29.8+f10c92d
rhoso-ctlplane-1.openshift.local   Ready                      control-plane,master,worker   4h43m   v1.29.8+f10c92d
rhoso-ctlplane-2.openshift.local   Ready                      control-plane,master,worker   4h43m   v1.29.8+f10c92d
[mkatari@dell-7625-02 install_yamls]$ ^C
[mkatari@dell-7625-02 install_yamls]$ oc label node \
  $(oc get nodes --field-selector spec.unschedulable=false -l node-role.kubernetes.io/worker -o jsonpath="{.items[0].metadata.name}") \
  openstack.org/cinder-lvm=
node/rhoso-ctlplane-0.openshift.local labeled
[mkatari@dell-7625-02 install_yamls]$ oc get nodes
NAME                               STATUS                        ROLES                         AGE     VERSION
rhoso-ctlplane-0.openshift.local   Ready                         control-plane,master,worker   4h52m   v1.29.8+f10c92d
rhoso-ctlplane-1.openshift.local   Ready                         control-plane,master,worker   4h52m   v1.29.8+f10c92d
rhoso-ctlplane-2.openshift.local   NotReady,SchedulingDisabled   control-plane,master,worker   4h52m   v1.29.8+f10c92d
[mkatari@dell-7625-02 install_yamls]$ oc apply -f ${CINDER_MC_BASE}/lvm/lvm.yaml
machineconfig.machineconfiguration.openshift.io/99-master-cinder-lvm-losetup created
[mkatari@dell-7625-02 install_yamls]$ 
[mkatari@dell-7625-02 install_yamls]$ 
[mkatari@dell-7625-02 install_yamls]$ oc get machineconfig | grep cinder
99-master-cinder-enable-iscsid                                                                3.2.0             13m
99-master-cinder-enable-multipathd                                                            3.2.0             13m
99-master-cinder-load-nvmeof                                                                  3.2.0             13m
99-master-cinder-lvm-losetup                                                                  3.2.0             64s
[mkatari@dell-7625-02 install_yamls]$ 





[mkatari@dell-7625-02 install_yamls]$ CRC_POOL=/var/lib/libvirt/images \
NNCP_INTERFACE=ens4 \
OPENSTACK_IMG=registry.redhat.io/redhat/redhat-operator-index:v4.16 \
make openstack


nmsate

oc apply -f /home/mkatari/install_yamls/out/openstack-operators/metallb/op
operatorgroup.operators.coreos.com/metallb-operator created
subscription.operators.coreos.com/metallb-operator-sub created



oc apply -f /home/mkatari/install_yamls/out/openstack-operators/namespace.yaml
namespace/openstack-operators created
timeout 300s bash -c "while ! (oc get project.v1.project.openshift.io openstack-operators); do sleep 1; done"
NAME                  DISPLAY NAME   STATUS
openstack-operators                  Active
oc project openstack-operators
Now using project "openstack-operators" on server "https://api.rhoso.openshift.local:6443".
oc apply -f /home/mkatari/install_yamls/out/openstack-operators/openstack/op
catalogsource.operators.coreos.com/openstack-operator-index created
operatorgroup.operators.coreos.com/openstack created
subscription.operators.coreos.com/openstack-operator created



[mkatari@dell-7625-02 install_yamls]$ oc patch subscriptions openstack-operator --type json \
  --patch '[{ "op": "remove", "path": "/spec/channel" }]'
subscription.operators.coreos.com/openstack-operator patched
[mkatari@dell-7625-02 install_yamls]$ 



oc apply -f /home/mkatari/install_yamls/out/crc/storage.yaml
storageclass.storage.k8s.io/local-storage created
persistentvolume/local-storage01-rhoso-ctlplane-0.openshift.local created
persistentvolume/local-storage02-rhoso-ctlplane-0.openshift.local created
persistentvolume/local-storage03-rhoso-ctlplane-0.openshift.local created
persistentvolume/local-storage04-rhoso-ctlplane-0.openshift.local created
persistentvolume/local-storage05-rhoso-ctlplane-0.openshift.local created
.
.
persistentvolume/local-storage12-rhoso-ctlplane-2.openshift.local created
persistentvolumeclaim/ansible-ee-logs created
[mkatari@dell-7625-02 install_yamls]$




OPENSTACK_CR=~/openstack_control_plane.yaml make openstack_deploy

+ '[' 0 -eq 15 ']'
+ oc kustomize /home/mkatari/install_yamls/out/openstack/openstack/cr
+ oc apply -f -
openstackcontrolplane.core.openstack.org/openstack created


[mkatari@dell-7625-02 install_yamls]$ oc get -n openstack pods
NAME                                READY   STATUS              RESTARTS   AGE
dnsmasq-dns-774f8d844f-z6kw2        0/1     Init:0/1            0          0s
dnsmasq-dns-7b64bb47f7-ck4hf        0/1     Terminating         0          3s
dnsmasq-dns-7d879fdf-5nqjn          1/1     Running             0          35s
memcached-0                         1/1     Running             0          31s
openstack-cell1-galera-0            1/1     Running             0          32s
openstack-galera-0                  1/1     Running             0          32s
ovn-controller-2p4n4                1/1     Running             0          26s
ovn-controller-2p4n4-config-85lgs   0/1     Completed           0          3s
ovn-controller-ovs-czbw5            2/2     Running             0          26s
ovn-controller-ovs-g54b6            2/2     Running             0          26s
ovn-controller-ovs-pnc6v            2/2     Running             0          26s
ovn-controller-pgjzk                1/1     Running             0          26s
ovn-controller-pgjzk-config-9jb9g   0/1     Completed           0          2s
ovn-controller-xf9pg                1/1     Running             0          26s
ovn-controller-xf9pg-config-jtgqj   0/1     Completed           0          3s
ovn-northd-5cdbdd95c9-ntn5g         0/1     ContainerCreating   0          3s
ovsdbserver-nb-0                    1/1     Running             0          26s
ovsdbserver-sb-0                    1/1     Running             0          25s
rabbitmq-cell1-server-0             0/1     Init:0/1            0          35s
rabbitmq-server-0                   0/1     Init:0/1            0          35s
swift-storage-0                     0/15    Pending             0          0s
[mkatari@dell-7625-02 install_yamls]$ 








[mkatari@dell-7625-02 out]$  oc rsh cinder-volume-lvm-iscsi-0
Defaulted container "cinder-volume" out of: cinder-volume, probe
sh-5.1# ls
afs  bin  boot  dev  etc  home  lib  lib64  lost+found  media  mnt  openstack  opt  proc  root  run  run_command  sbin  srv  sys  tmp  usr  var
sh-5.1# vi /etc/cinder/
api-paste.ini          cinder.conf            cinder.conf.d/         resource_filters.json  rootwrap.conf          rootwrap.d/            volumes/               
sh-5.1# vi /etc/cinder/
api-paste.ini          cinder.conf            cinder.conf.d/         resource_filters.json  rootwrap.conf          rootwrap.d/            volumes/               
sh-5.1# vi /etc/cinder/cinder.conf.d/
00-global-defaults.conf           02-global-custom.conf             04-service-custom-secrets.conf    ..data/                           
01-service-defaults.conf          03-service-custom.conf            ..2024_09_25_19_12_14.4109631537/ 
sh-5.1# vi /etc/cinder/cinder.conf.d/03-service-custom.conf 
sh-5.1# exit
exit
[mkatari@dell-7625-02 out]$ oc rsh openstackclient 
sh-5.1$ openstack volume service list
+------------------+-------------------------------+------+---------+-------+----------------------------+
| Binary           | Host                          | Zone | Status  | State | Updated At                 |
+------------------+-------------------------------+------+---------+-------+----------------------------+
| cinder-scheduler | cinder-scheduler-0            | nova | enabled | up    | 2024-09-25T19:17:40.000000 |
| cinder-backup    | cinder-backup-0               | nova | enabled | up    | 2024-09-25T19:17:47.000000 |
| cinder-volume    | cinder-volume-lvm-iscsi-0@lvm | nova | enabled | up    | 2024-09-25T19:17:48.000000 |
+------------------+-------------------------------+------+---------+-------+----------------------------+
sh-5.1$ 

