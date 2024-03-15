
After FFU mgr name is updated  from controller-0  to  controller-0.itgjpg

but we skip the dashabord tasks in https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/roles/tripleo_cephadm/tasks/monitoring.yaml#L107

if it is already enabled, so the config [2] is not reapplied on the new mgr.


[2] https://github.com/openstack-archive/tripleo-ansible/blob/stable/wallaby/tripleo_ansible/roles/tripleo_cephadm/tasks/dashboard/configure_dashboard_backends.yml#L36



# testing:

i[tripleo-admin@controller-0 ~]$ sudo podman ps -a -f 'name=ceph-?(.*)-mgr.*' --format \{\{\.Command\}\} --no-trunc
-n mgr.controller-0.itgjpg -f --setuser ceph --setgroup ceph --default-log-to-file=false --default-log-to-journald=true --default-log-to-stderr=false
[tripleo-admin@controller-0 ~]$ 



tripleo-admin@controller-0 ~]$ cat test.yaml 
---
- hosts: localhost
  tasks:
  - name: Get the current mgr
    command: |
      podman ps -a -f 'name=ceph-?(.*)-mgr.*' --format \{\{\.Command\}\} --no-trunc
    register: ceph_mgr
    become: true

  - name: Check the resulting mgr container instance
    set_fact:
      current_mgr: "{{ ceph_mgr.stdout | regex_replace('^-n mgr.(.*)(?P<inst>) -f (.*)+$', '\\1') }}"

  - name: print
    debug:
      msg: "{{ current_mgr }}"
[tripleo-admin@controller-0 ~]$ 
[tripleo-admin@controller-0 ~]$ 
[tripleo-admin@controller-0 ~]$ 
[tripleo-admin@controller-0 ~]$ ansible-playbook test.yaml 
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [localhost] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Get the current mgr] *******************************************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Check the resulting mgr container instance] ********************************************************************************************************************************************************************************************
ok: [localhost]

TASK [print] *********************************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "controller-0.itgjpg"
}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************
localhost                  : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

[tripleo-admin@controller-0 ~]$ 

