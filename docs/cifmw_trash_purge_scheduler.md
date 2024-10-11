







https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/merge_requests/745/diffs
https://github.com/openstack-k8s-operators/ci-framework/pull/2357





slack: https://redhat-internal.slack.com/archives/C052N9BRK4P/p1726556475426399


# testing


cifmw_cephadm_enable_trash_scheduler: true in /tmp/ceph_overrrides.yaml


TASK [cifmw_cephadm : Set trash interval _raw_params={{ cifmw_cephadm_ceph_cli }} trash purge schedule add {{ cifmw_cephadm_rbd_trash_interval | default(15) }} --pool {{ item.name }}] ******************************************************
Tuesday 24 September 2024  03:14:49 -0400 (0:00:00.077)       0:01:10.826 ***** 
skipping: [compute-0jqg16ss-0] => (item={'name': 'vms', 'pg_autoscale_mode': True, 'target_size_ratio': 0.2, 'application': 'rbd'}) 
ok: [compute-0jqg16ss-0] => (item={'name': 'volumes', 'pg_autoscale_mode': True, 'target_size_ratio': 0.3, 'application': 'rbd', 'trash_purge_enabled': True})
skipping: [compute-0jqg16ss-0] => (item={'name': 'backups', 'pg_autoscale_mode': True, 'target_size_ratio': 0.1, 'application': 'rbd'}) 
skipping: [compute-0jqg16ss-0] => (item={'name': 'images', 'target_size_ratio': 0.2, 'pg_autoscale_mode': True, 'application': 'rbd'}) 
skipping: [compute-0jqg16ss-0] => (item={'name': 'cephfs.cephfs.meta', 'target_size_ratio': 0.1, 'pg_autoscale_mode': True, 'application': 'cephfs'}) 
skipping: [compute-0jqg16ss-0] => (item={'name': 'cephfs.cephfs.data', 'target_size_ratio': 0.1, 'pg_autoscale_mode': True, 'application': 'cephfs'}) 

TASK [cifmw_cephadm : pause minutes=5] *******************************************************************************************************************************************************************************************************
Tuesday 24 September 2024  03:14:50 -0400 (0:00:00.918)       0:01:11.744 ***** 
Pausing for 300 seconds
(ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
Press 'C' to continue the play or 'A' to abort 
fatal: [compute-0jqg16ss-0]: FAILED! => 
  msg: user requested abort!





[ceph: root@compute-0jqg16ss-0 /]# rbd trash purge schedule ls --pool volumes
every 15m
[ceph: root@compute-0jqg16ss-0 /]# 

