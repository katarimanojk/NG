


before starting adoption, just gather from 17.1 undercloud node



(overcloud) [zuul@undercloud ~]$ openstack user list                                                                   
+----------------------------------+-------------------------+  
| ID                               | Name                    |  
+----------------------------------+-------------------------+  
| ed0f9407daaa46b88e5be3b3ace6cbae | admin                   |  
| fff5e70aacbe4d38aa75c83de884f71b | aodh                    |
| 619f674cbfad4754a3d67fdd29a08b4f | barbican                |                                                                                                                                                                                
| ec10c34f19db439fa61149a474082f6a | ceilometer              |                                                                                                                                                                                
| 158ba042af4c487dba30809d81275956 | cinder                  |                                                                                                                                                                                
| b9bcf71799d14974b70f95dbb3c0fc70 | cinderv3                |
| 900753f4e34a46c3a101455f375b4ad9 | glance                  |
| 2a7ec3b2495942849ff2a5f8a031a5ec | gnocchi                 |
| e953421206e247309954bb4aae77f282 | heat                    |
| 3f881169d8d04223a8be800ebe105322 | heat_stack_domain_admin |
| bf93e2bedc6644e08590045f55cff2fb | heat-cfn                |
| a3ce7d23c9584da6876d080e7aef75ea | manila                  |
| a640891b86e64a339b9698dc4cc84c1a | manilav2                |
| 7fe50e8b61274aa4942294ab51a4a503 | neutron                 |
| 3f72a5fced0646149e60cceda53a4a84 | nova                    |
| ce987d6b73244a85a4bf19697e0b0129 | swift                   |
| 5d28d947e9f14833aea11a48ecb5d5bd | placement               |
+----------------------------------+-------------------------+


(overcloud) [zuul@undercloud ~]$ openstack service list                                                                                                                                                                                       
+----------------------------------+-----------+----------------+                                                                                                                                                                             
| ID                               | Name      | Type           |                                                                                                                                                                             
+----------------------------------+-----------+----------------+                                                                                                                                                                             
| 02d6033b6d4b475a9ae59d6943950a8d | neutron   | network        |                                                                                                                                                                             
| 086cbf66ced2412d885d8837d2e9e076 | cinderv3  | volumev3       |                                                                                                                                                                             
| 0a056c7037f54efb9e6c2d614984454a | keystone  | identity       |                                                                                                                                                                             
| 0bc8a725f3aa4bf98b18740c2fc977d2 | aodh      | alarming       |                                                                                                                                                                             
| 0bd46dcc10204b5ca3ef32febdee4730 | heat-cfn  | cloudformation |                                                                                                                                                                             
| 104655615ac64c0da3199cff5e550439 | swift     | object-store   |                                                                                                                                                                             
| 2004341af23a4015a0da1a60f758412e | glance    | image          |                                                                                                                                                                             
| 307d08198e2746cebf548f81a071d11e | manila    | share          |                                                                                                                                                                             
| 44c4453603104fdf9566fb45797dd735 | manilav2  | sharev2        |                                                                                                                                                                             
| 45dc322e9d064a82a017ef69e4038331 | barbican  | key-manager    |                                                                                                                                                                             
| 9e2e40e9c7c24e93bd86b755a79d2977 | gnocchi   | metric         |                                                                                                                                                                             
| a226de8847e349afaa32c1cf0293e610 | heat      | orchestration  |                                                                                                                                                                             
| bba0933c61784879abd2690a266551da | placement | placement      |                                                                                                                                                                             
| c2a38532962e40f9b4867d5bd4a20ee8 | nova      | compute        |                                                                                                                                                                             
+----------------------------------+-----------+----------------+                                                                                                                                                                             
(overcloud) [zuul@undercloud ~]$ openstack role list                                                                                                                                                                                          
+----------------------------------+---------------------------+                                                                                                                                                                              
| ID                               | Name                      |                                                                                                                                                                              
+----------------------------------+---------------------------+                                                                                                                                                                              
| 035d041086424de7b0352b8050c337e2 | audit                     |                                                                                                                                                                              
| 0758286966a54d7995fe6a4313d6a7e1 | heat_stack_user           |                                                                                                                                                                              
| 0ba19c62ddb142dc97f7c5aec280b3e8 | ResellerAdmin             |                                                                                                                                                                              
| 2334d7329fff4f38bea61c4da38f67cb | swiftoperator             |                                                                                                                                                                              
| 2e062af43a914256842d62416aa05671 | observer                  |                                                                                                                                                                              
| 59f3d21601314afdb8f40db4a9618911 | key-manager:service-admin |                                                                                                                                                                              
| 6de779a032ea44348f12c57d6a6cd305 | admin                     |                                                                                                                                                                              
| 880460a821ca43c2911821331713eb17 | member                    |
| d6287225af4d413eb25e8fd60d28355f | service                   |
| d9bc9c139801496cb0896c5a1157201f | reader                    |
| dd311694ac6444d683c592b3ca9b8aa1 | creator                   |
+----------------------------------+---------------------------+







(overcloud) [zuul@undercloud ~]$ openstack endpoint list                                                                                                                                                                                      
+----------------------------------+-----------+--------------+----------------+---------+-----------+-------------------------------------------------------+                                                                                
| ID                               | Region    | Service Name | Service Type   | Enabled | Interface | URL                                                   |                                                                                
+----------------------------------+-----------+--------------+----------------+---------+-----------+-------------------------------------------------------+                                                                                
| 09b26670dc6d4e3db2fca0c907935e6e | regionOne | placement    | placement      | True    | admin     | http://172.17.0.145:8778/placement                    |                                                                                
| 12546dbb1a834dc9a47e5ef094e15cb2 | regionOne | glance       | image          | True    | admin     | http://172.17.0.145:9293                              |                                                                                
| 1b141ddad0e2490eadd22e2ddeb73626 | regionOne | heat-cfn     | cloudformation | True    | internal  | http://172.17.0.145:8000/v1                           |                                                                                
| 1faa7d0d26064d9c9bb793154be180c1 | regionOne | barbican     | key-manager    | True    | admin     | http://172.17.0.145:9311                              |                                                                                
| 31398f812c534bd5a8248204588c9143 | regionOne | heat-cfn     | cloudformation | True    | public    | http://10.0.0.248:8000/v1                             |                                                                                
| 37b34b8a2bee430a946dc8af0d0286a2 | regionOne | manilav2     | sharev2        | True    | admin     | http://172.17.0.145:8786/v2                           |                                                                                
| 38b18ada33b345e89e2e90d2cf64b397 | regionOne | neutron      | network        | True    | internal  | http://172.17.0.145:9696                              |                                                                                
| 399b8390125f4faeacbac5db1f7f59dd | regionOne | swift        | object-store   | True    | admin     | http://172.18.0.136:8080/swift/v1/AUTH_%(project_id)s |                                                                                
| 3c10054d698c435db59ec547b5712b6a | regionOne | cinderv3     | volumev3       | True    | admin     | http://172.17.0.145:8776/v3/%(tenant_id)s             |                                                                                
| 49d51dec31724f06b7f64de542b84241 | regionOne | neutron      | network        | True    | admin     | http://172.17.0.145:9696                              |                                                                                
| 4a1835f4964044b9a939a16792daf04c | regionOne | glance       | image          | True    | internal  | http://172.17.0.145:9293                              |                                                                                
| 5dd37e8c136148b19050d725d00be746 | regionOne | heat         | orchestration  | True    | public    | http://10.0.0.248:8004/v1/%(tenant_id)s               |                                                                                
| 61614ef32e85441b822ed624ad7d51bf | regionOne | placement    | placement      | True    | internal  | http://172.17.0.145:8778/placement                    |                                                                                
| 6a981631cf7c4d368cc0dbb92bc7dbdf | regionOne | keystone     | identity       | True    | public    | http://10.0.0.248:5000                                |                                                                                
| 6cd87a42c65f4d188b839185ee25db0c | regionOne | swift        | object-store   | True    | public    | http://10.0.0.248:8080/swift/v1/AUTH_%(project_id)s   |                                                                                
| 7458d285a9534230bb85076e3ec80688 | regionOne | manilav2     | sharev2        | True    | public    | http://10.0.0.248:8786/v2                             |                                                                                
| 7d7c45b755014967ad5f61117f0e4c48 | regionOne | heat         | orchestration  | True    | internal  | http://172.17.0.145:8004/v1/%(tenant_id)s             |
| 7eeb0e6001b945eb81da7575b3f1df16 | regionOne | placement    | placement      | True    | public    | http://10.0.0.248:8778/placement                      |                                                                                
| 8acf8928ec414f708770526d2c45385d | regionOne | nova         | compute        | True    | public    | http://10.0.0.248:8774/v2.1                           |                                                                                
| 8fc623cb2f00481fa05af9656eac1689 | regionOne | gnocchi      | metric         | True    | public    | http://10.0.0.248:8041                                |                                                                                
| a686435fdcb94eaaa69fc81f9829aaea | regionOne | aodh         | alarming       | True    | admin     | http://172.17.0.145:8042                              |
| af8d120600854b2dacf3076907df9dd0 | regionOne | gnocchi      | metric         | True    | admin     | http://172.17.0.145:8041                              |
| b9d5ae2fdc104e8a962047c3a2450736 | regionOne | cinderv3     | volumev3       | True    | public    | http://10.0.0.248:8776/v3/%(tenant_id)s               |
| c3dec92d3c254d0d9d292e98a3c3d046 | regionOne | glance       | image          | True    | public    | http://10.0.0.248:9292                                |
| c4e4ec2a00554cc1adc664046952755a | regionOne | nova         | compute        | True    | internal  | http://172.17.0.145:8774/v2.1                         |
| c536c90d7d284b0b920623ded154f1c0 | regionOne | manila       | share          | True    | public    | http://10.0.0.248:8786/v1/%(tenant_id)s               |
| ca6fe32478d84923b572f272c1ac8470 | regionOne | heat         | orchestration  | True    | admin     | http://172.17.0.145:8004/v1/%(tenant_id)s             |
| caaac00abc474d8785e9c1cd6d16dfbb | regionOne | neutron      | network        | True    | public    | http://10.0.0.248:9696                                |
| cd2cf017db174d1a960bf10dbd97b92b | regionOne | heat-cfn     | cloudformation | True    | admin     | http://172.17.0.145:8000/v1                           |
| d07eca2e79f0463b92f2bc8c043117c9 | regionOne | keystone     | identity       | True    | internal  | http://172.17.0.145:5000                              |
| d0ebcd0894174c46ad9d3f43c01e0642 | regionOne | aodh         | alarming       | True    | internal  | http://172.17.0.145:8042                              |
| d7b058a00953497ba15f2a7d5109637d | regionOne | aodh         | alarming       | True    | public    | http://10.0.0.248:8042                                |
| d836829e058641458cc0cb6737656b3a | regionOne | manila       | share          | True    | admin     | http://172.17.0.145:8786/v1/%(tenant_id)s             |
| d95f65bfba9b4d63b5d2e7a6c85e301a | regionOne | manila       | share          | True    | internal  | http://172.17.0.145:8786/v1/%(tenant_id)s             |
| da8167e1e0cd45e9b9672a347ce4328b | regionOne | barbican     | key-manager    | True    | internal  | http://172.17.0.145:9311                              |
| dbbaa6c5b6234d89b1a0ddf32f0e31e0 | regionOne | nova         | compute        | True    | admin     | http://172.17.0.145:8774/v2.1                         |
| ed4cd31725d34a5da18eebdd69b87675 | regionOne | keystone     | identity       | True    | admin     | http://192.168.122.99:35357                           |
| f05ac1877e3545bfa4b0dd9cf7b7d282 | regionOne | gnocchi      | metric         | True    | internal  | http://172.17.0.145:8041                              |
| f063a792d724424bae1a4cb534e0bd42 | regionOne | barbican     | key-manager    | True    | public    | http://10.0.0.248:9311                                |
| f081655f61f54ec786844b9d423f70f6 | regionOne | cinderv3     | volumev3       | True    | internal  | http://172.17.0.145:8776/v3/%(tenant_id)s             |
| f169d4190ac3468d9052f7ab73644c32 | regionOne | manilav2     | sharev2        | True    | internal  | http://172.17.0.145:8786/v2                           |
| fd912faf2bf349e6b1e936bd6d041930 | regionOne | swift        | object-store   | True    | internal  | http://172.18.0.136:8080/swift/v1/AUTH_%(project_id)s |
+----------------------------------+-----------+--------------+----------------+---------+-----------+-------------------------------------------------------+





when adoption started and openstackclient pod was ready

                                                                                                                                                                                                     
sh-5.1$ openstack role list                                                                                                                                                                                                                   
+----------------------------------+---------------------------+                                                                                                                                                                              
| ID                               | Name                      |                                                                                                                                                                              
+----------------------------------+---------------------------+                                                                                                                                                                              
| 035d041086424de7b0352b8050c337e2 | audit                     |                                                                                                                                                                              
| 0758286966a54d7995fe6a4313d6a7e1 | heat_stack_user           |                                                                                                                                                                              
| 0ba19c62ddb142dc97f7c5aec280b3e8 | ResellerAdmin             |                                                                                                                                                                              
| 2334d7329fff4f38bea61c4da38f67cb | swiftoperator             |                                                                                                                                                                              
| 2e062af43a914256842d62416aa05671 | observer                  |                                                                                                                                                                              
| 59f3d21601314afdb8f40db4a9618911 | key-manager:service-admin |                                                                                                                                                                              
| 6de779a032ea44348f12c57d6a6cd305 | admin                     |                                                                                                                                                                              
| 880460a821ca43c2911821331713eb17 | member                    |                                                                                                                                                                              
| d6287225af4d413eb25e8fd60d28355f | service                   |                                                                                                                                                                              
| d9bc9c139801496cb0896c5a1157201f | reader                    |                                                                                                                                                                              
| dd311694ac6444d683c592b3ca9b8aa1 | creator                   |                                                                                                                                                                              
+----------------------------------+---------------------------+                                                                                                                                                                              
sh-5.1$ openstack user list                                                                                                                                                                                                                   
+----------------------------------+-------------------------+                                                                                                                                                                                
| ID                               | Name                    |                                                                                                                                                                                
+----------------------------------+-------------------------+                                                                                                                                                                                
| ed0f9407daaa46b88e5be3b3ace6cbae | admin                   |                                                                                                                                                                                
| fff5e70aacbe4d38aa75c83de884f71b | aodh                    |                                                                                                                                                                                
| 619f674cbfad4754a3d67fdd29a08b4f | barbican                |                                                                                                                                                                                
| ec10c34f19db439fa61149a474082f6a | ceilometer              |                                                                                                                                                                                
| 158ba042af4c487dba30809d81275956 | cinder                  |
| b9bcf71799d14974b70f95dbb3c0fc70 | cinderv3                |                                                                                                                                                                                
| 900753f4e34a46c3a101455f375b4ad9 | glance                  |                                                                                                                                                                                
| 2a7ec3b2495942849ff2a5f8a031a5ec | gnocchi                 |                                                                                                                                                                                
| e953421206e247309954bb4aae77f282 | heat                    |
| 3f881169d8d04223a8be800ebe105322 | heat_stack_domain_admin |
| bf93e2bedc6644e08590045f55cff2fb | heat-cfn                |
| a3ce7d23c9584da6876d080e7aef75ea | manila                  |
| a640891b86e64a339b9698dc4cc84c1a | manilav2                |
| 7fe50e8b61274aa4942294ab51a4a503 | neutron                 |
| 3f72a5fced0646149e60cceda53a4a84 | nova                    |
| ce987d6b73244a85a4bf19697e0b0129 | swift                   |
| 5d28d947e9f14833aea11a48ecb5d5bd | placement               |
+----------------------------------+-------------------------+




sh-5.1$ openstack service list                                                                                         
+----------------------------------+-----------+--------------+                                                        
| ID                               | Name      | Type         |                                                                                                                                                                               
+----------------------------------+-----------+--------------+                                                                                                                                                                               
| 02d6033b6d4b475a9ae59d6943950a8d | neutron   | network      |  
| 0a056c7037f54efb9e6c2d614984454a | keystone  | identity     |  
| 104655615ac64c0da3199cff5e550439 | swift     | object-store |                                                                                                                                                                               
| 307d08198e2746cebf548f81a071d11e | manila    | share        |                                                                                                                                                                               
| 44c4453603104fdf9566fb45797dd735 | manilav2  | sharev2      |                                                                                                                                                                               
| 9e2e40e9c7c24e93bd86b755a79d2977 | gnocchi   | metric       |                                                                                                                                                                               
| bba0933c61784879abd2690a266551da | placement | placement    |                                                                                                                                                                               
| c2a38532962e40f9b4867d5bd4a20ee8 | nova      | compute      |                                                                                                                                                                               
+----------------------------------+-----------+--------------+                                                                                                                                                                               
sh-5.1$ openstack endpoint list                                                                                                                                                                                                               
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------------------------------------+                                                                                
| ID                               | Region    | Service Name | Service Type | Enabled | Interface | URL                                                     |                                                                                
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------------------------------------+                                                                                
| 09b26670dc6d4e3db2fca0c907935e6e | regionOne | placement    | placement    | True    | admin     | http://172.17.0.145:8778/placement                      |                                                                                
| 37b34b8a2bee430a946dc8af0d0286a2 | regionOne | manilav2     | sharev2      | True    | admin     | http://172.17.0.145:8786/v2                             |                                                                                
| 38b18ada33b345e89e2e90d2cf64b397 | regionOne | neutron      | network      | True    | internal  | http://172.17.0.145:9696                                |                                                                                
| 399b8390125f4faeacbac5db1f7f59dd | regionOne | swift        | object-store | True    | admin     | http://172.18.0.136:8080/swift/v1/AUTH_%(project_id)s   |                                                                                
| 49d51dec31724f06b7f64de542b84241 | regionOne | neutron      | network      | True    | admin     | http://172.17.0.145:9696                                |                                                                                
| 61614ef32e85441b822ed624ad7d51bf | regionOne | placement    | placement    | True    | internal  | http://172.17.0.145:8778/placement                      |                                                                                
| 6a981631cf7c4d368cc0dbb92bc7dbdf | regionOne | keystone     | identity     | True    | public    | http://keystone-public-openstack.apps.ocp.openstack.lab |                                                                                
| 6cd87a42c65f4d188b839185ee25db0c | regionOne | swift        | object-store | True    | public    | http://10.0.0.248:8080/swift/v1/AUTH_%(project_id)s     |                                                                                
| 7458d285a9534230bb85076e3ec80688 | regionOne | manilav2     | sharev2      | True    | public    | http://10.0.0.248:8786/v2                               |                                                                                
| 7eeb0e6001b945eb81da7575b3f1df16 | regionOne | placement    | placement    | True    | public    | http://10.0.0.248:8778/placement                        |                                                                                
| 8acf8928ec414f708770526d2c45385d | regionOne | nova         | compute      | True    | public    | http://10.0.0.248:8774/v2.1                             |                                                                                
| c4e4ec2a00554cc1adc664046952755a | regionOne | nova         | compute      | True    | internal  | http://172.17.0.145:8774/v2.1                           |                                                                                
| c536c90d7d284b0b920623ded154f1c0 | regionOne | manila       | share        | True    | public    | http://10.0.0.248:8786/v1/%(tenant_id)s                 |                                                                                
| caaac00abc474d8785e9c1cd6d16dfbb | regionOne | neutron      | network      | True    | public    | http://10.0.0.248:9696                                  |                                                                                
| d07eca2e79f0463b92f2bc8c043117c9 | regionOne | keystone     | identity     | True    | internal  | http://keystone-internal.openstack.svc:5000             |                                                                                
| d836829e058641458cc0cb6737656b3a | regionOne | manila       | share        | True    | admin     | http://172.17.0.145:8786/v1/%(tenant_id)s               |                   
| d95f65bfba9b4d63b5d2e7a6c85e301a | regionOne | manila       | share        | True    | internal  | http://172.17.0.145:8786/v1/%(tenant_id)s               |
| dbbaa6c5b6234d89b1a0ddf32f0e31e0 | regionOne | nova         | compute      | True    | admin     | http://172.17.0.145:8774/v2.1                           |
| f169d4190ac3468d9052f7ab73644c32 | regionOne | manilav2     | sharev2      | True    | internal  | http://172.17.0.145:8786/v2                             |
| fd912faf2bf349e6b1e936bd6d041930 | regionOne | swift        | object-store | True    | internal  | http://172.18.0.136:8080/swift/v1/AUTH_%(project_id)s   |
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------------------------------------+






After the adoption

sh-5.1$ openstack role list
+----------------------------------+---------------------------+
| ID                               | Name                      |
+----------------------------------+---------------------------+
| 035d041086424de7b0352b8050c337e2 | audit                     |
| 0758286966a54d7995fe6a4313d6a7e1 | heat_stack_user           |
| 0ba19c62ddb142dc97f7c5aec280b3e8 | ResellerAdmin             |
| 2334d7329fff4f38bea61c4da38f67cb | swiftoperator             |
| 2e062af43a914256842d62416aa05671 | observer                  |
| 59f3d21601314afdb8f40db4a9618911 | key-manager:service-admin |
| 6de779a032ea44348f12c57d6a6cd305 | admin                     |
| 880460a821ca43c2911821331713eb17 | member                    |
| d6287225af4d413eb25e8fd60d28355f | service                   |
| d9bc9c139801496cb0896c5a1157201f | reader                    |
| dd311694ac6444d683c592b3ca9b8aa1 | creator                   |
+----------------------------------+---------------------------+
sh-5.1$ openstack user list
+----------------------------------+-------------------------+
| ID                               | Name                    |
+----------------------------------+-------------------------+
| ed0f9407daaa46b88e5be3b3ace6cbae | admin                   |
| fff5e70aacbe4d38aa75c83de884f71b | aodh                    |
| 619f674cbfad4754a3d67fdd29a08b4f | barbican                |
| ec10c34f19db439fa61149a474082f6a | ceilometer              |
| 158ba042af4c487dba30809d81275956 | cinder                  |
| b9bcf71799d14974b70f95dbb3c0fc70 | cinderv3                |
| 900753f4e34a46c3a101455f375b4ad9 | glance                  |
| 2a7ec3b2495942849ff2a5f8a031a5ec | gnocchi                 |
| e953421206e247309954bb4aae77f282 | heat                    |
| 3f881169d8d04223a8be800ebe105322 | heat_stack_domain_admin |
| bf93e2bedc6644e08590045f55cff2fb | heat-cfn                |
| a3ce7d23c9584da6876d080e7aef75ea | manila                  |
| a640891b86e64a339b9698dc4cc84c1a | manilav2                |
| 7fe50e8b61274aa4942294ab51a4a503 | neutron                 |
| 3f72a5fced0646149e60cceda53a4a84 | nova                    |
| ce987d6b73244a85a4bf19697e0b0129 | swift                   |
| 5d28d947e9f14833aea11a48ecb5d5bd | placement               |
+----------------------------------+-------------------------+
sh-5.1$ 


sh-5.1$ openstack service list
+----------------------------------+-----------+----------------+
| ID                               | Name      | Type           |
+----------------------------------+-----------+----------------+
| 0a056c7037f54efb9e6c2d614984454a | keystone  | identity       |
| 1fd40ca9480f46679c13c70688db7988 | heat-cfn  | cloudformation |
| 48a10ebeffff4b538b575481136efcab | glance    | image          |
| 5487d5fdfea44dca9831bf2e9d867d60 | cinderv3  | volumev3       |
| 5a664ce568124190bbe2d4cc585103e1 | neutron   | network        |
| 5ad1a296ffde40c5b2a948fcf7babb1b | manila    | share          |
| 726c75c2da8445a2b11d2e84281937d5 | placement | placement      |
| 89a69a000be24c98b17e9d2046ebc36b | heat      | orchestration  |
| 960dcf34c280453e94385928ffa0109b | manilav2  | sharev2        |
| 9e092c6a406743228d5cc659990ff1a1 | barbican  | key-manager    |
| fe52772e1b184832b2c64e1e77112126 | nova      | compute        |
+----------------------------------+-----------+----------------+
sh-5.1$ openstack endpoint list
+----------------------------------+-----------+--------------+----------------+---------+-----------+--------------------------------------------------------------------------+
| ID                               | Region    | Service Name | Service Type   | Enabled | Interface | URL                                                                      |
+----------------------------------+-----------+--------------+----------------+---------+-----------+--------------------------------------------------------------------------+
| 0794f91d25ee4b418dcf1a251957c7d4 | regionOne | neutron      | network        | True    | internal  | http://neutron-internal.openstack.svc:9696                               |
| 189173ec9bd648dd9f00c8fec48d70c1 | regionOne | neutron      | network        | True    | public    | http://neutron-public-openstack.apps.ocp.openstack.lab                   |
| 25dc7f94ccec4f9db36627665beae287 | regionOne | glance       | image          | True    | internal  | http://glance-default-internal.openstack.svc:9292                        |
| 27ec0e50d417436d921bb44a1e95c577 | regionOne | manilav2     | sharev2        | True    | internal  | http://manila-internal.openstack.svc:8786/v2                             |
| 2d0f998cb4f2423bb6ee62b13bcf8f96 | regionOne | cinderv3     | volumev3       | True    | internal  | http://cinder-internal.openstack.svc:8776/v3                             |
| 32d2da8cb3b047f7b3c862faa6934d19 | regionOne | nova         | compute        | True    | public    | http://nova-public-openstack.apps.ocp.openstack.lab/v2.1                 |
| 6a981631cf7c4d368cc0dbb92bc7dbdf | regionOne | keystone     | identity       | True    | public    | http://keystone-public-openstack.apps.ocp.openstack.lab                  |
| 6c8c525f323641d0966691f7e576ab4d | regionOne | barbican     | key-manager    | True    | public    | http://barbican-public-openstack.apps.ocp.openstack.lab                  |
| 85a45255cab24655abf8672c51738b03 | regionOne | manilav2     | sharev2        | True    | public    | http://manila-public-openstack.apps.ocp.openstack.lab/v2                 |
| 8ca1ada9562c40fe9034f100018d630e | regionOne | heat         | orchestration  | True    | internal  | http://heat-api-internal.openstack.svc:8004/v1/%(tenant_id)s             |
| 969ade5d328a44f5a1fcff3608d0a7d9 | regionOne | barbican     | key-manager    | True    | internal  | http://barbican-internal.openstack.svc:9311                              |
| 9b59f7b27cb0437ebe545524d53ad204 | regionOne | placement    | placement      | True    | internal  | http://placement-internal.openstack.svc:8778                             |
| 9c6cd80e59b04f798642901546ff8f58 | regionOne | heat-cfn     | cloudformation | True    | internal  | http://heat-cfnapi-internal.openstack.svc:8000/v1                        |
| 9cf8e3d12374408e9d782df4027f5e53 | regionOne | heat-cfn     | cloudformation | True    | public    | http://heat-cfnapi-public-openstack.apps.ocp.openstack.lab/v1            |
| a1330a4e4dab44959c58e894b334f05c | regionOne | manila       | share          | True    | public    | http://manila-public-openstack.apps.ocp.openstack.lab/v1/%(project_id)s  |
| a48b030b8c454c2ea6634799f76bbec0 | regionOne | placement    | placement      | True    | public    | http://placement-public-openstack.apps.ocp.openstack.lab                 |
| a66dd176b89d44c8a334f2665dfb6c3c | regionOne | nova         | compute        | True    | internal  | http://nova-internal.openstack.svc:8774/v2.1                             |
| c76130c687674418af27d185898bfbb8 | regionOne | cinderv3     | volumev3       | True    | public    | http://cinder-public-openstack.apps.ocp.openstack.lab/v3                 |
| cc7898f5a47c44379283ec096f53b4eb | regionOne | glance       | image          | True    | public    | http://glance-default-public-openstack.apps.ocp.openstack.lab            |
| d07eca2e79f0463b92f2bc8c043117c9 | regionOne | keystone     | identity       | True    | internal  | http://keystone-internal.openstack.svc:5000                              |
| d2a14be72c9e4dc181b132300e8e0bb1 | regionOne | manila       | share          | True    | internal  | http://manila-internal.openstack.svc:8786/v1/%(project_id)s              |
| e80eab96eea34fbcba718db63bf347aa | regionOne | heat         | orchestration  | True    | public    | http://heat-api-public-openstack.apps.ocp.openstack.lab/v1/%(tenant_id)s |
+----------------------------------+-----------+--------------+----------------+---------+-----------+--------------------------------------------------------------------------+
sh-5.1$ 




