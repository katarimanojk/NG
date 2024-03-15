# Bug 2278832 - check for an nfs-container fails during ceph upgrade


firt upgrade prepare command should use  ceph-ansible manila env template


https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/environments/ceph-ansible/manila-cephfsganesha-config.yaml#L11


second command shoud use cephadm template

 https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/environments/manila-cephfsganesha-config.yaml#L11


this bz can be closed as they misused the templates, but as part of this bug

* py-t-c code which runs the upgrade commands should have the validation 
   -  if right manila template at the right time.
   -  when ceph-nfs is enabled
