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




# testing the solution:

-> Juan ran the jenkins job https://rhos-ci-jenkins.lab.eng.tlv2.redhat.com/job/DFG-storage-ffu-17.1-from-16.2-latest_cdn-3cont_2comp_3ceph-ipv4-ovn_dvr-ceph-nfs-ganesha/ and stopped it after 'Overcloud FFU prepare'

-> ceph is still V4, which means only first upgrade is run and rollingupdate+adoptions is pending.

d0639effc420  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:4-195                                                                13 hours ago  Up 13 hours ago          ceph-mon-controller-1                                       
987362e2b878  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:4-195                                                                13 hours ago  Up 13 hours ago          ceph-mgr-controller-1                                       
59fcb717a710  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:4-195                                                                13 hours ago  Up 13 hours ago          ceph-mds-controller-1                                       
80395d2f91a5  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:4-195                                                                13 hours ago  Up 13 hours ago          ceph-rgw-controller-1-rgw0                                  
fcdf7f6ab428  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:4-195                                                                13 hours ago  Up 13 hours ago          ceph-crash-controller-1 


-> After first upgrade prepare, i see external_upgrade_steps_tasks.yaml

- block:
  - import_role:
      role: ceph
      tasks_from: ceph-upgrade-version-check
    name: ensure ceph version is OK before proceeding
    vars:
      tripleo_cephadm_container_image: rh-osbs/rhceph
      tripleo_cephadm_container_ns: undercloud-0.ctlplane.redhat.local:8787
      tripleo_cephadm_container_tag: '5'
  - import_role:
      role: ceph
      tasks_from: ceph-health
    name: ensure ceph health is OK before proceeding
    tags:
    - ceph_health
    vars:
      fail_on_ceph_health_err: true
      fail_on_ceph_health_warn: true
      osd_percentage_min: 0
      tripleo_delegate_to: '{{ groups[''ceph_mon''] | default([]) }}'
  - import_role:
      role: ceph
      tasks_from: ceph-nfs-template-check
    name: ensure correct template is used for ceph manila nfsganesha
    tags:
    - ceph_nfsvalidation
    vars:
      ceph_ansible: true
  - name: set ceph_ansible_playbooks_default
    set_fact:
      ceph_ansible_playbooks_default:
      - /usr/share/ceph-ansible/infrastructure-playbooks/cephadm-adopt.yml


- block:
  - import_role:
      role: ceph
      tasks_from: ceph-nfs-template-check
    name: ensure correct template is used for ceph manila nfsganesha
    tags:
    - ceph_nfsvalidation
    vars:
      ceph_ansible: true
  - name: set ceph_ansible_playbooks_default
    set_fact:
      ceph_ansible_playbooks_default:
      - /usr/share/ceph-ansible/infrastructure-playbooks/rolling_update.yml
  - name: Add ceph-infra tag to the skip list
    set_fact:
      ceph_ansible_skip_tags: package-install,with_pkg,ceph_infra
  tags: ceph
  when: step|int == 0


-> but in the upgrade_prepare script, i still see default cephadm based nfs tempalte, which means 5.1.11.iii is not executed yet.


openstack overcloud upgrade prepare ${PREPARE_ANSWER} \
    --stack qe-Cloud-0 \
    --templates /usr/share/openstack-tripleo-heat-templates \
    -e /usr/share/openstack-tripleo-heat-templates/environments/manila-cephfsganesha-config.yaml \               <----- this one
    -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-rgw.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-mds.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml \


i even checked the vars manually, ceph_ansible_group_vars_nfss is not set.


[stack@undercloud-0 ~]$ grep -inr ceph_nfs_vars .
./overcloud-deploy/qe-Cloud-0/config-download/qe-Cloud-0/external_deploy_steps_tasks_step1.yaml:202:      ceph_nfs_vars:
./overcloud-deploy/qe-Cloud-0/config-download/qe-Cloud-0/external_deploy_steps_tasks.yaml:402:      ceph_nfs_vars:

[stack@undercloud-0 qe-Cloud-0]$ grep -inr ceph_nfs_vars .
./external_deploy_steps_tasks_step1.yaml:202:      ceph_nfs_vars:
./external_deploy_steps_tasks.yaml:402:      ceph_nfs_vars:
[stack@undercloud-0 qe-Cloud-0]$ vi ./external_deploy_steps_tasks.yaml +402


[stack@undercloud-0 qe-Cloud-0]$ grep -inr ceph_ansible_group_vars_nfss .
[stack@undercloud-0 qe-Cloud-0]$ 


/usr/share/openstack-tripleo-heat-templates/environments/manila-cephfsganesha-config.yaml 


do they run it ? if not validation will always stop them.


-> run ceph-upgrade-run.sh or manually run external upgrade



# we have a problem

1. no resource_registry set, so need a condiation in tht code so that validation is called only of ceph nfs ganesha is enabled.
may be after it is poupulated at some deploy step, for now we are not using it.

2. ceph_ansible_group_vars_nfss is missing it is poplulated at deploy_task step1 , 

see the order : upgrade tasks first and then deploy_tasks:


PLAY [External upgrade step 0] *************************************************                                                                                                             │················································
[WARNING]: any_errors_fatal only stops any future tasks running on the host                                                                                                                  │················································
that fails with the tripleo_free strategy.                                                                                                                                                   │················································
2024-08-22 10:51:52.836258 | 52540038-3612-8a3a-396b-000000000065 |       TASK | set ceph_ansible_playbooks_default                                                                          │················································
2024-08-22 10:51:52.873526 | 52540038-3612-8a3a-396b-000000000065 |         OK | set ceph_ansible_playbooks_default | undercloud                                                             │················································
2024-08-22 10:51:52.874781 | 52540038-3612-8a3a-396b-000000000065 |     TIMING | set ceph_ansible_playbooks_default | undercloud | 0:00:04.451651 | 0.04s                                    │················································
2024-08-22 10:51:52.893373 | 52540038-3612-8a3a-396b-000000000066 |       TASK | Add ceph-infra tag to the skip list                                                                         │················································
2024-08-22 10:51:52.933331 | 52540038-3612-8a3a-396b-000000000066 |         OK | Add ceph-infra tag to the skip list | undercloud                                                            │················································
2024-08-22 10:51:52.934926 | 52540038-3612-8a3a-396b-000000000066 |     TIMING | Add ceph-infra tag to the skip list | undercloud | 0:00:04.511791 | 0.04s                                   │················································
                                                                                                                                                                                             │················································
PLAY [External upgrade step 1] *************************************************                                                                                                             │················································
2024-08-22 10:51:53.034794 | 52540038-3612-8a3a-396b-0000000001b3 |       TASK | set ceph_ansible_playbooks_default                                                                          │················································
2024-08-22 10:51:53.072898 | 52540038-3612-8a3a-396b-0000000001b3 |    SKIPPED | set ceph_ansible_playbooks_default | undercloud                                                             │················································
2024-08-22 10:51:53.074628 | 52540038-3612-8a3a-396b-0000000001b3 |     TIMING | set ceph_ansible_playbooks_default | undercloud | 0:00:04.651491 | 0.04s                                    │················································
2024-08-22 10:51:53.092285 | 52540038-3612-8a3a-396b-0000000001b4 |       TASK | Add ceph-infra tag to the skip list                                                                         │················································
2024-08-22 10:51:53.122176 | 52540038-3612-8a3a-396b-0000000001b4 |    SKIPPED | Add ceph-infra tag to the skip list | undercloud                                                            │················································
2024-08-22 10:51:53.124262 | 52540038-3612-8a3a-396b-0000000001b4 |     TIMING | Add ceph-infra tag to the skip list | undercloud | 0:00:04.701129 | 0.03s                                   │················································
                                                                                                                                                                                             │················································
PLAY [External upgrade step 2] *************************************************                                                                                                             │················································
2024-08-22 10:51:53.219061 | 52540038-3612-8a3a-396b-000000000301 |       TASK | set ceph_ansible_playbooks_default                                                                          │················································
2024-08-22 10:51:53.258267 | 52540038-3612-8a3a-396b-000000000301 |    SKIPPED | set ceph_ansible_playbooks_default | undercloud                                                             │················································
2024-08-22 10:51:53.260493 | 52540038-3612-8a3a-396b-000000000301 |     TIMING | set ceph_ansible_playbooks_default | undercloud | 0:00:04.837350 | 0.04s                                    │················································
2024-08-22 10:51:53.279591 | 52540038-3612-8a3a-396b-000000000302 |       TASK | Add ceph-infra tag to the skip list                                                                         │················································
2024-08-22 10:51:53.308855 | 52540038-3612-8a3a-396b-000000000302 |    SKIPPED | Add ceph-infra tag to the skip list | undercloud                                                            │················································
2024-08-22 10:51:53.310194 | 52540038-3612-8a3a-396b-000000000302 |     TIMING | Add ceph-infra tag to the skip list | undercloud | 0:00:04.887064 | 0.03s                                   │················································
                                                                                                                                                                                             │················································
PLAY [External deploy step 1] **************************************************          


so /fp moved the tht validation code to step2 of deploy tasks.


# final testing:




-> when ceph-ansible manila template is not used as per 5.1.11.iii:

024-08-22 10:52:12.080556 | 52540038-3612-8a3a-396b-0000000004b7 |     TIMING | prepare for ceph-ansible uuid gathering | undercloud | 0:00:23.657423 | 0.04s                               │················································
2024-08-22 10:52:12.182224 | 52540038-3612-8a3a-396b-0000000004b9 |       TASK | set ceph-ansible skip tags facts                                                                            │················································
2024-08-22 10:52:12.220903 | 52540038-3612-8a3a-396b-0000000004b9 |         OK | set ceph-ansible skip tags facts | undercloud                                                               │················································
2024-08-22 10:52:12.223936 | 52540038-3612-8a3a-396b-0000000004b9 |     TIMING | set ceph-ansible skip tags facts | undercloud | 0:00:23.800777 | 0.04s                                      │················································
2024-08-22 10:52:12.254584 | 52540038-3612-8a3a-396b-0000000004c0 |       TASK | Check manila nfs ganesha template using nfs vars                                                            │················································
[WARNING]: conditional statements should not include jinja2 templating                                                                                                                       │················································
delimiters such as {{ }} or {% %}. Found: {{ groups['ceph_nfs'] | default([]) |                                                                                                              │················································
length > 0 }}                                                                                                                                                                                │················································
2024-08-22 10:52:12.303748 | 52540038-3612-8a3a-396b-0000000004c0 |      FATAL | Check manila nfs ganesha template using nfs vars | undercloud | error={"changed": false, "msg": "Ceph manil$│················································
 nfs ganesha is enabled but incorrect template is used, please check and run upgrade prepare again using './environments/ceph-ansible/manila-cephfsganesha-config.yaml'"}                    │················································
2024-08-22 10:52:12.306650 | 52540038-3612-8a3a-396b-0000000004c0 |     TIMING | ceph : Check manila nfs ganesha template using nfs vars | undercloud | 0:00:23.883490 | 0.05s               │················································
                                                                                                                                                                                             │················································
NO MORE HOSTS LEFT *************************************************************                                                                                                             │················································
                                                                                                                                                                                             │················································
PLAY RECAP *********************************************************************  





-> when ceph-ansible template is used.



at external deploy step2

2024-08-22 11:18:07.822495 | 52540038-3612-c315-747f-0000000004b4 |       TASK | set ceph-ansible skip tags facts
2024-08-22 11:18:07.849978 | 52540038-3612-c315-747f-0000000004b4 |         OK | set ceph-ansible skip tags facts | undercloud                                                                                                               
2024-08-22 11:18:07.851160 | 52540038-3612-c315-747f-0000000004b4 |     TIMING | set ceph-ansible skip tags facts | undercloud | 0:00:24.432155 | 0.03s                                                                                      
2024-08-22 11:18:07.874443 | 52540038-3612-c315-747f-0000000004bb |       TASK | Check manila nfs ganesha template using nfs vars                                                                                                            
[WARNING]: conditional statements should not include jinja2 templating
delimiters such as {{ }} or {% %}. Found: {{ groups['ceph_nfs'] | default([]) |
length > 0 }}
2024-08-22 11:18:07.911581 | 52540038-3612-c315-747f-0000000004bb |    SKIPPED | Check manila nfs ganesha template using nfs vars | undercloud                                                                                               
2024-08-22 11:18:07.913148 | 52540038-3612-c315-747f-0000000004bb |     TIMING | ceph : Check manila nfs ganesha template using nfs vars | undercloud | 0:00:24.494122 | 0.04s                                                               
2024-08-22 11:18:07.937951 | 52540038-3612-c315-747f-0000000004bf |       TASK | PAUSE



at step 1, it is generated:

(undercloud) [stack@undercloud-0 qe-Cloud-0]$ cd ceph-ansible/
(undercloud) [stack@undercloud-0 ceph-ansible]$ ls
extra_vars.yml  fetch_dir  group_vars  host_vars  inventory.yml  nodes_uuid_data.json  nodes_uuid_playbook.yml
(undercloud) [stack@undercloud-0 ceph-ansible]$ vi group_vars/
all.yml      clients.yml  mgrs.yml     mons.yml     nfss.yml     osds.yml     rgws.yml
(undercloud) [stack@undercloud-0 ceph-ansible]$ vi group_vars/
all.yml      clients.yml  mgrs.yml     mons.yml     nfss.yml     osds.yml     rgws.yml
(undercloud) [stack@undercloud-0 ceph-ansible]$ vi group_vars/nfss.yml




ceph-ansible playooks is run here: we are adding validaiton before it.

            - name: run ceph-ansible
              include_role:
                name: tripleo_ceph_run_ansible

