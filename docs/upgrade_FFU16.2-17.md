# my understanding of steps for FFU 16.2-17 (from ceph perspective)

https://docs.redhat.com/en/documentation/red_hat_openstack_platform/17.1/html-single/framework_for_upgrades_16.2_to_17.1/index
- undercloud upgrade
- overcloud preparation:
  - upgrade prepare using the tht from deploy
     - As per 5.1.11.iii: upgrade prepare with ceph-ansible based nfs file.
- 6.2 ceph upgrade from 4->5 : for which upgrades team uses a script: see upgrade_FFUscript.md
   - 6.3 rolling update
   - 6.5 ,6.6 : ceph-admin user and packages updation
   - 6.7 adoption
   - 6.9 modify upgrade prepare script and use cephadm based files.  
     - 6.10 update prepare script to use cephadm based nfs tht file.



chpater 13: 5->6 upgrade

# rolling_update + adoption logs

undercloud /config-download/env/ceph-ansible/ceph-ansible_command.log


# upgrade prepare

script overcloud_upgrade_prepare.sh in undercloud:~/ and also the log overcloud_upgrade_prepare.log

  during upgrade prepare, tasks under 'external_upgrade_tasks' are copied to 
/home/stack/overcloud-deploy/qe-Cloud-0/config-download/qe-Cloud-0/external_upgrade_steps_tasks.yaml

as ceph is external to OSP, it comes under external_upgrade tasks.


# known things:
as per 5.1.11.iii:
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/17.1/html/framework_for_upgrades_16.2_to_17.1/performing-the-overcloud-adoption_overcloud-adoption


we use 'upgrade prepare' twice (one before 4->5 upgrade and one before/after adoption: need to check)
ceph-nfs (manila) may fail through the upgrade procedure as the env template used in 'updrage prepare' command should be changed. 

[1] uses cephadm
[1] https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/environments/manila-cephfsganesha-config.yaml#L11

[2] uses ceph-ansible
[2] https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/environments/ceph-ansible/manila-cephfsganesha-config.yaml#L11

we have BZ 2278832 to handle this and fail the upgrade if incorrect template is used.



logs:

undercloud-0/home/stack/ceph-upgrade-run.log.gz
