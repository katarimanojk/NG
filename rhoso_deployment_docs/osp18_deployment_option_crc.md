source: https://github.com/fultonj/antelope/blob/main/docs/hci.md

openshift local / crc (code ready containers) : single node openshift (based on openshift 4.x) / All-in-one

see this : https://access.redhat.com/documentation/en-us/red_hat_codeready_containers/1.5/html-single/getting_started_guide/index#getting-started-with-codeready-containers_gsg

CRC using single vm which works as both master and worker

minishift (simillar to minikube) : based on openshift 3.x

## Reference docs:

https://github.com/openstack-k8s-operators/install_yamls/tree/main/devsetup


## Steps:

same thing is explain well here brno bootcamp doc:

https://gitlab.cee.redhat.com/johfulto/cinder-operator-bootcamp/-/blob/main/hypervisor.md


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
```
#### deploy OCP
```
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


--> now your ocp cluster is ready, you can use install_yamls  to deploy RHOSO











