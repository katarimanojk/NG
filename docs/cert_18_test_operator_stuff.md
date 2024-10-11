
# commands to check for test-operator  before running any cert commands

[zuul@shark20 rhoso-cert]$ oc get --all-namespaces pod        --field-selector spec.serviceAccountName=test-operator-controller-manager
No resources found
[zuul@shark20 rhoso-cert]$ oc get --all-namespaces pods | grep test-op
[zuul@shark20 rhoso-cert]$ 

[zuul@shark20 rhoso-cert]$ oc get --all-namespaces subscription | grep test
[zuul@shark20 rhoso-cert]$ 
[zuul@shark20 rhoso-cert]$ oc get --all-namespaces catalogsource | grep test


# more info:


[zuul@shark20 rhoso-cert]$ oc get --all-namespaces subscription
NAMESPACE               NAME                                                                                    PACKAGE                           SOURCE                     CHANNEL
cert-manager-operator   openshift-cert-manager-operator                                                         openshift-cert-manager-operator   redhat-operators           stable-v1
metallb-system          metallb-operator-sub                                                                    metallb-operator                  redhat-operators           stable
openshift-nmstate       kubernetes-nmstate-operator                                                             kubernetes-nmstate-operator       redhat-operators           stable
openstack-operators     barbican-operator-stable-v1.0-openstack-operator-index-openstack-operators              barbican-operator                 openstack-operator-index   stable-v1.0
openstack-operators     cinder-operator-stable-v1.0-openstack-operator-index-openstack-operators                cinder-operator                   openstack-operator-index   stable-v1.0
openstack-operators     designate-operator-stable-v1.0-openstack-operator-index-openstack-operators             designate-operator                openstack-operator-index   stable-v1.0
openstack-operators     glance-operator-stable-v1.0-openstack-operator-index-openstack-operators                glance-operator                   openstack-operator-index   stable-v1.0
openstack-operators     heat-operator-stable-v1.0-openstack-operator-index-openstack-operators                  heat-operator                     openstack-operator-index   stable-v1.0
openstack-operators     horizon-operator-stable-v1.0-openstack-operator-index-openstack-operators               horizon-operator                  openstack-operator-index   stable-v1.0
openstack-operators     infra-operator-stable-v1.0-openstack-operator-index-openstack-operators                 infra-operator                    openstack-operator-index   stable-v1.0
openstack-operators     ironic-operator-stable-v1.0-openstack-operator-index-openstack-operators                ironic-operator                   openstack-operator-index   stable-v1.0
openstack-operators     keystone-operator-stable-v1.0-openstack-operator-index-openstack-operators              keystone-operator                 openstack-operator-index   stable-v1.0
openstack-operators     manila-operator-stable-v1.0-openstack-operator-index-openstack-operators                manila-operator                   openstack-operator-index   stable-v1.0
openstack-operators     mariadb-operator-stable-v1.0-openstack-operator-index-openstack-operators               mariadb-operator                  openstack-operator-index   stable-v1.0
openstack-operators     neutron-operator-stable-v1.0-openstack-operator-index-openstack-operators               neutron-operator                  openstack-operator-index   stable-v1.0
openstack-operators     nova-operator-stable-v1.0-openstack-operator-index-openstack-operators                  nova-operator                     openstack-operator-index   stable-v1.0
openstack-operators     octavia-operator-stable-v1.0-openstack-operator-index-openstack-operators               octavia-operator                  openstack-operator-index   stable-v1.0
openstack-operators     openstack-baremetal-operator-stable-v1.0-openstack-operator-index-openstack-operators   openstack-baremetal-operator      openstack-operator-index   stable-v1.0
openstack-operators     openstack-operator                                                                      openstack-operator                openstack-operator-index   
openstack-operators     ovn-operator-stable-v1.0-openstack-operator-index-openstack-operators                   ovn-operator                      openstack-operator-index   stable-v1.0
openstack-operators     placement-operator-stable-v1.0-openstack-operator-index-openstack-operators             placement-operator                openstack-operator-index   stable-v1.0
openstack-operators     rabbitmq-cluster-operator-stable-v1.0-openstack-operator-index-openstack-operators      rabbitmq-cluster-operator         openstack-operator-index   stable-v1.0
openstack-operators     swift-operator-stable-v1.0-openstack-operator-index-openstack-operators                 swift-operator                    openstack-operator-index   stable-v1.0
openstack-operators     telemetry-operator-stable-v1.0-openstack-operator-index-openstack-operators             telemetry-operator                openstack-operator-index   stable-v1.0
[zuul@shark20 rhoso-cert]$ 



[zuul@shark20 rhoso-cert]$ oc get --all-namespaces catalogsource 
NAMESPACE               NAME                       DISPLAY               TYPE   PUBLISHER   AGE
openshift-marketplace   certified-operators        Certified Operators   grpc   Red Hat     162m
openshift-marketplace   community-operators        Community Operators   grpc   Red Hat     162m
openshift-marketplace   redhat-marketplace         Red Hat Marketplace   grpc   Red Hat     162m
openshift-marketplace   redhat-operators           Red Hat Operators     grpc   Red Hat     162m
openstack-operators     openstack-operator-index                         grpc               33m
[zuul@shark20 rhoso-cert]$ 





# After rhoso-cert-init



[zuul@shark20 rhoso-cert]$ ./rhoso-cert-init 
Control plane namespace ('openstack') : openstack
Choose a test suite :
    1 : Cinder (any protocol: iSCSI, FC, NVMe-oF)
    2 : Manila with CIFS, DHSS=False
    3 : Manila with CIFS, DHSS=True
    4 : Manila with NFS, DHSS=False
    5 : Manila with NFS, DHSS=True
    6 : Neutron
    7 : Debug (run only the tempest tests specified in rhoso-cert-debug.yaml)
Certification suite : 1
Creating the subscription to deploy the test-operator...
subscription.operators.coreos.com/test-operator created
Waiting for the test-operator's controller to spawn.........................
Waiting for the test-operator's controller to be ready.....
Done.
[zuul@shark20 rhoso-cert]$ 


[zuul@shark20 rhoso-cert]$ oc get --all-namespaces pods | grep test-op
openstack-operators                                test-operator-controller-manager-6c989dd474-gszmb                 2/2     Running     0             8m9s

[zuul@shark20 rhoso-cert]$ oc get --all-namespaces subscription | grep test
openstack-operators     test-operator                                                                           test-operator                     openstack-operator-index   

[zuul@shark20 rhoso-cert]$ oc get --all-namespaces catalogsource
NAMESPACE               NAME                       DISPLAY               TYPE   PUBLISHER   AGE
openshift-marketplace   certified-operators        Certified Operators   grpc   Red Hat     3h13m
openshift-marketplace   community-operators        Community Operators   grpc   Red Hat     3h13m
openshift-marketplace   redhat-marketplace         Red Hat Marketplace   grpc   Red Hat     3h13m
openshift-marketplace   redhat-operators           Red Hat Operators     grpc   Red Hat     3h13m
openstack-operators     openstack-operator-index                         grpc               64m
[zuul@shark20 rhoso-cert]$ oc -n openstack-operators get catalogsource
NAME                       DISPLAY   TYPE   PUBLISHER   AGE
openstack-operator-index             grpc               65m


Note: rhoso-cert-cleanup will just remove tempest CR and the pods, test-operator will remain on the system.
