
ref: https://github.com/openstack-k8s-operators/docs/blob/main/ceph.md#configure-swift-with-a-rgw-backend



  ansible.builtin.command:
    cmd: >-
      oc rsh
      --namespace={{ cifmw_install_yamls_defaults['NAMESPACE'] }}
      nova-cell0-conductor-0 nova-manage cell_v2 discover_hosts --verbose



    - name: List compute and network resources
      when:
        - podified_validation | default('false') | bool
      environment:
        KUBECONFIG: "{{ cifmw_openshift_kubeconfig }}"
        PATH: "{{ cifmw_path }}"
      ansible.builtin.shell: |
        oc rsh -n {{ openstack_namespace }} openstackclient openstack compute service list;
        oc rsh -n {{ openstack_namespace }} openstackclient openstack network agent list;



data collected:


   "cifmw_cephadm_vip": "172.18.0.2",

TASK [cifmw_cephadm : debug msg={{ hostvars[grafana_host][all_addresses] }}] ***
Tuesday 23 January 2024  06:04:37 -0500 (0:00:00.146)       0:01:34.133 *******
ok: [192.168.122.100] => {
    "msg": [
        "172.19.0.101",
        "192.168.111.40",
        "192.168.122.100",
        "172.17.0.101",
        "172.20.0.101",
        "172.18.0.101"
    ]
}




After creation of swift endpoint:


zuul@controller-0 ci-framework]$ oc rsh  openstackclient openstack user list |grep swift
| d2b7368689ee43dda44e55dc74f4950c | swift     |
[zuul@controller-0 ci-framework]$ oc rsh  openstackclient openstack service list |grep swift
| 0208b81677c44d31be2c467d8614905e | swift     | object-store |
| a53aa6b550274ddf8777e9679a08a096 | swift     | object-store |
[zuul@controller-0 ci-framework]$ oc rsh  openstackclient openstack role list |grep swift
| 57272b489300457e9e9e2eabd71c77e9 | swiftoperator |
[zuul@controller-0 ci-framework]$ oc rsh  openstackclient openstack endpoint list |grep swift
| 15427e2392d843fa99fb2c010da5b506 | regionOne | swift        | object-store | True    | public    | http://172.18.0.2:8080/swift/v1/AUTH_%(tenant_id)s             |
| f0ac1513e67f4e2ab9cba13eec9353f9 | regionOne | swift        | object-store | True    | internal  | http://172.18.0.2:8080/swift/v1/AUTH_%(tenant_id)s             |
[zuul@controller-0 ci-framework]$ 
[cifmw] 0:ssh*Z 1:bash  2:bash-                                                                                                                                                                        "shark19.mobius.lab.en" 17:02 07-Feb-24




- name: Check if swift service is already created
  cifmw.general.ci_script:
    output_dir: "/home/zuul/ci-framework-data/artifacts"
    script: "oc rsh openstackclient openstack service list | grep 'swift.*object-store' | wc -l"
  register: service_ls_swift
  delegate_to: localhost

- name: Check if swift endpoint is already created
  cifmw.general.ci_script:
    output_dir: "/home/zuul/ci-framework-data/artifacts"
    script: "oc rsh openstackclient openstack endpoint list | grep 'swift.*object-store' | wc -l"
  register: endpoint_ls_swift
  delegate_to: localhost



  when:
    - service_ls_swift == 0
    - endpoint_ls_swift == 0


[zuul@controller-0 ci-framework]$ cat ~/ci-framework-data/logs/ci_script_012_configure_ceph_rgw_as_backend_to_swift.log+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | OpenStack Object Storage         |
| enabled     | True                             |
| id          | e4509b27052b48cb9d8d139ac7f2c291 |
| name        | swift                            |
| type        | object-store                     |
+-------------+----------------------------------+
+---------------------+----------------------------------+
| Field               | Value                            |
+---------------------+----------------------------------+
| default_project_id  | 2382cfa770294fc08b23eb18d864b500 |
| domain_id           | default                          |
| enabled             | True                             |
| id                  | 85b5c34871d6477aa1be71ec5c3a8fec |
| name                | swift                            |
| options             | {}                               |
| password_expires_at | None                             |
+---------------------+----------------------------------+
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | None                             |
| domain_id   | None                             |
| id          | 8b98e602abcc41e1900c9df1af352216 |
| name        | swiftoperator                    |
| options     | {}                               |
+-------------+----------------------------------+
+-------------+----------------------------------+
| Field       | Value                            |
+-------------+----------------------------------+
| description | None                             |
| domain_id   | None                             |
| id          | 1e982ea2b07b4c819f928e8e82ba1f5c |
| name        | ResellerAdmin                    |
| options     | {}                               |
+-------------+----------------------------------+
+--------------+----------------------------------------------------+
| Field        | Value                                              |
+--------------+----------------------------------------------------+
| enabled      | True                                               |
| id           | 5754f91ad4fe4f35903c9105cfc229e5                   |
| interface    | public                                             |
| region       | regionOne                                          |
| region_id    | regionOne                                          |
| service_id   | e4509b27052b48cb9d8d139ac7f2c291                   |
| service_name | swift                                              |
| service_type | object-store                                       |
| url          | http://172.18.0.2:8080/swift/v1/AUTH_%(tenant_id)s |
+--------------+----------------------------------------------------+
+--------------+----------------------------------------------------+
| Field        | Value                                              |
+--------------+----------------------------------------------------+
| enabled      | True                                               |
| id           | 35373ea0e3c443c8a6cdee169a2c8025                   |
| interface    | internal                                           |
| region       | regionOne                                          |
| region_id    | regionOne                                          |
| service_id   | e4509b27052b48cb9d8d139ac7f2c291                   |
| service_name | swift                                              |
| service_type | object-store                                       |
| url          | http://172.18.0.2:8080/swift/v1/AUTH_%(tenant_id)s |
+--------------+----------------------------------------------------+


# After ci job podified-multinode-hci-deployment-crc failure



 - in manually deployed VA1 env testing locally, we observed that swift is not deployed via controlplane (more over the samples file in openstack-operators are having enabled:false for swift)
 - where as in ci job
     - swift is alreay deployed and endpoints exist
 - what i did:
     create a PR to disable swift and add depends-on in the PR message (depends-on in the commit message didnt help) 
    Depends-On: openstack-k8s-operators/openstack-operator#691
     # "OPENSTACK_CTLPLANE": "config/samples/core_v1beta1_openstackcontrolplane_galera_network_isolation.yaml"


  - based on review comments, update code like this
     pre.yaml : check swift in contrlplane , endpoints and print a warning if swift exists already
     post.yaml : run the acutal task to create endpoints when swift doesn't exist

   after which i see the ci job have swift disable, 





-name: Check if swift endpoint is already created
  shell: "oc rsh openstackclient openstack endpoint list | grep 'swift.*object-store' | wc -l"
  register: swift_endpoints_count
  delegate_to: localhost

- name: Configure ceph rgw as backend to Swift
  cifmw.general.ci_script:
    output_dir: "/home/zuul/ci-framework-data/artifacts"
    script: |-
      oc rsh openstackclient openstack service create --name swift --description 'OpenStack Object Storage' object-store
      oc rsh openstackclient openstack user create --project service --password {{ cifmw_ceph_rgw_keystone_psw }}  swift
      oc rsh openstackclient openstack role create swiftoperator
      oc rsh openstackclient openstack role create ResellerAdmin
      oc rsh openstackclient openstack role add --user swift --project service member
      oc rsh openstackclient openstack role add --user swift --project service admin
      oc rsh openstackclient openstack endpoint create --region regionOne object-store public http://{{ cifmw_cephadm_vip }}:8080/swift/v1/AUTH_%\(tenant_id\)s
      oc rsh openstackclient openstack endpoint create --region regionOne object-store internal http://{{ cifmw_cephadm_vip }}:8080/swift/v1/AUTH_%\(tenant_id\)s
      oc rsh openstackclient openstack role add --project admin --user admin swiftoperator
  delegate_to: localhost
  when: swift_endpoints_count.stdout == "0"

- name: Display message about endpoint updation
  ansible.builtin.debug:
    msg: "End point already exists, updation of end points is not supported. It can be done manually using 'openstack endpoint set' command"
  when: swift_endpoints_count.stdout != "0"



- name: Check the list of services
  environment:
    KUBECONFIG: "{{ cifmw_openshift_kubeconfig }}"
  shell: |
    oc rsh openstackclient openstack service list
    oc rsh openstackclient openstack user list
    oc rsh openstackclient openstack role list
    oc rsh openstackclient openstack endpoint list
    oc get pods
  register: service_list
  delegate_to: localhost



# remove swift endpoint
oc rsh openstackclient openstack service list
oc rsh openstackclient openstack user list
oc rsh openstackclient openstack role list
oc rsh openstackclient openstack endpoint list | grep swift

oc rsh openstackclient openstack endpoint delete b2c1ea25a7b74d81a582a75fd10aea32 5c1ce45222db4f92b6fd740acef53f95
oc rsh openstackclient openstack role delete swiftoperator ResellerAdmin
oc rsh openstackclient openstack user delete swift
oc rsh openstackclient openstack service delete swift



Testing:

comment kubeconfig part

-  environment:                                                                                                        
-    KUBECONFIG: "{{ cifmw_openshift_kubeconfig }}"                                                                                                                                                                                           
+  #environment:                                                                                                                                                                                                                              
+  # KUBECONFIG: "{{ cifmw_openshift_kubeconfig }}"                                                                                                                                                                                           
   delegate_to: localhost                                                                                                                                                                                                                     
-  when: cifmw_openshift_kubeconfig is defined                                                                                                                                                                                                
+    #when: cifmw_openshift_kubeconfig is defined     
