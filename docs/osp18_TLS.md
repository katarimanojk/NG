
ocp contolplane wil have tls enabled:
can check through openssl s_client -connect api.ocp.openstack.lab:6443 -showcerts

TLS at RHOSO level (ctlplane/dataplane level) can be enabled/disabled

and it also can be enabled/disabled at service level (cinder, nova, ceph-rgw etc)



# greenfield

by default in RHOSO, tls is enabled


for ceph hci (ungamma) : https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/raw/main/scenarios/ceph/hci.yaml  
cifmw_cephadm_certificate: "/etc/pki/tls/ceph.cert"
cifmw_cephadm_key: "/etc/pki/tls/ceph.key"



post deployment, how to enable tls explictly

https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0/html-single/configuring_security_services/index#proc_enabling-TLS-on-a-RHOSO-environment-after-deployment_security-services







# brownfield

migrate 17.1 tls 
https://openstack-k8s-operators.github.io/data-plane-adoption/user/index.html#migrating-tls-everywhere_configuring-network
