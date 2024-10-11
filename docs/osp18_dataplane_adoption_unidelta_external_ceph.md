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

