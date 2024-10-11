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

#ceph orch ps
Inferring fsid 279c19fd-1e4a-535c-a07a-ae91b536ab3e
Inferring config /var/lib/ceph/279c19fd-1e4a-535c-a07a-ae91b536ab3e/mon.controller-0/config
Using ceph image with id '1af7b794f353' and tag '6-199' created on 2023-07-26 19:11:48 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:aa68701446f0401dd61a46ae1486e7eb50d56d744ed22d99fef51c6c3d8aa8d7
NAME                         HOST           PORTS                   STATUS         REFRESHED  AGE  MEM USE  MEM LIM  VERSION           IMAGE ID      CONTAINER ID  
alertmanager.controller-0    controller-0   172.17.3.68:9093,9094   running (19h)     5m ago  19h    36.9M        -  0.23.0            5ad97095676e  7451530e52ae  
alertmanager.controller-1    controller-1   172.17.3.136:9093,9094  running (19h)     5m ago  19h    31.3M        -  0.23.0            5ad97095676e  50b86eedd124  
alertmanager.controller-2    controller-2   172.17.3.96:9093,9094   running (19h)     5m ago  19h    31.9M        -  0.23.0            5ad97095676e  2b7d5793f197  
crash.cephstorage-0          cephstorage-0                          running (20h)     6m ago  20h    6895k        -  17.2.6-100.el9cp  1af7b794f353  1efbe350ad11  
crash.cephstorage-1          cephstorage-1                          running (20h)     6m ago  20h    6899k        -  17.2.6-100.el9cp  1af7b794f353  6c5c964f85e1  
crash.cephstorage-2          cephstorage-2                          running (20h)     6m ago  20h    6899k        -  17.2.6-100.el9cp  1af7b794f353  74e5e719db1c  
crash.controller-0           controller-0                           running (20h)     5m ago  20h    6899k        -  17.2.6-100.el9cp  1af7b794f353  96e58a44930d  
crash.controller-1           controller-1                           running (20h)     5m ago  20h    6895k        -  17.2.6-100.el9cp  1af7b794f353  5160f5c792d4  
crash.controller-2           controller-2                           running (20h)     5m ago  20h    6903k        -  17.2.6-100.el9cp  1af7b794f353  1a5ecb60686c  
grafana.controller-0         controller-0   172.17.3.68:3100        running (19h)     5m ago  19h    79.9M        -  <unknown>         9926ad0ec67e  7909f339631b  
grafana.controller-1         controller-1   172.17.3.136:3100       running (19h)     5m ago  19h    90.3M        -  <unknown>         9926ad0ec67e  aa9e188a10ce  
grafana.controller-2         controller-2   172.17.3.96:3100        running (19h)     5m ago  19h    89.9M        -  <unknown>         9926ad0ec67e  8732739559e9  
mds.mds.controller-0.rlehnz  controller-0                           running (19h)     5m ago  19h    25.0M        -  17.2.6-100.el9cp  1af7b794f353  e40bbffa29e8  
mds.mds.controller-1.wbuwog  controller-1                           running (19h)     5m ago  19h    26.0M        -  17.2.6-100.el9cp  1af7b794f353  9aa5736ab00d  
mds.mds.controller-2.aqqkoo  controller-2                           running (19h)     5m ago  19h    38.3M        -  17.2.6-100.el9cp  1af7b794f353  3a02e9fb251a  
mgr.controller-0.nrbaoj      controller-0   *:9283                  running (20h)     5m ago  20h     548M        -  17.2.6-100.el9cp  1af7b794f353  a93e2686bd1e  
mgr.controller-1.amtdus      controller-1                           running (20h)     5m ago  20h     413M        -  17.2.6-100.el9cp  1af7b794f353  b5237bfac398  
mgr.controller-2.scllhx      controller-2                           running (20h)     5m ago  20h     412M        -  17.2.6-100.el9cp  1af7b794f353  2c2d12806077  
mon.controller-0             controller-0                           running (20h)     5m ago  20h     414M    2048M  17.2.6-100.el9cp  1af7b794f353  23eeb201e1d7  
mon.controller-1             controller-1                           running (20h)     5m ago  20h     407M    2048M  17.2.6-100.el9cp  1af7b794f353  55bebfa7a54e  
mon.controller-2             controller-2                           running (20h)     5m ago  20h     404M    2048M  17.2.6-100.el9cp  1af7b794f353  a65d19ae68b9  
node-exporter.cephstorage-0  cephstorage-0  172.17.3.29:9100        running (19h)     6m ago  19h    20.4M        -  1.3.1             c5fea2f9a0cd  c85c109225a9  
node-exporter.cephstorage-1  cephstorage-1  172.17.3.45:9100        running (19h)     6m ago  19h    19.5M        -  1.3.1             c5fea2f9a0cd  c601816e1f6f  
node-exporter.cephstorage-2  cephstorage-2  172.17.3.117:9100       running (19h)     6m ago  19h    23.2M        -  1.3.1             c5fea2f9a0cd  96cc22ffe1c9  
node-exporter.controller-0   controller-0   172.17.3.68:9100        running (19h)     5m ago  19h    31.9M        -  1.3.1             c5fea2f9a0cd  d341ce184925  
node-exporter.controller-1   controller-1   172.17.3.136:9100       running (19h)     5m ago  19h    29.1M        -  1.3.1             c5fea2f9a0cd  f65b415e49ce  
node-exporter.controller-2   controller-2   172.17.3.96:9100        running (19h)     5m ago  19h    28.7M        -  1.3.1             c5fea2f9a0cd  b5e1357cd1ee  
osd.0                        cephstorage-0                          running (20h)     6m ago  20h     425M    4096M  17.2.6-100.el9cp  1af7b794f353  e39c91c81483  
osd.1                        cephstorage-2                          running (20h)     6m ago  20h     540M    4096M  17.2.6-100.el9cp  1af7b794f353  3779e9fc44e2  
osd.2                        cephstorage-1                          running (20h)     6m ago  20h     463M    4096M  17.2.6-100.el9cp  1af7b794f353  7166e9cb64ac  
osd.3                        cephstorage-0                          running (20h)     6m ago  20h     364M    4096M  17.2.6-100.el9cp  1af7b794f353  ab0499372065  
osd.4                        cephstorage-2                          running (20h)     6m ago  20h     538M    4096M  17.2.6-100.el9cp  1af7b794f353  7b8657193dbf  
osd.5                        cephstorage-1                          running (20h)     6m ago  20h     377M    4096M  17.2.6-100.el9cp  1af7b794f353  a49049378ac5  
osd.6                        cephstorage-0                          running (20h)     6m ago  20h     520M    4096M  17.2.6-100.el9cp  1af7b794f353  19faa14d063b  
osd.7                        cephstorage-2                          running (20h)     6m ago  20h     419M    4096M  17.2.6-100.el9cp  1af7b794f353  8750192067fa  
osd.8                        cephstorage-1                          running (20h)     6m ago  20h     419M    4096M  17.2.6-100.el9cp  1af7b794f353  3eaf803f2b95  
osd.9                        cephstorage-0                          running (20h)     6m ago  20h     501M    4096M  17.2.6-100.el9cp  1af7b794f353  cb2f22bcd9c4  
osd.10                       cephstorage-2                          running (20h)     6m ago  20h     506M    4096M  17.2.6-100.el9cp  1af7b794f353  d31c6e6cef50  
osd.11                       cephstorage-1                          running (20h)     6m ago  20h     387M    4096M  17.2.6-100.el9cp  1af7b794f353  927d8f7c9d80  
osd.12                       cephstorage-0                          running (20h)     6m ago  20h     486M    4096M  17.2.6-100.el9cp  1af7b794f353  8199b68b8422  
osd.13                       cephstorage-2                          running (20h)     6m ago  20h     315M    4096M  17.2.6-100.el9cp  1af7b794f353  0b93cf0fd857  
osd.14                       cephstorage-1                          running (20h)     6m ago  20h     442M    4096M  17.2.6-100.el9cp  1af7b794f353  d93d03e9928d  
prometheus.controller-0      controller-0   172.17.3.68:9092        running (19h)     5m ago  19h     115M        -  2.32.1            eed6d68641e2  7a2f347b7d49  
prometheus.controller-1      controller-1   172.17.3.136:9092       running (19h)     5m ago  19h     120M        -  2.32.1            eed6d68641e2  152ec93b2035  
prometheus.controller-2      controller-2   172.17.3.96:9092        running (19h)     5m ago  19h     113M        -  2.32.1            eed6d68641e2  62ff04e99814  
rgw.rgw.controller-0.xbducv  controller-0   172.17.3.68:8080        running (19h)     5m ago  19h     121M        -  17.2.6-100.el9cp  1af7b794f353  086c490398c6  
rgw.rgw.controller-1.vimmbn  controller-1   172.17.3.136:8080       running (19h)     5m ago  19h     118M        -  17.2.6-100.el9cp  1af7b794f353  c246a41501db  
rgw.rgw.controller-2.nmspiy  controller-2   172.17.3.96:8080        running (19h)     5m ago  19h     119M        -  17.2.6-100.el9cp  1af7b794f353  b14b4215bb19  

