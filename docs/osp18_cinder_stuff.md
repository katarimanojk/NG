# cinder rbd configuration:

- generate the CR that configures cinder to use ceph rbd
oc kustomize https://github.com/openstack-k8s-operators/cinder-operator.git/config/samples/backends/ceph?ref=main > ~/cinder-rbd.yaml

- redeploy ctlplane and also apply the CR 
OPENSTACK_CR=~/cinder-rbd.yaml.yaml make openstack_deploy



[zuul@controller-0 openstack]$ oc get pods -l service=cinder
NAME                             READY   STATUS      RESTARTS   AGE
cinder-api-0                     2/2     Running     0          48d
cinder-api-1                     2/2     Running     0          48d
cinder-api-2                     2/2     Running     0          23d
cinder-backup-0                  2/2     Running     0          7d3h
cinder-backup-1                  2/2     Running     0          48d
cinder-backup-2                  2/2     Running     0          48d
cinder-db-purge-28693441-xtj98   0/1     Completed   0          2d13h
cinder-db-purge-28694881-qzv9b   0/1     Completed   0          37h
cinder-db-purge-28696321-dv8l6   0/1     Completed   0          13h
cinder-scheduler-0               2/2     Running     0          48d
cinder-volume-ceph-0             2/2     Running     0          48d
[zuul@controller-0 openstack]$ 



[zuul@controller-0 openstack]$ oc rsh cinder-volume-ceph-0
(or)
oc -n openstack exec cinder-volume-ceph-0 -c cinder-volume --stdin --tty -- /bin/bash



sh-5.1# vi etc/cinder/cinder.conf.d/
00-global-defaults.conf          01-service-defaults.conf         02-global-custom.conf            03-service-custom.conf           04-service-custom-secrets.conf   ..2024_06_05_14_03_47.879861832/ ..data/
sh-5.1# vi etc/cinder/cinder.conf.d/



sh-5.1# cat etc/cinder/cinder.conf.d/03-service-custom.conf
[DEFAULT]
enabled_backends=ceph
[ceph]
volume_backend_name=ceph
volume_driver=cinder.volume.drivers.rbd.RBDDriver
rbd_flatten_volume_from_snapshot=False
rbd_pool=vckendcinder_volume_backendolumes
_/etc/ceph/ceph.conf
rbd_user=openstack
rbd_secret_uuid=ae5ea249-6fd7-51ba-824e-2d3cba90c7ef


[zuul@controller-0 ci-framework]$  oc -n openstack rsh openstackclient openstack volume service list
+------------------+---------------------------------+------+---------+-------+----------------------------+
| Binary           | Host                            | Zone | Status  | State | Updated At                 |
+------------------+---------------------------------+------+---------+-------+----------------------------+
| cinder-scheduler | cinder-ba2c6-scheduler-0        | nova | enabled | up    | 2024-10-08T07:02:16.000000 |
| cinder-backup    | cinder-ba2c6-backup-0           | nova | enabled | up    | 2024-10-08T07:02:13.000000 |
| cinder-volume    | cinder-ba2c6-volume-ceph-0@ceph | nova | enabled | up    | 2024-10-08T07:02:14.000000 |
| cinder-backup    | cinder-ba2c6-backup-1           | nova | enabled | up    | 2024-10-08T07:02:20.000000 |
| cinder-backup    | cinder-ba2c6-backup-2           | nova | enabled | up    | 2024-10-08T07:02:20.000000 |
+------------------+---------------------------------+------+---------+-------+----------------------------+
[zuul@controller-0 ci-framework]$ 




# edit the cinder conf by partner

oc edit openstackcontrolplane and no restart required


mkatari@dell-7625-02 ~]$ oc edit openstackcontrolplane
openstackcontrolplane.core.openstack.org/openstack edited
[mkatari@dell-7625-02 ~]$ oc edit openstackcontrolplane^C

CinderVolumes:
        ceph-rbd:
          customServiceConfig: |
            [ceph]
            volume_backend_name=ceph
            volume_driver=cinder.volume.drivers.rbd.RBDDriver
            rbd_ceph_conf=/etc/ceph/ceph.conf
            rbd_user=openstack
            rbd_pool=volumes
            rbd_flatten_volume_from_snapshot=False
            report_discard_supported=True
          replicas: 1
          resources: {}



[mkatari@dell-7625-02 ~]$ oc rsh openstackclient
sh-5.1$ openstack volume service list
+------------------+-------------------------------+------+---------+-------+----------------------------+
| Binary           | Host                          | Zone | Status  | State | Updated At                 |
+------------------+-------------------------------+------+---------+-------+----------------------------+
| cinder-scheduler | cinder-scheduler-0            | nova | enabled | up    | 2024-09-26T12:17:07.000000 |
| cinder-backup    | cinder-backup-0               | nova | enabled | up    | 2024-09-26T12:17:11.000000 |
| cinder-volume    | cinder-volume-lvm-iscsi-0@lvm | nova | enabled | up    | 2024-09-26T12:17:14.000000 |
| cinder-volume    | cinder-volume-ceph-rbd-0@ceph | nova | enabled | up    | 2024-09-26T12:16:50.000000 |
+------------------+-------------------------------+------+---------+-------+----------------------------+
sh-5.1$ 


eg2:

[zuul@shark19 ~]$ oc rsh openstackclient openstack volume service list
+------------------+-------------------------------+------+---------+-------+----------------------------+       
| Binary           | Host                          | Zone | Status  | State | Updated At                 |       
+------------------+-------------------------------+------+---------+-------+----------------------------+       
| cinder-backup    | cinder-backup-0               | nova | enabled | up    | 2025-01-23T09:51:58.000000 |       
| cinder-scheduler | cinder-scheduler-0            | nova | enabled | up    | 2025-01-23T09:51:59.000000 |       
| cinder-volume    | cinder-volume-lvm-iscsi-0@lvm | nova | enabled | up    | 2025-01-23T09:52:00.000000 |       
+------------------+-------------------------------+------+---------+-------+----------------------------+  


[zuul@shark19 ~]$ cat ~/manoj/cinder_netapp_nfs.yaml                                                                   
spec:                                                                                                                  
  cinder:                                                                                                              
    template:                                                                                                          
      cinderVolumes:                                                                                                   
        ontap-nfs:                                                                                                     
          networkAttachments:                                                                                          
            - storage                                                                                                  
          customServiceConfig: |                                                                                       
            [nfs_netapp]                                                                                               
            volume_backend_name=nfs_netapp                                                                             
            volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver                         
            nfs_snapshot_support=true                                                                                  
            nas_secure_file_operations=false                                                                           
            nas_secure_file_permissions=false                                                                          
            netapp_server_hostname=hostname                                                                            
            netapp_server_port=80                                                                                      
            netapp_storage_protocol=nfs                                                                                
            netapp_storage_family=ontap_cluste

[zuul@shark19 ~]$ oc patch openstackcontrolplane openstack --type=merge --patch-file=/home/zuul/manoj/cinder_netapp_nfs.yaml
openstackcontrolplane.core.openstack.org/openstack patched                                                             
[zuul@shark19 ~]$



[zuul@shark19 ~]$ oc rsh openstackclient openstack volume service list
+------------------+--------------------------------------+------+---------+-------+----------------------------+
| Binary           | Host                                 | Zone | Status  | State | Updated At                 |
+------------------+--------------------------------------+------+---------+-------+----------------------------+
| cinder-backup    | cinder-backup-0                      | nova | enabled | up    | 2025-01-23T09:52:18.000000 |
| cinder-scheduler | cinder-scheduler-0                   | nova | enabled | up    | 2025-01-23T09:52:19.000000 |
| cinder-volume    | cinder-volume-lvm-iscsi-0@lvm        | nova | enabled | up    | 2025-01-23T09:52:20.000000 |
| cinder-volume    | cinder-volume-ontap-nfs-0@nfs_netapp | nova | enabled | up    | 2025-01-23T09:52:08.000000 |
+------------------+--------------------------------------+------+---------+-------+----------------------------+
[zuul@shark19 ~]$ oc get pods | grep cinder-volume
cinder-volume-lvm-iscsi-0                                       2/2     Running     0          110m
cinder-volume-ontap-nfs-0                                       2/2     Running     0          56s
[zuul@shark19 ~]$ 


[zuul@shark19 ~]$ oc rsh cinder-volume-ontap-nfs-0
Defaulted container "cinder-volume" out of: cinder-volume, probe
sh-5.1# cat /etc/cinder/cinder.conf.d/
00-global-defaults.conf          01-service-defaults.conf         02-global-custom.conf            03-service-custom.conf           04-service-custom-secrets.conf   ..2025_01_23_09_51_48.213476518/ ..data/
sh-5.1# cat /etc/cinder/cinder.conf.d/03-service-custom.conf 
[DEFAULT]
enabled_backends=nfs_netapp
[nfs_netapp]
volume_backend_name=nfs_netapp
volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
nfs_snapshot_support=true
nas_secure_file_operations=false
nas_secure_file_permissions=false
netapp_server_hostname=hostname
netapp_server_port=80
netapp_storage_protocol=nfs
netapp_storage_family=ontap_cluster
sh-5.1# 



# adoption impact

database migration



# must-gather:

namespaces/openstack/CRS
 - cinders.cinder.openstack.org/cinder.yaml  is the main CR that takes care of all other cinder services.

namespaces/openstack/secrets
 - secrets/cinder/cinder-volume-ceph-config-data.yaml


# CR hierarchy

pod
  -> replicaset
            -> openstackctlplane cr i



# misc


