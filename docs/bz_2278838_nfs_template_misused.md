# Bug 2278838 - ceph-update-ganesha.yml playbook fails for missing variables 


It is identifed that the reason for mising vairables is they didnt use the manila env template in the upgrade prepare command


variables are defined here: https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/deployment/cephadm/ceph-nfs.yaml#L125,


which is included in manila env file: https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/environments/ceph-ansible/manila-cephfsganesha-config.yaml#L11


so the plan is to use the default value to tripleo_ceph_client_config_home
in https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/roles/tripleo_cephadm/templates/ceph-nfs.service.j2#L19


this template is used here: (issue is found while running the playbook ceph-update-ganesha.yml)
./tripleo_ansible/playbooks/ceph-update-ganesha.yml:9:            src: /usr/share/ansible/roles/tripleo_cephadm/templates/ceph-nfs.service.j2



other two paramters used in the template are

tripleo_cephadm_ceph_nfs_dynamic_exports: true
tripleo_cephadm_ceph_nfs_service_suffix: pacemaker

but we are not sure of the exact default for those.

Testng:


after this change
  --name=ceph-nfs-{{ tripleo_cephadm_ceph_nfs_service_suffix | default(ansible_facts['hostname'],'pacemaker') }} \



[stack@undercloud-0 ~]$ ansible-playbook  /usr/share/ansible/tripleo-playbooks/ceph-update-ganesha.yml -e overcloud-deploy/overcloud/config-download/overcloud/global_vars.yaml -e overcloud-deploy/overcloud/config-download/overcloud/cephadm/cephadm-extra-vars-heat.yml
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'                                                                                                                  

PLAY [localhost] *****************************************************************************************************************************************************************************************************************************

TASK [Render ganesha systemd unit] ***********************************************************************************************************************************************************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: ansible.errors.AnsibleUndefinedVariable: 'dict object' has no attribute 'hostname'. 'dict object' has no attribute 'hostname'               
fatal: [localhost]: FAILED! => {"changed": false, "msg": "AnsibleUndefinedVariable: 'dict object' has no attribute 'hostname'. 'dict object' has no attribute 'hostname'"}     
