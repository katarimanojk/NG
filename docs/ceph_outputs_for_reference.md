If a customer is doing an upgrade from 16 to 17 and following our docs, then they will pass this override CephConfigPath: /etc/ceph.

In a greenfield deployment CephConfigPath will default to /var/lib/tripleo-config/ceph.

how about  /var/lib/ceph/<fsid>/config






[root@controller-0 ~]# cd /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/
[root@controller-0 e14864ba-e171-552d-864a-db189e445ef5]# ls
alertmanager.controller-0                                                 config               grafana.controller-0         mon.controller-0             selinux
cephadm.7abfde288599583cb2aa3637be9473aff385ca0f20175317016701e3c11901e7  crash                home                         node-exporter.controller-0
cephadm.9518974d361f391a9cd8e84ee824576e0adafec37702a3b8ef9db8bf20c84cfe  crash.controller-0   mds.mds.controller-0.dlqvyc  prometheus.controller-0
cephadm.f80f84ff5bcaa1d0080a0f56e9c4ae88a679c4010ab9e1f9152589097bb7fa0d  custom_config_files  mgr.controller-0.kxazet      rgw.rgw.controller-0.rvqzyt
[root@controller-0 e14864ba-e171-552d-864a-db189e445ef5]# cd config/
[root@controller-0 config]# ls
ceph.client.admin.keyring  ceph.conf
[root@controller-0 config]# pwd
/var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/config
[root@controller-0 config]# ls
ceph.client.admin.keyring  ceph.conf
[root@controller-0 config]# cat ceph.client.admin.keyring 
[client.admin]
        key = AQAkeldmZRvbFxAAIsoi++4vNB44+2z84KpXoQ==
        caps mds = "allow *"
        caps mgr = "allow *"
        caps mon = "allow *"
        caps osd = "allow *"
[root@controller-0 config]# cat ceph.conf 
# minimal ceph.conf for e14864ba-e171-552d-864a-db189e445ef5
[global]
        fsid = e14864ba-e171-552d-864a-db189e445ef5
        mon_host = [v2:172.17.3.79:3300/0,v1:172.17.3.79:6789/0] [v2:172.17.3.39:3300/0,v1:172.17.3.39:6789/0] [v2:172.17.3.132:3300/0,v1:172.17.3.132:6789/0]
[root@controller-0 config]# 






[root@controller-0 config]# cd ../mon.controller-0/
[root@controller-0 mon.controller-0]# ls
config  external_log_to  keyring  kv_backend  min_mon_release  store.db  unit.configured  unit.created  unit.image  unit.meta  unit.poststop  unit.run  unit.stop
[root@controller-0 mon.controller-0]# cat config 
# minimal ceph.conf for e14864ba-e171-552d-864a-db189e445ef5
[global]
        fsid = e14864ba-e171-552d-864a-db189e445ef5
        mon_host = [v2:172.17.3.79:3300/0,v1:172.17.3.79:6789/0] [v2:172.17.3.39:3300/0,v1:172.17.3.39:6789/0] [v2:172.17.3.132:3300/0,v1:172.17.3.132:6789/0]
[mon.controller-0]
public network = 172.17.3.0/24
[root@controller-0 mon.controller-0]# cat keyring 
[mon.]
        key = AQAkeldmSnDaDBAA2QuaAn+wFHWikRhya5A+hQ==
        caps mon = "allow *"
[root@controller-0 mon.controller-0]# 



[root@controller-0 crash.controller-0]# cat config 
# minimal ceph.conf for e14864ba-e171-552d-864a-db189e445ef5
[global]
        fsid = e14864ba-e171-552d-864a-db189e445ef5
        mon_host = [v2:172.17.3.79:3300/0,v1:172.17.3.79:6789/0] [v2:172.17.3.39:3300/0,v1:172.17.3.39:6789/0] [v2:172.17.3.132:3300/0,v1:172.17.3.132:6789/0]
[root@controller-0 crash.controller-0]# cat keyring 
[client.crash.controller-0]
key = AQBJeldmkCe9GhAAwoNon6kSz4K0BRO2dEOeOw==
[root@controller-0 crash.controller-0]# 




# keyrings


[ceph: root@controller-0 /]# ceph auth get client.admin
[client.admin]
        key = AQAkeldmZRvbFxAAIsoi++4vNB44+2z84KpXoQ==
        caps mds = "allow *"
        caps mgr = "allow *"
        caps mon = "allow *"
        caps osd = "allow *"
[ceph: root@controller-0 /]# 



[tripleo-admin@controller-0 ~]$ sudo find / -name *.keyring                                                                                                                                                                                   
/var/lib/containers/storage/overlay/548d34dffce15044e83aca68d1fe338fc3e9f746d71c65657c74a3fcc117c1f9/diff/etc/ceph/ceph.client.crash.controller-0.keyring                                                                                     
/var/lib/containers/storage/overlay/548d34dffce15044e83aca68d1fe338fc3e9f746d71c65657c74a3fcc117c1f9/merged/etc/ceph/ceph.client.crash.controller-0.keyring                                                                                   
/var/lib/containers/storage/overlay/660ef774e929cf39fb67206c13ffcc317d3eab3f71595811a1a92dc64c76a107/diff/etc/ceph/ceph.client.openstack.keyring                                                                                              
/var/lib/containers/storage/overlay/660ef774e929cf39fb67206c13ffcc317d3eab3f71595811a1a92dc64c76a107/diff/etc/ceph/ceph.client.radosgw.keyring                                                                                                
/var/lib/containers/storage/overlay/660ef774e929cf39fb67206c13ffcc317d3eab3f71595811a1a92dc64c76a107/diff/etc/ceph/ceph.client.manila.keyring                                                                                                 
/var/lib/containers/storage/overlay/b142aa377faef3dea96e5c530c2d031cd1e00896db08af2a00f7078473fddec9/diff/etc/ceph/ceph.client.openstack.keyring                                                                                              
/var/lib/containers/storage/overlay/b142aa377faef3dea96e5c530c2d031cd1e00896db08af2a00f7078473fddec9/diff/etc/ceph/ceph.client.radosgw.keyring                                                                                                
/var/lib/containers/storage/overlay/b142aa377faef3dea96e5c530c2d031cd1e00896db08af2a00f7078473fddec9/diff/etc/ceph/ceph.client.manila.keyring                                                                                                 
/var/lib/containers/storage/overlay/b142aa377faef3dea96e5c530c2d031cd1e00896db08af2a00f7078473fddec9/merged/etc/ceph/ceph.client.openstack.keyring                                                                                            
/var/lib/containers/storage/overlay/b142aa377faef3dea96e5c530c2d031cd1e00896db08af2a00f7078473fddec9/merged/etc/ceph/ceph.client.radosgw.keyring                                                                                              
/var/lib/containers/storage/overlay/b142aa377faef3dea96e5c530c2d031cd1e00896db08af2a00f7078473fddec9/merged/etc/ceph/ceph.client.manila.keyring                                                                                               
/var/lib/containers/storage/overlay/adea6fb3598d1ddf0259d93d3ab1d1f7bd0b2725d6d950dffb501cb8fb84a1b6/diff/etc/ceph/ceph.client.openstack.keyring                                                                                              
/var/lib/containers/storage/overlay/adea6fb3598d1ddf0259d93d3ab1d1f7bd0b2725d6d950dffb501cb8fb84a1b6/diff/etc/ceph/ceph.client.radosgw.keyring                                                                                                
/var/lib/containers/storage/overlay/adea6fb3598d1ddf0259d93d3ab1d1f7bd0b2725d6d950dffb501cb8fb84a1b6/diff/etc/ceph/ceph.client.manila.keyring                                                                                                 
/var/lib/containers/storage/overlay/adea6fb3598d1ddf0259d93d3ab1d1f7bd0b2725d6d950dffb501cb8fb84a1b6/merged/etc/ceph/ceph.client.openstack.keyring                                                                                            
/var/lib/containers/storage/overlay/adea6fb3598d1ddf0259d93d3ab1d1f7bd0b2725d6d950dffb501cb8fb84a1b6/merged/etc/ceph/ceph.client.radosgw.keyring                                                                                              
/var/lib/containers/storage/overlay/adea6fb3598d1ddf0259d93d3ab1d1f7bd0b2725d6d950dffb501cb8fb84a1b6/merged/etc/ceph/ceph.client.manila.keyring                                                                                               
/var/lib/containers/storage/overlay/66ee233eda721d8ff0d476650beae32941c9fd6145650bf311f20390b705a474/diff/etc/ceph/ceph.client.openstack.keyring                                                                                              
/var/lib/containers/storage/overlay/66ee233eda721d8ff0d476650beae32941c9fd6145650bf311f20390b705a474/diff/etc/ceph/ceph.client.radosgw.keyring                                                                                                
/var/lib/containers/storage/overlay/66ee233eda721d8ff0d476650beae32941c9fd6145650bf311f20390b705a474/diff/etc/ceph/ceph.client.manila.keyring                                                                                                 
/var/lib/containers/storage/overlay/66ee233eda721d8ff0d476650beae32941c9fd6145650bf311f20390b705a474/merged/etc/ceph/ceph.client.openstack.keyring                                                                                            
/var/lib/containers/storage/overlay/66ee233eda721d8ff0d476650beae32941c9fd6145650bf311f20390b705a474/merged/etc/ceph/ceph.client.radosgw.keyring                                                                                              
/var/lib/containers/storage/overlay/66ee233eda721d8ff0d476650beae32941c9fd6145650bf311f20390b705a474/merged/etc/ceph/ceph.client.manila.keyring                                                                                               
/var/lib/containers/storage/overlay/eec42bac2558689ff2c967c8048875985dfdd10f23e4764ff167dd3c59f44fe9/diff/etc/ceph/ceph.client.openstack.keyring                                                                                              
/var/lib/containers/storage/overlay/eec42bac2558689ff2c967c8048875985dfdd10f23e4764ff167dd3c59f44fe9/diff/etc/ceph/ceph.client.radosgw.keyring                                                                                                
/var/lib/containers/storage/overlay/eec42bac2558689ff2c967c8048875985dfdd10f23e4764ff167dd3c59f44fe9/diff/etc/ceph/ceph.client.manila.keyring                                                                                                 
/var/lib/containers/storage/overlay/eec42bac2558689ff2c967c8048875985dfdd10f23e4764ff167dd3c59f44fe9/merged/etc/ceph/ceph.client.openstack.keyring                                                                                            
/var/lib/containers/storage/overlay/eec42bac2558689ff2c967c8048875985dfdd10f23e4764ff167dd3c59f44fe9/merged/etc/ceph/ceph.client.radosgw.keyring                                                                                              
/var/lib/containers/storage/overlay/eec42bac2558689ff2c967c8048875985dfdd10f23e4764ff167dd3c59f44fe9/merged/etc/ceph/ceph.client.manila.keyring                                                                                               
/var/lib/tripleo-config/ceph/ceph.client.openstack.keyring                                                                                                                                                                                    
/var/lib/tripleo-config/ceph/ceph.client.radosgw.keyring                                                                                                                                                                                      
/var/lib/tripleo-config/ceph/ceph.client.manila.keyring                                                                                                                                                                                       
/var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/config/ceph.client.admin.keyring                                                                                                                                                           
/var/lib/ceph/bootstrap-rgw/ceph.keyring                                                                                                                                                                                                      
/etc/ceph/ceph.client.openstack.keyring                                                                                                                                                                                                       
/etc/ceph/ceph.client.radosgw.keyring                                                                                                                                                                                                         
/etc/ceph/ceph.client.manila.keyring                                                                                                                                                                                                          
/etc/ceph/ceph.client.admin.keyring   


[tripleo-admin@controller-0 ~]$ sudo cat /var/lib/tripleo-config/ceph/ceph.client.openstack.keyring 
[client.openstack]
   key = "AQDfeldmAAAAABAAzggXMcstK/9AMAkJjr3tyw=="
   caps mgr = allow *
   caps mon = profile rbd
   caps osd = profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups
[tripleo-admin@controller-0 ~]$ sudo cat /var/lib/tripleo-config/ceph/ceph.client.radosgw.keyring 
[client.radosgw]
   key = "AQDfeldmAAAAABAAzKLZkW33lrdpJtIm/fM/UA=="
   caps mgr = allow *
   caps mon = allow rw
   caps osd = allow rwx
[tripleo-admin@controller-0 ~]$ sudo cat /var/lib/tripleo-config/ceph/ceph.client.manila.keyring 
[client.manila]
   key = "AQDfeldmAAAAABAAcOMvPwmt1N8CcURIOZ9hzQ=="
   caps mgr = allow rw
   caps mon = allow r
   caps osd = allow rw pool manila_data
[tripleo-admin@controller-0 ~]$ 




[ceph: root@controller-0 /]# ceph auth ls            

mds.mds.controller-0.dlqvyc                    
        key: AQDhfldm+N0nHhAAHXiiGeZzdZOe6JRJW98BEg==
        caps: [mds] allow                            
        caps: [mon] profile mds                
        caps: [osd] allow rw tag cephfs *=*          
mds.mds.controller-1.vaugdh                          
        key: AQDjfldmKRgdMxAAwNQxlrbMYN8a91zNkVvQvw== 
        caps: [mds] allow  
        caps: [mon] profile mds                      
        caps: [osd] allow rw tag cephfs *=*          
mds.mds.controller-2.huqegc          
        key: AQDlfldmmfNaJhAAJZp8wHOg5C5VVFvqGD0V3w==
        caps: [mds] allow        
        caps: [mon] profile mds  
        caps: [osd] allow rw tag cephfs *=*          
osd.0                                                
        key: AQCDeldmvU4JJRAAbFzNWBPahNqe+n2w/L/imA==
        caps: [mgr] allow profile osd
        caps: [mon] allow profile osd
        caps: [osd] allow *                          
osd.1                                
        key: AQCHeldmc0MgEBAAT5JSAohpe0/gO14o3oL1og==
        caps: [mgr] allow profile osd
        caps: [mon] allow profile osd                
        caps: [osd] allow *                          
osd.10                               
        key: AQDWeldmVJOiFxAA1U5YKctqY6cOqOJbRaofyw==
        caps: [mgr] allow profile osd                
        caps: [mon] allow profile osd
        caps: [osd] allow *                          
osd.11                               
        key: AQDZeldmIDYAJxAAJk13wG0NHd+2YG1qU8C2Nw==
        caps: [mgr] allow profile osd
        caps: [mon] allow profile osd
        caps: [osd] allow *               

client.admin
        key: AQAkeldmZRvbFxAAIsoi++4vNB44+2z84KpXoQ==
        caps: [mds] allow *
        caps: [mgr] allow *
        caps: [mon] allow *
        caps: [osd] allow *
client.bootstrap-mds
        key: AQAmeldmBO8uNxAAVZWaLThgsuFMFE4x9GPVUA==
        caps: [mon] allow profile bootstrap-mds
client.bootstrap-mgr
        key: AQAmeldmRvsuNxAAqqA27jOk7TdxQGLpjMfysQ==
        caps: [mon] allow profile bootstrap-mgr
client.bootstrap-osd
        key: AQAmeldmbgUvNxAAAv2rQjUtMNgRXTJMjPDwjQ==
        caps: [mon] allow profile bootstrap-osd
client.bootstrap-rbd
        key: AQAmeldmRhEvNxAAybjNrmZlnspw5w3XKzxieA==
        caps: [mon] allow profile bootstrap-rbd
client.bootstrap-rbd-mirror
        key: AQAmeldmhxsvNxAAdH7xMcGFsVAzv826vuW4sw==
        caps: [mon] allow profile bootstrap-rbd-mirror
client.bootstrap-rgw
        key: AQAmeldmvyYvNxAA0zrcRYcINk+Sv39qOfud5A==
        caps: [mon] allow profile bootstrap-rgw
client.crash.cephstorage-0
        key: AQB/eldmAkIGChAAh5qZgKnlN6ilsjm2CSyejw==
        caps: [mgr] profile crash
        caps: [mon] profile crash
client.crash.cephstorage-1
        key: AQDHeldmQLRCNRAAG8IGN0OqMQA/yqxn6rOYLA==
        caps: [mgr] profile crash
        caps: [mon] profile crash
client.crash.cephstorage-2
        key: AQDKeldmJS1EGBAA4g2TLmNzsR2GNFTf23g+Kw==
        caps: [mgr] profile crash
        caps: [mon] profile crash
client.crash.controller-0
        key: AQBJeldmkCe9GhAAwoNon6kSz4K0BRO2dEOeOw==
        caps: [mgr] profile crash
        caps: [mon] profile crash
client.crash.controller-1
        key: AQB7eldm6XaPNhAAGOXMaU8KWMTr0pFHuth3Lw==
        caps: [mgr] profile crash
        caps: [mon] profile crash
client.crash.controller-2
        key: AQB9eldmk1ZfIxAAvbbUjnonwf0PT8n61YIlFQ==
        caps: [mgr] profile crash
        caps: [mon] profile crash
client.manila
        key: AQDfeldmAAAAABAAcOMvPwmt1N8CcURIOZ9hzQ==
        caps: [mgr] allow rw
        caps: [mon] allow r
        caps: [osd] allow rw pool manila_data

client.openstack
        key: AQDfeldmAAAAABAAzggXMcstK/9AMAkJjr3tyw==
        caps: [mgr] allow *
        caps: [mon] profile rbd
        caps: [osd] profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups
client.radosgw
        key: AQDfeldmAAAAABAAzKLZkW33lrdpJtIm/fM/UA==
        caps: [mgr] allow *
        caps: [mon] allow rw
        caps: [osd] allow rwx
client.rgw.controller-0
        key: AQDCgldmcSbiMhAAEFN2gvKrHj7yJK/PQm1fRw==
        caps: [mon] allow rw
        caps: [osd] allow rwx
client.rgw.rgw.controller-0.rvqzyt
        key: AQDafldmeNO0DhAAsmkDUT7p2fCY6duyMdQunQ==
        caps: [mgr] allow rw
        caps: [mon] allow *
        caps: [osd] allow rwx tag rgw *=*
client.rgw.rgw.controller-1.irpzpt
        key: AQDcfldmEktHFhAAaYhR9NG3RetY1qfH2sRNBQ==
        caps: [mgr] allow rw
        caps: [mon] allow *
        caps: [osd] allow rwx tag rgw *=*
client.rgw.rgw.controller-2.jaqzdb
        key: AQDefldmsylLBxAAAyyn+VdcxU1BeEYax1/lWA==
        caps: [mgr] allow rw
        caps: [mon] allow *
        caps: [osd] allow rwx tag rgw *=*
mgr.controller-0.kxazet
        key: AQAkeldmKVk6IxAAjCb11MEA90p0zxjvXAa/mA==
        caps: [mds] allow *
        caps: [mon] profile mgr
        caps: [osd] allow *
mgr.controller-1.auuiew
        key: AQB1eldmQ984BRAAGw1grwYrgONNk3ESw8YKVA==
        caps: [mds] allow *
        caps: [mon] profile mgr
        caps: [osd] allow *
mgr.controller-2.ipoxll
        key: AQB2eldm6T3HIRAAECCSWkduQBAq30cwYKQgqQ==
        caps: [mds] allow *
        caps: [mon] profile mgr
        caps: [osd] allow *




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



