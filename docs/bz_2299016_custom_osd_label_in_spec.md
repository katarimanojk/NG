

# slack thread

https://redhat-internal.slack.com/archives/C04MH4T5GPK/p1721333120753319

# code flow

[1] https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/playbooks/cli-deployed-ceph.yaml#L92-L128

https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/roles/tripleo_run_cephadm/tasks/enable_ceph_admin_user.yml#L86 

https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/playbooks/ceph-admin-user-playbook.yml

https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/roles/tripleo_create_admin/tasks/main.yml#L21


# Notes:

spec module will use fixed labels mon, mgr, osd

so code in [1] is written accordingly.

if you update spec and use your own label, code in [1] may skip ceph-admin creds for the host and you apply_spec may fail while trying to ssh to the host.
