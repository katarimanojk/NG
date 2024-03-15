
see john's comment on
https://code.engineering.redhat.com/gerrit/c/openstack-tripleo-validations/+/452536/4/roles/ceph/tasks/ceph-health.yaml




If a customer is doing an upgrade from 16 to 17 and following our docs, then they will pass this override CephConfigPath: /etc/ceph.

In a greenfield deployment CephConfigPath will default to /var/lib/tripleo-config/ceph.




his health check is for when Ceph is deployed by tripleo. When it does this, the following role is called so that the admin key is distributed the the mon hosts.

https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/roles/tripleo_ceph_distribute_keys/tasks/distribute_conf_and_keys.yaml#L22
