
see john's comment on
https://code.engineering.redhat.com/gerrit/c/openstack-tripleo-validations/+/452536/4/roles/ceph/tasks/ceph-health.yaml



keys in cifmw:

cifmw_cepahdm_keys are passed : https://github.com/openstack-k8s-operators/ci-framework/blob/main/playbooks/ceph.yml#L329

keys are created here on the target nodes : https://github.com/openstack-k8s-operators/ci-framework/blob/main/playbooks/ceph.yml#L442   
 https://github.com/openstack-k8s-operators/ci-framework/blob/main/roles/cifmw_cephadm/tasks/keys.yml#L17

ceph client is again rendered in /tmp on localhost (hypervisor) here: https://github.com/openstack-k8s-operators/ci-framework/blob/main/playbooks/ceph.yml#L482



If a customer is doing an upgrade from 16 to 17 and following our docs, then they will pass this override CephConfigPath: /etc/ceph.

In a greenfield deployment CephConfigPath will default to /var/lib/tripleo-config/ceph.




his health check is for when Ceph is deployed by tripleo. When it does this, the following role is called so that the admin key is distributed the the mon hosts.

https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/roles/tripleo_ceph_distribute_keys/tasks/distribute_conf_and_keys.yaml#L22
