
# https://issues.redhat.com/browse/OSPRH-7427

tripleo_cephadm_assimilate_conf: "/home/{{ tripleo_cephadm_ssh_user }}/assimilate_{{ tripleo_cephadm_cluster }}.conf"
tripleo_cephadm_assimilate_conf_container: "/home/assimilate_{{ tripleo_cephadm_cluster }}.conf"



- in ./roles/tripleo_cephadm/tasks/pre.yaml , tripleo_cephadm_assimilate_conf is generated 

   if tripleo_cephadm_bootstrap_conf is passed, it is copied to assimilate.conf

   else generate assimilate.conf from template ceph.conf.j2, which relies on  config_overrides: "{{ tripleo_cephadm_conf_overrides }}"
 
    - from sealusa  ./overcloud-deploy/overcloud/config-download/overcloud/cephadm/cephadm-extra-vars-heat.yml

    ceph_conf_overrides:
    global:
        rgw_keystone_accepted_admin_roles: ResellerAdmin, swiftoperator
        rgw_keystone_accepted_reader_roles: SwiftSystemReader
        rgw_keystone_accepted_roles: member, Member, admin
        rgw_keystone_admin_domain: default
        rgw_keystone_admin_password: cCokeQquxqsTq4fZ9CIAHk2OM
        rgw_keystone_admin_project: service
        rgw_keystone_admin_user: swift
        rgw_keystone_api_version: 3
        rgw_keystone_implicit_tenants: 'true'
        rgw_keystone_revocation_interval: '0'
        rgw_keystone_url: http://172.17.1.45:5000
        rgw_keystone_verify_ssl: false
        rgw_max_attr_name_len: 128
        rgw_max_attr_size: 1024
        rgw_max_attrs_num_in_req: 90
        rgw_s3_auth_use_keystone: 'true'
        rgw_swift_account_in_url: 'true'
        rgw_swift_enforce_content_length: true
        rgw_swift_versioning_enabled: true
        rgw_trust_forwarded_https: 'true'


- also every bootstrap checks for assimilate.conf and use it in bootstrap command if the conf file exists.




- later cephadm playbook applies the config roles/tripleo_cephadm/tasks/apply_ceph_conf_overrides.yaml , playbooks/cephadm.yml +39  when  tripleo_cephadm_apply_ceph_conf_overrides_on_update  is set
     - where it uses  'ceph config assimilate-conf <filename>' which ingests/assimilates the config into the existing cluster.  





# sealusa assimilate.conf 

[root@controller-0 ceph-admin]# pwd
/home/ceph-admin
[root@controller-0 ceph-admin]# cat assimilate_ceph.conf
[global]
fsid = e8fc5e7e-ff84-515f-8ebc-7ce07f42f017
mon host = 172.17.3.26
rgw_keystone_accepted_admin_roles = ResellerAdmin, swiftoperator
rgw_keystone_accepted_reader_roles = SwiftSystemReader
rgw_keystone_accepted_roles = member, Member, admin
rgw_keystone_admin_domain = default
rgw_keystone_admin_password = cCokeQquxqsTq4fZ9CIAHk2OM
rgw_keystone_admin_project = service
rgw_keystone_admin_user = swift
rgw_keystone_api_version = 3
rgw_keystone_implicit_tenants = true
rgw_keystone_revocation_interval = 0
rgw_keystone_url = http://172.17.1.45:5000
rgw_keystone_verify_ssl = False
rgw_max_attr_name_len = 128
rgw_max_attr_size = 1024
rgw_max_attrs_num_in_req = 90
rgw_s3_auth_use_keystone = true
rgw_swift_account_in_url = true
rgw_swift_enforce_content_length = True
rgw_swift_versioning_enabled = True
rgw_trust_forwarded_https = true

[root@controller-0 ceph-admin]# 



# implementation plan in osp18

- implement a .j2 template for assimilate conf : already there
- in pre.yaml, a task to generate assmilate.conf from the template : already there but not called
- in rgw.yaml task: Apply ceph rgw keystone config , apply the assimimile conf.
- update readme file with assimilate conf parameter and details.


./playbooks/ceph.yml:253:    cifmw_cephadm_bootstrap_conf: /tmp/initial_ceph.conf


so generating from template is always skipped and it will always have inital ceph.conf as shown below.
 
ot@compute-0 ceph-admin]# cat assimilate_ceph.conf 
[global]
osd pool default size = 1
public_network = 172.18.0.0/24
cluster_network = 172.20.0.0/24
[mon]
mon_warn_on_pool_no_redundancy = false
[root@compute-0 ceph-admin]# 


when i commented 'cifmw_cephadm_bootstrap_conf: /tmp/initial_ceph.conf' and ran ceph deploy


TASK [Get Storage network range cifmw_cephadm_rgw_network={{ lookup('ansible.builtin.ini', 'public_network section=global file=' ~ cifmw_cephadm_bootstrap_conf) }}] *************************************************************************
task path: /home/zuul/src/github.com/openstack-k8s-operators/ci-framework/playbooks/ceph.yml:292                                                                                                                                              
Tuesday 13 August 2024  10:18:11 -0400 (0:00:00.049)       0:00:21.983 ********                                                                                                                                                               
fatal: [192.168.122.100]: FAILED! =>                                                                                                                                                                                                          
  msg: |-                                                                                                                                                                                                                                     
    The task includes an option with an undefined variable. The error was: 'cifmw_cephadm_bootstrap_conf' is undefined. 'cifmw_cephadm_bootstrap_conf' is undefined                                                                          
                                                                                                                                                                                                                                              
    The error appears to be in '/home/zuul/src/github.com/openstack-k8s-operators/ci-framework/playbooks/ceph.yml': line 292, column 7, but may                                                                                              
    be elsewhere in the file depending on the exact syntax problem.                                                                                                                                                                           
                                                                                                                                                                                                                                              
    The offending line appears to be:                                                                                                                                                                                                         
                                                                                                                                                                                                                                              
        # public network always exist because is provided by the ceph_spec role                                                                                                                                                               
        - name: Get Storage network range                                                                                                                                                                                                     
          ^ here                  



because we use it here


./playbooks/ceph.yml:324:        cifmw_cephadm_rgw_network: "{{ lookup('ansible.builtin.ini', 'public_network section=global file=' ~ cifmw_cephadm_bootstrap_conf) }}"
./playbooks/ceph.yml:396:        cifmw_cephadm_monitoring_network: "{{ lookup('ansible.builtin.ini', 'public_network section=global file=' ~ cifmw_cephadm_bootstrap_conf) }}"


i manually based bootstrap conf as empty to pre task


TASK [cifmw_cephadm : Generate cifmw_cephadm_assimilate_conf on bootstrap node src=ceph.conf.j2, dest={{ cifmw_cephadm_assimilate_conf }}, owner={{ cifmw_cephadm_uid }}, group={{ cifmw_cephadm_uid }}, mode=0644, config_overrides={{ cifmw_
cephadm_conf_overrides }}, config_type=ini] ***                                                                                                                                                                                               
task path: /home/zuul/src/github.com/openstack-k8s-operators/ci-framework/roles/cifmw_cephadm/tasks/pre.yml:147                                                                                                                               
Tuesday 13 August 2024  10:27:09 -0400 (0:00:00.048)       0:00:28.760 ********                                                                                                                                                               
fatal: [192.168.122.100]: FAILED! =>                                                                                                                                                                                                          
  msg: The module config_template was not found in configured module 



used ansible.builtin.template and updated conf to use cifmw_ceph_rgw_config and it generated the below conf in compute.


[root@compute-0 ceph-admin]# cat /home/ceph-admin/assimilate_ceph.conf
# Ansible managed
# Generated by cifmw_cephadm for initial bootstrap of first Ceph Mon


[global]
fsid = 62adefb3-4129-54aa-8872-94e0f2316e81
mon host = 172.18.0.100

rgw_keystone_url = keystone-internal.openstack.svc:5000
rgw_keystone_verify_ssl = False
rgw_keystone_api_version = 3
rgw_keystone_accepted_roles = "member, Member, admin"
rgw_keystone_accepted_admin_roles = "ResellerAdmin, swiftoperator"
rgw_keystone_admin_domain = default
rgw_keystone_admin_project = service
rgw_keystone_admin_user = swift
rgw_keystone_admin_password = 12345678
rgw_keystone_implicit_tenants = true
rgw_s3_auth_use_keystone = True
rgw_swift_versioning_enabled = True
rgw_swift_enforce_content_length = True
rgw_swift_account_in_url = True
rgw_trust_forwarded_https = True
rgw_max_attr_name_len = 128
rgw_max_attrs_num_in_req = 90
rgw_max_attr_size = 1024

[root@compute-0 ceph-admin]# 




TASK [cifmw_cephadm : Apply ceph rgw keystone config _raw_params={{ cifmw_cephadm_ceph_cli }} config assimilate-conf -i {{ cifmw_cephadm_assimilate_conf_container }}
] ***********************************************************************                                                                                                                                                                     
task path: /home/zuul/src/github.com/openstack-k8s-operators/ci-framework/roles/cifmw_cephadm/tasks/rgw.yml:70       
Friday 16 August 2024  04:01:14 -0400 (0:00:00.122)       0:01:41.141 ********* 
ok: [192.168.122.100] => changed=false     
  cmd:                                                                                                                 
  - podman                                                                                                                                                                                                                                    
  - run                                                                                                                                                                                                                                       
  - --rm                                                                                                                                                                                                                                      
  - --net=host                                                                                                         
  - --ipc=host                                                                                                         
  - --volume                                                                                                                                                                                                                                  
  - /etc/ceph:/etc/ceph:z                                  
  - --volume                                                                                                                                                                                                                                    - /home/ceph-admin/assimilate_ceph.conf:/home/assimilate_ceph.conf:z                                                                                                                                                                          - --volume                                                                                                                                                                                                                                    - /tmp/ceph_rgw.yml:/home/ceph_spec.yaml:z                                                                                                                                                                                                    - --entrypoint                                                                                                       
  - ceph                                                                                                               
  - quay.io/ceph/ceph:v18                                                                                                                                                                                                                     
  - --fsid                                                 
  - 62adefb3-4129-54aa-8872-94e0f2316e81                                                                                                                                                                                                      
  - -c                                                                                                                                                                                                                                        
  - /etc/ceph/ceph.conf                                                                                                                                                                                                                       
  - -k                                                                                                                                                                                                                                        
  - /etc/ceph/ceph.client.admin.keyring                                                                                
  - config                                                                                                             
  - assimilate-conf                                                                                                                                                                                                                           
  - -i                                                                                                                                                                                                                                        
  - /home/assimilate_ceph.conf                                                                                                                                                                                                                  delta: '0:00:00.755726'                                                                                                                                                                                                                     
  end: '2024-08-16 08:01:16.561165'          
  msg: ''                                                                                                                                                                                                                                     
  rc: 0                                                                                                                
  start: '2024-08-16 08:01:15.805439'                                                                                  
  stderr: ''                                                                                                                                                                                                                                  
  stderr_lines: <omitted>                                                                                              
  stdout: |2-                                                                                                          
                                                                                                                                                                                                                                              
    [global]                                                                                                           
            fsid = 62adefb3-4129-54aa-8872-94e0f2316e81    
            mon_host = 172.18.0.100                                                                                                                                                                                                           
  stdout_lines: <omitted>





manual testing:

[ceph: root@compute-0 /]# ceph config rm global rgw_keystone_api_version 
[ceph: root@compute-0 /]# ceph config dump | grep api
[ceph: root@compute-0 /]# ceph config assimilate-conf -i /mnt/ceph-admin/assimilate_ceph.conf 

[global]
        fsid = 62adefb3-4129-54aa-8872-94e0f2316e81
        mon_host = 172.18.0.100
[ceph: root@compute-0 /]# ceph config dump | grep api
global                                 advanced  rgw_keystone_api_version                    3                                                                        
[ceph: root@compute-0 /]# 




