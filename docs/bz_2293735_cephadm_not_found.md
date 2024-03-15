
see john's comments in https://code.engineering.redhat.com/gerrit/c/openstack-tripleo-validations/+/452536/4/roles/ceph/tasks/ceph-health.yaml

for answers on conf and keyring


If a customer is doing an upgrade from 16 to 17 and following our docs, then they will pass this override CephConfigPath: /etc/ceph.

In a greenfield deployment CephConfigPath will default to /var/lib/tripleo-config/ceph.


# testing


[tripleo-admin@controller-0 ~]$ cat eg_shell_manoj2.yaml
---
- hosts: localhost
  vars:
    from_ceph_ansible : true
    tripleo_ceph_config_path: "/etc/ceph"
    ceph_cluster_name : "ceph"
  tasks:
    - name: Get ceph health using cephadm
      become: true
      shell: "cephadm shell -- {{ ceph_cluster_name.stdout }} health | awk '{print $1}'"
      register: ceph_health1
      when: not from_ceph_ansible | default(false) | bool

    - name: print
      debug:
        msg: "{{ ceph_health1 }}"

    - name: Get ceph health
      become: true
      #shell: "podman  run --rm -v {{ tripleo_ceph_config_path }}/ceph.client.admin.keyring:{{ tripleo_ceph_config_path }}/ceph.keyring:z -v {{ tripleo_ceph_config_path }}/ceph.conf:{{ tripleo_ceph_config_path }}/ceph.conf:z --entrypoint ceph  5412073bd7693a6a3dd757df8ea45c8442acb7666bd993355de4e44342b0b240 --cluster {{ ceph_cluster_name.stdout }} health | awk '{print $1}'"
      shell: "podman  run --rm -v {{ tripleo_ceph_config_path }}/{{ ceph_cluster_name | default('ceph') }}.client.admin.keyring:{{ tripleo_ceph_config_path }}/ceph.keyring:z -v {{ tripleo_ceph_config_path }}/{{ ceph_cluster_name | default('ceph') }}.conf:{{ tripleo_ceph_config_path }}/ceph.conf:z --entrypoint ceph 5412073bd7693a6a3dd757df8ea45c8442acb7666bd993355de4e44342b0b240 --cluster {{ ceph_cluster_name | default('ceph') }} health | awk '{print $1}'"
      register: ceph_health2
      when: from_ceph_ansible | default(false) | bool

    - name: print
      debug:
        msg: "{{ ceph_health2 }}"

    - name: stat
      set_fact:
        ceph_health: "{{ ceph_health2 if (ceph_health2.stdout is defined and ceph_health2.stdout | length > 0) else ceph_health1 }}"
        #ceph_health: {{ ceph_health1 }}
      #when: ceph_health1.stdout is defined and ceph_health1.stdout | length > 0

    - name: print
      debug:
        msg: "{{ ceph_health }}"
[tripleo-admin@controller-0 ~]$ 





# Testing on FFU job


 ffu job is paused after first upgrade prepare 

 when i tried ceph-upgrade-run.sh, it was failing at the task 'run ceph-ansible' while looking for container ceph-mon-controller-0  which doesn't exist

 so i went ahead with 

 #openstack overcloud external-upgrade run --yes --stack qe-Cloud-0 --tags cephadm_adopt  
which executed the tasks (we fixed) in external_upgrade_steps_tasks.yaml



--- my fix is update here

(undercloud) [stack@undercloud-0 qe-Cloud-0]$ head -30 external_upgrade_steps_tasks.yaml
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
      ceph_ansible: true
      ceph_cluster_name: ceph
      fail_on_ceph_health_err: true
      fail_on_ceph_health_warn: true
      osd_percentage_min: 0
      tripleo_ceph_config_path: /etc/ceph
      tripleo_cephadm_container_image: rh-osbs/rhceph
      tripleo_cephadm_container_ns: undercloud-0.ctlplane.redhat.local:8787
      tripleo_cephadm_container_tag: '5'
      tripleo_delegate_to: '{{ groups[''ceph_mon''] | default([]) }}'
  - name: set ceph_ansible_playbooks_default
    set_fact:
      ceph_ansible_playbooks_default:
      - /usr/share/ceph-ansible/infrastructure-playbooks/cephadm-adopt.yml
(undercloud) [stack@undercloud-0 qe-Cloud-0]$ 



adopt command logs....


PLAY [External upgrade step 0] *************************************************                                                                                                                                                             
[WARNING]: any_errors_fatal only stops any future tasks running on the host                                                                                                                                                                  
that fails with the tripleo_free strategy.                                                                                                                                                                                                   
2024-07-08 17:25:05.820559 | 52540071-6000-6b0f-0e4a-000000000031 |       TASK | Get Ceph version                                                                                                                                            
2024-07-08 17:25:28.410789 | 52540071-6000-6b0f-0e4a-000000000031 |    CHANGED | Get Ceph version | undercloud                                                                                                                               
2024-07-08 17:25:28.415344 | 52540071-6000-6b0f-0e4a-000000000031 |     TIMING | ceph : Get Ceph version | undercloud | 0:00:25.128927 | 22.59s                                                                                              
2024-07-08 17:25:28.435132 | 52540071-6000-6b0f-0e4a-000000000032 |       TASK | Check for valid ceph version during FFU                                                                                                                     
2024-07-08 17:25:28.467085 | 52540071-6000-6b0f-0e4a-000000000032 |    SKIPPED | Check for valid ceph version during FFU | undercloud                                                                                                        
2024-07-08 17:25:28.468727 | 52540071-6000-6b0f-0e4a-000000000032 |     TIMING | Check for valid ceph version during FFU | undercloud | 0:00:25.182339 | 0.03s                                                                               
2024-07-08 17:25:28.509390 | 52540071-6000-6b0f-0e4a-00000000003d |       TASK | Check if ceph_mon is deployed                                                                                                                               
2024-07-08 17:25:28.989319 | 52540071-6000-6b0f-0e4a-00000000003d |         OK | Check if ceph_mon is deployed | undercloud -> 192.168.24.44                                                                                                 
[WARNING]: ('undercloud -> 192.168.24.44',                                                                                                                                                                                                   
'52540071-6000-6b0f-0e4a-00000000003d') missing from stats                                                                                                                                                                                   
2024-07-08 17:25:29.040870 | 52540071-6000-6b0f-0e4a-00000000003f |       TASK | Get ceph health using cephadm                                                                                                                               
2024-07-08 17:25:29.079510 | 52540071-6000-6b0f-0e4a-00000000003f |    SKIPPED | Get ceph health using cephadm | undercloud                                                                                                                  
2024-07-08 17:25:29.081522 | 52540071-6000-6b0f-0e4a-00000000003f |     TIMING | Get ceph health using cephadm | undercloud | 0:00:25.795130 | 0.04s                                                                                         
2024-07-08 17:25:29.116248 | 52540071-6000-6b0f-0e4a-000000000040 |       TASK | Get ceph health for ceph-ansible
2024-07-08 17:25:30.790484 | 52540071-6000-6b0f-0e4a-000000000040 |    CHANGED | Get ceph health for ceph-ansible | undercloud -> 192.168.24.44                                                                                              
[WARNING]: ('undercloud -> 192.168.24.44',
'52540071-6000-6b0f-0e4a-000000000040') missing from stats                                                                                                                                                                                   
2024-07-08 17:25:30.833937 | 52540071-6000-6b0f-0e4a-000000000041 |       TASK | Capture ceph_health                                                                                                                                         
2024-07-08 17:25:30.897019 | 52540071-6000-6b0f-0e4a-000000000041 |         OK | Capture ceph_health | undercloud -> 192.168.24.44                                                                                                           
[WARNING]: ('undercloud -> 192.168.24.44',                                                                                                                                                                                                   
'52540071-6000-6b0f-0e4a-000000000041') missing from stats                                                                                                                                                                                   
2024-07-08 17:25:30.939109 | 52540071-6000-6b0f-0e4a-000000000042 |       TASK | Check ceph health                                                                                                                                           
2024-07-08 17:25:30.989303 | 52540071-6000-6b0f-0e4a-000000000042 |    SKIPPED | Check ceph health | undercloud                                                                                                                              
2024-07-08 17:25:30.992171 | 52540071-6000-6b0f-0e4a-000000000042 |     TIMING | Check ceph health | undercloud | 0:00:27.705753 | 0.05s                                                                                                     
2024-07-08 17:25:31.032101 | 52540071-6000-6b0f-0e4a-000000000043 |       TASK | Fail if ceph health is HEALTH_WARN                                                                                                                          
2024-07-08 17:25:31.094711 | 52540071-6000-6b0f-0e4a-000000000043 |      FATAL | Fail if ceph health is HEALTH_WARN | undercloud -> 192.168.24.44 | error={"changed": false, "msg": "Ceph is in HEALTH_WARN state."}                         
[WARNING]: ('undercloud -> 192.168.24.44',                                                                                                                                                                                                   
'52540071-6000-6b0f-0e4a-000000000043') missing from stats                                                                                                                                                                                   
                                                              







