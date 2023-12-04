# Abstract:
During overcloud OS upgrade

openstack overcloud upgrade run --yes \
        --stack dcn1 \
        --tags system_upgrade \
        --limit dcn1-computehci1-0 2>&1

which is run after ceph  , OSP upgrade on of the upgrade tasks failed in 

/home/stack/overcloud-deploy/dcn1/config-download/dcn1/ComputeHCI1RHEL8/upgrade_tasks_step1.yaml

at this task

- - name: Set noout flag
            shell: "cephadm shell -- ceph osd set {{ item }}"
            become: true
            with_items:
              - noout
              - norecover
              - nobackfill
              - norebalance
              - nodeep-scrub
            delegate_to: "{{ ceph_mon_short_bootstrap_node_name }}"

which is set in ceph here: https://opendev.org/openstack/tripleo-heat-templates/src/branch/stable/wallaby/deployment/cephadm/ceph-osd.yaml#L109


# Analysis:

The ENV has 3 stacks central, dcn1, dcn2


(undercloud) [stack@site-undercloud-0 ~]$ metalsmith list
+--------------------------------------+-------------------+--------------------------------------+----------------------------+-------------+------------------------+
| UUID                                 | Node Name         | Allocation UUID                      | Hostname                   | State       | IP Addresses           |
+--------------------------------------+-------------------+--------------------------------------+----------------------------+-------------+------------------------+
| 874de804-f25d-48e1-8220-ae75467e9365 | dcn1-computehci-0 | 30c9071c-c0c6-4488-a4db-17f882d6e757 | dcn1-computehci1-1         | MAINTENANCE | ctlplane=192.168.34.26 |
| 70e729ab-12b4-41a8-93a2-465bc5dabd13 | dcn1-computehci-1 | 9145ba26-74d3-4e41-ba76-bf68b813efb4 | dcn1-computehci1-0         | MAINTENANCE | ctlplane=192.168.34.74 |
| 670272cd-948d-4100-92ca-eccddc47673d | dcn1-computehci-2 | f70cc094-d159-4c8e-9a3a-f17ee99bc575 | dcn1-computehci1-2         | MAINTENANCE | ctlplane=192.168.34.27 |
| 2e0858dc-0549-4c05-b59e-68c747e38219 | dcn1-computehci-3 | ee09cd42-9238-43bf-a538-e4d6734a5200 | dcn1-computehciscaleout1-0 | MAINTENANCE | ctlplane=192.168.34.88 |
| 662cf96e-4373-4df7-93a4-06534025a1dd | dcn2-computehci-0 | ff33016e-3e33-4efc-b4b6-61242f8c4db8 | dcn2-computehci2-1         | MAINTENANCE | ctlplane=192.168.44.71 |
| 95c5e8cd-c46a-46b4-9d6e-64045a92892f | dcn2-computehci-1 | eac09264-9c38-4932-9c58-9e0a558ca246 | dcn2-computehci2-0         | MAINTENANCE | ctlplane=192.168.44.33 |
| 0f862fd2-ab78-476d-8469-42c37f0e8cec | dcn2-computehci-2 | aaf0af99-170c-411b-ba90-006bb39b0f8c | dcn2-computehci2-2         | MAINTENANCE | ctlplane=192.168.44.25 |
| 1e20f60f-3f43-40b3-b304-f9f95acd2c2f | dcn2-computehci-3 | 3ad5ab7e-7707-4fc9-b9ab-d8580d59d0d2 | dcn2-computehciscaleout2-0 | MAINTENANCE | ctlplane=192.168.44.70 |
| 4f4acf89-9b26-4ec7-b544-4ce3075bfc77 | site-computehci-0 | e40641f3-9d58-4908-a898-7a530fc7d2a6 | central-computehci0-2      | MAINTENANCE | ctlplane=192.168.24.79 |
| dcf95c56-760a-4cca-a34f-b4dd84f0a443 | site-computehci-1 | 9cc2bfb7-d055-4117-bff2-bf0a7a2135c7 | central-computehci0-0      | MAINTENANCE | ctlplane=192.168.24.13 |
| 28868e48-14ed-4d5e-9a24-4422957f0334 | site-computehci-2 | b6805cf1-c073-48fc-a429-6e4f80582a9a | central-computehci0-1      | MAINTENANCE | ctlplane=192.168.24.26 |
| cf4fcf94-0388-4f36-b2b6-5a80b658fd01 | site-controller-0 | cd3f227f-d99b-4407-a389-3d502b249e65 | central-controller0-2      | MAINTENANCE | ctlplane=192.168.24.42 |
| 4a327c66-200c-4d54-bd04-0b31c8573d6e | site-controller-1 | 4e7a82a9-418c-4e79-ace8-a6bb7af72167 | central-controller0-1      | MAINTENANCE | ctlplane=192.168.24.74 |
| 87a3e8c1-ed11-496b-888b-4eb58f3ada4c | site-controller-2 | 9bc6b7e8-41fa-4438-a158-30d09d36667b | central-controller0-0      | MAINTENANCE | ctlplane=192.168.24.67 |
+--------------------------------------+-------------------+--------------------------------------+----------------------------+-------------+------------------------+
(undercloud) [stack@site-undercloud-0 ~]$ 


Looking at the error, the task is run on  central-controller0-0  as per 

./overcloud.json:220:    "ceph_mon_short_bootstrap_node_name": "central-controller0-0",

instead of using the host in the same stack 
 
2023-12-11 16:35:46.699720 | 5254009f-6055-3fca-9ea7-0000000001f3 |      FATAL | Set noout flag | dcn1-computehci1-0 -> central-controller0-0 | item=noout | error={"ansible_loop_var": "item"
, "changed": false, "item": "noout", "module_stderr": "", "module_stdout": "Please login as the user \"heat-admin\" rather than the user \"root\".\n\n", "msg": "MODULE FAILURE\nSee stdout/st
derr for the exact error", "rc": 142, "warnings": ["Platform unknown on host dcn1-computehci1-0 is using the discovered Python interpreter at /usr/bin/python, but future installation of anot
her Python interpreter could change the meaning of that path. See https://docs.ansible.com/ansible-core/2.14/reference_appendices/interpreter_discovery.html for more information."]}         [WARNING]: ('dcn1-computehci1-0 -> central-controller0-0',          







# Fix


1. we should delegate the task to relevant dcn node
 
    "ceph_mon_short_node_names": [
        "dcn1-computehci1-0",
        "dcn1-computehci1-1",
        "dcn1-computehci1-2",



2. run the correct cephcommand on the correct ceph cluster

    -- finding difficulty in running the command

    -- {{ tripleo_cephadm_fsid }} -c /etc/ceph/{{ tripleo_cephadm_cluster }}.conf    , duirng upgrade_tasks these variable are available

