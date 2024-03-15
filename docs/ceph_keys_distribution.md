# admin and non-admin hosts from spec , create keys and distribute 

[mkatari@fedora tripleo_ansible]$ vi playbooks/cli-deployed-ceph.yaml 



only ceph-storage nodes will have osd label



[mkatari@fedora tripleo_ansible]$ vi ./roles/tripleo_run_cephadm/tasks/enable_ceph_admin_user.yml +32
  will use the admin and non-admin hosts generated in before step 


prepares 
[stack@undercloud-0 ~]$ cat ./overcloud-deploy/overcloud/cephadm_admin_limit.txt
undercloud
controller-0
controller-1
controller-2
[stack@undercloud-0 ~]$ cat ./overcloud-deploy/overcloud/cephadm_non_admin_limit.txt 
undercloud
cephstorage-0
cephstorage-1
cephstorage-2
[stack@undercloud-0 ~]$ 

and then calls
 
/usr/share/ansible/tripleo-playbooks/ceph-admin-user-playbook.yml  with --limit

is called twice    
    cephadm_public_private_ssh_list:
      - '-e distribute_private_key=true'
      - "--limit @{{ ceph_working_dir }}/cephadm_admin_limit.txt"
    
    cephadm_public_ssh_list:
      - '-e distribute_private_key=false'
      - "--limit @{{ ceph_working_dir }}/cephadm_non_admin_limit.txt"


1st time:  public+private keys for admin hosts
2nd time: private keys for non-admin hosts with distribute_private_key=false'  ====> no use of calling it here

https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/roles/tripleo_run_cephadm/tasks/enable_ceph_admin_user.yml#L86
https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/playbooks/ceph-admin-user-playbook.yml
https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/roles/tripleo_create_admin/tasks/main.yml#L21

ceph-admin-user-playbook.yml 
  - create private and public keys in undercloud
  - for overcloud nodes, call tripleo_create_admin


./roles/tripleo_create_admin/tasks/main.yml runs only if 
distribute_private_key is true 
