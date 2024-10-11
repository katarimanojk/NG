
# reference: first 18 cert by pure
https://pure-storage-openstack-docs.readthedocs.io/en/latest/cinder/configuration/cinder_config_files/section_rhoso180_flasharray_configuration.html


## doubts:
- can't we update controlplane in different ways using oc edit or oc kusomize

for eg:
oc kustomize https://github.com/openstack-k8s-operators/cinder-operator/tree/main/config/samples/backends/netapp/ontap/iscsi?ref=main > netapp_backend.yam
OPENSTACK_CR=~/netapp_backend.yaml make openstack_deploy    

oc kustomize chances of loosing the delta, for eg: if you have one backend, you wnat to add 2nd backend, kustomize may loose 1t 

oc patch/edit  may not be persitent

so edit the complete controlplane CR and add the required files, let openshift decide on what changes are added



## things to check

* typos ?
* unnecessary or irrelevant notes
* links pointinng to 16 or 17
* any rhosp references instea of rhoso
* networkAttachments: should have both storage and storageMgmt
* secrets before the ctlplane CR edit and apply
* ctlplane CR, only cindervolume and not cinderapi etc , elises are ok but not full details
  - indentation
  -  backend names used should match with the secret backend name ([])
  - seretname should be same in customServiceConfigSecrets

* mutlibackend covered with correct examples ?
  - indentation
  -  every backend needs explicit secret, a note about it ?


* testing the backend

   same backned names mentioned int the samples are used ?
  
ref:
pure: https://issues.redhat.com/browse/CERTOPS-1375
netapp: https://issues.redhat.com/browse/CERTOPS-1577
