
[ceph: root@compute-0 /]# ceph orch ls
NAME                     PORTS                 RUNNING  REFRESHED  AGE  PLACEMENT                      
alertmanager             ?:9093,9094               1/1  6m ago     23m  compute-0;count:1              
crash                                              3/3  8m ago     25m  *                              
grafana                  ?:3000                    1/1  6m ago     23m  compute-0;count:1              
ingress.nfs.cephfs       172.18.0.2:2049,9049      6/6  8m ago     22m  compute-0;compute-1;compute-2  
ingress.rgw.default      172.18.0.2:8080,8999      2/2  6m ago     23m  count:1                        
mds.cephfs                                         3/3  8m ago     22m  compute-0;compute-1;compute-2  
mgr                                                3/3  8m ago     25m  compute-0;compute-1;compute-2  
mon                                                3/3  8m ago     25m  compute-0;compute-1;compute-2  
nfs.cephfs               ?:12049                   3/3  8m ago     22m  compute-0;compute-1;compute-2  
node-exporter            ?:9100                    3/3  8m ago     23m  *                              
node-proxy                                         0/0  -          25m  *                              
osd.default_drive_group                              3  8m ago     25m  compute-0;compute-1;compute-2  
prometheus               ?:9095                    1/1  6m ago     23m  compute-0;count:1              
rgw.rgw                  ?:8082                    3/3  8m ago     21m  compute-0;compute-1;compute-2  



