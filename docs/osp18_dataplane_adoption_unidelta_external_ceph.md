# JIRA: https://issues.redhat.com/browse/OSPRH-17207

ASK :  - deploy external ceph cluster
       - 17.1 deployment configured with external ceph.

hci ?
  - hci has deployed ceph : https://github.com/openstack-k8s-operators/ci-framework/blob/main/hooks/playbooks/adoption_deploy_ceph.yml#L163
      - called by https://github.com/openstack-k8s-operators/data-plane-adoption/blob/main/scenarios/hci.yaml#L72
        when the command #ansible-playbook deploy-osp-adoption.yml -e cifmw_architecture_scenario=hci -e @osp_secrets.yaml -e "cifmw_adoption_source_scenario_path=/home/zuul/data-plane-adoption/scenarios" is run.


unidelta needs external ceph:
  - check cifmw code ?
     hooks has ceph_deploy.yaml (uses make_ceph)
       -  ceph-bm.yml is used on top of openshift
  
  - whats happening with unidelta greenfield job:

  https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/blob/main/zuul.d/integration-pipeline-uni-jobs-base.yaml?ref_type=heads#L258


[mkatari@fedora architecture]$ grep -inr ceph.yml .
./automation/vars/osasinfra.yaml:53:            source: "../../playbooks/ceph.yml"
./automation/vars/uni04delta-ipv6.yaml:54:            source: "../../playbooks/ceph.yml"
./automation/vars/uni04delta.yaml:54:            source: "../../playbooks/ceph.yml"
./automation/vars/hci.yaml:53:            source: "../../playbooks/ceph.yml"
./automation/vars/uni05epsilon.yaml:57:            source: "../../playbooks/ceph.yml"
./examples/dt/uni04delta-ipv6/edpm-pre-ceph.md:55:    Use ci-framework/playbooks/ceph.yml and
./examples/dt/uni04delta/edpm-pre-ceph.md:55:    Use ci-framework/playbooks/ceph.yml and

 looks the greenfield job runs 
   #ansible-playbook playbooks/06-deploy-architecture.yml -e cifmw_architecture_repo=$HOME/architecture \
                  -e cifmw_architecture_scenario=uni04delta-ipv6
  
    where https://github.com/openstack-k8s-operators/architecture/blob/main/automation/vars/uni04delta-ipv6.yaml is doing everything





   logs: https://sf.apps.int.gpc.ocp-hub.prod.psi.redhat.com/logs/dea/components-integration/dea8a483ad32475281d9d29f6c0e627e/logs/controller-0/ci-framework-data/logs/2025-05-30_21-32/ansible-deploy-architecture.log
   2025-05-30 20:13:51,634 p=28029 u=zuul n=ansible | Friday 30 May 2025  20:13:51 +0000 (0:00:00.080)       0:03:07.763 ************ 
2025-05-30 20:13:51,663 p=28029 u=zuul n=ansible | PLAY [EDPM deployment on pre-provisioned VMs] **********************************
2025-05-30 20:13:51,716 p=28029 u=zuul n=ansible | TASK [Early end if architecture deploy _raw_params=end_play] *******************
2025-05-30 20:13:51,716 p=28029 u=zuul n=ansible | Friday 30 May 2025  20:13:51 +0000 (0:00:00.081)       0:03:07.845 ************ 
2025-05-30 20:13:51,747 p=28029 u=zuul n=ansible | PLAY [Deploy an NFS server] ****************************************************
2025-05-30 20:13:51,760 p=28029 u=zuul n=ansible | TASK [Gathering Facts ] ********************************************************
2025-05-30 20:13:51,760 p=28029 u=zuul n=ansible | Friday 30 May 2025  20:13:51 +0000 (0:00:00.043)       0:03:07.889 ************ 
2025-05-30 20:13:53,851 p=28029 u=zuul n=ansible | ok: [compute-nih0r9v5-0]
2025-05-30 20:13:53,869 p=28029 u=zuul n=ansible | TASK [End play early if no NFS is needed _raw_params=end_play] *****************
2025-05-30 20:13:53,869 p=28029 u=zuul n=ansible | Friday 30 May 2025  20:13:53 +0000 (0:00:02.109)       0:03:09.998 ************ 
2025-05-30 20:13:53,888 p=28029 u=zuul n=ansible | PLAY [Clear ceph target hosts facts to force refreshing in HCI deployments] ****
2025-05-30 20:13:53,957 p=28029 u=zuul n=ansible | TASK [Gathering Facts ] ********************************************************
2025-05-30 20:13:53,957 p=28029 u=zuul n=ansible | Friday 30 May 2025  20:13:53 +0000 (0:00:00.088)       0:03:10.087 ************ 
2025-05-30 20:13:55,740 p=28029 u=zuul n=ansible | ok: [ceph-nih0r9v5-2]
2025-05-30 20:13:55,784 p=28029 u=zuul n=ansible | ok: [ceph-nih0r9v5-1]
2025-05-30 20:13:55,924 p=28029 u=zuul n=ansible | ok: [ceph-nih0r9v5-0]
2025-05-30 20:13:55,981 p=28029 u=zuul n=ansible | TASK [Early end if architecture deploy _raw_params=end_play] *******************



    
  - in greenfiled deployment , how is external ceph deployed by cifmw:
     -  we mostly used hci, where ceph.yaml playbook is used to deploy ceph.
     - may be we can use 'deploy ceph on target nodes' with target nodes pointing to new ceph nodes.
        -  https://github.com/openstack-k8s-operators/ci-framework/blob/main/playbooks/06-deploy-edpm.yml#L120

    - cifmw  deploy_arhcitecture for hci is desinged to deploy edpm pre-ceph, ceph and postceph (06-deploy-edpm.yml)
      for non-hci, looks like the same playbooks is executed to deploy ceph and skip hci bits (cifmw_edpm_deploy_hci) ?


Plan:

  - ceph nodes down, can i bringup manually and deploy ceph using ceph.yaml playbook ?
  - tweak deploy-osp-adoption.yaml , deploy ceph and configure ceph in 17.1 ?


doubts:
 - how is the green field deployment run by unigamma vs unidelta dt ? it looks same for me ?
    suppose for hci (unigamma), doesn't it exactly do https://ci-framework.pages.redhat.com/docs/main/ci-framework/deploy_va.html#run-the-deployment ?
    - i see cifmw-jobs calling the dt : https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/blob/main/zuul.d/integration-pipeline-uni-jobs-base.yaml?ref_type=heads#L258
     there is no dt for hci
     
   
  - for unidelts i see this https://github.com/openstack-k8s-operators/architecture/blob/main/examples/dt/uni04delta/README.md
     - edpm pre-ceph ? we do we have to deploy datplane based on ceph when ceph is external ?

  - we perfrom https://ci-framework.pages.redhat.com/docs/main/ci-framework/deploy_va.html#run-the-deployment
    which uses reproducer.yaml 
    only uni* jobs use cifmw_architecture_scenario ? how about the customer ?


# what i did

- copied https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/merge_requests/1864/diffs#2832dfa9134f0a6f408ba0b92ac910114d6903d1 to cifmw/custom

	- all other cifmw patches are merged

- we don't need dataplaneadoption patch for create-infra


we need get rid of the error
msg: 'internal error: Check the host setup: interface enp3s0f0 has kernel autoconfigured                                                                                                                                                  
      IPv6 routes and enabling forwarding without accept_ra set to 2 will cause the kernel                                                                                                                                                    
      to flush them, breaking networking.'
  check
    sudo sysctl -a | grep accept_ra

- echo "net.ipv6.conf.enp3s0f0.accept_ra=2" | sudo tee -a /etc/sysctl.d/99-custom.conf; sudo sysctl --system

- in 02-host-config.yaml

cifmw_libvirt_manager_configuration:
  networks:

    storage: |
      <network>
        <name>storage</name>
        <forward mode='open' stp='on' delay='0'/>
        <bridge name='storage' />
        <ip family='ipv6'
        address='{{ cifmw_networking_definition.networks.storage.network |
                    ansible.utils.nthhost(1) }}'
        prefix='{{ cifmw_networking_definition.networks.storage.network |
                   ansible.utils.ipaddr('prefix') }}'>
        </ip>
      </network>


ceph
        - storage
        - storagemgmt


ansible-playbook  create-infra.yml  -e @custom/01-net-def.yaml  -e @custom/02-host-config.yaml -e @release_vars.yaml -e cifmw_architecture_scenario=uni04delta-ipv6  --flush-cache


# run the ceph playbook

- inventory ?
  chat gpt have me below inventory based on ceph host names

[zuul@shark20 ci-framework]$ cat custom/cephnodes_inventory.yaml
all:
  hosts:
    node1:
      ansible_host: ceph-uni04delta-ipv6-0.localhost
      ansible_user: zuul
    node2:
      ansible_host: ceph-uni04delta-ipv6-1.localhost
      ansible_user: zuul
    node3:
      ansible_host: ceph-uni04delta-ipv6-2.localhost
      ansible_user: zuul
[zuul@shark20 ci-framework]$ ansible all -i custom/cephnodes_inventory.yaml -m ping
node2 | SUCCESS => 
    changed: false
    ping: pong
node1 | SUCCESS => 
    changed: false
    ping: pong
node3 | SUCCESS => 
    changed: false
    ping: pong
[zuul@shark20 ci-framework]$ 


simiplified inventory

[zuul@shark20 ci-framework]$ cat inventory.yml 
localhost ansible_connection=local
[ceph]
2620:cf:cf:aaaa::6a ansible_user=zuul ansible_ssh_private_key_file=/home/zuul/.ssh/cifmw_reproducer_key
2620:cf:cf:aaaa::6b ansible_user=zuul ansible_ssh_private_key_file=/home/zuul/.ssh/cifmw_reproducer_key
2620:cf:cf:aaaa::6c ansible_user=zuul ansible_ssh_private_key_file=/home/zuul/.ssh/cifmw_reproducer_key
[zuul@shark20 ci-framework]$ 


# this is captured from default_vars used by reproducer in greenfield mainly for repo_setup

[zuul@shark20 ci-framework]$ cat /tmp/repo_vars.yaml 
_oso_release: "{{ cifmw_oso_release | default('osp18') }}"
_ceph_version: "{{ cifmw_ceph_release | default('ceph-7.1-rhel-9') }}"
_rhel_version: "{{ cifmw_rhel_version | default('9.4') }}"
_rhoso_version: "{{ cifmw_rhoso_release | default('') }}"
_default_rhos_release_args: "{{ _ceph_version }} {{ _rhoso_version }} -r {{ _rhel_version }}"
cifmw_repo_setup_rhos_release_path: "/home/zuul/rhos-release"
cifmw_repo_setup_rhos_release_rpm: "http://download.devel.redhat.com/rcm-guest/puddles/OpenStack/rhos-release/rhos-release-latest.noarch.rpm"
cifmw_repo_setup_rhos_release_args: "{{ _default_rhos_release_args }}"
cifmw_repo_setup_output: "/etc/yum.repos.d"
cifmw_ceph_target: "ceph"
[zuul@shark20 ci-framework]$


ansible-playbook -i inventory.yml playbooks/ceph_repo_setup.yml -e  @/tmp/repo_vars.yaml



[controller-0]$ cat <<EOF >/tmp/ceph_overrides.yml
---
storage_network_range: "2620:cf:cf:cccc::/64"
storage_mgmt_network_range: "2620:cf:cf:dddd::/64"
cifmw_cephadm_default_container: false
cifmw_cephadm_container_ns: registry-proxy.engineering.redhat.com/rh-osbs
cifmw_cephadm_container_image: rhceph
cifmw_cephadm_container_tag: 7
cifmw_cephadm_ceph_spec_fqdn: false
cifmw_cephadm_haproxy_container_image: "{{ cifmw_cephadm_container_ns }}/haproxy:latest"
cifmw_cephadm_keepalived_container_image: "{{ cifmw_cephadm_container_ns }}/keepalived:latest"
cifmw_cephadm_prometheus_container_ns: registry-proxy.engineering.redhat.com/prometheus
cifmw_cephadm_alertmanager_container_image: "{{ cifmw_cephadm_prometheus_container_ns }}/alertmanager:latest"
cifmw_cephadm_grafana_container_image: "{{ cifmw_cephadm_container_ns }}/grafana:latest"
cifmw_cephadm_node_exporter_container_image: "{{ cifmw_cephadm_prometheus_container_ns }}/node-exporter:latest"
cifmw_cephadm_prometheus_container_image: "{{ cifmw_cephadm_prometheus_container_ns }}/prometheus:latest"
cifmw_ceph_target: "ceph"
EOF


# run the playbook
ANSIBLE_GATHERING=implicit ansible-playbook -vv playbooks/ceph.yml -i ./inventory.yml -e @/tmp/ceph_overrides.yml

- issue1: we need to run repo_setup and install_ca roles 
        and then merge /tmp/repo_vars into /tmp/ceph_overrides 

diff --git a/playbooks/ceph.yml b/playbooks/ceph.yml
index 8bdc4ba8..70e218a3 100644
--- a/playbooks/ceph.yml
+++ b/playbooks/ceph.yml
@@ -115,6 +115,16 @@
           (cifmw_ceph_spec_data_devices is defined and
            cifmw_ceph_spec_data_devices | length > 0)
       ansible.builtin.meta: end_play
+
+    - name: Setup repositories via rhos-release if needed
+      ansible.builtin.import_role:
+        name: repo_setup
+        tasks_from: rhos_release.yml
+
+    - name: Install custom CA if needed
+      ansible.builtin.import_role:
+        name: install_ca
+        
   tasks:
     - name: Set cifmw_num_osds_perhost



- issue2: ipv6 condition should be changed, it should not rely on ipv4  


TASK [Set IPv6 facts ssh_network_range=2620:cf:cf:aaaa::/64, storage_mgmt_network_range=2620:cf:cf:dddd::/64, all_addresses=ansible_all_ipv6_addresses, ms_bind_ipv4=False, ms_bind_ipv6=True] ***********************************************
task path: /home/zuul/ci-framework/playbooks/ceph.yml:183                                                                                                                                                                                     
Wednesday 25 June 2025  17:24:19 +0000 (0:00:00.056)       0:03:06.950 ********                                                                                                                                                               
skipping: [localhost] =>                                                                                                                                                                                                                      
    changed: false                                                                                                                                                                                                                            
    false_condition: ansible_all_ipv4_addresses | length == 0 


     - name: Set IPv6 facts
-      when: ansible_all_ipv4_addresses | length == 0
+      #when: ansible_all_ipv4_addresses | length == 0
+      when: ansible_all_ipv6_addresses | length > 0
       ansible.builtin.set_fact:
         ssh_network_range: "2620:cf:cf:aaaa::/64"
         # storage_network_range: "2620:cf:cf:cccc::/64"
@@ -223,7 +232,7 @@
         - name: Set IPv6 network ranges vars
           when:
             - cifmw_networking_env_definition is defined
-            - ansible_all_ipv4_addresses | length == 0
+            - ansible_all_ipv6_addresses | length > 0
           ansible.builtin.set_fact:
             storage_network_range: >-
               {{
@@ -316,7 +325,8 @@
         cidr: 24
 
     - name: Set IPv6 facts
-      when: ansible_all_ipv4_addresses | length == 0
+      #when: ansible_all_ipv4_addresses | length == 0
+      when: ansible_all_ipv6_addresses | length > 0
       ansible.builtin.set_fact:
         all_addresses: ansible_all_ipv6_addresses
         cidr: 64



- issue3: even with insall_ca, we see this error

      pinging container registry registry-proxy.engineering.redhat.com: Get "https://registry-proxy.engineering.redhat.com/v2/":                                                                                                              
      tls: failed to verify certificate: x509: certificate signed by unknown authority'                                                                                                                                                       
    - ''                                                                                

as cifmw_install_ca_url: "https://certs.corp.redhat.com/certs/Current-IT-Root-CAs.pem" should be set in overrides.


- issue4: failed after apply spec with error

    stderr: 'Error EINVAL: name component must include only a-z, 0-9, and -. Got "2620:cf:cf:aaaa::6a"'

so updated the inventory as

localhost ansible_connection=local
[ceph]
ceph-uni04delta-ipv6-0 ansible_user=zuul ansible_ssh_private_key_file=/home/zuul/.ssh/cifmw_reproducer_key
ceph-uni04delta-ipv6-1 ansible_user=zuul ansible_ssh_private_key_file=/home/zuul/.ssh/cifmw_reproducer_key
ceph-uni04delta-ipv6-2 ansible_user=zuul ansible_ssh_private_key_file=/home/zuul/.ssh/cifmw_reproducer_key
~                                                                                                           

- issu5: if failed with osd not coming

TASK [cifmw_cephadm : Wait for expected number of osds to be running _raw_params={{ cifmw_cephadm_ceph_cli }} status --format json | jq .osdmap.num_up_osds] *** 
FAILED - RETRYING: [ceph-uni04delta-ipv6-0]: Wait for expected number of osds to be running (1 retries left).
fatal: [ceph-uni04delta-ipv6-0]: FAILED! => 

[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ps --daemon-type=osd                                                                                                                                                                       
NAME   HOST                    PORTS  STATUS  REFRESHED  AGE  MEM USE  MEM LIM  VERSION    IMAGE ID                                                                                                                                           
osd.0  ceph-uni04delta-ipv6-1         error      9m ago   7h        -    4096M  <unknown>  <unknown>  
osd.1  ceph-uni04delta-ipv6-0         error      7s ago   7h        -    4096M  <unknown>  <unknown>  
osd.2  ceph-uni04delta-ipv6-2         error      5m ago   7h        -    4096M  <unknown>  <unknown> 

[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ls --service_type osd
NAME                     PORTS  RUNNING  REFRESHED  AGE  PLACEMENT                                                              
osd.default_drive_group               0  7m ago     7h   ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2 

[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch device ls
HOST                    PATH      TYPE  DEVICE ID                        SIZE  AVAILABLE  REFRESHED  REJECT REASONS                                                   
ceph-uni04delta-ipv6-0  /dev/sdb  hdd   QEMU_HARDDISK_1-0000:00:06.7-2   370k  No         11m ago    Has a FileSystem, Insufficient space (<5GB), id_bus, read-only  

then when i looked at the  osd systemd service logs
Jun 25 18:07:33 ceph-uni04delta-ipv6-0 ceph-osd[38858]: bdev(0x55a4db417180 /var/lib/ceph/osd/ceph-1/block) close                                                                                                                             
Jun 25 18:07:33 ceph-uni04delta-ipv6-0 ceph-osd[38858]: bdev(0x55a4db416e00 /var/lib/ceph/osd/ceph-1/block) close                                                                                                                             
Jun 25 18:07:33 ceph-uni04delta-ipv6-0 ceph-osd[38858]: starting osd.1 osd_data /var/lib/ceph/osd/ceph-1 /var/lib/ceph/osd/ceph-1/journal                                                                                                     
Jun 25 18:07:33 ceph-uni04delta-ipv6-0 ceph-osd[38858]: unable to find any IPv6 address in networks '2620:cf:cf:dddd::/64' interfaces ''                                                                                                      
Jun 25 18:07:33 ceph-uni04delta-ipv6-0 ceph-osd[38858]: Failed to pick cluster address.                                                                                                                                                       
Jun 25 18:07:33 ceph-uni04delta-ipv6-0 ceph-e965ee0c-cc80-5c3f-891a-9964f7e3178a-osd-1[38854]: 2025-06-25T18:07:33.855+0000 7fd946c26a40 -1 unable to find any IPv6 address in networks '2620:cf:cf:dddd::/64' interfaces ''                  
Jun 25 18:07:33 ceph-uni04delta-ipv6-0 ceph-e965ee0c-cc80-5c3f-891a-9964f7e3178a-osd-1[38854]: 2025-06-25T18:07:33.855+0000 7fd946c26a40 -1 Failed to pick cluster address.   

it is looking for storagemgmt network, i am going to cleanup, re-run create-infra with storagmgmt netwrok in ceph nodes.




- issue6: after using storagement
msg: 'error creating bridge interface cifmw-storagemgmt: Numerical result out of range'
name is toolong : se we used stormgmt (<15 expected), cifmw-storagemgmt is 17

after fixing the name, it moved ahead  and failed to create logs directory

TASK [cifmw_cephadm : Create ceph-logs directory path={{ cifmw_cephadm_log_path }}, state=directory, mode=0755] ******************************************************************************************************************************
task path: /home/zuul/ci-framework/roles/cifmw_cephadm/tasks/post.yml:34                                                                                                                                                                      
Thursday 26 June 2025  10:52:43 +0000 (0:00:00.042)       0:03:44.553 *********                                                                                                                                                               
fatal: [ceph-uni04delta-ipv6-0 -> localhost]: FAILED! =>                                                                                                                                                                                      
    changed: false                                                                                                                                                                                                                            
    msg: 'There was an issue creating /root/ci-framework-data as requested: [Errno 13]                                                                                                                                                        
      Permission denied: b''/root/ci-framework-data'''                                                                                                                                                                                        
    path: /root/ci-framework-data/logs/ceph        
                                              

updated override vars with :  ansible_user_dir: "/home/zuul"




-- for unielta-ipv6, we should use ganesha tht manila-cephfsganesha-config.yaml instead of manila-cephfsnative-config.yaml

then 17.1 deployment failed wwith 

create an empty rados index object                                                                                                                                                                                                      
    - "\e[0;31m2025-07-17 06:50:45.693165 | 6999f46d-62da-578f-ae8b-00000000ac52 |      FATAL                                                                                                                                                 
      | create an empty rados index object | undercloud -> 2620:00cf:00cf:aaaa:0000:0000:0000:0070                                                                                                                                            
      | error={\"changed\": true, \"cmd\": [\"podman\", \"run\", \"--rm\", \"--net=host\",                                                                                                                                                    
      \"--ipc=host\", \"--volume\", \"/var/lib/tripleo-config/ceph:/etc/ceph:z\", \"--entrypoint\",                                                                                                                                           
      \"rados\", \"registry.redhat.io/rhceph/rhceph-7-rhel9:latest\", \"--fsid\", \"7f8c0b24-7afd-53eb-a443-f5b7da31bb60\",                                                                                                                   
      \"-c\", \"/etc/ceph/ceph.conf\", \"-k\", \"/etc/ceph/ceph.client.manila.keyring\",                               
      \"-n\", \"client.manila\", \"-p\", \"manila_data\", \"--cluster\", \"ceph\", \"put\",                                                                                                                                                   
      \"ganesha-export-index\", \"/dev/null\"], \"delta\": \"0:00:00.256030\", \"end\":                                                                                                                                                       
      \"2025-07-17 06:50:45.646916\", \"msg\": \"non-zero return code\", \"rc\": 1, \"start\":   
      \"2025-07-17 06:50:45.390886\", \"stderr\": \"2025-07-17T06:50:45.550+0000 7fc36bfff640                                                                                                                                                 
      -1 monclient(hunting): handle_auth_bad_method server allowed_methods [2] but i only                                                                                                                                                     
      support [2,1]\\n2025-07-17T06:50:45.552+0000 7fc36b7fe640 -1 monclient(hunting):                                 
      handle_auth_bad_method server allowed_methods [2] but i only support [2,1]\\nfailed         
      to fetch mon config (--no-mon-config to skip)\", \"stderr_lines\": [\"2025-07-17T06:50:45.550+0000           
      7fc36bfff640 -1 monclient(hunting): handle_auth_bad_method server allowed_methods                                                                                                                                                       
      [2] but i only support [2,1]\", \"2025-07-17T06:50:45.552+0000 7fc36b7fe640 -1 monclient(hunting):                                                                                                                                      
      handle_auth_bad_method server allowed_methods [2] but i only support [2,1]\", \"failed                                                                                                                                                  
      to fetch mon config (--no-mon-config to skip)\"], \"stdout\": \"\", \"stdout_lines\": 


we observed that manila key is missing, we we updated the ceph playbook to create the key /etc/ceph/ceph.client.manila.keyring  

@@ -337,6 +341,13 @@
               mon: profile rbd
               osd: "{{ pools | map('regex_replace', '^(.*)$',
                                    'profile rbd pool=\\1') | join(', ') }}"
+          - name: client.manila
+            key: "{{ cephx.key }}"
+            mode: '0600'
+            caps:
+              mgr: allow rw
+              mon: allow r
+              osd: allow rw pool=manila_data
       vars:

we saw the same error again and observed that pools itself is not created

[zuul@ceph-uni04delta-ipv6-0 ~]$ rados --cluster ceph   --conf /etc/ceph/ceph.conf   --keyring /etc/ceph/ceph.client.manila.keyring   -n client.manila   -p manila_data  ls
error opening pool manila_data: (2) No such file or directory

[zuul@ceph-uni04delta-ipv6-0 ~]$ rados --cluster ceph   --conf /etc/ceph/ceph.conf   --keyring /etc/ceph/ceph.client.manila.keyring   -n client.manila  lspools
.mgr
vms
volumes
backups
images
cephfs.cephfs.meta
cephfs.cephfs.data
.rgw.root
default.rgw.log
default.rgw.control
default.rgw.meta


@@ -301,6 +301,10 @@
         target_size_ratio: 0.1
         pg_autoscale_mode: true
         application: cephfs
+      - name: manila_data
+        target_size_ratio: 0.1
+        pg_autoscale_mode: true
+        application: cephfs

this is not creating the pool as  https://github.com/openstack-k8s-operators/ci-framework/blob/main/roles/cifmw_cephadm/tasks/pools.yml#L27 is creating only rbd pools
so commented the when condition, and then the pools are created



[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph osd pool ls
.mgr
vms
volumes
backups
images
cephfs.cephfs.meta
cephfs.cephfs.data
.rgw.root
default.rgw.log
default.rgw.control
default.rgw.meta
manila_data
[ceph: root@ceph-uni04delta-ipv6-0 /]# exit
exit
[zuul@ceph-uni04delta-ipv6-0 ~]$ rados --cluster ceph   --conf /etc/ceph/ceph.conf   --keyring /etc/ceph/ceph.client.manila.keyring   -n client.manila  lspools
.mgr
vms
volumes
backups
images
cephfs.cephfs.meta
cephfs.cephfs.data
.rgw.root
default.rgw.log
default.rgw.control
default.rgw.meta
manila_data


even after created pools, we saw the error and then had a debug session with francesco and understood that the comamnd is run on controller not working but working on ceph node

[zuul@ceph-uni04delta-ipv6-0 ~]$ rados --cluster ceph   --conf /etc/ceph/ceph.conf   --keyring /etc/ceph/ceph.client.manila.keyring   -n client.manila  lspools 


[zuul@osp-controller-uni04delta-ipv6-0 ~]$ sudo rados --cluster ceph   --conf /var/lib/tripleo-config/ceph/ceph.conf  --keyring /var/lib/tripleo-config/ceph/ceph.client.manila.keyring   -n client.manila  ls
2025-07-21T06:25:47.911+0000 7f34b6395640 -1 monclient(hunting): handle_auth_bad_method server allowed_methods [2] but i only support [2,1]
2025-07-21T06:25:47.911+0000 7f34b5b94640 -1 monclient(hunting): handle_auth_bad_method server allowed_methods [2] but i only support [2,1]
failed to fetch mon config (--no-mon-config to skip)


[zuul@osp-controller-uni04delta-ipv6-0 ~]$ sudo rados --cluster ceph   --conf /var/lib/tripleo-config/ceph/ceph.conf  --keyring /var/lib/tripleo-config/ceph/ceph.client.manila.keyring   -n client.manila  lspools
2025-07-21T06:25:27.785+0000 7f4decfb3640 -1 monclient(hunting): handle_auth_bad_method server allowed_methods [2] but i only support [2,1]
2025-07-21T06:25:27.785+0000 7f4ded7b4640 -1 monclient(hunting): handle_auth_bad_method server allowed_methods [2] but i only support [2,1]
failed to fetch mon config (--no-mon-config to skip)
[zuul@osp-controller-uni04delta-ipv6-0 ~]$ 


[zuul@osp-controller-uni04delta-ipv6-0 ~]$ sudo podman run --rm --net=host   --ipc=host   --volume /var/lib/tripleo-config/ceph:/etc/ceph:z   --entrypoint rados   registry.redhat.io/rhceph/rhceph-7-rhel9:latest   --fsid cb91ea42-0a7f-547d-8af9-43faddce1b73   -c /etc/ceph/ceph.conf   -k /etc/ceph/ceph.client.manila.keyring   -n client.manila   -p manila_data   --cluster ceph   put ganesha-export-index /dev/null                                                               
2025-07-21T05:39:44.098+0000 7fc87ffff640 -1 monclient(hunting): handle_auth_bad_method server allowed_methods [2] but i only support [2,1]                                                                                                   
2025-07-21T05:39:44.099+0000 7fc87f7fe640 -1 monclient(hunting): handle_auth_bad_method server allowed_methods [2] but i only support [2,1]                                                                                                   
failed to fetch mon config (--no-mon-config to skip) 



then we realized that key is different in ceph cluster and the one in /var/lib/tripleo-config/ceph/ceph.client.manila.keyring, we modified it and it worked.




-- we ran everything from scratch after cleanup , even then we see only manila keyring in controller is different.


[zuul@osp-controller-uni04delta-ipv6-0 ~]$ sudo podman run --rm --net=host   --ipc=host   --volume /var/lib/tripleo-config/ceph:/etc/ceph:z   --entrypoint rados   registry.redhat.io/rhceph/rhceph-7-rhel9:latest   --fsid cb91ea42-0a7f-547d-8af9-43faddce1b73   -c /etc/ceph/ceph.conf   -k /etc/ceph/ceph.client.manila.keyring   -n client.manila   -p manila_data   --cluster ceph   put ganesha-export-index /dev/null                                                               
2025-07-21T05:39:44.098+0000 7fc87ffff640 -1 monclient(hunting): handle_auth_bad_method server allowed_methods [2] but i only support [2,1]                                                                                                   
2025-07-21T05:39:44.099+0000 7fc87f7fe640 -1 monclient(hunting): handle_auth_bad_method server allowed_methods [2] but i only support [2,1]                                                                                                   
failed to fetch mon config (--no-mon-config to skip) 



[zuul@titan149 ~]$ cat external_ceph_params.yaml 
parameter_defaults:
  CephClusterFSID: 'cb91ea42-0a7f-547d-8af9-43faddce1b73'
  CephClientKey: 'AQD6LnpoAAAAABAAkn7sh3Gq+/eXrqavwSg2sQ=='
  CephExternalMonHost: '2620:cf:cf:cccc::6a, 2620:cf:cf:cccc::6b, 2620:cf:cf:cccc::6c'
[zuul@titan149 ~]$ 



[zuul@osp-controller-uni04delta-ipv6-0 ~]$ sudo cat /var/lib/tripleo-config/ceph/ceph.client.manila.keyring 
[client.manila]
   key = "AQAHOnpoAAAAABAAwcW5+fr/KIR4B0cFsk3I4w=="
   caps mgr = allow rw
   caps mon = allow r
   caps osd = allow rw pool manila_data
[zuul@osp-controller-uni04delta-ipv6-0 ~]$ sudo cat /var/lib/tripleo-config/ceph/ceph.client.openstack.keyring 
[client.openstack]
   key = "AQD6LnpoAAAAABAAkn7sh3Gq+/eXrqavwSg2sQ=="
   caps mgr = allow *
   caps mon = profile rbd
   caps osd = profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups

[zuul@osp-controller-uni04delta-ipv6-0 ~]$ cat /var/lib/tripleo-config/ceph/ceph.conf
# Ansible managed
[global]
fsid = cb91ea42-0a7f-547d-8af9-43faddce1b73
mon host = 2620:cf:cf:cccc::6a, 2620:cf:cf:cccc::6b, 2620:cf:cf:cccc::6c

[client.libvirt]
admin socket = /var/run/ceph/$cluster-$type.$id.$pid.$cctid.asok
log file = /var/log/ceph/qemu-guest-$pid.log


- we see

[zuul@undercloud cephadm]$ pwd
/home/zuul/config-download/overcloud/cephadm
[zuul@undercloud cephadm]$ vi cephadm-extra-vars-ansible.yml

tripleo_cephadm_keys: [{'name': 'client.openstack', 'key': 'AQD6LnpoAAAAABAAkn7sh3Gq+/eXrqavwSg2sQ==', 'mode': '0600', 'caps': {'mgr': 'allow *', 'mon': 'profile rbd', 'osd': 'profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups'}}, {'name': 'client.manila', 'key': 'AQAHOnpoAAAAABAAwcW5+fr/KIR4B0cFsk3I4w==', 'mode': '0600', 'caps': {'mgr': 'allow rw', 'mon': 'allow r', 'osd': 'allow rw pool manila_data'}}]

tripleo_cephadm_keys has the wrong key


- we understood that we have another pare CephManilaClientKey 
 https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/deployment/cephadm/ceph-base.yaml#L189
https://github.com/openstack-archive/tripleo-heat-templates/blob/stable/wallaby/deployment/cephadm/ceph-base.yaml#L631

        manila:
                    name: {get_param: ManilaCephFSCephFSAuthId}
                    key: {get_param: CephManilaClientKey}

- 17.1 deployment is succesful and we see nfs (packemaker based) ganesha deployed 


[zuul@osp-controller-uni04delta-ipv6-0 ~]$ sudo podman ps | grep -i ceph
f0cf5fcca99c  registry.redhat.io/rhceph/rhceph-7-rhel9:latest                           -c rpcbind && rpc...  15 hours ago  Up 15 hours                          ceph-nfs-pacemaker
[zuul@osp-controller-uni04delta-ipv6-0 ~]$ 


# rgw ingress issue

but we observed that ingress deamon (with ceph ) was deployed by cifmw, but in tripleo we should have haproxy saperately deployed as pacemaker service 

[zuul@ceph-uni04delta-ipv6-0 ~]$ sudo cephadm shell -- ceph orch ls
Inferring fsid 08e33555-cc69-5712-9f2a-b71327bfbbb0
Inferring config /var/lib/ceph/08e33555-cc69-5712-9f2a-b71327bfbbb0/mon.ceph-uni04delta-ipv6-0/config
Using ceph image with id '40ce20dd902d' and tag '7' created on 2025-07-18 00:22:34 +0000 UTC
registry-proxy.engineering.redhat.com/rh-osbs/rhceph@sha256:96e47f347d4b9ee32e6a6a658dac941c5ce984cc4641dfc3859eecd237c4fb24
NAME                     PORTS                         RUNNING  REFRESHED  AGE  PLACEMENT                                                             
crash                                                      3/3  8m ago     16h  *                                                                     
ingress.rgw.default      2620:cf:cf:cccc::2:8080,8999      3/4  8m ago     16h  count:2                                                               
mds.cephfs                                                 3/3  8m ago     16h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
mgr                                                        3/3  8m ago     16h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
mon                                                        3/3  8m ago     16h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
node-proxy                                                 0/0  -          16h  *                                                                     
osd.default_drive_group                                      3  8m ago     16h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
rgw.rgw                  ?:8082                            3/3  8m ago     16h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
[zuul@ceph-uni04delta-ipv6-0 ~]$


2c89f15a85cc  registry-proxy.engineering.redhat.com/rh-osbs/keepalived:latest  ./init.sh             18 hours ago  Up 18 hours              ceph-b139b042-8917-5897-8060-79b63fc5d236-keepalived-rgw-default-ceph-uni04delta-ipv6-0-vgagpv
594d11f4473c  registry-proxy.engineering.redhat.com/rh-osbs/rhceph:7           -n client.rgw.rgw...  18 hours ago  Up 18 hours              ceph-b139b042-8917-5897-8060-79b63fc5d236-rgw-rgw-ceph-uni04delta-ipv6-0-lucogh
dcf1e45b0258  registry-proxy.engineering.redhat.com/rh-osbs/haproxy:latest     haproxy -f /var/l...  18 hours ago  Up 18 hours              ceph-b139b042-8917-5897-8060-79b63fc5d236-haproxy-rgw-default-ceph-uni04delta-ipv6-0-qwxddv


we need to get rid of ingress,
 - eithre do ceph orch rm 
 - use a variable in //github.com/openstack-k8s-operators/ci-framework/blob/main/roles/cifmw_cephadm/templates/ceph_rgw.yml.j2#L21 to skip the spec creation
   {% if _hosts|length > 1 and cifmw_rgw_ingress %}
     where cifmw_rgw_ingress: true by default and override in our case in ceph_overrides

so we should add in datplaneadoption scenarios/unideltaipv6.yaml 

and follow this doc: https://docs.redhat.com/en/documentation/red_hat_openstack_platform/16.2/html-single/integrating_an_overcloud_with_an_existing_red_hat_ceph_storage_cluster/index#proc-adding-an-additional-environment-file-for-external-ceph-object-gateway-rgw-for-object-storage_integrate-with-existing-cs-cluster

 "/usr/share/openstack-tripleo-heat-templates/environments/swift-external.yaml"
      - "/home/zuul/swift_external_params.yaml


[zuul@osp-undercloud-uni04delta-ipv6-0 ~]$ cat swift_external_params.yaml 
parameter_defaults:
   ExternalSwiftPublicUrl: 'http://2620:cf:cf:cccc:132:8080/swift/v1/AUTH_%(project_id)s'
   ExternalSwiftInternalUrl: 'http://2620:cf:cf:cccc:132:8080/swift/v1/AUTH_%(project_id)s'
   ExternalSwiftAdminUrl: 'http://2620:cf:cf:cccc:132:8080/swift/v1/AUTH_%(project_id)s'
   ExternalSwiftUserTenant: 'service'


why 2620:cf:cf:cccc:132 ? i tried to capture it form haproxy.cfg from previous 17.1 
but we set this before 17.1 where haproxy.cfg doesn't exist, so we can just to stack updte ?
or can we go with same ip, as  predictable IP addresses are used.

listen swift_proxy_server
  bind 2620:cf:cf:cccc::132:8080 transparent
  bind 2620:cf:cf:cf02::1aa:8080 transparent
  mode http
  balance leastconn
  http-request set-header X-Forwarded-Proto https if { ssl_fc }
  http-request set-header X-Forwarded-Proto http if !{ ssl_fc }
  http-request set-header X-Forwarded-Port %[dst_port]
  option httpchk GET /healthcheck
  option httplog
  option forwardfor
  timeout client 2m
  timeout server 2m
  server osp-controller-uni04delta-ipv6-0.storage.example.com 2620:00cf:00cf:cccc:0000:0000:0000:0070:8080 check fall 5 inter 2000 rise 2
  server osp-controller-uni04delta-ipv6-1.storage.example.com 2620:00cf:00cf:cccc:0000:0000:0000:0071:8080 check fall 5 inter 2000 rise 2
  server osp-controller-uni04delta-ipv6-2.storage.example.com 2620:00cf:00cf:cccc:0000:0000:0000:0072:8080 check fall 5 inter 2000 rise 2


but we anyways get rid of haproxy and create ingress daemon explicitly , so we thought moving ahead like this

ingress spec is created here: https://github.com/openstack-k8s-operators/ci-framework/blob/main/roles/cifmw_cephadm/templates/ceph_rgw.yml.j2#L21

[zuul@ceph-uni04delta-ipv6-0 ~]$ sudo cephadm shell -- ceph orch ps
Inferring fsid a20afb38-bfa5-5c83-b983-ed114372baf0
Inferring config /var/lib/ceph/a20afb38-bfa5-5c83-b983-ed114372baf0/mon.ceph-uni04delta-ipv6-0/config
Using ceph image with id '3d4068943e59' and tag '7' created on 2025-07-22 04:48:21 +0000 UTC
registry-proxy.engineering.redhat.com/rh-osbs/rhceph@sha256:0a33f89fd3dd3c91bada072d4a293be3ecaeb08b1408e0e74870de14b4640b94
NAME                                                  HOST                    PORTS                     STATUS        REFRESHED  AGE  MEM USE  MEM LIM  VERSION           IMAGE ID      CONTAINER ID  
crash.ceph-uni04delta-ipv6-0                          ceph-uni04delta-ipv6-0                            running (6m)    57s ago   6m    6899k        -  18.2.1-340.el9cp  3d4068943e59  220c37988bb8  
crash.ceph-uni04delta-ipv6-1                          ceph-uni04delta-ipv6-1                            running (5m)    58s ago   5m    6903k        -  18.2.1-340.el9cp  3d4068943e59  f3702bffad50  
crash.ceph-uni04delta-ipv6-2                          ceph-uni04delta-ipv6-2                            running (4m)    57s ago   4m    6895k        -  18.2.1-340.el9cp  3d4068943e59  614ba4f0021e  
haproxy.rgw.default.ceph-uni04delta-ipv6-0.keaqma     ceph-uni04delta-ipv6-0  *:8080,8999               running (3m)    57s ago   3m    9177k        -  2.4.22-f8e3218    f31d111a14b0  4f34fccc560f  
haproxy.rgw.default.ceph-uni04delta-ipv6-2.siixic     ceph-uni04delta-ipv6-2  *:8080,8999               error           57s ago   3m        -        -  <unknown>         <unknown>     <unknown>     
keepalived.rgw.default.ceph-uni04delta-ipv6-0.tqkggc  ceph-uni04delta-ipv6-0                            running (3m)    57s ago   3m    1837k        -  2.2.8             fe88742546e4  add9d82b26c6  
keepalived.rgw.default.ceph-uni04delta-ipv6-2.awtyxq  ceph-uni04delta-ipv6-2                            running (3m)    57s ago   3m    1832k        -  2.2.8             fe88742546e4  22bc425eb24b  
mds.cephfs.ceph-uni04delta-ipv6-0.suqgpd              ceph-uni04delta-ipv6-0                            running (4m)    57s ago   4m    16.5M        -  18.2.1-340.el9cp  3d4068943e59  2e0c79e7a455  
mds.cephfs.ceph-uni04delta-ipv6-1.dvbmeb              ceph-uni04delta-ipv6-1                            running (4m)    58s ago   4m    13.6M        -  18.2.1-340.el9cp  3d4068943e59  1e4667cec823  
mds.cephfs.ceph-uni04delta-ipv6-2.hapwwo              ceph-uni04delta-ipv6-2                            running (4m)    57s ago   4m    18.4M        -  18.2.1-340.el9cp  3d4068943e59  84b03bc7dca0  
mgr.ceph-uni04delta-ipv6-0.ampclq                     ceph-uni04delta-ipv6-0  *:9283,8765               running (7m)    57s ago   7m     494M        -  18.2.1-340.el9cp  3d4068943e59  1377d25094bb  
mgr.ceph-uni04delta-ipv6-1.tmpnwe                     ceph-uni04delta-ipv6-1  *:8765                    running (4m)    58s ago   4m     446M        -  18.2.1-340.el9cp  3d4068943e59  74e1089d3e12  
mgr.ceph-uni04delta-ipv6-2.xhkxcp                     ceph-uni04delta-ipv6-2  *:8765                    running (4m)    57s ago   4m     444M        -  18.2.1-340.el9cp  3d4068943e59  72cbf915236c  
mon.ceph-uni04delta-ipv6-0                            ceph-uni04delta-ipv6-0                            running (7m)    57s ago   7m    46.8M    2048M  18.2.1-340.el9cp  3d4068943e59  32fc70e99d26  
mon.ceph-uni04delta-ipv6-1                            ceph-uni04delta-ipv6-1                            running (4m)    58s ago   4m    40.5M    2048M  18.2.1-340.el9cp  3d4068943e59  69deac151560  
mon.ceph-uni04delta-ipv6-2                            ceph-uni04delta-ipv6-2                            running (4m)    57s ago   4m    41.3M    2048M  18.2.1-340.el9cp  3d4068943e59  eb552520fb28  
osd.0                                                 ceph-uni04delta-ipv6-0                            running (5m)    57s ago   5m    79.6M    4992M  18.2.1-340.el9cp  3d4068943e59  7e1dd9721b0c  
osd.1                                                 ceph-uni04delta-ipv6-1                            running (5m)    58s ago   5m    83.0M    9.87G  18.2.1-340.el9cp  3d4068943e59  2362f877a915  
osd.2                                                 ceph-uni04delta-ipv6-2                            running (4m)    57s ago   4m    74.0M    4992M  18.2.1-340.el9cp  3d4068943e59  26439448c107  
rgw.rgw.ceph-uni04delta-ipv6-0.ptmvqk                 ceph-uni04delta-ipv6-0  2620:cf:cf:cccc::6a:8082  running (4m)    57s ago   4m    79.3M        -  18.2.1-340.el9cp  3d4068943e59  14d7fbaeb60e  
rgw.rgw.ceph-uni04delta-ipv6-1.afgefc                 ceph-uni04delta-ipv6-1  2620:cf:cf:cccc::6b:8082  running (4m)    58s ago   4m    78.2M        -  18.2.1-340.el9cp  3d4068943e59  e2aadc7799aa  
rgw.rgw.ceph-uni04delta-ipv6-2.egwnhj                 ceph-uni04delta-ipv6-2  2620:cf:cf:cccc::6c:8082  running (4m)    57s ago   4m    79.5M        -  18.2.1-340.el9cp  3d4068943e59  17eb7dfb9a46  

[zuul@ceph-uni04delta-ipv6-0 ~]$ sudo cephadm shell -- ceph orch ls
Inferring fsid a20afb38-bfa5-5c83-b983-ed114372baf0
Inferring config /var/lib/ceph/a20afb38-bfa5-5c83-b983-ed114372baf0/mon.ceph-uni04delta-ipv6-0/config
Using ceph image with id '3d4068943e59' and tag '7' created on 2025-07-22 04:48:21 +0000 UTC
registry-proxy.engineering.redhat.com/rh-osbs/rhceph@sha256:0a33f89fd3dd3c91bada072d4a293be3ecaeb08b1408e0e74870de14b4640b94
NAME                     PORTS                         RUNNING  REFRESHED  AGE  PLACEMENT                                                             
crash                                                      3/3  92s ago    7m   *                                                                     
ingress.rgw.default      2620:cf:cf:cccc::2:8080,8999      3/4  91s ago    4m   count:2                                                               
mds.cephfs                                                 3/3  92s ago    4m   ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
mgr                                                        3/3  92s ago    6m   ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
mon                                                        3/3  92s ago    6m   ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
node-proxy                                                 0/0  -          6m   *                                                                     
osd.default_drive_group                                      3  92s ago    6m   ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
rgw.rgw                  ?:8082                            3/3  92s ago    4m   ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
[zuul@ceph-uni04delta-ipv6-0 ~]$ 



some time later (may be after 17.1 deployment ? not sure), i see first rgw dameon using the ingress vip

[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ps
NAME                                                  HOST                    PORTS                     STATUS          REFRESHED   AGE  MEM USE  MEM LIM  VERSION           IMAGE ID      CONTAINER ID  
crash.ceph-uni04delta-ipv6-0                          ceph-uni04delta-ipv6-0                            running (2h)      18s ago    2h    6899k        -  18.2.1-340.el9cp  3d4068943e59  220c37988bb8  
crash.ceph-uni04delta-ipv6-1                          ceph-uni04delta-ipv6-1                            running (2h)       4m ago    2h    6903k        -  18.2.1-340.el9cp  3d4068943e59  f3702bffad50  
crash.ceph-uni04delta-ipv6-2                          ceph-uni04delta-ipv6-2                            running (2h)      18s ago    2h    6895k        -  18.2.1-340.el9cp  3d4068943e59  614ba4f0021e  
haproxy.rgw.default.ceph-uni04delta-ipv6-0.keaqma     ceph-uni04delta-ipv6-0  *:8080,8999               running (104m)    18s ago    2h    11.4M        -  2.4.22-f8e3218    f31d111a14b0  ebed427a3121  
haproxy.rgw.default.ceph-uni04delta-ipv6-2.siixic     ceph-uni04delta-ipv6-2  *:8080,8999               error             18s ago    2h        -        -  <unknown>         <unknown>     <unknown>     
keepalived.rgw.default.ceph-uni04delta-ipv6-0.tqkggc  ceph-uni04delta-ipv6-0                            running (2h)      18s ago    2h    1837k        -  2.2.8             fe88742546e4  add9d82b26c6  
keepalived.rgw.default.ceph-uni04delta-ipv6-2.awtyxq  ceph-uni04delta-ipv6-2                            running (2h)      18s ago    2h    1832k        -  2.2.8             fe88742546e4  22bc425eb24b  
mds.cephfs.ceph-uni04delta-ipv6-0.suqgpd              ceph-uni04delta-ipv6-0                            running (2h)      18s ago    2h    27.0M        -  18.2.1-340.el9cp  3d4068943e59  2e0c79e7a455  
mds.cephfs.ceph-uni04delta-ipv6-1.dvbmeb              ceph-uni04delta-ipv6-1                            running (2h)       4m ago    2h    23.7M        -  18.2.1-340.el9cp  3d4068943e59  1e4667cec823  
mds.cephfs.ceph-uni04delta-ipv6-2.hapwwo              ceph-uni04delta-ipv6-2                            running (2h)      18s ago    2h    28.8M        -  18.2.1-340.el9cp  3d4068943e59  84b03bc7dca0  
mgr.ceph-uni04delta-ipv6-0.ampclq                     ceph-uni04delta-ipv6-0  *:9283,8765               running (2h)      18s ago    2h     518M        -  18.2.1-340.el9cp  3d4068943e59  1377d25094bb  
mgr.ceph-uni04delta-ipv6-1.tmpnwe                     ceph-uni04delta-ipv6-1  *:8765                    running (2h)       4m ago    2h     454M        -  18.2.1-340.el9cp  3d4068943e59  74e1089d3e12  
mgr.ceph-uni04delta-ipv6-2.xhkxcp                     ceph-uni04delta-ipv6-2  *:8765                    running (2h)      18s ago    2h     453M        -  18.2.1-340.el9cp  3d4068943e59  72cbf915236c  
mon.ceph-uni04delta-ipv6-0                            ceph-uni04delta-ipv6-0                            running (2h)      18s ago    2h     158M    2048M  18.2.1-340.el9cp  3d4068943e59  32fc70e99d26  
mon.ceph-uni04delta-ipv6-1                            ceph-uni04delta-ipv6-1                            running (2h)       4m ago    2h     150M    2048M  18.2.1-340.el9cp  3d4068943e59  69deac151560  
mon.ceph-uni04delta-ipv6-2                            ceph-uni04delta-ipv6-2                            running (2h)      18s ago    2h     154M    2048M  18.2.1-340.el9cp  3d4068943e59  eb552520fb28  
osd.0                                                 ceph-uni04delta-ipv6-0                            running (2h)      18s ago    2h    92.5M    4096M  18.2.1-340.el9cp  3d4068943e59  7e1dd9721b0c  
osd.1                                                 ceph-uni04delta-ipv6-1                            running (2h)       4m ago    2h    96.9M    4096M  18.2.1-340.el9cp  3d4068943e59  2362f877a915  
osd.2                                                 ceph-uni04delta-ipv6-2                            running (2h)      18s ago    2h    86.9M    4096M  18.2.1-340.el9cp  3d4068943e59  26439448c107  
rgw.rgw.ceph-uni04delta-ipv6-0.kseqpr                 ceph-uni04delta-ipv6-0  2620:cf:cf:cccc::2:8082   running (104m)    18s ago  104m     105M        -  18.2.1-340.el9cp  3d4068943e59  39fed32b1cd2  
rgw.rgw.ceph-uni04delta-ipv6-1.afgefc                 ceph-uni04delta-ipv6-1  2620:cf:cf:cccc::6b:8082  running (2h)       4m ago    2h     104M        -  18.2.1-340.el9cp  3d4068943e59  e2aadc7799aa  
rgw.rgw.ceph-uni04delta-ipv6-2.egwnhj                 ceph-uni04delta-ipv6-2  2620:cf:cf:cccc::6c:8082  running (2h)      18s ago    2h     105M        -  18.2.1-340.el9cp  3d4068943e59  17eb7dfb9a46  








# debug rgw issue after ganesha


Aug 11 10:20:18 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-rgw-default-ceph-uni04delta-ipv6-0-buapwn[2775301]: [NOTICE]   (2) : haproxy version is 2.4.22-f8e3218
Aug 11 10:20:18 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-rgw-default-ceph-uni04delta-ipv6-0-buapwn[2775301]: [NOTICE]   (2) : path to executable is /usr/sbin/haproxy
Aug 11 10:20:18 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-rgw-default-ceph-uni04delta-ipv6-0-buapwn[2775301]: [ALERT]    (2) : Starting frontend stats: cannot bind socket (Cannot assign requested address) [2
620:cf:cf:cccc::2:8999]
Aug 11 10:20:18 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-rgw-default-ceph-uni04delta-ipv6-0-buapwn[2775301]: [ALERT]    (2) : Starting frontend frontend: cannot bind socket (Cannot assign requested address)
 [2620:cf:cf:cccc::2:8080]
Aug 11 10:20:18 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-rgw-default-ceph-uni04delta-ipv6-0-buapwn[2775301]: [ALERT]    (2) : [haproxy.main()] Some protocols failed to start their listeners! Exiting.


why it is tyring to use ::2 where as vip is set to ::4
Note: also something went wrong with ceph multiple redploys as :4 is used as ingress vip in orch ls and :2 is used on the one of the rgw dameons

but it is fixed with
ceph orch redeploy ingress.rgw.default

more details below:

TASK [print vip msg={{ cifmw_cephadm_vip }}] *************************************************************************************************************************************************************************************************
Tuesday 12 August 2025  07:18:26 +0000 (0:00:00.069)       0:00:31.571 ********
ok: [ceph-uni04delta-ipv6-0] =>
    msg: 2620:cf:cf:cccc::4


service_type: ingress
service_id: rgw.default
service_name: ingress.rgw.default
placement:
  count: 2
spec:
  backend_service: rgw.rgw
  first_virtual_router_id: 50
  frontend_port: 8080
  monitor_port: 8999
  virtual_interface_networks:
  - 2620:cf:cf:cccc::/64
  virtual_ip: 2620:cf:cf:cccc::4/64


[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ls
NAME                     PORTS                         RUNNING  REFRESHED  AGE  PLACEMENT                                                              
crash                                                      3/3  5m ago     3d   *
ingress.nfs.cephfs       2620:cf:cf:cccc::9:2049,9049      6/6  5m ago     14h  label:nfs
ingress.rgw.default      2620:cf:cf:cccc::4:8080,8999      3/4  5m ago     14h  count:2
mds.cephfs                                                 3/3  5m ago     23h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2
mgr                                                        3/3  5m ago     23h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2
mon                                                        3/3  5m ago     23h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2
nfs.cephfs               ?:12049                           3/3  5m ago     14h  label:nfs
node-proxy                                                 0/0  -          3d   *
osd.default_drive_group                                      3  5m ago     23h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2
rgw.rgw                  ?:8082                            3/3  5m ago     23h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2


[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ps                                                                    
NAME                                                  HOST                    PORTS                     STATUS         REFRESHED  AGE  MEM USE  MEM LIM  VERSION           IMAGE ID      CONTAINER ID                                         
crash.ceph-uni04delta-ipv6-0                          ceph-uni04delta-ipv6-0                            running (3d)      2m ago   3d    6899k        -  18.2.1-340.el9cp  0fdba70d843f  f6df6480b5e6                                         
crash.ceph-uni04delta-ipv6-1                          ceph-uni04delta-ipv6-1                            running (3d)      2m ago   3d    6899k        -  18.2.1-340.el9cp  0fdba70d843f  1967d3c42397                                         
crash.ceph-uni04delta-ipv6-2                          ceph-uni04delta-ipv6-2                            running (3d)      2m ago   3d    6895k        -  18.2.1-340.el9cp  0fdba70d843f  c7c0ce4237e5                                         
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-0.fkapgr      ceph-uni04delta-ipv6-0  *:2049,9049               running (14h)     2m ago  14h    20.2M        -  2.4.22-f8e3218    0d7803e184cb  85fcad3f09c7                                         
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-1.oedabi      ceph-uni04delta-ipv6-1  *:2049,9049               running (14h)     2m ago  14h    11.8M        -  2.4.22-f8e3218    78aea9a8ef82  feaa75114261                                         
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-2.elhhie      ceph-uni04delta-ipv6-2  *:2049,9049               running (14h)     2m ago  14h    9945k        -  2.4.22-f8e3218    0d7803e184cb  c41356f853ba  
haproxy.rgw.default.ceph-uni04delta-ipv6-0.buapwn     ceph-uni04delta-ipv6-0  *:8080,8999               error             2m ago   3d        -        -  <unknown>         <unknown>     <unknown>                                            
haproxy.rgw.default.ceph-uni04delta-ipv6-2.noenzd     ceph-uni04delta-ipv6-2  *:8080,8999               running (3d)      2m ago   3d    17.1M        -  2.4.22-f8e3218    0d7803e184cb  e3c8df0d57d6                                         
keepalived.nfs.cephfs.ceph-uni04delta-ipv6-0.akoeuz   ceph-uni04delta-ipv6-0                            running (14h)     2m ago  14h    1832k        -  2.2.8             169ed9896e5a  5ab592e35dd0  
keepalived.nfs.cephfs.ceph-uni04delta-ipv6-1.cjpfiq   ceph-uni04delta-ipv6-1                            running (14h)     2m ago  14h    1837k        -  2.2.8             a9af58a30668  3ce7952cbc7a                                         
keepalived.nfs.cephfs.ceph-uni04delta-ipv6-2.nxjlpw   ceph-uni04delta-ipv6-2                            running (14h)     2m ago  14h    1824k        -  2.2.8             169ed9896e5a  b6c851f2d305  
keepalived.rgw.default.ceph-uni04delta-ipv6-0.qtbehj  ceph-uni04delta-ipv6-0                            running (3d)      2m ago   3d    1824k        -  2.2.8             169ed9896e5a  3a5ac2cf73fa  
keepalived.rgw.default.ceph-uni04delta-ipv6-2.prvyyx  ceph-uni04delta-ipv6-2                            running (3d)      2m ago   3d    1832k        -  2.2.8             169ed9896e5a  3bd4aace668d                                         
mon.ceph-uni04delta-ipv6-2                            ceph-uni04delta-ipv6-2                            running (3d)      2m ago   3d     444M    2048M  18.2.1-340.el9cp  0fdba70d843f  577fa5015c7f  
nfs.cephfs.0.0.ceph-uni04delta-ipv6-1.epbrkv          ceph-uni04delta-ipv6-1  *:12049                   running (14h)     2m ago  14h    74.9M        -  5.7               0fdba70d843f  82c8b94c08a4  
nfs.cephfs.1.0.ceph-uni04delta-ipv6-2.mvikpe          ceph-uni04delta-ipv6-2  *:12049                   running (14h)     2m ago  14h    77.4M        -  5.7               0fdba70d843f  d8c3b93b1f5c                                         nfs.cephfs.2.0.ceph-uni04delta-ipv6-0.jobpcu          ceph-uni04delta-ipv6-0  *:12049                   running (14h)     2m ago  14h    76.8M        -  5.7               0fdba70d843f  2d6cf5adb259                                         
osd.0                                                 ceph-uni04delta-ipv6-1                            running (3d)      2m ago   3d     321M    4096M  18.2.1-340.el9cp  0fdba70d843f  976bd58d223c  
osd.1                                                 ceph-uni04delta-ipv6-0                            running (3d)      2m ago   3d     345M    4096M  18.2.1-340.el9cp  0fdba70d843f  44139b8b0684                                         
osd.2                                                 ceph-uni04delta-ipv6-2                            running (3d)      2m ago   3d     283M    4096M  18.2.1-340.el9cp  0fdba70d843f  45e8c75b074b  
rgw.rgw.ceph-uni04delta-ipv6-0.qwycon                 ceph-uni04delta-ipv6-0  2620:cf:cf:cccc::6a:8082  running (3d)      2m ago   3d     121M        -  18.2.1-340.el9cp  0fdba70d843f  1e15e6998595  
rgw.rgw.ceph-uni04delta-ipv6-1.eyqgrd                 ceph-uni04delta-ipv6-1  2620:cf:cf:cccc::6b:8082  running (3d)      2m ago   3d     121M        -  18.2.1-340.el9cp  0fdba70d843f  cff522bbe505  
rgw.rgw.ceph-uni04delta-ipv6-2.gxegzy                 ceph-uni04delta-ipv6-2  2620:cf:cf:cccc::2:8082   running (3d)      2m ago   3d     121M        -  18.2.1-340.el9cp  0fdba70d843f  c5c8368c5894


Note: also something went wrong with ceph multiple redploys as :4 is used as ingress vip in orch ls and :2 is used on the one of the rgw dameons
                                                                                                                                                                                                                                              
[zuul@ceph-uni04delta-ipv6-0 ~]$ ip a  | grep cccc                                                                                                                                                                                            
    inet6 2620:cf:cf:cccc::9/64 scope global nodad   --> vip created in storage network for nfs ganesha                                                                                                                                       
    inet6 2620:cf:cf:cccc::6a/64 scope global                                                                                                                                                                                                 
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              
[zuul@ceph-uni04delta-ipv6-2 ~]$ ip a | grep cccc                                                                                                                                                                                             
    inet6 2620:cf:cf:cccc::2/64 scope global nodad                                                                                                                                                                                            
    inet6 2620:cf:cf:cccc::6c/64 scope global                                                                                                                                                                                                 
[zuul@ceph-uni04delta-ipv6-2 ~]$ 



# before adoption (ganesha adoption):

nfs-ganesha https://logserver.rdoproject.org/aa2/rdoproject.org/aa28bcaf0ba849b481959ed1a5a33987/docs_build/docs_build/adoption-user/index-downstream.html#creating-a-ceph-nfs-cluster_ceph-prerequisites

as discussed with franceso, we need to run https://github.com/openstack-k8s-operators/data-plane-adoption/blob/main/tests/playbooks/test_tripleo_adoption_requirements.yaml playbook
after building the required ceph_overrides

what is missing:
 - undercloud inventory
 - ceph inventory is not part of ^, need to append what we have already
 - cephadm tool on controller
 - ceph overrides required to run playbook : ansible-playbook -i tripleo-ansible-inventory.yaml build_ceph_overrides_unideltaipv6.yaml
 - #ansible-playbook -i ~/tripleo-ansible-inventory.yaml -e @/home/zuul/rdo-jobs/playbooks/data_plane_adoption/ceph_overrides.yaml  playbooks/test_tripleo_adoption_requirements.yaml --skip-tags ceph_firewall


the doc is updated with the steps 


[zuul@shark19 ~]$ ssh osp-controller-0 cat /etc/ganesha/ganesha.conf | grep Bind_Addr
Warning: Permanently added 'osp-controller-uni04delta-ipv6-0.utility' (ED25519) to the list of known hosts.
       Bind_Addr=2620:cf:cf:cf02::17f;

and use the same vip in 
ansible-playbook -i tripleo-ansible-inventory.yaml -i ceph_nodes_inventory.yaml -e "nfs_vip=2620:cf:cf:cf02::17f" build_ceph_overrides_unideltaipv6.yaml


[ceph: root@ceph-uni04delta-ipv6-2 /]# ceph orch ps | grep nfs
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-0.qedizz      ceph-uni04delta-ipv6-0  *:2049,9049               error           44s ago   2h        -        -  <unknown>         <unknown>     <unknown>     
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-1.zfxdxu      ceph-uni04delta-ipv6-1  *:2049,9049               error           44s ago   2h        -        -  <unknown>         <unknown>     <unknown>     
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-2.bmywja      ceph-uni04delta-ipv6-2  *:2049,9049               error           44s ago   2h        -        -  <unknown>         <unknown>     <unknown>     
nfs.cephfs.0.0.ceph-uni04delta-ipv6-1.qosbrq          ceph-uni04delta-ipv6-1  *:12049                   running (2h)    44s ago   2h    75.2M        -  5.7               0fdba70d843f  a4641127d320  
nfs.cephfs.1.0.ceph-uni04delta-ipv6-2.yhhjru          ceph-uni04delta-ipv6-2  *:12049                   running (2h)    44s ago   2h    76.4M        -  5.7               0fdba70d843f  8fddc61dbd31  
nfs.cephfs.2.0.ceph-uni04delta-ipv6-0.tkngkj          ceph-uni04delta-ipv6-0  *:12049                   running (2h)    44s ago   2h    74.0M        -  5.7               0fdba70d843f  a0640dd38617  



[ceph: root@ceph-uni04delta-ipv6-2 /]# ceph orch ls           
NAME                     PORTS                           RUNNING  REFRESHED  AGE  PLACEMENT                                                             
crash                                                        3/3  7m ago     2d   *                                                                     
ingress.nfs.cephfs       2620:cf:cf:cf02::16a:2049,9049      0/6  7m ago     2h   label:nfs                                                             
ingress.rgw.default      2620:cf:cf:cccc::4:8080,8999        3/4  7m ago     8h   count:2                                                               
mds.cephfs                                                   3/3  7m ago     8h   ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
mgr                                                          3/3  7m ago     8h   ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
mon                                                          3/3  7m ago     8h   ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
nfs.cephfs               ?:12049                             3/3  7m ago     2h   label:nfs                                                             
node-proxy                                                   0/0  -          2d   *                                                                     
osd.default_drive_group                                        3  7m ago     8h   ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
rgw.rgw                  ?:8082                              3/3  7m ago     8h   ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
[ceph: root@ceph-uni04delta-ipv6-2 /]#

no hapoxy container seen

systtemctl log on haproxy.service shows

Aug 11 12:54:58 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-nfs-cephfs-ceph-uni04delta-ipv6-0-qedizz[2884747]: [NOTICE]   (2) : haproxy version is 2.4.22-f8e3218
Aug 11 12:54:58 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-nfs-cephfs-ceph-uni04delta-ipv6-0-qedizz[2884747]: [NOTICE]   (2) : path to executable is /usr/sbin/haproxy
Aug 11 12:54:58 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-nfs-cephfs-ceph-uni04delta-ipv6-0-qedizz[2884747]: [ALERT]    (2) : Starting frontend stats: cannot bind socket (Cannot assign requested address) [26
20:cf:cf:cf02::16a:9049]
Aug 11 12:54:58 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-nfs-cephfs-ceph-uni04delta-ipv6-0-qedizz[2884747]: [ALERT]    (2) : Starting frontend frontend: cannot bind socket (Cannot assign requested address)
[2620:cf:cf:cf02::16a:2049]
Aug 11 12:54:58 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-nfs-cephfs-ceph-uni04delta-ipv6-0-qedizz[2884747]: [ALERT]    (2) : [haproxy.main()] Some protocols failed to start their listeners! Exiting.


then /fp suggested to a different ip and set ipv6 bind below

[zuul@ceph-uni04delta-ipv6-0 ~]$ cat /proc/sys/net/ipv6/ip_nonlocal_bind
0

sudo sysctl -w net.ipv6.ip_nonlocal_bind=1


[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ps | grep nfs
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-0.rgchfj      ceph-uni04delta-ipv6-0  *:2049,9049               running (108s)    92s ago  108s    8702k        -  2.4.22-f8e3218    0d7803e184cb  ac200cc1b0c1  
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-1.pldjah      ceph-uni04delta-ipv6-1  *:2049,9049               running (110s)    93s ago  110s    6601k        -  2.4.22-f8e3218    78aea9a8ef82  0cb285a8f6b1  
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-2.dxseem      ceph-uni04delta-ipv6-2  *:2049,9049               running (105s)    92s ago  104s    10.5M        -  2.4.22-f8e3218    0d7803e184cb  f79d2bb099fd  
nfs.cephfs.0.0.ceph-uni04delta-ipv6-1.battyc          ceph-uni04delta-ipv6-1  *:12049                   running (2m)      93s ago    2m    50.6M        -  5.7               0fdba70d843f  cfba7b9ce7db  
nfs.cephfs.1.0.ceph-uni04delta-ipv6-2.oasvwd          ceph-uni04delta-ipv6-2  *:12049                   running (117s)    92s ago  117s    50.4M        -  5.7               0fdba70d843f  95558145e4ba  
nfs.cephfs.2.0.ceph-uni04delta-ipv6-0.snprru          ceph-uni04delta-ipv6-0  *:12049                   running (113s)    92s ago  113s    52.2M        -  5.7               0fdba70d843f  a826c3063708  
[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ls | grep nfs
ingress.nfs.cephfs       2620:cf:cf:cf02::16b:2049,9049      3/6  114s ago   2m   label:nfs                                                             
nfs.cephfs               ?:12049                             3/3  114s ago   2m   label:nfs


it worked but keepalived is missing

[zuul@ceph-uni04delta-ipv6-0 ~]$ sudo podman ps -a | grep keep
3a5ac2cf73fa  registry-proxy.engineering.redhat.com/rh-osbs/keepalived:latest  ./init.sh             2 days ago     Up 2 days                 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-keepalived-rgw-default-ceph-uni04delta-ipv6-0-qtbehj
[zuul@ceph-uni04delta-ipv6-0 ~]$ sudo systemctl list-units | grep keep
  ceph-96303f71-564d-5cea-a699-a191d6e0ab1a@keepalived.rgw.default.ceph-uni04delta-ipv6-0.qtbehj.service           loaded active running   Ceph keepalived.rgw.default.ceph-uni04delta-ipv6-0.qtbehj for 96303f71-564d-5cea-a699-a191d6e0ab1a
[zuul@ceph-uni04delta-ipv6-0 ~]$


enable cephadm debug and watch the logs:
ceph config set mgr mgr/cephadm/log_to_cluster_level debug
ceph -W cephadm --watch-debug




2025-08-11T15:45:16.427954+0000 mgr.ceph-uni04delta-ipv6-0.uoohds [ERR] Failed to apply ingress.nfs.cephfs spec IngressSpec.from_json(yaml.safe_load('''service_type: ingress                                                                 
service_id: nfs.cephfs                                                                                                                                                                                                                        
service_name: ingress.nfs.cephfs                                                                                                                                                                                                              
placement:                                                                                                                                                                                                                                    
  label: nfs                                                                                                           
spec:                                                                                                                  
  backend_service: nfs.cephfs                                                                                          
  enable_haproxy_protocol: true                                                                                        
  first_virtual_router_id: 50                                                                                          
  frontend_port: 2049                                                                                                                                                                                                                         
  monitor_port: 9049                                                                                                   
  virtual_ip: 2620:cf:cf:cf02::16b                                                                                                                                                                                                            
''')): list index out of range                                                                                         
Traceback (most recent call last):                                                                                     
  File "/usr/share/ceph/mgr/cephadm/serve.py", line 588, in _apply_all_services                                        
    if self._apply_service(spec):                                                                                                                                                                                                             
  File "/usr/share/ceph/mgr/cephadm/serve.py", line 929, in _apply_service                                             
    daemon_spec = svc.prepare_create(daemon_spec)                                                                                                                                                                                             
  File "/usr/share/ceph/mgr/cephadm/services/ingress.py", line 48, in prepare_create                                   
    return self.keepalived_prepare_create(daemon_spec)                                                                 
  File "/usr/share/ceph/mgr/cephadm/services/ingress.py", line 219, in keepalived_prepare_create                       
    daemon_spec.final_config, daemon_spec.deps = self.keepalived_generate_config(daemon_spec)                          
  File "/usr/share/ceph/mgr/cephadm/services/ingress.py", line 332, in keepalived_generate_config                      
    interface, ip = _get_valid_interface_and_ip(vip, host)                                                                                                                                                                                    
  File "/usr/share/ceph/mgr/cephadm/services/ingress.py", line 263, in _get_valid_interface_and_ip                     
    host_ip = ifaces[interface][0]                                                                                                                                                                                                            
IndexError: list index out of range                                                                                                                                                                                                           
2025-08-11T15:45:16.428237+0000 mgr.ceph-uni04delta-ipv6-0.uoohds [DBG] Applying service ingress.rgw.default spec                                                                                                                             
2025-08-11T15:45:16.428471+0000 mgr.ceph-uni04delta-ipv6-0.uoohds [DBG] Found related daemons [<DaemonDescription>(rgw.rgw.ceph-uni04delta-ipv6-0.qwycon), <DaemonDescription>(rgw.rgw.ceph-uni04delta-ipv6-1.eyqgrd), <DaemonDescription>(rgw.rgw.ceph-uni04delta-ipv6-2.gxegzy)] for service ingress.rgw.default  



checking the ingress spec:

[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ls ingress --export
service_type: ingress
service_id: nfs.cephfs
service_name: ingress.nfs.cephfs
placement:
  label: nfs
spec:
  backend_service: nfs.cephfs
  enable_haproxy_protocol: true
  first_virtual_router_id: 50
  frontend_port: 2049
  monitor_port: 9049
  virtual_ip: 2620:cf:cf:cf02::16b
---
service_type: ingress
service_id: rgw.default
service_name: ingress.rgw.default
placement:
  count: 2
spec:
  backend_service: rgw.rgw
  first_virtual_router_id: 50
  frontend_port: 8080
  monitor_port: 8999
  virtual_interface_networks:
  - 2620:cf:cf:cccc::/64
  virtual_ip: 2620:cf:cf:cccc::4/64


updated spec to use virtual_ip: 2620:cf:cf:cf02::16b/64 but didnt help

then i used storage network and ran the playbook again

cd ~/data-plane-adoption/tests
ansible-playbook -i ~/combined_inventory.yaml -e @/home/zuul/rdo-jobs/playbooks/data_plane_adoption/ceph_overrides.yaml  playbooks/test_tripleo_adoption_requirements.yaml --skip-tags ceph_firewall



[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ls | grep nfs
ingress.nfs.cephfs       2620:cf:cf:cccc::9:2049,9049      6/6  17s ago    78s  label:nfs                                                             
nfs.cephfs               ?:12049                           3/3  17s ago    78s  label:nfs                                                             
[ceph: root@ceph-uni04delta-ipv6-0 /]# 


[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ps | grep nfs
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-0.fkapgr      ceph-uni04delta-ipv6-0  *:2049,9049               running (33s)     9s ago  33s    19.2M        -  2.4.22-f8e3218    0d7803e184cb  85fcad3f09c7  
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-1.oedabi      ceph-uni04delta-ipv6-1  *:2049,9049               running (34s)     9s ago  34s    6673k        -  2.4.22-f8e3218    78aea9a8ef82  feaa75114261  
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-2.elhhie      ceph-uni04delta-ipv6-2  *:2049,9049               running (29s)     9s ago  29s    9005k        -  2.4.22-f8e3218    0d7803e184cb  c41356f853ba  
keepalived.nfs.cephfs.ceph-uni04delta-ipv6-0.akoeuz   ceph-uni04delta-ipv6-0                            running (26s)     9s ago  26s    1832k        -  2.2.8             169ed9896e5a  5ab592e35dd0  
keepalived.nfs.cephfs.ceph-uni04delta-ipv6-1.cjpfiq   ceph-uni04delta-ipv6-1                            running (11s)     9s ago  11s    1837k        -  2.2.8             a9af58a30668  3ce7952cbc7a  
keepalived.nfs.cephfs.ceph-uni04delta-ipv6-2.nxjlpw   ceph-uni04delta-ipv6-2                            running (27s)     9s ago  27s    1824k        -  2.2.8             169ed9896e5a  b6c851f2d305  
nfs.cephfs.0.0.ceph-uni04delta-ipv6-1.epbrkv          ceph-uni04delta-ipv6-1  *:12049                   running (47s)     9s ago  47s    50.3M        -  5.7               0fdba70d843f  82c8b94c08a4  
nfs.cephfs.1.0.ceph-uni04delta-ipv6-2.mvikpe          ceph-uni04delta-ipv6-2  *:12049                   running (42s)     9s ago  41s    60.0M        -  5.7               0fdba70d843f  d8c3b93b1f5c  
nfs.cephfs.2.0.ceph-uni04delta-ipv6-0.jobpcu          ceph-uni04delta-ipv6-0  *:12049                   running (37s)     9s ago  37s    50.3M        -  5.7               0fdba70d843f  2d6cf5adb259



# the main part : adoption:


Things to address:


https://github.com/openstack-k8s-operators/data-plane-adoption/blob/main/tests/roles/ceph_backend_configuration/tasks/main.yaml


[zuul@titan149 data-plane-adoption]$ git diff tests/roles/ceph_backend_configuration/tasks/main.yaml
diff --git a/tests/roles/ceph_backend_configuration/tasks/main.yaml b/tests/roles/ceph_backend_configuration/tasks/main.yaml
index 27fb05d..eb7560e 100644
--- a/tests/roles/ceph_backend_configuration/tasks/main.yaml
+++ b/tests/roles/ceph_backend_configuration/tasks/main.yaml
@@ -2,7 +2,7 @@
   no_log: "{{ use_no_log }}"
   ansible.builtin.set_fact:
     ceph_backend_configuration_shell_vars: |
-      CEPH_SSH="{{ controller1_ssh }}"
+      CEPH_SSH="{{ ceph1_ssh }}"
       CEPH_KEY=$($CEPH_SSH "cat /etc/ceph/ceph.client.openstack.keyring | base64 -w 0")
       CEPH_CONF=$($CEPH_SSH "cat /etc/ceph/ceph.conf | base64 -w 0")
 
@@ -11,7 +11,7 @@
   ansible.builtin.shell: |
     {{ shell_header }}
     {{ oc_header }}
-    CEPH_SSH="{{ controller1_ssh }}"
+    CEPH_SSH="{{ ceph1_ssh }}"
     CEPH_CAPS="mgr 'allow *' mon 'allow r, profile rbd' osd 'profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups, allow rw pool manila_data'"
     OSP_KEYRING="client.openstack"
     CEPH_ADM=$($CEPH_SSH "cephadm shell -- ceph auth caps $OSP_KEYRING $CEPH_CAPS")
[zuul@titan149 data-plane-adoption]$


# after adoption configre swift to use rgw
