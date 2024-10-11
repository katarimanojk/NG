
  - name: Override osd_spec if osd_spec_path is provided
      set_fact:
        osd_spec: "{{ osd_spec_path_content | from_yaml }}"
      vars:
        osd_spec_path_content: "{{ lookup('file', osd_spec_path) }}"
      when:
        - osd_spec_path is defined
        - osd_spec_path | length > 0
      tags:
        - ceph_spec


- osd_spec is defined as dict in the module, if we use multiple yamls in one file sapered by --, 


  File "/usr/lib/python3.9/site-packages/ansible/plugins/filter/core.py", line 218, in from_yaml                                                                                                                                              
    return yaml_load(text_type(to_text(data, errors='surrogate_or_strict')))                                                                                                                                                                  
  File "/usr/lib64/python3.9/site-packages/yaml/__init__.py", line 114, in load                                                                                                                                                               
    return loader.get_single_data()                                                                                                                                                                                                           
  File "/usr/lib64/python3.9/site-packages/yaml/constructor.py", line 49, in get_single_data                                                                                                                                                  
    node = self.get_single_node()                                                                                                                                                                                                             
  File "yaml/_yaml.pyx", line 719, in yaml._yaml.CParser.get_single_node                                                                                                                                                                      
yaml.composer.ComposerError: expected a single document in the stream                                                                                                                                                                         
  in "<unicode string>", line 1, column 1                                                                                                                                                                                                     
but found another document                



- we used from_yaml_all , it generates a list of dicts so the module rejects the list of dicts with this error


[stack@undercloud-0 ~]$ openstack overcloud ceph spec -o /home/stack/manojosd_ceph_spec_multi.yaml -vvv --osd-spec /home/stack/osd_spec_multi.yaml --stack overcloud  --roles-data /home/stack/composable_roles/roles/roles_data.yaml /home/stack/templates/manoj_overcloud-baremetal-deployed.yaml


    },
    "msg": "argument 'osd_spec' is of type <class 'list'> and we were unable to convert to dict: <class 'list'> cannot be converted to a dict"                                                                                               
}


------------ MULI YAML OSD SPEC---------------
2024-08-20 06:48:25.198013 | 52540075-aaeb-37a5-5be8-000000000012 |         OK | Override osd_spec if osd_spec_path is provided | undercloud | result={                                                                                       
    "ansible_facts": {                                                                                                                                                                                                                        
        "osd_spec": [                                                                                                                                                                                                                         
            {                                                                                                                                                                                                                                 
                "data_devices": {                                                                                                                                                                                                            
                    "paths": [    
                        "/dev/sda",    
                        "/dev/sdb",    
                        "/dev/sdc"                                                                                                                                   
                    ]                                                                                                                       
                },                                                                                                                                       
                "db_devices": {                                                                                                                                                   
                    "paths": [                                                                                                                      
                        "/dev/nvme0n1"                                         
                    ]                     
                },                                    
                "encrypted": true,                       
                "osds_per_device": 1,                                                                                                                                      
                "placement": {                                                                                                                                                                                                               
                    "host_pattern": "cigr-storage-*"                                                                                                                                                                                         
                },                                                                                                                                                                                                                           
                "service_id": "osd_spec_hdd",
                "service_type": "osd",           
                "wal_devices": {                                                                                                                                                                                                             
                    "paths": [      
                        "/dev/nvme0n1"
                    ]      
                }                                                        
            },           
            {    
                "data_devices": {    
                    "paths": [    
                        "/dev/sdk",    
                        "/dev/sdl",    
                        "/dev/sdm",   
                        "/dev/sdn"
                    ] 
                },                 
                "db_devices": {   
                    "paths": [            
                        "/dev/nvme0n1"
                    ] 
                },                    
                "encrypted": true,       
                "osds_per_device": 1,
                "placement": {                          
                    "host_pattern": "cigr-storage-*"
                },                               
                "service_id": "osd_spec_ssd",
                "service_type": "osd",
                "wal_devices": {  
                    "paths": [            
 
---------------------------------------------------M--------------------------



To support both:


   - name: Override osd_spec if osd_spec_path is provided
      set_fact:
        osd_spec: "{{ osd_spec_path_content | from_yaml_all }}"


and while passing it to module

    - name: Create Ceph spec based on baremetal_deployed_path and tripleo_roles
      ceph_spec_bootstrap:
        new_ceph_spec: "{{ ceph_spec_path }}"
        tripleo_roles: "{{ tripleo_roles_path }}"
        osd_spec: "{{ osd_spec[0] }}"

[stack@undercloud-0 ~]$ openstack overcloud ceph spec -o /home/stack/manojosd_ceph_spec_single.yaml -vvv --osd-spec /home/stack/osd_spec.yaml --stack overcloud  --roles-data /home/stack/composable_roles/roles/roles_data.yaml /home/stack/templates/manoj_overcloud-baremetal-deployed.yaml


[stack@undercloud-0 ~]$ openstack overcloud ceph spec -o /home/stack/manojosd_ceph_spec_multi.yaml -vvv --osd-spec /home/stack/osd_spec_multi.yaml --stack overcloud  --roles-data /home/stack/composable_roles/roles/roles_data.yaml /home/stack/templates/manoj_overcloud-baremetal-deployed.yaml


