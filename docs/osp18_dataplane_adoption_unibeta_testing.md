Unibeta_adoption testing


plan was to use the same unigamma doc (https://docs.google.com/document/d/1xXEmhwdVh7a2t0yB6Th_3gYZIp3XkcsV330eb7M5xCk/edit?tab=t.0) and tune it

apply 3 WIP  patches from luigi
https://github.com/openstack-k8s-operators/ci-framework/pull/2649
https://github.com/openstack-k8s-operators/data-plane-adoption/pull/784
https://github.com/openstack-k8s-operators/architecture/pull/474


1. create infra (we used same command as unigama va-hci)
ansible-playbook  create-infra.yml -e @scenarios/reproducers/va-hci.yml -e @scenarios/reproducers/networking-definition.yml -e @release_vars.yaml --flush-cache


2. OSP 17.1 deployment

update  data-plane-adoption/scenarios/uni02beta.yaml and add env file (/usr/share/openstack-tripleo-heat-templates/environments/netapp_nfs_tlv_config.yaml) under vars

ansible-playbook deploy-osp-adoption.yml -e cifmw_architecture_scenario=uni02beta -e @osp_secrets.yaml -e "cifmw_adoption_source_scenario_path=/home/zuul/data-plane-adoption/scenarios" -e "cifmw_adoption_osp_deploy_ntp_server=clock.redhat.com" --flush-cache

in 5 minutes when undercloud node is ready, create the below file

/usr/share/openstack-tripleo-heat-templates/environments/netapp_nfs_tlv_config.yaml   

---
parameter_defaults:
    CinderEnableIscsiBackend: false
    CinderNetappLogin: 'vsadmin'
    CinderNetappPassword: 'qum5net'
    CinderNetappServerHostname: '10.46.29.74'
    CinderNetappServerPort: '80'
    CinderNetappSizeMultiplier: '1.2'
    CinderNetappTransportType: 'http'
    CinderNetappStorageProtocol: 'iscsi'
    CinderNetappVserver: 'ntap-rhv-dev-rhos'
    # until rocky, and stein as deprecated (https://review.opendev.org/633055):
    CinderNetappStoragePools: '(cinder_volumes)'
    # from train as only value (https://review.opendev.org/679266)
    CinderNetappPoolNameSearchPattern: '(cinder_volumes)'
    CinderEnableNfsBackend: true
    # TLV2 Dev Netapp
    CinderNfsServers: "10.46.29.88:/cinder_nfs"
    GlanceBackend: cinder

copied from: https://gitlab.cee.redhat.com/eng/openstack/rhos-infrared/-/blob/master/private/storage/netapp_tlv_multi_iscsi_nfs.yaml?ref_type=heads



failed with https://access.redhat.com/solutions/7052149 
https://paste.opendev.org/show/bLgmT3Yz4wXkfmUyHhe8/



## tried networking-definition_uni02beta.yml from https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/blob/main/scenarios/uni/uni02beta/01-net-def.yaml?ref_type=heads
ansible-playbook  create-infra.yml -e @scenarios/reproducers/va-hci.yml -e @scenarios/reproducers/networking-definition_uni02beta.yml -e @release_vars.yaml --flush-cache


got the error

TASK [networking_mapper : Call the networking mapper networking_definition={{ _cifmw_networking_mapper_definition }}, interfaces_info={{                                                                                                      
  cifmw_networking_mapper_ifaces_info |                                                                                                                                                                                                       
  default(omit)                                                                                                                                                                                                                               
}}, search_domain_base={{                                                                                                                                                                                                                     
  cifmw_networking_mapper_search_domain_base |                                                                                                                                                                                                
  default(omit)                                                                                                                                                                                                                               
}}, interfaces_info_translations={{                                                                                                                                                                                                           
  cifmw_networking_mapper_interfaces_info_translations |
  default(omit)     
}}, full_map={{ cifmw_networking_mapper_full_map |  default(omit) }}] ***
Wednesday 19 February 2025  12:03:20 +0000 (0:00:00.428)       0:00:38.794 **** 
fatal: [localhost]: FAILED! => changed=false 
  details: {}                                                                                                                                                                                                                                 
  field: null                                                                                                          
  invalid_value: storagemgmt
  message: osp-controllers template points to the non-existing network storagemgmt
  parent_name: null
  parent_type: null 



so updated 

[zuul@shark19 ci-framework]$ git diff scenarios/reproducers/va-hci-base.yml
diff --git a/scenarios/reproducers/va-hci-base.yml b/scenarios/reproducers/va-hci-base.yml
index d3a0f60f..010f5dbd 100644
--- a/scenarios/reproducers/va-hci-base.yml
+++ b/scenarios/reproducers/va-hci-base.yml
@@ -1,5 +1,5 @@
 ---
-cifmw_architecture_scenario: hci
+cifmw_architecture_scenario: uni02beta



but same issue 
https://paste.opendev.org/show/bLgmT3Yz4wXkfmUyHhe8/




3. OCP deployment



4. prepare ocp for openstack install, deploy operators (some part of RHOSO) on ocp cluster



5. prepare vars/secrets for adoption


6. run adoption
