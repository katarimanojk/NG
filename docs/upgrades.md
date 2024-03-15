
# FFU 16.2 to 17.1 (4->5) upgrade
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/17.1/html-single/framework_for_upgrades_16.2_to_17.1/index#upgrading-to-ceph-storage-5-upgrading-ceph

# 4-5
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/5/html/upgrade_guide/upgrading-a-red-hat-ceph-storage-cluster-running-rhel-8-from-rhcs-4-to-rhcs-5#doc-wrapper
https://gitlab.cee.redhat.com/rhos-upgrades/ffwd3/-/blob/main/Scenario.md#upgrade-ceph-from-ceph4ceph-ansible-to-ceph5cephadm


# 5->6


main steps
 1. cephadm rpm update on controller : target cephadm 17.x.x
    customer documenation: subscriptions are needed, i couldnt do it
    rhos-release tool using francesco's document: https://docs.google.com/document/d/14R9bVuz-jpdkVqLACAyXYQozHZJ3vsS4igntfv59Ht8/edit
 2. prepare container image : 6 image in undercloud registry
 3. start upgade on controller-0 : sudo cephadm shell -- ceph orch upgrade start --image <image_name>: <version>
 4. track the upgrade, ensure it is completed
 5. check all the containers are moved to 6
 6. only nfs-ganesha continer should be upgraded separetly by updating systemd file and pcs restart.



https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/17.1/html-single/framework_for_upgrades_16.2_to_17.1/index#proc_ceph-upgrade-5-6-update-image-prepare-file_post-upgrade-internal-ceph

it calls ceph documentation
https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/6/html-single/upgrade_guide/index

**** reference bugs for detailed logs of 5->6 : bz_2278836_ceph_5-6_issue_monitoring_stack.md

ansible-playbook -i ~/overcloud-deploy/overcloud/tripleo-ansible-inventory.yaml ~/enable_rhcs6.yml --limit ControllerStorageNfs


it may fail but use this
copy /etc/yum.repos.d/rhos-release.repo  from undercloud to controller 
[rhos-release]
name=RHOS Release
baseurl=http://download.devel.redhat.com/rcm-guest/puddles/OpenStack/rhos-release/
skip_if_unavailable=1
enabled=1
sslverify=0                                                                                                                                                                                                                                  
gpgcheck=0                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                             
[rhos-release-extras]
name=RHOS Release Extras
baseurl=http://download.devel.redhat.com/rcm-guest/puddles/OpenStack/rhos-release/extras/$releasever
skip_if_unavailable=1
enabled=1
sslverify=0                                                                                                                                                                                                                                  
gpgcheck=0                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                             
[rhos-release-brew]
name=RHOS Release Brew
baseurl=https://download-node-02.eng.bos.redhat.com/brewroot/repos/rhostools-rhel-8/latest/x86_64/
skip_if_unavailable=1
enabled=1
sslverify=0
gpgcheck=0


and then run #sudo dnf install -y rhos-release

and then run the playbook



## 5->6 ceph nfs ganesha is upgramded saperately



# downgrade/upgrade cephadm manually:

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

