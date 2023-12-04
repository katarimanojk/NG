ref: tlse for ipa registration tasks move to pre-deploy from external deploy tasks allows us to
parallelize the ipa_client_install on each node to significantly reduce the deployment time.
https://github.com/openstack/tripleo-heat-templates/commit/09e149f7f2ad0157f3158e77f97ce54699d19c8a

fwiu, this ^ has no dependancy and can be done pre deploy time also.

does triple client role has dependency on deployment ? no currently it is called in exteranal_deploy_tasks which is done before deployment.


https://opendev.org/openstack/tripleo-ansible/src/branch/stable/wallaby/tripleo_ansible/roles/tripleo_ceph_client/tasks/sync.yml#L50

which is called in tht belwo under external_deploy_tasks:  

 deployment/cephadm/ceph-client.yaml:


              - name: configure ceph clients
                include_role:
                  name: tripleo_ceph_client
                vars:
                  tripleo_ceph_client_config_home: {get_param: CephConfigPath}
                  tripleo_ceph_client_vars: {get_param: CephClientConfigVars}
              - include_role:
                  name: tripleo_ceph_client
                name: tripleo client role
                vars:
                  tripleo_ceph_client_config_home: {get_param: CephConfigPath}
                  multiple: "{{ item }}"
                loop: "{{ ceph_external_multi_config }}"
                when:
                  - ceph_external_multi_config is defined


code changes:
tht  :  move code to pre-deploy tasks 
t-a  :  remove delegate_to in role sync.yaml ?



# implementaiton doubts:


tht: 

deployment/cephadm/ceph-client.yaml 

              - include_role:
                  name: tripleo_ceph_client
                name: tripleo client role
                vars:
                  tripleo_ceph_client_config_home: {get_param: CephConfigPath}
                  multiple: "{{ item }}"
                loop: "{{ ceph_external_multi_config }}"
                when:
                  - ceph_external_multi_config is defined

planning to move this code to predeply_steps but where to delegate to


roles/tripleo_ceph_client/tasks/sync.yml 

delegate_to at L50 and L59 loops over tripleo_ceph_client_dist which is 'mon_client_hosts'

which is generated here roles/tripleo_ceph_work_dir/tasks/prepare.yml +116
