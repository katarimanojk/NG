
FFU 4->5 upgrade
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/17.1/html-single/framework_for_upgrades_16.2_to_17.1/index#upgrading-to-ceph-storage-5-upgrading-ceph


5->6
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/17.1/html-single/framework_for_upgrades_16.2_to_17.1/index#proc_ceph-upgrade-5-6-update-image-prepare-file_post-upgrade-internal-ceph

it calls ceph documentation
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/6/html-single/upgrade_guide/index



downgrade/upgrade cephadm:

make sure that "rhceph-5-tools-for-rhel-8-x86_64-rpms" is updated for all nodes manually
"sudo dnf downgrade -y cephadm-16.2.0-152.el8cp"

what worked:
[tripleo-admin@controller-0 ~]$ rpm -qa | grep cephadm
cephadm-16.2.10-187.el9cp.noarch
[tripleo-admin@controller-0 ~]$ ls
cephadm-16.2.10-187.el9cp.noarch.rpm  cephadm-17.2.6-216.el9cp.noarch.rpm  upgrade_cephadm.yml
[tripleo-admin@controller-0 ~]$ sudo dnf remove cephadm


[tripleo-admin@controller-0 ~]$ sudo rpm -i cephadm-17.2.6-216.el9cp.noarch.rpm
[tripleo-admin@controller-0 ~]$ sudo dnf info cephadm | grep -i version
Version      : 17.2.6
[tripleo-admin@controller-0 ~]$ rpm -qa | grep cephadm
cephadm-17.2.6-216.el9cp.noarch
[tripleo-admin@controller-0 ~]$ 

