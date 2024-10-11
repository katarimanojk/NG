before migration

[zuul@osp-controller-3d8cr9wp-0 ~]$ sudo cephadm shell -- ceph config dump | grep dashboard
Inferring fsid 75a90c59-7a90-5d73-9daa-0d8136ed6ae0
Inferring config /var/lib/ceph/75a90c59-7a90-5d73-9daa-0d8136ed6ae0/mon.osp-controller-3d8cr9wp-0/config
Using ceph image with id '11fbfe5b88bc' and tag 'latest' created on 2025-02-17 23:37:48 +0000 UTC
registry.redhat.io/rhceph/rhceph-7-rhel9@sha256:74f12deed91db0e478d5801c08959e451e0dbef427497badef7a2d8829631882
mgr                                                    advanced  mgr/dashboard/ALERTMANAGER_API_HOST                         http://172.18.0.103:9093                                          * 
mgr                                                    advanced  mgr/dashboard/GRAFANA_API_PASSWORD                          7LEhs2HRbkkkLJID9HDksw8tl                                         * 
mgr                                                    advanced  mgr/dashboard/GRAFANA_API_SSL_VERIFY                        false                                                             * 
mgr                                                    advanced  mgr/dashboard/GRAFANA_API_URL                               https://172.18.0.105:3100                                         * 
mgr                                                    advanced  mgr/dashboard/GRAFANA_API_USERNAME                          admin                                                             * 
mgr                                                    advanced  mgr/dashboard/PROMETHEUS_API_HOST                           http://172.18.0.150:9092                                          * 
mgr                                                    advanced  mgr/dashboard/osp-controller-3d8cr9wp-0.jejpdr/server_addr  172.18.0.103                                                      * 
mgr                                                    advanced  mgr/dashboard/osp-controller-3d8cr9wp-1.fakucs/server_addr  172.18.0.104                                                      * 
mgr                                                    advanced  mgr/dashboard/osp-controller-3d8cr9wp-2.smftir/server_addr  172.18.0.105                                                      * 
mgr                                                    advanced  mgr/dashboard/server_port                                   8444                                                              * 
mgr                                                    advanced  mgr/dashboard/ssl                                           false                                                             * 
mgr                                                    advanced  mgr/dashboard/ssl_server_port                               8444                                                              * 



after migration

[zuul@osp-controller-3d8cr9wp-0 ~]$ sudo cephadm shell -- ceph config dump | grep dashboard
Inferring fsid 75a90c59-7a90-5d73-9daa-0d8136ed6ae0
Inferring config /var/lib/ceph/75a90c59-7a90-5d73-9daa-0d8136ed6ae0/config/ceph.conf
Using ceph image with id '11fbfe5b88bc' and tag 'latest' created on 2025-02-17 23:37:48 +0000 UTC
registry.redhat.io/rhceph/rhceph-7-rhel9@sha256:74f12deed91db0e478d5801c08959e451e0dbef427497badef7a2d8829631882
mgr                                                    advanced  mgr/dashboard/ALERTMANAGER_API_HOST                         http://172.18.0.108:9093                                          * 
mgr                                                    advanced  mgr/dashboard/GRAFANA_API_PASSWORD                          7LEhs2HRbkkkLJID9HDksw8tl                                         * 
mgr                                                    advanced  mgr/dashboard/GRAFANA_API_SSL_VERIFY                        false                                                             * 
mgr                                                    advanced  mgr/dashboard/GRAFANA_API_URL                               https://172.18.0.106:3100                                         * 
mgr                                                    advanced  mgr/dashboard/GRAFANA_API_USERNAME                          admin                                                             * 
mgr                                                    advanced  mgr/dashboard/PROMETHEUS_API_HOST                           http://172.18.0.107:9092                                          * 
mgr                                                    advanced  mgr/dashboard/RGW_API_ACCESS_KEY                            ZZOZRW2BMCELY0MQT59F                                              * 
mgr                                                    advanced  mgr/dashboard/RGW_API_SECRET_KEY                            HDC72jd5bCZxiY5JkGRqnd6m9AjHSPd09CJFx4sh                          * 
mgr                                                    advanced  mgr/dashboard/osp-controller-3d8cr9wp-0.jejpdr/server_addr  172.18.0.103                                                      * 
mgr                                                    advanced  mgr/dashboard/osp-controller-3d8cr9wp-1.fakucs/server_addr  172.18.0.104                                                      * 
mgr                                                    advanced  mgr/dashboard/osp-controller-3d8cr9wp-2.smftir/server_addr  172.18.0.105                                                      * 
mgr                                                    advanced  mgr/dashboard/server_port                                   8443                                                              * 
mgr                                                    advanced  mgr/dashboard/ssl                                           false                                                             * 
mgr                                                    advanced  mgr/dashboard/ssl_server_port                               8443                                                              * 
[zuul@osp-controller-3d8cr9wp-0 ~]$ sudo cephadm shell -- ceph config dump | less




[zuul@osp-compute-3d8cr9wp-0 ~]$ ansible-playbook -v test_dashboard.yaml 
Using /etc/ansible/ansible.cfg as config file
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [test] **********************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Validate connection to dashboard service] **********************************************************************************************************************************************************************************************
ok: [localhost] => {"attempts": 1, "changed": false, "checksum_dest": "f601961e9e151f916f141ae1de5ddc73d8fa8b23", "checksum_src": "f601961e9e151f916f141ae1de5ddc73d8fa8b23", "dest": "/tmp/dash_response", "elapsed": 0, "failed_when_result": false, "gid": 1000, "group": "zuul", "md5sum": "5c93bd511f2bd647067f50f8e1783249", "mode": "0644", "msg": "OK (17189 bytes)", "owner": "zuul", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 17189, "src": "/home/zuul/.ansible/tmp/ansible-tmp-1743088633.8363945-204948-60050633541792/tmp_6g3v8xc", "state": "file", "status_code": 200, "uid": 1000, "url": "http://172.18.0.106:8443"}

TASK [Check http response code from dashboard service with login] ****************************************************************************************************************************************************************************
changed: [localhost] => {"attempts": 1, "changed": true, "checksum_dest": null, "checksum_src": "f601961e9e151f916f141ae1de5ddc73d8fa8b23", "dest": "/tmp/dash_http_response", "elapsed": 0, "failed_when_result": false, "gid": 1000, "group": "zuul", "md5sum": "5c93bd511f2bd647067f50f8e1783249", "mode": "0644", "msg": "OK (17189 bytes)", "owner": "zuul", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 17189, "src": "/home/zuul/.ansible/tmp/ansible-tmp-1743088634.716974-204964-93340699658884/tmpjpjrt1n6", "state": "file", "status_code": 200, "uid": 1000, "url": "http://172.18.0.106:8443"}

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

[zuul@osp-compute-3d8cr9wp-0 ~]$ 




[ceph: root@osp-compute-3d8cr9wp-0 /]# ceph orch ps
NAME                                              HOST                                PORTS                   STATUS         REFRESHED  AGE  MEM USE  MEM LIM  VERSION           IMAGE ID      CONTAINER ID  
alertmanager.osp-compute-3d8cr9wp-2               osp-compute-3d8cr9wp-2.example.com  172.18.0.108:9093,9094  running (58m)     4m ago  67m    25.0M        -  0.26.0            89643d4ace3e  b23ffee66983  
crash.osp-compute-3d8cr9wp-0                      osp-compute-3d8cr9wp-0.example.com                          running (3h)      4m ago   3h    6903k        -  18.2.1-298.el9cp  11fbfe5b88bc  79bda7fa3f5b  
crash.osp-compute-3d8cr9wp-1                      osp-compute-3d8cr9wp-1.example.com                          running (3h)      4m ago   3h    6895k        -  18.2.1-298.el9cp  11fbfe5b88bc  2006073030ff  
crash.osp-compute-3d8cr9wp-2                      osp-compute-3d8cr9wp-2.example.com                          running (3h)      4m ago   3h    6895k        -  18.2.1-298.el9cp  11fbfe5b88bc  7aa843c309bb  
grafana.osp-compute-3d8cr9wp-0                    osp-compute-3d8cr9wp-0.example.com  172.18.0.106:3100       running (63m)     4m ago  67m    78.8M        -  10.4.8            724afa652534  507c4eb027c9  
haproxy.ingress.osp-compute-3d8cr9wp-0.knwsjk     osp-compute-3d8cr9wp-0.example.com  *:8080,8989             running (58m)     4m ago  65m    9.78M        -  2.4.22-f8e3218    c430935d1e55  c11588a02356  
haproxy.ingress.osp-compute-3d8cr9wp-1.hnruer     osp-compute-3d8cr9wp-1.example.com  *:8080,8989             running (58m)     4m ago  65m    9.78M        -  2.4.22-f8e3218    c430935d1e55  71d998e8a7bc  
keepalived.ingress.osp-compute-3d8cr9wp-0.puzxyd  osp-compute-3d8cr9wp-0.example.com                          running (65m)     4m ago  65m    1824k        -  2.2.8             7638eeff3c3d  e3cfed641e56  
keepalived.ingress.osp-compute-3d8cr9wp-1.tfwlbp  osp-compute-3d8cr9wp-1.example.com                          running (64m)     4m ago  64m    1828k        -  2.2.8             7638eeff3c3d  64ff4fc191c8  
mds.mds.osp-compute-3d8cr9wp-0.ziklne             osp-compute-3d8cr9wp-0.example.com                          running (66m)     4m ago  66m    28.4M        -  18.2.1-298.el9cp  11fbfe5b88bc  cbfb28e9f424  
mds.mds.osp-compute-3d8cr9wp-1.eusvbx             osp-compute-3d8cr9wp-1.example.com                          running (66m)     4m ago  66m    27.5M        -  18.2.1-298.el9cp  11fbfe5b88bc  ca2918cbf63d  
mds.mds.osp-compute-3d8cr9wp-2.edzbip             osp-compute-3d8cr9wp-2.example.com                          running (66m)     4m ago  66m    30.8M        -  18.2.1-298.el9cp  11fbfe5b88bc  9fb467839a17  
mgr.osp-compute-3d8cr9wp-0.sjkzpf                 osp-compute-3d8cr9wp-0.example.com  *:8443,9283,8765        running (64m)     4m ago  64m     534M        -  18.2.1-298.el9cp  11fbfe5b88bc  5d727123ba3b  
mgr.osp-compute-3d8cr9wp-1.hxfqsn                 osp-compute-3d8cr9wp-1.example.com  *:8443,9283,8765        running (64m)     4m ago  64m     454M        -  18.2.1-298.el9cp  11fbfe5b88bc  f93741256021  
mgr.osp-compute-3d8cr9wp-2.fhhgzj                 osp-compute-3d8cr9wp-2.example.com  *:8443,9283,8765        running (64m)     4m ago  64m     454M        -  18.2.1-298.el9cp  11fbfe5b88bc  e505b9d5facc  
mon.osp-compute-3d8cr9wp-0                        osp-compute-3d8cr9wp-0.example.com                          running (62m)     4m ago  62m     165M    2048M  18.2.1-298.el9cp  11fbfe5b88bc  f4e0e0c98ef7  
mon.osp-compute-3d8cr9wp-1                        osp-compute-3d8cr9wp-1.example.com                          running (60m)     4m ago  60m     147M    2048M  18.2.1-298.el9cp  11fbfe5b88bc  0abf699749cf  
mon.osp-compute-3d8cr9wp-2                        osp-compute-3d8cr9wp-2.example.com                          running (58m)     4m ago  58m     105M    2048M  18.2.1-298.el9cp  11fbfe5b88bc  b6b841847bd2  
node-exporter.osp-compute-3d8cr9wp-0              osp-compute-3d8cr9wp-0.example.com  172.18.0.106:9100       running (3h)      4m ago   3h    21.1M        -  1.4.0             c34478ecb587  9b31b1b483c3  
node-exporter.osp-compute-3d8cr9wp-1              osp-compute-3d8cr9wp-1.example.com  172.18.0.107:9100       running (3h)      4m ago   3h    26.2M        -  1.4.0             c34478ecb587  462d54689655  
node-exporter.osp-compute-3d8cr9wp-2              osp-compute-3d8cr9wp-2.example.com  172.18.0.108:9100       running (3h)      4m ago   3h    23.2M        -  1.4.0             c34478ecb587  90e4a47aec13  
osd.0                                             osp-compute-3d8cr9wp-0.example.com                          running (3h)      4m ago   3h     109M    4096M  18.2.1-298.el9cp  11fbfe5b88bc  a10dbcf0b556  
osd.1                                             osp-compute-3d8cr9wp-1.example.com                          running (3h)      4m ago   3h     108M    4096M  18.2.1-298.el9cp  11fbfe5b88bc  65b16ab07f76  
osd.2                                             osp-compute-3d8cr9wp-2.example.com                          running (3h)      4m ago   3h     132M    4096M  18.2.1-298.el9cp  11fbfe5b88bc  a45cadfad2e1  
osd.3                                             osp-compute-3d8cr9wp-0.example.com                          running (3h)      4m ago   3h     133M    4096M  18.2.1-298.el9cp  11fbfe5b88bc  b3bf8f8d73b4  
osd.4                                             osp-compute-3d8cr9wp-1.example.com                          running (3h)      4m ago   3h     115M    4096M  18.2.1-298.el9cp  11fbfe5b88bc  175ee729841c  
osd.5                                             osp-compute-3d8cr9wp-2.example.com                          running (3h)      4m ago   3h     105M    4096M  18.2.1-298.el9cp  11fbfe5b88bc  e473a5cd84c8  
osd.6                                             osp-compute-3d8cr9wp-0.example.com                          running (3h)      4m ago   3h     103M    4096M  18.2.1-298.el9cp  11fbfe5b88bc  61895d32ca73  
osd.7                                             osp-compute-3d8cr9wp-1.example.com                          running (3h)      4m ago   3h     104M    4096M  18.2.1-298.el9cp  11fbfe5b88bc  4a48641a95d4  
osd.8                                             osp-compute-3d8cr9wp-2.example.com                          running (3h)      4m ago   3h     106M    4096M  18.2.1-298.el9cp  11fbfe5b88bc  45e420cab7c7  
prometheus.osp-compute-3d8cr9wp-1                 osp-compute-3d8cr9wp-1.example.com  172.18.0.107:9092       running (56m)     4m ago  66m    86.9M        -  2.48.0            ab845acdca6f  d97867015910  


