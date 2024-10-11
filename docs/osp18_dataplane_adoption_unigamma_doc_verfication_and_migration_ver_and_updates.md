
IMP NOTE:  from the unigamma doc, if tripleo (osp) deployment is ready, we can test migration even if ocp deployment is not ready
shark20, deploy osp cluster, clone cifmw , rdo , data-plane-adoption repo and run the ceph migration step

doc created by mikolaj for manual unigama adoption using cifmw :

https://docs.google.com/document/d/1xXEmhwdVh7a2t0yB6Th_3gYZIp3XkcsV330eb7M5xCk/edit?tab=t.0#heading=h.8oigbikkuakj


adoption failing here:


TASK [ceph_backend_configuration : update the openstack keyring caps for Manila] *************************************************************************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": true, "cmd": "set -euxo pipefail\n\n\nCEPH_SSH=\"ssh -i /home/zuul/.ssh/id_cifw -o StrictHostKeyChecking=accept-new  root@192.168.122.103\"\nCEPH_CAPS=\"mgr 'allow *' mon 'allow r, profile rbd' o
sd 'profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups, allow rw pool manila_data'\"\nOSP_KEYRING=\"client.openstack\"\nCEPH_ADM=$($CEPH_SSH \"cephadm shell -- ceph auth caps $OSP_KEYRING $CE
PH_CAPS\")\n", "delta": "0:00:00.048432", "end": "2024-12-30 12:59:31.294775", "msg": "non-zero return code", "rc": 255, "start": "2024-12-30 12:59:31.246343", "stderr": "+ CEPH_SSH='ssh -i /home/zuul/.ssh/id_cifw -o StrictHostKeyChecking
=accept-new  root@192.168.122.103'\n+ CEPH_CAPS='mgr '\\''allow *'\\'' mon '\\''allow r, profile rbd'\\'' osd '\\''profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups, allow rw pool manila_dat
a'\\'''\n+ OSP_KEYRING=client.openstack\n++ ssh -i /home/zuul/.ssh/id_cifw -o StrictHostKeyChecking=accept-new root@192.168.122.103 'cephadm shell -- ceph auth caps client.openstack mgr '\\''allow *'\\'' mon '\\''allow r, profile rbd'\\''
 osd '\\''profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups, allow rw pool manila_data'\\'''\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\n@    WARNING: REMOTE HOST IDENTIF
ICATION HAS CHANGED!     @\r\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\nIT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!\r\nSomeone could be eavesdropping on you right now (man-in-the-middle attack)!\r\nIt is als
o possible that a host key has just been changed.\r\nThe fingerprint for the ED25519 key sent by the remote host is\nSHA256:8GvaU85WfXUPQ2YY4c8xFmE219yRKrtxOZlHyLp/nyI.\r\nPlease contact your system administrator.\r\nAdd correct host key 
in /home/zuul/.ssh/known_hosts to get rid of this message.\r\nOffending ECDSA key in /home/zuul/.ssh/known_hosts:6\r\nHost key for 192.168.122.103 has changed and you have requested strict checking.\r\nHost key verification failed.\r\n+ C
EPH_ADM=", "stderr_lines": ["+ CEPH_SSH='ssh -i /home/zuul/.ssh/id_cifw -o StrictHostKeyChecking=accept-new  root@192.168.122.103'", "+ CEPH_CAPS='mgr '\\''allow *'\\'' mon '\\''allow r, profile rbd'\\'' osd '\\''profile rbd pool=vms, pro
file rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups, allow rw pool manila_data'\\'''", "+ OSP_KEYRING=client.openstack", "++ ssh -i /home/zuul/.ssh/id_cifw -o StrictHostKeyChecking=accept-new root@192.168.122.103 'cep
hadm shell -- ceph auth caps client.openstack mgr '\\''allow *'\\'' mon '\\''allow r, profile rbd'\\'' osd '\\''profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups, allow rw pool manila_data'\
\'''", "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", "@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @", "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", "IT IS POSSIBLE THAT SOMEONE IS DOING SOME
THING NASTY!", "Someone could be eavesdropping on you right now (man-in-the-middle attack)!", "It is also possible that a host key has just been changed.", "The fingerprint for the ED25519 key sent by the remote host is", "SHA256:8GvaU85W
fXUPQ2YY4c8xFmE219yRKrtxOZlHyLp/nyI.", "Please contact your system administrator.", "Add correct host key in /home/zuul/.ssh/known_hosts to get rid of this message.", "Offending ECDSA key in /home/zuul/.ssh/known_hosts:6", "Host key for 1
92.168.122.103 has changed and you have requested strict checking.", "Host key verification failed.", "+ CEPH_ADM="], "stdout": "", "stdout_lines": []}                                                                                       
                                                                                                                                                                                                                                              
PLAY RECAP ***********************************************************************************************************************************************************************************************************************************
localhost                  : ok=20   changed=15   unreachable=0    failed=1    skipped=17   rescued=0    ignored=0                                                                                                                            
         


couldn't run ansible with this error sometimes

zuul@shark19 ci-framework]$ ansible-playbook reproducer-clean.yml
ERROR: Unhandled exception when retrieving DEFAULT_LOCAL_TMP:
[Errno 28] No space left on device: '/home/zuul/.ansible/tmp/ansible-local-607208spur6rm'. [Errno 28] No space left on device: '/home/zuul/.ansible/tmp/ansible-local-607208spur6rm'



# Testin migration

IMP NOTE:  from the unigamma doc, if tripleo (osp) deployment is ready, we can test migration even if ocp deployment is not ready
shark20, deploy osp cluster, clone cifmw , rdo , data-plane-adoption repo and run the ceph migration step

# ceph migration part
see migration seciton in https://docs.google.com/document/d/1xXEmhwdVh7a2t0yB6Th_3gYZIp3XkcsV330eb7M5xCk/edit?tab=t.0


## copy inventory from tripleo

[zuul@shark20 ~]$ scp osp-undercloud-0:~/overcloud-deploy/overcloud/tripleo-ansible-inventory.yaml .                                                                                                                                          
Warning: Permanently added 'osp-undercloud-122njy6j-0.utility' (ED25519) to the list of known hosts.                                                                                                                                          
tripleo-ansible-inventory.yaml                                                                                                                                                                              100% 3004     4.5MB/s   00:00     
[zuul@shark20 ~]$




[zuul@shark20 ~]$ ansible -m ping  all -i tripleo-ansible-inventory.yaml                                                                                                                                                                      
undercloud | SUCCESS => {                                                                                                                                                                                                                         "ansible_facts": {                                                                                                                                                                                                                        
        "discovered_interpreter_python": "/usr/bin/python3"                                                                                                                                                                                       },                                         
    "changed": false,





## create overrides
[zuul@shark20 ~]$ ansible-playbook  -i tripleo-ansible-inventory.yaml  build_ceph_overrides.yaml 
                                                                                                                       
PLAY [Build ceph overrides for migration] ****************************************************************************************************************************************************************************************************
                                                           
TASK [Set Ceph relevant network facts] *******************************************************************************************************************************************************************************************************
ok: [localhost]                                            
                                                                                                                                                                                                                                              
TASK [Ceph Migration - Build the list of src and target nodes] *******************************************************************************************************************************************************************************
changed: [localhost]                                                                                                                                                                                                                          
                                                                                                                                                                                                                                              
PLAY RECAP ***********************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
                                                           
[zuul@shark20 ~]$ 




[zuul@shark20 tests]$ cat /home/zuul/rdo-jobs/playbooks/data_plane_adoption/ceph_overrides.yaml
# The ceph base image is split into ns/img/tag for backward compatibility with
# tripleo modules
ceph_container_ns: registry.redhat.io/rhceph
ceph_container_image: rhceph-7-rhel9
ceph_container_tag: latest
# Ceph dashboard and Ceph ingress related images
ceph_haproxy_container_image: "registry.redhat.io/rhceph/rhceph-haproxy-rhel9:latest"
ceph_keepalived_container_image: "registry.redhat.io/rhceph/keepalived-rhel9:latest"
ceph_alertmanager_container_image: "registry.redhat.io/openshift4/ose-prometheus-alertmanager:v4.15"
ceph_grafana_container_image: "registry.redhat.io/rhceph/grafana-rhel9:latest"
ceph_node_exporter_container_image: "registry.redhat.io/openshift4/ose-prometheus-node-exporter:v4.15"
ceph_prometheus_container_image: "registry.redhat.io/openshift4/ose-prometheus:v4.15"
ceph_spec_render_dir: "/home/tripleo-admin"
ceph_daemons_layout:
  monitoring: false
  rbd: true
  rgw: false
  mds: true
# BEGIN ceph nodes vars ANSIBLE MANAGED BLOCK
# CI related overrides:
# - 172.18 is the Ceph cluster storage network on vlan_id: 21
# - 172.18.0.200 is chosen as the client ip used to temporary
#   access the ceph cluster from the current automation while
#   migrating mons
# - 172.18.0.100 is used as VIP on the storage network is RGW
#   is present
decomm_nodes:
  - osp-controller-122njy6j-0
  - osp-controller-122njy6j-1
  - osp-controller-122njy6j-2
target_nodes:
  - osp-compute-122njy6j-0
  - osp-compute-122njy6j-1
  - osp-compute-122njy6j-2
node_map:
  - {"hostname": "osp-controller-122njy6j-0", "ip": "172.18.0.103"}
  - {"hostname": "osp-controller-122njy6j-1", "ip": "172.18.0.104"}
  - {"hostname": "osp-controller-122njy6j-2", "ip": "172.18.0.105"}
  - {"hostname": "osp-compute-122njy6j-0", "ip": "172.18.0.106"}
  - {"hostname": "osp-compute-122njy6j-1", "ip": "172.18.0.107"}
  - {"hostname": "osp-compute-122njy6j-2", "ip": "172.18.0.108"}
client_node: "osp-controller-122njy6j-0"
ceph_keep_mon_ipaddr: true
ceph_net_manual_migration: true
#override os-net-config conf file
os_net_conf_path: "/etc/os-net-config/tripleo_config.yaml"
ceph_storage_net_prefix: "172.18.0"
ceph_client_ip: 172.18.0.200
vlan_id: 21
ceph_rgw_virtual_ips_list:
      - 172.18.0.100/24
ceph_config_tmp_client_home: "/home/zuul/ceph_client"
# END ceph nodes vars ANSIBLE MANAGED BLOCK
[zuul@shark20 tests]$ 







before running migration, checking the deamons

[zuul@shark20 tests]$ ssh osp-controller-0
Warning: Permanently added 'osp-controller-122njy6j-0.utility' (ED25519) to the list of known hosts.
Register this system with Red Hat Insights: insights-client --register
Create an account or view all your systems at https://red.ht/insights-dashboard
Last login: Wed Feb  5 07:16:18 2025 from 192.168.122.1
[zuul@osp-controller-122njy6j-0 ~]$ sudo podman ps | grep ceph
c8d5c37ac814  registry.redhat.io/rhceph/rhceph-7-rhel9:latest                           -n mon.osp-contro...  13 hours ago  Up 13 hours                        ceph-87edd8f7-9fb3-5ce1-9e4d-77f3ef9594d2-mon-osp-controller-122njy6j-0
cf0de8995d47  registry.redhat.io/rhceph/rhceph-7-rhel9:latest                           -n mgr.osp-contro...  13 hours ago  Up 13 hours                        ceph-87edd8f7-9fb3-5ce1-9e4d-77f3ef9594d2-mgr-osp-controller-122njy6j-0-tajbnf
1fd6e0f30144  registry.redhat.io/rhceph/rhceph-7-rhel9:latest                           -n client.crash.o...  13 hours ago  Up 13 hours                        ceph-87edd8f7-9fb3-5ce1-9e4d-77f3ef9594d2-crash-osp-controller-122njy6j-0
f12d1b4b9bdf  registry.redhat.io/rhceph/rhceph-7-rhel9:latest                           -n client.rgw.rgw...  13 hours ago  Up 13 hours                        ceph-87edd8f7-9fb3-5ce1-9e4d-77f3ef9594d2-rgw-rgw-osp-controller-122njy6j-0-cimsef
a165910210a4  registry.redhat.io/rhceph/rhceph-7-rhel9:latest                           -n mds.mds.osp-co...  13 hours ago  Up 13 hours                        ceph-87edd8f7-9fb3-5ce1-9e4d-77f3ef9594d2-mds-mds-osp-controller-122njy6j-0-qmonzz
[zuul@osp-controller-122njy6j-0 ~]$ exit
logout
Connection to osp-controller-122njy6j-0.utility closed.
[zuul@shark20 tests]$ ssh osp-compute-0
Warning: Permanently added 'osp-compute-122njy6j-0.utility' (ED25519) to the list of known hosts.
Register this system with Red Hat Insights: insights-client --register
Create an account or view all your systems at https://red.ht/insights-dashboard
Last login: Wed Feb  5 07:16:18 2025 from 192.168.122.1
[zuul@osp-compute-122njy6j-0 ~]$ sudo podman ps | grep cpeh
[zuul@osp-compute-122njy6j-0 ~]$ sudo podman ps | grep ceph
e4423cf59623  registry.redhat.io/rhceph/rhceph-7-rhel9:latest                           -n client.crash.o...  13 hours ago  Up 13 hours                        ceph-87edd8f7-9fb3-5ce1-9e4d-77f3ef9594d2-crash-osp-compute-122njy6j-0
a3a66c758472  registry.redhat.io/rhceph/rhceph-7-rhel9:latest                           -n osd.1 -f --set...  13 hours ago  Up 13 hours                        ceph-87edd8f7-9fb3-5ce1-9e4d-77f3ef9594d2-osd-1
3ce184c92e9d  registry.redhat.io/rhceph/rhceph-7-rhel9:latest                           -n osd.4 -f --set...  13 hours ago  Up 13 hours                        ceph-87edd8f7-9fb3-5ce1-9e4d-77f3ef9594d2-osd-4
ffc6a72ea0f9  registry.redhat.io/rhceph/rhceph-7-rhel9:latest                           -n osd.7 -f --set...  13 hours ago  Up 13 hours                        ceph-87edd8f7-9fb3-5ce1-9e4d-77f3ef9594d2-osd-7
[zuul@osp-compute-122njy6j-0 ~]$










before migration, build the ceph overrides , we used this first and later we updated the file


[zuul@shark20 ~]$ cat build_ceph_overrides.yaml 
---
- name: Build ceph overrides for migration
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Set Ceph relevant network facts
      ansible.builtin.set_fact:
        ceph_storage_net_prefix: "172.18.0"
        ceph_nodes_ctlplane_prefix: "192.168.122"
        ceph_storage_vlan_id: 21
    - name: Ceph Migration - Build the list of src and target nodes
      ansible.builtin.blockinfile:
        marker_begin: "BEGIN ceph nodes vars"
        marker_end: "END ceph nodes vars"
        path: "/home/zuul/rdo-jobs/playbooks/data_plane_adoption/ceph_overrides.yaml"
        block: |
          # CI related overrides:
          # - 172.18 is the Ceph cluster storage network on vlan_id: 21
          # - 172.18.0.200 is chosen as the client ip used to temporary
          #   access the ceph cluster from the current automation while
          #   migrating mons
          # - 172.18.0.100 is used as VIP on the storage network is RGW
          #   is present
          decomm_nodes:
            - {{ hostvars[inventory_hostname].groups.Controller[0]+".localdomain" }}
            - {{ hostvars[inventory_hostname].groups.Controller[1]+".localdomain" }}
            - {{ hostvars[inventory_hostname].groups.Controller[2]+".localdomain" }}
          target_nodes:
            - {{ hostvars[inventory_hostname].groups.ComputeHCI[0]+".localdomain" }}
            - {{ hostvars[inventory_hostname].groups.ComputeHCI[1]+".localdomain" }}
            - {{ hostvars[inventory_hostname].groups.ComputeHCI[2]+".localdomain" }}
          node_map:
            - {"hostname": "{{ hostvars[inventory_hostname].groups.Controller[0]+'.localdomain' }}", "ip": "{{ ceph_storage_net_prefix }}.103"}
            - {"hostname": "{{ hostvars[inventory_hostname].groups.Controller[1]+'.localdomain' }}", "ip": "{{ ceph_storage_net_prefix }}.104"}
            - {"hostname": "{{ hostvars[inventory_hostname].groups.Controller[2]+'.localdomain' }}", "ip": "{{ ceph_storage_net_prefix }}.105"}
            - {"hostname": "{{ hostvars[inventory_hostname].groups.ComputeHCI[0]+'.localdomain' }}", "ip": "{{ ceph_storage_net_prefix }}.106"}
            - {"hostname": "{{ hostvars[inventory_hostname].groups.ComputeHCI[1]+'.localdomain' }}", "ip": "{{ ceph_storage_net_prefix }}.107"}
            - {"hostname": "{{ hostvars[inventory_hostname].groups.ComputeHCI[2]+'.localdomain' }}", "ip": "{{ ceph_storage_net_prefix }}.108"}
          client_node: "{{ hostvars[inventory_hostname].groups.Controller[0]+'.localdomain' }}"
          ceph_keep_mon_ipaddr: true
          ceph_net_manual_migration: true
          #override os-net-config conf file
          os_net_conf_path: "/etc/os-net-config/tripleo_config.yaml"
          ceph_storage_net_prefix: "{{ ceph_storage_net_prefix }}"
          ceph_client_ip: {{ ceph_storage_net_prefix }}.200
          vlan_id: {{ ceph_storage_vlan_id }}
          ceph_rgw_virtual_ips_list:
                - {{ ceph_storage_net_prefix }}.100/24
          ceph_config_tmp_client_home: "/home/zuul/ceph_client"
[zuul@shark20 ~]$ 




final build_overrides.yaml




---                                                                                                                                                                                                                                   [4/1989]
- name: Build ceph overrides for migration   
  hosts: localhost                  
  gather_facts: false                                 
  tasks:                                                                                                               
    - name: Set Ceph relevant network facts    
      ansible.builtin.set_fact:
        ceph_storage_net_prefix: "172.18.0"
        ceph_nodes_ctlplane_prefix: "192.168.122"
        ceph_storage_vlan_id: 21
    - name: Fetch canonical hostnames of OSP Controllers
      set_fact:
        controllers_fqdn : "{{ controllers_fqdn | default([]) + [ hostvars[item]['canonical_hostname'] ] }}"
      loop: "{{ groups['Controller'] }}"      
    - name: Fetch canonical hostnames of OSP Computes
      set_fact:
        computes_fqdn : "{{ computes_fqdn | default([]) + [ hostvars[item]['canonical_hostname'] ] }}"
      loop: "{{ groups['ComputeHCI'] }}"       
    - name: Ceph Migration - Build the list of src and target nodes
      ansible.builtin.blockinfile:
        marker_begin: "BEGIN ceph nodes vars"
        marker_end: "END ceph nodes vars"
        path: "/home/zuul/rdo-jobs/playbooks/data_plane_adoption/ceph_overrides.yaml"
        block: |
          # CI related overrides:
          # - 172.18 is the Ceph cluster storage network on vlan_id: 21
          # - 172.18.0.200 is chosen as the client ip used to temporary
          #   access the ceph cluster from the current automation while
          #   migrating mons
          # - 172.18.0.100 is used as VIP on the storage network is RGW
          #   is present
          decomm_nodes:
            - {{ controllers_fqdn[0] }}
            - {{ controllers_fqdn[1] }}
            - {{ controllers_fqdn[2] }}
          target_nodes:
            - {{ computes_fqdn[0] }}
            - {{ computes_fqdn[1] }}
            - {{ computes_fqdn[2] }}
          node_map:
            - {"hostname": "{{ controllers_fqdn[0] }}", "ip": "{{ ceph_storage_net_prefix }}.103"}
            - {"hostname": "{{ controllers_fqdn[1] }}", "ip": "{{ ceph_storage_net_prefix }}.104"}
            - {"hostname": "{{ controllers_fqdn[2] }}", "ip": "{{ ceph_storage_net_prefix }}.105"}
            - {"hostname": "{{ computes_fqdn[0] }}", "ip": "{{ ceph_storage_net_prefix }}.106"}
            - {"hostname": "{{ computes_fqdn[1] }}", "ip": "{{ ceph_storage_net_prefix }}.107"}
            - {"hostname": "{{ computes_fqdn[2] }}", "ip": "{{ ceph_storage_net_prefix }}.108"}
          client_node: "{{ controllers_fqdn[0] }}"
          ceph_keep_mon_ipaddr: true
          ceph_net_manual_migration: true
          #override os-net-config conf file
          os_net_conf_path: "/etc/os-net-config/tripleo_config.yaml"
          ceph_storage_net_prefix: "{{ ceph_storage_net_prefix }}"
          ceph_client_ip: {{ ceph_storage_net_prefix }}.200 
          vlan_id: {{ ceph_storage_vlan_id }}
          ceph_rgw_virtual_ips_list:
                - {{ ceph_storage_net_prefix }}.100/24
          ceph_config_tmp_client_home: "/home/zuul/ceph_client"







ssh config is generated during create-infra playbbok





which calls https://github.com/openstack-k8s-operators/ci-framework/blob/d1242e45ede578e6e702eb4860f41e9ef9ca41d8/roles/libvirt_manager/tasks/manage_vms.yml#L22

where ssh_jumper role is called with patterns of hosts

where https://github.com/openstack-k8s-operators/ci-framework/blob/main/roles/ssh_jumper/templates/ssh_host.conf.j2 is renederted into ssh config files for different overcloud nodes




until tempest is ready, some basic tests to ensure that cinder services can use the externalized ceph:


[zuul@shark20 ~]$ oc rsh openstackclient 



sh-5.1$ openstack volume service list                                                                                  
+------------------+------------------------+------+---------+-------+----------------------------+
| Binary           | Host                   | Zone | Status  | State | Updated At                 |
+------------------+------------------------+------+---------+-------+----------------------------+
| cinder-volume    | hostgroup@tripleo_ceph | nova | enabled | up    | 2025-02-17T13:44:34.000000 |
| cinder-scheduler | cinder-scheduler-0     | nova | enabled | up    | 2025-02-17T13:44:36.000000 |
| cinder-backup    | cinder-backup-0        | nova | enabled | up    | 2025-02-17T13:44:29.000000 |
+------------------+------------------------+------+---------+-------+----------------------------+

sh-5.1$ openstack volume type create rbd_type                                                                          
+-------------+--------------------------------------+                                                                 
| Field       | Value                                |                                                                 
+-------------+--------------------------------------+                                                                 
| description | None                                 |                                                                 
| id          | da24f25c-3b9a-4bc3-a702-ea1e46bb7231 |
| is_public   | True                                 |
| name        | rbd_type                             |
+-------------+--------------------------------------+


[ceph: root@osp-compute-6h8l9x2i-0 /]# rbd ls -l -p volumes
[ceph: root@osp-compute-6h8l9x2i-0 /]#



sh-5.1$ openstack volume type set --property "volume_backend_name=tripleo_ceph" rbd_type
sh-5.1$ openstack volume type show rbd_type                 
+--------------------+--------------------------------------+
| Field              | Value                                |
+--------------------+--------------------------------------+
| access_project_ids | None                                 |
| description        | None                                 |
| id                 | da24f25c-3b9a-4bc3-a702-ea1e46bb7231 |
| is_public          | True                                 |
| name               | rbd_type                             |
| properties         | volume_backend_name='tripleo_ceph'   |
| qos_specs_id       | None                                 |
+--------------------+--------------------------------------+





 
sh-5.1$ openstack volume create --type rbd_type --size 1 rbd_vol1
+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+    
| attachments         | []                                   |    
| availability_zone   | nova                                 |    
| bootable            | false                                |    
| consistencygroup_id | None                                 |    
| created_at          | 2025-02-17T13:47:29.775180           |    
| description         | None                                 |
| encrypted           | False                                |    
| id                  | e4c68893-35dd-403e-905c-4ff63d0f7ecd |    
| migration_status    | None                                 |    
| multiattach         | False                                |    
| name                | rbd_vol1                             |    
| properties          |                                      |    
| replication_status  | None                                 |
| size                | 1                                    |    
| snapshot_id         | None                                 |    
| source_volid        | None                                 |    
| status              | creating                             |    
| type                | rbd_type                             |    
| updated_at          | None                                 |    
| user_id             | 2535485a002242e2a6017f8e8ffbcdf1     |
+---------------------+--------------------------------------+
sh-5.1$ openstack volume list
+--------------------------------------+----------+-----------+------+-------------+
| ID                                   | Name     | Status    | Size | Attached to |
+--------------------------------------+----------+-----------+------+-------------+
| e4c68893-35dd-403e-905c-4ff63d0f7ecd | rbd_vol1 | available |    1 |             |
+--------------------------------------+----------+-----------+------+-------------+



[ceph: root@osp-compute-6h8l9x2i-0 /]# rbd ls -l -p volumes
NAME                                         SIZE   PARENT  FMT  PROT  LOCK
volume-e4c68893-35dd-403e-905c-4ff63d0f7ecd  1 GiB            2  







sh-5.1$ openstack image list
+--------------------------------------+--------+--------+
| ID                                   | Name   | Status |
+--------------------------------------+--------+--------+
| daa9d12c-b984-45fe-8cbd-1cef8c6312a4 | cirros | active |
+--------------------------------------+--------+--------+


[ceph: root@osp-compute-6h8l9x2i-0 /]# rbd ls -l -p images 
NAME                                       SIZE     PARENT  FMT  PROT  LOCK
daa9d12c-b984-45fe-8cbd-1cef8c6312a4       112 MiB            2            
daa9d12c-b984-45fe-8cbd-1cef8c6312a4@snap  112 MiB            2  yes  




sh-5.1$ openstack image create --volume e4c68893-35dd-403e-905c-4ff63d0f7ecd rbd_vol1_image
+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| container_format    | bare                                 |
| disk_format         | raw                                  |
| display_description | None                                 |
| id                  | e4c68893-35dd-403e-905c-4ff63d0f7ecd |
| image_id            | add12b5d-4a82-4ef3-ac3d-0476a7d5f450 |
| image_name          | rbd_vol1_image                       |
| protected           | False                                |
| size                | 1                                    |
| status              | uploading                            |
| updated_at          | 2025-02-17T13:47:31.000000           |
| visibility          | shared                               |
| volume_type         | rbd_type                             |
+---------------------+--------------------------------------+
sh-5.1$ openstack image list
+--------------------------------------+----------------+--------+
| ID                                   | Name           | Status |
+--------------------------------------+----------------+--------+
| daa9d12c-b984-45fe-8cbd-1cef8c6312a4 | cirros         | active |
| add12b5d-4a82-4ef3-ac3d-0476a7d5f450 | rbd_vol1_image | saving |
+--------------------------------------+----------------+--------+
sh-5.1$ openstack image list
+--------------------------------------+----------------+--------+
| ID                                   | Name           | Status |
+--------------------------------------+----------------+--------+
| daa9d12c-b984-45fe-8cbd-1cef8c6312a4 | cirros         | active |
| add12b5d-4a82-4ef3-ac3d-0476a7d5f450 | rbd_vol1_image | saving |
+--------------------------------------+----------------+--------+
sh-5.1$ openstack image list
+--------------------------------------+----------------+--------+
| ID                                   | Name           | Status |
+--------------------------------------+----------------+--------+
| daa9d12c-b984-45fe-8cbd-1cef8c6312a4 | cirros         | active |
| add12b5d-4a82-4ef3-ac3d-0476a7d5f450 | rbd_vol1_image | active |
+--------------------------------------+----------------+--------+
sh-5.1$ 


on the ceph cluster:
[ceph: root@osp-compute-6h8l9x2i-0 /]# rbd ls -l -p images
NAME                                       SIZE     PARENT  FMT  PROT  LOCK
add12b5d-4a82-4ef3-ac3d-0476a7d5f450       248 MiB            2        excl
daa9d12c-b984-45fe-8cbd-1cef8c6312a4       112 MiB            2            
daa9d12c-b984-45fe-8cbd-1cef8c6312a4@snap  112 MiB            2  yes     



sh-5.1$ openstack volume delete e4c68893-35dd-403e-905c-4ff63d0f7ecd
sh-5.1$ openstack volume list

sh-5.1$ 

[ceph: root@osp-compute-6h8l9x2i-0 /]# rbd ls -l -p volumes
[ceph: root@osp-compute-6h8l9x2i-0 /]# 








# other steps to improve automatoin of the first step




[zuul@shark20 ~]$ cat ceph_migration.yaml_bkp 
---
- name: Perform ceph migration
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Fetch tripleo-ansible-inventory from osp undercloud
      ansible.builtin.shell: scp zuul@osp-undercloud-0:~/overcloud-deploy/overcloud/tripleo-ansible-inventory.yaml .

    - name: update private keys in inventory
      ansible.builtin.lineinfile:
        path: /home/zuul/tripleo-ansible-inventory.yaml
        regexp: '^ansible_ssh_user: zuul'
        insertafter: 'ansible_ssh_user: zuul'
        line: "    ansible_ssh_private_key_file: /home/zuul/.ssh/cifmw_reproducer_key"

[zuul@shark20 ~]$ cat ceph_migration.yaml_addhost 
---
- name: Perform ceph migration
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Fetch tripleo-ansible-inventory from osp undercloud
      ansible.builtin.shell: scp zuul@osp-undercloud-0:~/overcloud-deploy/overcloud/tripleo-ansible-inventory.yaml .

    - name: Add host with SSH key
      add_host:
        name: "{{ item }}"
        ansible_ssh_private_key_file: "/home/zuul/.ssh/cifmw_reproducer_key"
      loop: "{{ groups['Controller'] }}"

- name: checking hosts
  hosts: "{{ groups['ComputeHCI'] }}"
  connection: local
  gather_facts: false
  tasks:
    - debug: var=group_names
    - debug: msg="{{ inventory_hostname }}"
    - debug: var=hostvars[inventory_hostname]    

- name: checking hosts
  hosts: localhost
  connection: local
  gather_facts: false
  tasks:
    - name: ssh test
      shell: "ssh zuul@192.168.122.103 ls -l"
[zuul@shark20 ~]$ 


# new problem


fqdn can change

c[ceph: root@osp-controller-1ixmsjqd-0 /]# ceph orch host ls
HOST                                   ADDR             LABELS          STATUS  
osp-compute-1ixmsjqd-0.example.com     192.168.122.106  osd                     
osp-compute-1ixmsjqd-1.example.com     192.168.122.107  osd                     
osp-compute-1ixmsjqd-2.example.com     192.168.122.108  osd                     
osp-controller-1ixmsjqd-0.example.com  192.168.122.103  _admin,mon,mgr          
osp-controller-1ixmsjqd-1.example.com  192.168.122.104  _admin,mon,mgr          
osp-controller-1ixmsjqd-2.example.com  192.168.122.105  _admin,mon,mgr          
6 hosts in cluster
[ceph: root@osp-controller-1ixmsjqd-0 /]# 



[zuul@shark19 tests]$ grep canonical ~/tripleo-ansible-inventory.yaml
      canonical_hostname: osp-compute-1ixmsjqd-0.example.com
      canonical_hostname: osp-compute-1ixmsjqd-1.example.com
      canonical_hostname: osp-compute-1ixmsjqd-2.example.com
      canonical_hostname: osp-controller-1ixmsjqd-0.example.com
      canonical_hostname: osp-controller-1ixmsjqd-1.example.com
      canonical_hostname: osp-controller-1ixmsjqd-2.example.com
[zuul@shark19 tests]$ 


https://github.com/openstack-k8s-operators/ci-framework/pull/2729/files may not help here


so i see the same error again (error is because of fqdn)



TASK [ceph_migrate : Ensure firewall is temporarily stopped] *******************                      
failed: [osp-controller-1ixmsjqd-0 -> osp-compute-1ixmsjqd-0.example.com] (item=iptables) => {"ansible_loop_var": "item", "item": "iptables", "msg": "Failed to connect to the host via ssh: ssh: Could not resolve hostname osp-compute-1ixms
jqd-0.example.com: Name or service not known", "unreachable": true}                                 
failed: [osp-controller-1ixmsjqd-0 -> osp-compute-1ixmsjqd-0.example.com] (item=nftables) => {"ansible_loop_var": "item", "item": "nftables", "msg": "Failed to connect to the host via ssh: ssh: Could not resolve hostname osp-compute-1ixms
jqd-0.example.com: Name or service not known", "unreachable": true}                         
fatal: [osp-controller-1ixmsjqd-0 -> {{ node }}]: UNREACHABLE! => {"changed": false, "msg": "All items completed", "results": [{"ansible_loop_var": "item", "item": "iptables", "msg": "Failed to connect to the host via ssh: ssh: Could not 
resolve hostname osp-compute-1ixmsjqd-0.example.com: Name or service not known", "unreachable": true}, {"ansible_loop_var": "item", "item": "nftables", "msg": "Failed to connect to the host via ssh: ssh: Could not resolve hostname osp-com
pute-1ixmsjqd-0.example.com: Name or service not known", "unreachable": true}]}                                        
                                                                                                                       
PLAY RECAP ********************************************************************* 




- name: Dump the updated inventory
  hosts: all
  connection: local
  gather_facts: false
  tasks:
    - name: copy
      copy:
        content: "{{ hostvars[controller] | to_nice_yaml }}"
        dest: "/home/zuul/tripleo-ansible-inventory-ceph.yaml"
    - name: copy
      copy:
        content: "{{ hostvars[computes] | to_nice_yaml }}"
        dest: "/home/zuul/tripleo-ansible-inventory-ceph.yaml"









    - name: Ensure to enable rgw for adoption
      ansible.builtin.lineinfile:
        path: /home/zuul/rdo-jobs/playbooks/data_plane_adoption/ceph_overrides.yaml
        line: 'ceph_daemons_layout.rgw: true'
    - name: Add controllers with SSH key to inventory
      add_host:
        name: "{{ item }}"
        ansible_ssh_private_key_file: "/home/zuul/.ssh/cifmw_reproducer_key"
      loop: "{{ groups['Controller'] }}"
    - name: Add computes with SSH key to inventory
      add_host:
        name: "{{ item }}"
        ansible_ssh_private_key_file: "/home/zuul/.ssh/cifmw_reproducer_key"
      loop: "{{ groups['ComputeHCI'] }}"



Update the vars section in the inventory for ‘ComputeHCI’ and ‘Controller’ to use private key so that login issues will not be seen.


ansible_ssh_private_key_file: "/home/zuul/.ssh/cifmw_reproducer_key"




