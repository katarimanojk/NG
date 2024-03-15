# 6-7

main steps
 1. cephadm rpm update on controller : target cephadm 18.x.x
    customer documenation: subscriptions are needed, i couldnt do it
    rhos-release tool using francesco's document: https://docs.google.com/document/d/14R9bVuz-jpdkVqLACAyXYQozHZJ3vsS4igntfv59Ht8/edit
 2. prepare container image : 7 image in undercloud registry
 3. start upgade on controller-0 : sudo cephadm shell -- ceph orch upgrade start --image <image_name>: <version>
 4. track the upgrade, ensure it is completed
 5. check all the containers are moved to 7
 6. only nfs-ganesha continer should be upgraded separetly by updating systemd file and pcs restart.


***NOTE: orch upgrade 5-6 or 6-7 ,
- pulls image from undercloud to controller node for mon, mgr services , and then 
- pulls it to ceph nodes for crash, osd
- and then mds and rgw on controller node
 - and then montiroing stack on controller+ceph nodes

(undercloud) [stack@undercloud-0 ~]$ cat enable_rhcs7.yml
- hosts: all
  gather_facts: false
  tasks:
    - name: Enable RHCS 7 tools repo
      become: true
      block:
        - name: Install rhos-release package
          ansible.builtin.dnf:
            name: 'http://download.devel.redhat.com/rcm-guest/puddles/OpenStack/rhos-release/rhos-release-latest.noarch.rpm'
            state: present
        - name: Enable RHCS 7 tools repo
          ansible.builtin.shell: |
            rhos-release ceph-7.0-rhel-9; sed -i -e 's/enabled=1/enabled=1\nsslverify=0/g' $(ls /etc/yum.repos.d/*)
        - name: Update cephadm
          ansible.builtin.package:
            name: cephadm
            state: latest
          become: true
(undercloud) [stack@undercloud-0 ~]$ 



(undercloud) [stack@undercloud-0 ~]$ ansible-playbook -vv -i ~/overcloud-deploy/overcloud/tripleo-ansible-inventory.yaml ~/enable_rhcs7.yml --limit ControllerStorageNfs


PLAYBOOK: enable_rhcs7.yml ********************************************************************************************
1 plays in /home/stack/enable_rhcs7.yml

PLAY [all] ************************************************************************************************************

TASK [Install rhos-release package] ***********************************************************************************
task path: /home/stack/enable_rhcs7.yml:7
ok: [controller-0] => {"ansible_facts": {"discovered_interpreter_python": "/usr/bin/python3"}, "changed": false, "msg": "Nothing to do", "rc": 0, "results": ["Installed /home/tripleo-admin/.ansible/tmp/ansible-tmp-1717758416.3732607-306627-263401541718645/rhos-release-latest.noarchhlf95k25.rpm"]}
ok: [controller-2] => {"ansible_facts": {"discovered_interpreter_python": "/usr/bin/python3"}, "changed": false, "msg": "Nothing to do", "rc": 0, "results": ["Installed /home/tripleo-admin/.ansible/tmp/ansible-tmp-1717758416.8284655-306630-226311651212665/rhos-release-latest.noarchay5m2ekr.rpm"]}
ok: [controller-1] => {"ansible_facts": {"discovered_interpreter_python": "/usr/bin/python3"}, "changed": false, "msg": "Nothing to do", "rc": 0, "results": ["Installed /home/tripleo-admin/.ansible/tmp/ansible-tmp-1717758416.782361-306628-110355627604109/rhos-release-latest.noarchzpp_knbm.rpm"]}

TASK [Enable RHCS 7 tools repo] ***************************************************************************************
task path: /home/stack/enable_rhcs7.yml:11
changed: [controller-1] => {"changed": true, "cmd": "rhos-release ceph-7.0-rhel-9; sed -i -e 's/enabled=1/enabled=1\\nsslverify=0/g' $(ls /etc/yum.repos.d/*)\n", "delta": "0:00:01.562706", "end": "2024-06-07 11:07:01.017869", "msg": "", "rc": 0, "start": "2024-06-07 11:06:59.455163", "stderr": "", "stderr_lines": [], "stdout": "Installing dnf-utils...\nInstalled: /etc/yum.repos.d/rhos-release-ceph-7.0-rhel-9.repo", "stdout_lines": ["Installing dnf-utils...", "Installed: /etc/yum.repos.d/rhos-release-ceph-7.0-rhel-9.repo"]}
changed: [controller-2] => {"changed": true, "cmd": "rhos-release ceph-7.0-rhel-9; sed -i -e 's/enabled=1/enabled=1\\nsslverify=0/g' $(ls /etc/yum.repos.d/*)\n", "delta": "0:00:01.572588", "end": "2024-06-07 11:07:01.032678", "msg": "", "rc": 0, "start": "2024-06-07 11:06:59.460090", "stderr": "", "stderr_lines": [], "stdout": "Installing dnf-utils...\nInstalled: /etc/yum.repos.d/rhos-release-ceph-7.0-rhel-9.repo", "stdout_lines": ["Installing dnf-utils...", "Installed: /etc/yum.repos.d/rhos-release-ceph-7.0-rhel-9.repo"]}
changed: [controller-0] => {"changed": true, "cmd": "rhos-release ceph-7.0-rhel-9; sed -i -e 's/enabled=1/enabled=1\\nsslverify=0/g' $(ls /etc/yum.repos.d/*)\n", "delta": "0:00:01.559605", "end": "2024-06-07 11:07:01.034760", "msg": "", "rc": 0, "start": "2024-06-07 11:06:59.475155", "stderr": "", "stderr_lines": [], "stdout": "Installing dnf-utils...\nInstalled: /etc/yum.repos.d/rhos-release-ceph-7.0-rhel-9.repo", "stdout_lines": ["Installing dnf-utils...", "Installed: /etc/yum.repos.d/rhos-release-ceph-7.0-rhel-9.repo"]}

TASK [Update cephadm] *************************************************************************************************
task path: /home/stack/enable_rhcs7.yml:14
changed: [controller-2] => {"changed": true, "msg": "", "rc": 0, "results": ["Installed: cephadm-2:18.2.0-192.el9cp.noarch", "Removed: cephadm-2:17.2.6-216.el9cp.noarch"]}                                                                  
changed: [controller-0] => {"changed": true, "msg": "", "rc": 0, "results": ["Installed: cephadm-2:18.2.0-192.el9cp.noarch", "Removed: cephadm-2:17.2.6-216.el9cp.noarch"]}                                                                  
changed: [controller-1] => {"changed": true, "msg": "", "rc": 0, "results": ["Installed: cephadm-2:18.2.0-192.el9cp.noarch", "Removed: cephadm-2:17.2.6-216.el9cp.noarch"]}                                                                  

PLAY RECAP ************************************************************************************************************
controller-0               : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
controller-1               : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
controller-2               : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0






[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph orch upgrade start --image undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id 'ceae6c596672' and tag '6' created on 2024-04-16 20:00:03 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:0e8fcaf340946dd2881027da80d977066726f5f2bdd454c2b61bcb8ce5aba58b
Initiating upgrade to undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7
[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph orch upgrade status
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id 'ceae6c596672' and tag '6' created on 2024-04-16 20:00:03 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:0e8fcaf340946dd2881027da80d977066726f5f2bdd454c2b61bcb8ce5aba58b
{
    "target_image": "undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7",
    "in_progress": true,
    "which": "Upgrading all daemon types on all hosts",
    "services_complete": [],
    "progress": "",
    "message": "Doing first pull of undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7 image",
    "is_paused": false
}
[tripleo-admin@controller-0 ~]


[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph orch upgrade status
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id 'ceae6c596672' and tag '6' created on 2024-04-16 20:00:03 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:0e8fcaf340946dd2881027da80d977066726f5f2bdd454c2b61bcb8ce5aba58b
{
    "target_image": "undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7",
    "in_progress": true,
    "which": "Upgrading all daemon types on all hosts",
    "services_complete": [],
    "progress": "",
    "message": "Currently upgrading mgr daemons",
    "is_paused": false
}
[tripleo-admin@controller-0 ~]$ 




[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph status
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '5412073bd769' and tag '7' created on 2024-05-31 19:37:19 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:3d75ca419b9ef00cf2c944680737e84e6e1059e0f33156bc21d4dbf76a7da5b1
  cluster:
    id:     e14864ba-e171-552d-864a-db189e445ef5
    health: HEALTH_WARN
            noout,noscrub,nodeep-scrub flag(s) set
 
  services:
    mon: 3 daemons, quorum controller-0,controller-1,controller-2 (age 32s)
    mgr: controller-0.kxazet(active, since 81s), standbys: controller-1.auuiew, controller-2.ipoxll
    mds: 1/1 daemons up, 2 standby
    osd: 15 osds: 15 up (since 4d), 15 in (since 10d)
         flags noout,noscrub,nodeep-scrub
    rgw: 3 daemons active (3 hosts, 1 zones)
 
  data:
    volumes: 1/1 healthy
    pools:   11 pools, 321 pgs
    objects: 254 objects, 467 KiB
    usage:   2.3 GiB used, 478 GiB / 480 GiB avail
    pgs:     321 active+clean
 
  progress:
    Upgrade to 18.2.1-194.el9cp (22s)
      [==..........................] (remaining: 3m)


 
[tripleo-admin@controller-0 ~]$ sudo podman ps | grep -i ceph
e1eac1f12d50  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n client.crash.c...  4 days ago          Up 4 days                           ceph-e14864ba-e171-552d-864a-db189e445ef5-crash-controller-0
3ba2c9b3f593  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n mds.mds.contro...  4 days ago          Up 4 days                           ceph-e14864ba-e171-552d-864a-db189e445ef5-mds-mds-controller-0-dlqvyc
c71943e0d253  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n client.rgw.rgw...  4 days ago          Up 4 days                           ceph-e14864ba-e171-552d-864a-db189e445ef5-rgw-rgw-controller-0-rvqzyt
5b01d5ba31ac  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -c rpcbind && rpc...  3 days ago          Up 3 days                           ceph-nfs-pacemaker
bc49bd23af79  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.12                  --no-collector.ti...  3 minutes ago       Up 3 minutes                        ceph-e14864ba-e171-552d-864a-db189e445ef5-node-exporter-controller-0
0f197ce2f6ee  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.12                   --cluster.listen-...  3 minutes ago       Up 3 minutes                        ceph-e14864ba-e171-552d-864a-db189e445ef5-alertmanager-controller-0
1eed48b18a25  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                                                      3 minutes ago       Up 3 minutes                        ceph-e14864ba-e171-552d-864a-db189e445ef5-grafana-controller-0
217bfbc21954  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n mgr.controller...  2 minutes ago       Up 2 minutes                        ceph-e14864ba-e171-552d-864a-db189e445ef5-mgr-controller-0-kxazet
1d49d7ea9d83  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.12                                --config.file=/et...  2 minutes ago       Up 2 minutes                        ceph-e14864ba-e171-552d-864a-db189e445ef5-prometheus-controller-0
f79694a25ffa  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n mon.controller...  About a minute ago  Up About a minute                   ceph-e14864ba-e171-552d-864a-db189e445ef5-mon-controller-0
[tripleo-admin@controller-0 ~]$ 


--- it failed like this

[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph orch upgrade status
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '5412073bd769' and tag '7' created on 2024-05-31 19:37:19 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:3d75ca419b9ef00cf2c944680737e84e6e1059e0f33156bc21d4dbf76a7da5b1
{
    "target_image": "undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7",
    "in_progress": true,
    "which": "Upgrading all daemon types on all hosts",
    "services_complete": [
        "mgr",
        "mon"
    ],
    "progress": "6/48 daemons upgraded",
    "message": "Error: UPGRADE_FAILED_PULL: Upgrade: failed to pull target image",
    "is_paused": true
}
[tripleo-admin@controller-0 ~]$ 


2024-06-11T05:26:53.875378+0000 mgr.controller-0.kxazet [INF] Upgrade: First pull of undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7
2024-06-11T05:26:53.876347+0000 mgr.controller-0.kxazet [DBG] _run_cephadm : command = inspect-image
2024-06-11T05:26:53.876458+0000 mgr.controller-0.kxazet [DBG] _run_cephadm : args = []
2024-06-11T05:26:53.876602+0000 mgr.controller-0.kxazet [DBG] args: --image undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7 --timeout 895 inspect-image
2024-06-11T05:26:53.876738+0000 mgr.controller-0.kxazet [DBG] Running command: sudo which python3
2024-06-11T05:26:54.041048+0000 mgr.controller-0.kxazet [DBG] Running command: sudo /bin/python3 /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/cephadm.7abfde288599583cb2aa3637be9473aff385ca0f20175317016701e3c11901e7 --image undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7 --timeout 895 inspect-image

OSError: [Errno 28] No space left on device


RuntimeError: Failed command: /bin/podman inspect --format {{.ID}},{{.RepoDigests}} undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7: Error: inspecting object: no such object: "undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7"

2024-06-11T05:26:56.088998+0000 mgr.controller-0.kxazet [INF] Upgrade: Pulling undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7 on cephstorage-0

2024-06-11T05:26:56.089615+0000 mgr.controller-0.kxazet [DBG] _run_cephadm : command = pull
2024-06-11T05:26:56.089676+0000 mgr.controller-0.kxazet [DBG] _run_cephadm : args = []
2024-06-11T05:26:56.089797+0000 mgr.controller-0.kxazet [DBG] args: --image undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7 --timeout 895 pull
2024-06-11T05:26:56.089909+0000 mgr.controller-0.kxazet [DBG] Running command: sudo which python3
2024-06-11T05:26:56.238920+0000 mgr.controller-0.kxazet [DBG] Running command: sudo /bin/python3 /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/cephadm.7abfde288599583cb2aa3637be9473aff385ca0f20175317016701e3c11901e7 --image undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7 --timeout 895 pull
2024-06-11T05:27:16.863257+0000 mgr.controller-0.kxazet [DBG] code: 1
2024-06-11T05:27:16.863416+0000 mgr.controller-0.kxazet [DBG] err: Pulling container image undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7...
Non-zero exit code 125 from /bin/podman pull undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7
/bin/podman: stderr Trying to pull undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7...
/bin/podman: stderr Getting image source signatures
/bin/podman: stderr Copying blob sha256:5f50543efd3b415f859e79c211421a2ce41ef19ea0905e3597cc2bfc634ef630
/bin/podman: stderr Copying blob sha256:570d5d7d3a6a72fe2fa36c5d2c31cde66a5b88741d1336218422745bd35cf321

/bin/podman: stderr Error: writing blob: adding layer with blob "sha256:5f50543efd3b415f859e79c211421a2ce41ef19ea0905e3597cc2bfc634ef630": processing tar file(write /usr/bin/ceph-osd: no space left on device): exit status 1
ERROR: Failed command: /bin/podman pull undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7

2024-06-11T05:27:16.865814+0000 mgr.controller-0.kxazet [ERR] Upgrade: Paused due to UPGRADE_FAILED_PULL: Upgrade: failed to pull target image


** Note: may continous 5-6 and 6-7 may consume space in cephstorage node, so cleanup the images



[tripleo-admin@cephstorage-0 ~]$ sudo podman images
REPOSITORY                                                                              TAG              IMAGE ID      CREATED        SIZE                                                                                                   
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter  v4.12            76cec178b405  2 weeks ago    446 MB                                                                                                 
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhosp17-openstack-cron                  17.1_20240515.1  ed727d7f21ab  3 weeks ago    347 MB                                                                                                 
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph                                  6                ceae6c596672  7 weeks ago    1.09 GB                                                                                                
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter  v4.10            c5fea2f9a0cd  5 months ago   357 MB                                                                                                 
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph                                  5-446            72d512a15e58  11 months ago  1.02 GB                                                                                                
[tripleo-admin@cephstorage-0 ~]$ sudo podman pull undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7
Trying to pull undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7...
Getting image source signatures
Copying blob 570d5d7d3a6a skipped: already exists
Copying blob 5f50543efd3b done
Error: writing blob: adding layer with blob "sha256:5f50543efd3b415f859e79c211421a2ce41ef19ea0905e3597cc2bfc634ef630": processing tar file(write /usr/bin/ceph-osd: no space left on device): exit status 1 


sudo podman rmi <5 image>

[tripleo-admin@controller-0 ~]$ sudo podman ps | grep ceph
5b01d5ba31ac  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -c rpcbind && rpc...  4 days ago          Up 4 days                           ceph-nfs-pacemaker                 
217bfbc21954  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n mgr.controller...  39 hours ago        Up 39 hours                         ceph-e14864ba-e171-552d-864a-db189e445ef5-mgr-controller-0-kxazet
f79694a25ffa  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n mon.controller...  39 hours ago        Up 39 hours                         ceph-e14864ba-e171-552d-864a-db189e445ef5-mon-controller-0
e27c41fa799f  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n client.crash.c...  9 minutes ago       Up 9 minutes                        ceph-e14864ba-e171-552d-864a-db189e445ef5-crash-controller-0
1885e0757896  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n mds.mds.contro...  5 minutes ago       Up 5 minutes                        ceph-e14864ba-e171-552d-864a-db189e445ef5-mds-mds-controller-0-dlqvyc
6da33f6d75ae  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n client.rgw.rgw...  4 minutes ago       Up 4 minutes                        ceph-e14864ba-e171-552d-864a-db189e445ef5-rgw-rgw-controller-0-rvqzyt
27eca8a00284  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.12                  --no-collector.ti...  3 minutes ago       Up 3 minutes                        ceph-e14864ba-e171-552d-864a-db189e445ef5-node-exporter-controller-0
d8ffd222acce  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.12                                --config.file=/et...  2 minutes ago       Up 2 minutes                        ceph-e14864ba-e171-552d-864a-db189e445ef5-prometheus-controller-0
eee9ff10d808  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.12                   --cluster.listen-...  2 minutes ago       Up 2 minutes                        ceph-e14864ba-e171-552d-864a-db189e445ef5-alertmanager-controller-0
755b87a12e4b  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                                                      About a minute ago  Up About a minute                   ceph-e14864ba-e171-552d-864a-db189e445ef5-grafana-controller-0
[tripleo-admin@controller-0 ~]$ 




# nfs ganesha upgrade 





(undercloud) [stack@undercloud-0 ~]$ cat ganesha_update_extravars.yaml 
tripleo_cephadm_container_image: rh-osbs/rhceph
tripleo_cephadm_container_ns: undercloud-0.ctlplane.redhat.local:8787
tripleo_cephadm_container_tag: '7'
(undercloud) [stack@undercloud-0 ~]








(undercloud) [stack@undercloud-0 ~]$ ansible-playbook -i $HOME/overcloud-deploy/overcloud/config-download/overcloud/cephadm/inventory.yml /usr/share/ansible/tripleo-playbooks/ceph-update-ganesha.yml \                                     
 -e @$HOME/overcloud-deploy/overcloud/config-download/overcloud/global_vars.yaml \
 -e @$HOME/overcloud-deploy/overcloud/config-download/overcloud/cephadm/cephadm-extra-vars-heat.yml \
 -e @$HOME/ganesha_update_extravars.yaml
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details

PLAY [ceph_nfs] ******************************************************************************************************************************************************************************************************************************

TASK [Render ganesha systemd unit] ***********************************************************************************************************************************************************************************************************
changed: [controller-2]
changed: [controller-1]
changed: [controller-0]

TASK [Restart Pacemaker resource] ************************************************************************************************************************************************************************************************************changed: [controller-0]

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************
controller-0               : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
controller-1               : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
controller-2               : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

(undercloud) [stack@undercloud-0 ~]$ 









[tripleo-admin@controller-0 ~]$ sudo podman ps | grep ceph
217bfbc21954  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n mgr.controller...  40 hours ago    Up 40 hours                         ceph-e14864ba-e171-552d-864a-db189e445ef5-mgr-controller-0-kxazet
f79694a25ffa  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n mon.controller...  40 hours ago    Up 40 hours                         ceph-e14864ba-e171-552d-864a-db189e445ef5-mon-controller-0
e27c41fa799f  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n client.crash.c...  40 minutes ago  Up 40 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-crash-controller-0
1885e0757896  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n mds.mds.contro...  36 minutes ago  Up 36 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-mds-mds-controller-0-dlqvyc
6da33f6d75ae  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                      -n client.rgw.rgw...  35 minutes ago  Up 35 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-rgw-rgw-controller-0-rvqzyt
27eca8a00284  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.12                  --no-collector.ti...  34 minutes ago  Up 34 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-node-exporter-controller-0
d8ffd222acce  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.12                                --config.file=/et...  33 minutes ago  Up 33 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-prometheus-controller-0
eee9ff10d808  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.12                   --cluster.listen-...  33 minutes ago  Up 33 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-alertmanager-controller-0
755b87a12e4b  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                                                      32 minutes ago  Up 32 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-grafana-controller-0
[tripleo-admin@controller-0 ~]$ 




using v4.15 for monitoring stack:

Upsream versions for reef (RHCS7)
Prometheus 2.43.0
Node-exporter 1.5.0
Grafana 9.4.7
Alertmanager 0.25.0



[tripleo-admin@controller-0 ~]$ sudo podman ps | grep ceph
217bfbc21954  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                                        -n mgr.controller...  4 days ago      Up 4 days                           ceph-e14864ba-e171-552d-864a-db189e445ef5-mgr-controller-0-kxazet
f79694a25ffa  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                                        -n mon.controller...  4 days ago      Up 4 days                           ceph-e14864ba-e171-552d-864a-db189e445ef5-mon-controller-0
e27c41fa799f  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                                        -n client.crash.c...  3 days ago      Up 3 days                           ceph-e14864ba-e171-552d-864a-db189e445ef5-crash-controller-0
1885e0757896  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                                        -n mds.mds.contro...  2 days ago      Up 2 days                           ceph-e14864ba-e171-552d-864a-db189e445ef5-mds-mds-controller-0-dlqvyc
6da33f6d75ae  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                                        -n client.rgw.rgw...  2 days ago      Up 2 days                           ceph-e14864ba-e171-552d-864a-db189e445ef5-rgw-rgw-controller-0-rvqzyt
4cbb0a534c03  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                                                        -c rpcbind && rpc...  2 days ago      Up 2 days                           ceph-nfs-pacemaker   
b83c85ffd15a  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:3d75ca419b9ef00cf2c944680737e84e6e1059e0f33156bc21d4dbf76a7da5b1  -W cephadm --watc...  7 minutes ago   Up 7 minutes                        frosty_mayer         
80fc349fa51e  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.15                                    --no-collector.ti...  31 seconds ago  Up 32 seconds                       ceph-e14864ba-e171-552d-864a-db189e445ef5-node-exporter-controller-0
da03cc2ea4bb  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.15                                     --cluster.listen-...  25 seconds ago  Up 26 seconds                       ceph-e14864ba-e171-552d-864a-db189e445ef5-alertmanager-controller-0
cc650a1672b0  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                                                                        19 seconds ago  Up 19 seconds                       ceph-e14864ba-e171-552d-864a-db189e445ef5-grafana-controller-0
c8050dc49e7a  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.15                                                  --config.file=/et...  10 seconds ago  Up 11 seconds                       ceph-e14864ba-e171-552d-864a-db189e445ef5-prometheus-controller-0

