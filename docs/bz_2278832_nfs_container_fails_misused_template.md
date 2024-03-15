# Bug 2278832 - check for an nfs-container fails during ceph upgrade


firt upgrade prepare command should use  ceph-ansible manila env template


https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/environments/ceph-ansible/manila-cephfsganesha-config.yaml#L11


second command shoud use cephadm template

 https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/environments/manila-cephfsganesha-config.yaml#L11


this bz can be closed as they misused the templates, but as part of this bug

* py-t-c code which runs the upgrade commands should have the validation 
   -  if right manila template at the right time.
   -  when ceph-nfs is enabled





env parmaeters are validated here
./v1/overcloud_upgrade.py:85:        parameters.check_forbidden_params(self.log,

./workflows/parameters.py:182:def check_forbidden_params(log, env_files, forbidden):


get_hosts_and_enable_ssh_admin method is called after that
./workflows/deployment.py:118:def get_hosts_and_enable_ssh_admin(stack_name, overcloud_ssh_network,\


.
.
.

we can't distingish between first and second upgrade prepare in py-t-c

can we validate something duing upgrade run 



$ openstack overcloud external-upgrade run \
--skip-tags "ceph_ansible_remote_tmp" \
--stack <stack> \
--tags ceph,facts 2>&1


it doesn't use env files but uses config-download generated from heat stack

which executes the playbook  "external_upgrade_steps_playbook.yaml with tags 'ceph'

 external_upgrade_tasks: section in THT  from different deployment files are captured into playbook 'external_upgrade_steps_playbook.yaml' in config-download



[mkatari@fedora ceph-ansible]$ grep -inr external_upgrade .
./ceph-client.yaml:69:      external_upgrade_tasks: {get_attr: [CephBase, role_data, external_upgrade_tasks]}
./ceph-external.yaml:72:      external_upgrade_tasks: {get_attr: [CephBase, role_data, external_upgrade_tasks]}
./ceph-grafana.yaml:145:      external_upgrade_tasks: {get_attr: [CephBase, role_data, external_upgrade_tasks]}
./ceph-mds.yaml:80:      external_upgrade_tasks: {get_attr: [CephBase, role_data, external_upgrade_tasks]}
./ceph-mgr.yaml:138:      external_upgrade_tasks: {get_attr: [CephBase, role_data, external_upgrade_tasks]}
./ceph-mon.yaml:102:      external_upgrade_tasks: {get_attr: [CephBase, role_data, external_upgrade_tasks]}
./ceph-osd.yaml:136:      external_upgrade_tasks: {get_attr: [CephBase, role_data, external_upgrade_tasks]}
./ceph-rbdmirror.yaml:98:      external_upgrade_tasks: {get_attr: [CephBase, role_data, external_upgrade_tasks]}
./ceph-rgw.yaml:155:      external_upgrade_tasks: {get_attr: [CephBase, role_data, external_upgrade_tasks]}
./ceph-nfs.yaml:93:      external_upgrade_tasks: {get_attr: [CephBase, role_data, external_upgrade_tasks]}
./ceph-base.yaml:768:      external_upgrade_tasks:



validations can be added before rolling update here:

https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/deployment/ceph-ansible/ceph-base.yaml#L793


before adpotion here (while doing ceph health check)

https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/deployment/ceph-ansible/ceph-base.yaml#L756



what to validate ? vars that are different

only difference is this file:

deployment/ceph-ansible/ceph-nfs.yaml   (environments/ceph-ansible/manila-cephfsganesha-config.yaml)

or

deployment/cephadm/ceph-nfs.yaml   (environments/manila-cephfsganesha-config.yaml)



https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/deployment/ceph-ansible/ceph-nfs.yaml#L119 vs
https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/deployment/cephadm/ceph-nfs.yaml#L125


