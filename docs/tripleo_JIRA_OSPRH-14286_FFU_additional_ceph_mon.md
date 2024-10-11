
After ceph upgrade (rolling+adoption) from 4 to 5, ceph was healthy

but when they tried (chapter 8) to upgrade the overcloud, it failed.
#openstack overcloud upgrade run --yes --stack <stack> --debug --limit allovercloud,undercloud --playbook all

why failed?
  due to container id missing when podman inspect happens here (https://github.com/ceph/ceph-ansible/blob/stable-4.0/roles/ceph-container-common/tasks/fetch_image.yml#L3C9-L3C35)
   

during overcloud upgrade, why should we inspect ceph containers ?
  does it run site-container.yml.sample ? 
  may be :site-container.yml.sample -?ceph-container-common  -> fetch_image
  ceph_ansible_command.sh is pointing to site-container.yml.sample and 

why podman inpsect didn't look into the actual container id ( ceph-ce1258aa-8427-4cbe-9884-123d440bf2aa-mon-gs-ltclddc3cn03 )
  may be ceph_mon_container_stat is not showing that., it is generated here
  - name: check for a mon container
    command: "{{ container_binary }} ps -q --filter='name=ceph-mon-{{ ansible_facts['hostname'] }}'"
    register: ceph_mon_container_stat


why containerid missing?
  ceph-mon-gs-ltclddc3cn03 (without FSID) kept restarting and the containerid changes (not sure where it came from)
  whereas we have the actual container ceph-ce1258aa-8427-4cbe-9884-123d440bf2aa-mon-gs-ltclddc3cn03.


how did ceph-mon-gs-ltclddc3cn03 came into picture ?
  no idea, i suspect some 

what we found from ceph-ansible log
  - rolling_update on feb5th
  - adoption (failed duirng placement of rgw hosts) on feb5h
  - re-run adoption (successful) on feb5th
  - site-container.yml.sample on feb 11th (4 times), feb 12th (3 times), feb18th (1 time)
      - everytime it failed with same error 


# solution:

Regarding why additional ceph-mon is created, we suspect that steps were not executed correctly.

After analyzing ceph_ansible_command.log, Here is my observation:

i see that after rolling_update (6.3.3), adoption (6.3.7) is so ceph upgrade using ceph-ansible is complete.
After that, may be the step 6.3.9  (Modify the overcloud_upgrade_prepare.sh file to replace the ceph-ansible file with a cephadm heat environment file:) is not executed before going to step8 ?

When you run step8 (#openstack overcloud upgrade run) , nothing related to ceph should happen but it runs site-container.yml.sample from ceph-ansible indicates that they didn't switch the THT params to cephadm (via the second upgrade prepare in 6.3.9) and ceph-ansible is trying to "deploy" a fresh new cluster.

Looks like this note in step 6.3.9 is overlooked

"Important
Do not include ceph-ansible environment or deployment files, for example, environments/ceph-ansible/ceph-ansible.yaml or deployment/ceph-ansible/ceph-grafana.yaml, in openstack deployment commands such as openstack overcloud upgrade prepare and openstack overcloud deploy. For more information about replacing ceph-ansible environment and deployment files with cephadm files, see Implications of upgrading to Red Hat Ceph Storage 5."



the name ceph-mon-gs-ltclddc3cn03 (without FSID) itself indicates that ceph-ansible is doing something

after adoption, we create ceph-mon contains in this parttern ceph-<FSID>-mon-<hostname>





The problem is precisely in this “additional” mon container, for which it is unclear where it came from and why the upgrade procedure refers to it and breaks down on it.n


rolling_update:

Running /home/stack/overcloud-deploy/d3t/config-download/d3t/ceph-ansible/ceph_ansible_command.sh
2025-02-05 15:01:54,901 p=790874 u=root n=ansible | Using /usr/share/ceph-ansible/ansible.cfg as config file
2025-02-05 15:01:55,777 p=790874 u=root n=ansible | [WARNING]: Could not match supplied host pattern, ignoring: active_mdss
2025-02-05 15:01:55,853 p=790874 u=root n=ansible | [WARNING]: Could not match supplied host pattern, ignoring: standby_mdss
2025-02-05 15:01:56,550 p=790874 u=root n=ansible | PLAY [confirm whether user really meant to upgrade the cluster] ***************



2025-02-05 15:11:41,569 p=790874 u=root n=ansible | TASK [ceph-handler : check for a mon container] ********************************
2025-02-05 15:11:41,569 p=790874 u=root n=ansible | Wednesday 05 February 2025  15:11:41 +0300 (0:00:00.070)       0:09:45.030 ****
2025-02-05 15:11:42,202 p=790874 u=root n=ansible | ok: [gs-ltclddc3cn01] => {"changed": false, "cmd": ["podman", "ps", "-q", "--filter=name=ceph-mon-gs-ltclddc3cn01"], "delta": "0:00:00.256387", "end": "2025-02-05 15:11:42.177829", "failed_when_result": false, "rc": 0, "start": "2025-02-05 15:11:41.921442", "stderr": "", "stderr_lines": [], "stdout": "ef8a0bfcac7b", "stdout_lines": ["ef8a0bfcac7b"]}







adoption (failed):

Running /home/stack/overcloud-deploy/d3t/config-download/d3t/ceph-ansible/ceph_ansible_command.sh
2025-02-05 17:02:37,342 p=238574 u=root n=ansible | Using /usr/share/ceph-ansible/ansible.cfg as config file
2025-02-05 17:02:38,012 p=238574 u=root n=ansible | PLAY [confirm whether user really meant to adopt the cluster by cephadm] *******


2025-02-05 17:04:29,952 p=238574 u=root n=ansible | PLAY [adopt ceph mon daemons] **************************************************
2025-02-05 17:04:29,976 p=238574 u=root n=ansible | TASK [adopt mon daemo




2025-02-05 17:12:02,361 p=238574 u=root n=ansible | TASK [Update the placement of radosgw hosts] ***********************************
2025-02-05 17:12:02,361 p=238574 u=root n=ansible | Wednesday 05 February 2025  17:12:02 +0300 (0:00:00.129)       0:09:24.360 ****
2025-02-05 17:12:02,422 p=238574 u=root n=ansible | fatal: [gs-ltclddc3cn01 -> {{ groups[mon_group_name][0] }}]: FAILED! => {"msg": "The task includes an option with an undefined variable. The error was: the inline if-expression on line 10 evaluated to false and no else section was defined.\n\nThe error appears to be in '/usr/share/ceph-ansible/infrastructure-playbooks/cephadm-adopt.yml': line 1016, column 7, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n\n    - name: Update the placement of radosgw hosts\n      ^ here\n"}
2025-02-05 17:12:02,482 p=238574 u=root n=ansible | fatal: [gs-ltclddc3cn02 -> {{ groups[mon_group_name][0] }}]: FAILED! => {"msg": "The task includes an option with an undefined variable. The error was: the inline if-expression on line 10 evaluated to false and no else section was defined.\n\nThe error appears to be in '/usr/share/ceph-ansible/infrastructure-playbooks/cephadm-adopt.yml': line 1016, column 7, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n\n    - name: Update the placement of radosgw hosts\n      ^ here\n"}
2025-02-05 17:12:02,501 p=238574 u=root n=ansible | fatal: [gs-ltclddc3cn03 -> {{ groups[mon_group_name][0] }}]: FAILED! => {"msg": "The task includes an option with an undefined variable. The error was: the inline if-expression on line 10 evaluated to false and no else section was defined.\n\nThe error appears to be in '/usr/share/ceph-ansible/infrastructure-playbooks/cephadm-adopt.yml': line 1016, column 7, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n\n    - name: Update the placement of radosgw hosts\n      ^ here\n"}





adoptoin re-run:



Running /home/stack/overcloud-deploy/d3t/config-download/d3t/ceph-ansible/ceph_ansible_command.sh
2025-02-05 17:33:54,348 p=364982 u=root n=ansible | Using /usr/share/ceph-ansible/ansible.cfg as config file
2025-02-05 17:33:55,026 p=364982 u=root n=ansible | PLAY [confirm whether user really meant to adopt the cluster by cephadm] *******



2025-02-05 17:44:51,044 p=364982 u=root n=ansible | TASK [inform users about cephadm] **********************************************
2025-02-05 17:44:51,044 p=364982 u=root n=ansible | Wednesday 05 February 2025  17:44:51 +0300 (0:00:05.246)       0:10:56.030 ****
2025-02-05 17:44:51,061 p=364982 u=root n=ansible | ok: [gs-ltclddc3cn01] => {
    "msg": "This Ceph cluster is now managed by cephadm. Any new changes to the\ncluster need to be achieved by using the cephadm CLI and you don't\nneed to use ceph-ansible playbooks anymore.\n"
}
2025-02-05 17:44:51,062 p=364982 u=root n=ansible | PLAY RECAP *********************************************************************
2025-02-05 17:44:51,062 p=364982 u=root n=ansible | gs-ltclddc3cn01            : ok=98   changed=29   unreachable=0    failed=0    skipped=37   rescued=0    ignored=0
2025-02-05 17:44:51,062 p=364982 u=root n=ansible | gs-ltclddc3cn02            : ok=64   changed=27   unreachable=0    failed=0    skipped=32   rescued=0    ignored=0
2025-02-05 17:44:51,062 p=364982 u=root n=ansible | gs-ltclddc3cn03            : ok=64   changed=27   unreachable=0    failed=0    skipped=32   rescued=0    ignored=0
2025-02-05 17:44:51,062 p=364982 u=root n=ansible | gs-ltclddc3ds01            : ok=38   changed=12   unreachable=0    failed=0    skipped=8    rescued=0    ignored=0
2025-02-05 17:44:51,062 p=364982 u=root n=ansible | gs-ltclddc3ds02            : ok=29   changed=8    unreachable=0    failed=0    skipped=8    rescued=0    ignored=0
2025-02-05 17:44:51,062 p=364982 u=root n=ansible | gs-ltclddc3ds03            : ok=29   changed=8    unreachable=0    failed=0    skipped=8    rescued=0    ignored=0
2025-02-05 17:44:51,062 p=364982 u=root n=ansible | localhost                  : ok=1    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
2025-02-05 17:44:51,063 p=364982 u=root n=ansible | Wednesday 05 February 2025  17:44:51 +0300 (0:00:00.018)       0:10:56.048 ****
2025-02-05 17:44:51,063 p=364982 u=root n=ansible | ===============================================================================
2025-02-05 17:44:51,063 p=364982 u=root n=ansible | adopt grafana daemon --------------------------------------------------- 52.53s
2025-02-05 17:44:51,063 p=364982 u=root n=ansible | remove the legacy grafana data ----------------------------------------- 17.76s
2025-02-05 17:44:51,063 p=364982 u=root n=ansible | adopt prometheus daemon ------------------------------------------------ 16.28s
2025-02-05 17:44:51,063 p=364982 u=root n=ansible | adopt osd daemon ------------------------------------------------------- 11.63s
2025-02-05 17:44:51,063 p=364982 u=root n=ansible | copy the client.admin keyring ------------------------------------------ 11.00s
2025-02-05 17:44:51,063 p=364982 u=root n=ansible | gather and delegate facts ---------------------------------------------- 11.00s
2025-02-05 17:44:51,063 p=364982 u=root n=ansible | adopt alertmanager daemon ----------------------------------------------- 7.74s
2025-02-05 17:44:51,063 p=364982 u=root n=ansible | disable pg autoscale on pools ------------------------------------------- 7.45s



many runs of site-container.yml.sample


Running /home/stack/overcloud-deploy/d3t/config-download/d3t/ceph-ansible/ceph_ansible_command.sh
2025-02-12 04:17:31,239 p=576468 u=root n=ansible | Using /usr/share/ceph-ansible/ansible.cfg as config file
2025-02-12 04:17:31,506 p=576468 u=root n=ansible | [WARNING]: Could not match supplied host pattern, ignoring: nfss

2025-02-12 04:17:31,507 p=576468 u=root n=ansible | [WARNING]: Could not match supplied host pattern, ignoring: rbdmirrors

2025-02-12 04:17:31,507 p=576468 u=root n=ansible | [WARNING]: Could not match supplied host pattern, ignoring: iscsigws

2025-02-12 04:17:31,507 p=576468 u=root n=ansible | [WARNING]: Could not match supplied host pattern, ignoring: monitoring

2025-02-12 04:17:32,431 p=576468 u=root n=ansible | PLAY [mons,osds,mdss,rgws,nfss,rbdmirrors,clients,iscsigws,mgrs,monitoring] ****





 in this run,  there are two new ceph-mon-hostname containers created


2025-02-12 04:18:40,795 p=576468 u=root n=ansible | TASK [ceph-handler : check for a mon container] ********************************
2025-02-12 04:18:40,795 p=576468 u=root n=ansible | Wednesday 12 February 2025  04:18:40 +0300 (0:00:00.447)       0:01:08.375 ****
2025-02-12 04:18:40,925 p=576468 u=root n=ansible | skipping: [gs-ltclddc3ds01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:18:40,952 p=576468 u=root n=ansible | skipping: [gs-ltclddc3ds02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:18:40,981 p=576468 u=root n=ansible | skipping: [gs-ltclddc3ds03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:18:41,010 p=576468 u=root n=ansible | skipping: [gs-ltclddc3hv01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:18:41,038 p=576468 u=root n=ansible | skipping: [gs-ltclddc3hv02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:18:41,051 p=576468 u=root n=ansible | skipping: [gs-ltclddc3hv03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:18:41,397 p=576468 u=root n=ansible | ok: [gs-ltclddc3cn01] => {"changed": false, "cmd": ["podman", "ps", "-q", "--filter=name=ceph-mon-gs-ltclddc3cn01"], "delta": "0:00:00.220940", "end": "2025-02-12 04:18:42.516325", "failed_when_result": false, "rc": 0, "start": "2025-02-12 04:18:42.295385", "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
2025-02-12 04:18:41,542 p=576468 u=root n=ansible | ok: [gs-ltclddc3cn03] => {"changed": false, "cmd": ["podman", "ps", "-q", "--filter=name=ceph-mon-gs-ltclddc3cn03"], "delta": "0:00:00.321071", "end": "2025-02-12 04:18:42.662246", "failed_when_result": false, "rc": 0, "start": "2025-02-12 04:18:42.341175", "stderr": "", "stderr_lines": [], "stdout": "31ca9e9b60d0", "stdout_lines": ["31ca9e9b60d0"]}
2025-02-12 04:18:41,551 p=576468 u=root n=ansible | ok: [gs-ltclddc3cn02] => {"changed": false, "cmd": ["podman", "ps", "-q", "--filter=name=ceph-mon-gs-ltclddc3cn02"], "delta": "0:00:00.345336", "end": "2025-02-12 04:18:42.672209", "failed_when_result": false, "rc": 0, "start": "2025-02-12 04:18:42.326873", "stderr": "", "stderr_lines": [], "stdout": "0bfb01e86675", "stdout_lines": ["0bfb01e86675"]}




2025-02-12 04:19:00,398 p=576468 u=root n=ansible | TASK [ceph-container-common : inspect ceph mon container] **********************
2025-02-12 04:19:00,398 p=576468 u=root n=ansible | Wednesday 12 February 2025  04:19:00 +0300 (0:00:00.544)       0:01:27.978 ****
2025-02-12 04:19:00,435 p=576468 u=root n=ansible | skipping: [gs-ltclddc3cn01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:19:00,521 p=576468 u=root n=ansible | skipping: [gs-ltclddc3ds01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:19:00,547 p=576468 u=root n=ansible | skipping: [gs-ltclddc3ds02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:19:00,576 p=576468 u=root n=ansible | skipping: [gs-ltclddc3ds03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:19:00,605 p=576468 u=root n=ansible | skipping: [gs-ltclddc3hv01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:19:00,633 p=576468 u=root n=ansible | skipping: [gs-ltclddc3hv02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:19:00,648 p=576468 u=root n=ansible | skipping: [gs-ltclddc3hv03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 04:19:01,025 p=576468 u=root n=ansible | fatal: [gs-ltclddc3cn02]: FAILED! => {"changed": false, "cmd": ["podman", "inspect", "0bfb01e86675"], "delta": "0:00:00.241809", "end": "2025-02-12 04:19:02.148128", "msg": "non-zero return code", "rc": 125, "start": "2025-02-12 04:19:01.906319", "stderr": "Error: error inspecting object: no such object: \"0bfb01e86675\"", "stderr_lines": ["Error: error inspecting object: no such object: \"0bfb01e86675\""], "stdout": "[]", "stdout_lines": ["[]"]}
2025-02-12 04:19:01,056 p=576468 u=root n=ansible | fatal: [gs-ltclddc3cn03]: FAILED! => {"changed": false, "cmd": ["podman", "inspect", "31ca9e9b60d0"], "delta": "0:00:00.222970", "end": "2025-02-12 04:19:02.178511", "msg": "non-zero return code", "rc": 125, "start": "2025-02-12 04:19:01.955541", "stderr": "Error: error inspecting object: no such object: \"31ca9e9b60d0\"", "stderr_lines": ["Error: error inspecting object: no such object: \"31ca9e9b60d0\""], "stdout": "[]", "stdout_lines": ["[]"]}





--- another instance



2025-02-12 05:11:17,746 p=839163 u=root n=ansible | TASK [ceph-handler : check for a mon container] ********************************
2025-02-12 05:11:17,746 p=839163 u=root n=ansible | Wednesday 12 February 2025  05:11:17 +0300 (0:00:00.428)       0:01:07.741 ****
2025-02-12 05:11:17,872 p=839163 u=root n=ansible | skipping: [gs-ltclddc3ds01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:17,977 p=839163 u=root n=ansible | skipping: [gs-ltclddc3ds02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:18,005 p=839163 u=root n=ansible | skipping: [gs-ltclddc3ds03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:18,033 p=839163 u=root n=ansible | skipping: [gs-ltclddc3hv01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:18,061 p=839163 u=root n=ansible | skipping: [gs-ltclddc3hv02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:18,074 p=839163 u=root n=ansible | skipping: [gs-ltclddc3hv03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:18,427 p=839163 u=root n=ansible | ok: [gs-ltclddc3cn01] => {"changed": false, "cmd": ["podman", "ps", "-q", "--filter=name=ceph-mon-gs-ltclddc3cn01"], "delta": "0:00:00.327981", "end": "2025-02-12 05:11:19.555903", "failed_when_result": false, "rc": 0, "start": "2025-02-12 05:11:19.227922", "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
2025-02-12 05:11:18,451 p=839163 u=root n=ansible | ok: [gs-ltclddc3cn02] => {"changed": false, "cmd": ["podman", "ps", "-q", "--filter=name=ceph-mon-gs-ltclddc3cn02"], "delta": "0:00:00.318890", "end": "2025-02-12 05:11:19.577322", "failed_when_result": false, "rc": 0, "start": "2025-02-12 05:11:19.258432", "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
2025-02-12 05:11:18,505 p=839163 u=root n=ansible | ok: [gs-ltclddc3cn03] => {"changed": false, "cmd": ["podman", "ps", "-q", "--filter=name=ceph-mon-gs-ltclddc3cn03"], "delta": "0:00:00.319957", "end": "2025-02-12 05:11:19.633302", "failed_when_result": false, "rc": 0, "start": "2025-02-12 05:11:19.313345", "stderr": "", "stderr_lines": [], "stdout": "192c940a2373", "stdout_lines": ["192c940a2373"]}


2025-02-12 05:11:36,754 p=839163 u=root n=ansible | TASK [ceph-container-common : inspect ceph mon container] **********************
2025-02-12 05:11:36,754 p=839163 u=root n=ansible | Wednesday 12 February 2025  05:11:36 +0300 (0:00:00.532)       0:01:26.749 ****
2025-02-12 05:11:36,791 p=839163 u=root n=ansible | skipping: [gs-ltclddc3cn01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:36,823 p=839163 u=root n=ansible | skipping: [gs-ltclddc3cn02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:36,876 p=839163 u=root n=ansible | skipping: [gs-ltclddc3ds01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:36,902 p=839163 u=root n=ansible | skipping: [gs-ltclddc3ds02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:36,931 p=839163 u=root n=ansible | skipping: [gs-ltclddc3ds03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:36,961 p=839163 u=root n=ansible | skipping: [gs-ltclddc3hv01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:36,992 p=839163 u=root n=ansible | skipping: [gs-ltclddc3hv02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:37,008 p=839163 u=root n=ansible | skipping: [gs-ltclddc3hv03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-12 05:11:37,445 p=839163 u=root n=ansible | fatal: [gs-ltclddc3cn03]: FAILED! => {"changed": false, "cmd": ["podman", "inspect", "192c940a2373"], "delta": "0:00:00.265443", "end": "2025-02-12 05:11:38.574050", "msg": "non-zero return code", "rc": 125, "start": "2025-02-12 05:11:38.308607", "stderr": "Error: error inspecting object: no such object: \"192c940a2373\"", "stderr_lines": ["Error: error inspecting object: no such object: \"192c940a2373\""], "stdout": "[]", "stdout_lines": ["[]"]}



--on more instace

 
2025-02-18 10:35:04,434 p=719486 u=root n=ansible | TASK [ceph-handler : check for a mon container] ********************************
2025-02-18 10:35:04,435 p=719486 u=root n=ansible | Tuesday 18 February 2025  10:35:04 +0300 (0:00:00.575)       0:01:17.860 ******
2025-02-18 10:35:04,680 p=719486 u=root n=ansible | skipping: [gs-ltclddc3ds01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:04,710 p=719486 u=root n=ansible | skipping: [gs-ltclddc3ds02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:04,748 p=719486 u=root n=ansible | skipping: [gs-ltclddc3ds03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:04,788 p=719486 u=root n=ansible | skipping: [gs-ltclddc3hv01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:04,823 p=719486 u=root n=ansible | skipping: [gs-ltclddc3hv02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:04,842 p=719486 u=root n=ansible | skipping: [gs-ltclddc3hv03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:05,181 p=719486 u=root n=ansible | ok: [gs-ltclddc3cn01] => {"changed": false, "cmd": ["podman", "ps", "-q", "--filter=name=ceph-mon-gs-ltclddc3cn01"], "delta": "0:00:00.355647", "end": "2025-02-18 10:35:05.184113", "failed_when_result": false, "rc": 0, "start": "2025-02-18 10:35:04.828466", "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
2025-02-18 10:35:05,290 p=719486 u=root n=ansible | ok: [gs-ltclddc3cn02] => {"changed": false, "cmd": ["podman", "ps", "-q", "--filter=name=ceph-mon-gs-ltclddc3cn02"], "delta": "0:00:00.336531", "end": "2025-02-18 10:35:05.293020", "failed_when_result": false, "rc": 0, "start": "2025-02-18 10:35:04.956489", "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
2025-02-18 10:35:05,299 p=719486 u=root n=ansible | ok: [gs-ltclddc3cn03] => {"changed": false, "cmd": ["podman", "ps", "-q", "--filter=name=ceph-mon-gs-ltclddc3cn03"], "delta": "0:00:00.320260", "end": "2025-02-18 10:35:05.303219", "failed_when_result": false, "rc": 0, "start": "2025-02-18 10:35:04.982959", "stderr": "", "stderr_lines": [], "stdout": "221af5b8ff4d", "stdout_lines": ["221af5b8ff4d"]}



2025-02-18 10:35:26,632 p=719486 u=root n=ansible | TASK [ceph-container-common : inspect ceph mon container] **********************
2025-02-18 10:35:26,632 p=719486 u=root n=ansible | Tuesday 18 February 2025  10:35:26 +0300 (0:00:00.745)       0:01:40.058 ******
2025-02-18 10:35:26,678 p=719486 u=root n=ansible | skipping: [gs-ltclddc3cn01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:26,720 p=719486 u=root n=ansible | skipping: [gs-ltclddc3cn02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:26,815 p=719486 u=root n=ansible | skipping: [gs-ltclddc3ds01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:26,857 p=719486 u=root n=ansible | skipping: [gs-ltclddc3ds02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:26,892 p=719486 u=root n=ansible | skipping: [gs-ltclddc3ds03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:26,934 p=719486 u=root n=ansible | skipping: [gs-ltclddc3hv01] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:26,935 p=719486 u=root n=ansible | skipping: [gs-ltclddc3hv02] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:26,955 p=719486 u=root n=ansible | skipping: [gs-ltclddc3hv03] => {"changed": false, "skip_reason": "Conditional result was False"}
2025-02-18 10:35:27,307 p=719486 u=root n=ansible | fatal: [gs-ltclddc3cn03]: FAILED! => {"changed": false, "cmd": ["podman", "inspect", "221af5b8ff4d"], "delta": "0:00:00.224551", "end": "2025-02-18 10:35:27.309638", "msg": "non-zero return code", "rc": 125, "start": "2025-02-18 10:35:27.085087", "stderr": "Error: error inspecting object: no such object: \"221af5b8ff4d\"", "stderr_lines": ["Error: error inspecting object: no such object: \"221af5b8ff4d\""], "stdout": "[]











