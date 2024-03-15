logs:

undercloud-0/home/stack/ceph-upgrade-run.log.gz



known things:
as per 5.1.11.iii:
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/17.1/html/framework_for_upgrades_16.2_to_17.1/performing-the-overcloud-adoption_overcloud-adoption


we use 'upgrade prepare' twice (one before 4->5 upgrade and one before/after adoption: need to check)
ceph-nfs (manila) may fail through the upgrade procedure as the env template used in 'updrage prepare' command should be changed. 

[1] uses cephadm
[1] https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/environments/manila-cephfsganesha-config.yaml#L11

[2] uses ceph-ansible
[2] https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/environments/ceph-ansible/manila-cephfsganesha-config.yaml#L11
