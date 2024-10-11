Testing the manual doc:

PR : https://github.com/openstack-k8s-operators/data-plane-adoption/pull/818

netapp storage from uni02 beta greenfield job : https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/blob/main/scenarios/uni/uni02beta/04-scenario-vars.yaml?ref_type=heads


[zuul@shark19 manoj]$ oc apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  labels:
    service: cinder
    component: cinder-volume
  name: cinder-volume-ontap-secrets
type: Opaque
stringData:
  ontap-cinder-secrets: |
    [ontap-nfs]
    netapp_login= vsadmin
    netapp_password= qum5net
    netapp_vserver= ntap-rhv-dev-rhos
    nas_host= 10.46.29.88
    nas_share_path=/cinder_nfs
    netapp_pool_name_search_pattern=(cinder_volumes)
EOF
secret/cinder-volume-ontap-secrets created
[zuul@shark19 manoj]$ oc get secret/cinder-volume-ontap-secrets
NAME                          TYPE     DATA   AGE
cinder-volume-ontap-secrets   Opaque   1      8s
[zuul@shark19 manoj]$ oc get secret/cinder-volume-ontap-secrets -o yaml | less
[zuul@shark19 manoj]$ oc get secret/cinder-volume-ontap-secrets -o yaml
apiVersion: v1
data:
  ontap-cinder-secrets: W29udGFwLW5mc10KbmV0YXBwX2xvZ2luPSB2c2FkbWluCm5ldGFwcF9wYXNzd29yZD0gcXVtNW5ldApuZXRhcHBfdnNlcnZlcj0gbnRhcC1yaHYtZGV2LXJob3MKbmFzX2hvc3Q9IDEwLjQ2LjI5Ljg4Cm5hc19zaGFyZV9wYXRoPS9jaW5kZXJfbmZzCm5ldGFwcF9wb29sX25hbWVfc2VhcmNoX3BhdHRlcm49KGNpbmRlcl92b2x1bWVzKQo=
kind: Secret
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Secret","metadata":{"annotations":{},"labels":{"component":"cinder-volume","service":"cinder"},"name":"cinder-volume-ontap-secrets","namespace":"openstack"},"stringData":{"ontap-cinder-secrets":"[ontap-nfs]\nnetapp_login= vsadmin\nnetapp_password= qum5net\nnetapp_vserver= ntap-rhv-dev-rhos\nnas_host= 10.46.29.88\nnas_share_path=/cinder_nfs\nnetapp_pool_name_search_pattern=(cinder_volumes)\n"},"type":"Opaque"}
  creationTimestamp: "2025-02-25T06:20:16Z"
  labels:
    component: cinder-volume
    service: cinder
  name: cinder-volume-ontap-secrets
  namespace: openstack
  resourceVersion: "6483132"
  uid: 981fd37f-634d-46dc-9081-ec3bdf3ddc38
type: Opaque
[zuul@shark19 manoj]$ 


# before deploying netapp

[zuul@shark19 manoj]$ oc get pods | grep cinder
cinder-api-0                                                    2/2     Running     0          4d15h
cinder-backup-0                                                 2/2     Running     0          4d15h
cinder-db-purge-29004481-8c7gs                                  0/1     Completed   0          2d6h
cinder-db-purge-29005921-l8zkw                                  0/1     Completed   0          30h
cinder-db-purge-29007361-vmddl                                  0/1     Completed   0          6h20m
cinder-scheduler-0                                              2/2     Running     0          4d15h
cinder-volume-lvm-iscsi-0                                       2/2     Running     0          4d15h
[zuul@shark19 manoj]$ 

[zuul@shark19 manoj]$ oc rsh openstackclient openstack volume service list
+------------------+-------------------------------+------+---------+-------+----------------------------+
| Binary           | Host                          | Zone | Status  | State | Updated At                 |
+------------------+-------------------------------+------+---------+-------+----------------------------+
| cinder-backup    | cinder-backup-0               | nova | enabled | up    | 2025-02-25T06:23:13.000000 |
| cinder-scheduler | cinder-scheduler-0            | nova | enabled | up    | 2025-02-25T06:23:10.000000 |
| cinder-volume    | cinder-volume-lvm-iscsi-0@lvm | nova | enabled | up    | 2025-02-25T06:23:16.000000 |
+------------------+-------------------------------+------+---------+-------+----------------------------+
[zuul@shark19 manoj]$ 


# deploy netapp

[zuul@shark19 manoj]$ cat cinder_NetappNFS.patch 
spec:
  cinder:
    enabled: true
    template:
      cinderVolumes:
        ontap-nfs:
          networkAttachments:
            - storage
          customServiceConfig: |
            [ontap-nfs]
            volume_backend_name=ontap-nfs
            volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
            nfs_snapshot_support=true
            nas_secure_file_operations=false
            nas_secure_file_permissions=false
            netapp_server_hostname= netapp_backendip
            netapp_server_port=80
            netapp_storage_protocol=nfs
            netapp_storage_family=ontap_cluster
          customServiceConfigSecrets:
          - cinder-volume-ontap-secrets
[zuul@shark19 manoj]$





[zuul@shark19 manoj]$ oc patch openstackcontrolplane openstack --type=merge --patch-file=cinder_NetappNFS.patch
openstackcontrolplane.core.openstack.org/openstack patched
[zuul@shark19 manoj]$ 
[zuul@shark19 manoj]$ oc get pods | grep cinder
cinder-api-0                                                    2/2     Running     0          4d16h
cinder-backup-0                                                 2/2     Running     0          4d16h
cinder-db-purge-29004481-8c7gs                                  0/1     Completed   0          2d6h
cinder-db-purge-29005921-l8zkw                                  0/1     Completed   0          30h
cinder-db-purge-29007361-vmddl                                  0/1     Completed   0          6h37m
cinder-scheduler-0                                              2/2     Running     0          4d16h
cinder-volume-lvm-iscsi-0                                       2/2     Running     0          4d16h
cinder-volume-ontap-nfs-0                                       1/2     Running     0          8s
[zuul@shark19 manoj]$







[zuul@shark19 manoj]$ oc rsh openstackclient openstack volume service list
+------------------+-------------------------------------+------+---------+-------+----------------------------+
| Binary           | Host                                | Zone | Status  | State | Updated At                 |
+------------------+-------------------------------------+------+---------+-------+----------------------------+
| cinder-backup    | cinder-backup-0                     | nova | enabled | up    | 2025-02-25T06:39:23.000000 |
| cinder-scheduler | cinder-scheduler-0                  | nova | enabled | up    | 2025-02-25T06:39:20.000000 |
| cinder-volume    | cinder-volume-lvm-iscsi-0@lvm       | nova | enabled | up    | 2025-02-25T06:39:16.000000 |
| cinder-volume    | cinder-volume-ontap-nfs-0@ontap-nfs | nova | enabled | up    | 2025-02-25T06:38:16.000000 |
+------------------+-------------------------------------+------+---------+-------+----------------------------+
[zuul@shark19 manoj]$ 



[zuul@shark19 manoj]$ oc rsh cinder-volume-ontap-nfs-0
Defaulted container "cinder-volume" out of: cinder-volume, probe
sh-5.1# cd /etc/cinder/cinder.conf.d/
sh-5.1# ls
00-global-defaults.conf  01-service-defaults.conf  02-global-custom.conf  03-service-custom.conf  04-service-custom-secrets.conf
sh-5.1# cat 03-service-custom.conf 
[DEFAULT]
enabled_backends=ontap-nfs
[ontap-nfs]
volume_backend_name=ontap-nfs
volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
nfs_snapshot_support=true
nas_secure_file_operations=false
nas_secure_file_permissions=false
netapp_server_hostname=10.46.29.74
netapp_server_port=80
netapp_storage_protocol=nfs
netapp_storage_family=ontap_cluster
sh-5.1# cat 04-service-custom-secrets.conf
[ontap-nfs]
netapp_login= vsadmin
netapp_password= qum5net
netapp_vserver= ntap-rhv-dev-rhos
nas_host= 10.46.29.88
nas_share_path=/cinder_nfs
netapp_pool_name_search_pattern=(cinder_volumes)

sh-5.1# 

oc logs -f cinder-volume-ontap-nfs-0




2025-02-25 07:03:28.385 963387 ERROR os_brick.remotefs.remotefs [None req-37844e8c-0a58-4243-88b3-cbd2ce2d2182 - - - - - -] Failed to mount 10.46.29.88:/cinder_nfs, reason: mount.nfs: access denied by server while mounting 10.46.29.88:/ci
nder_nfs
: oslo_concurrency.processutils.ProcessExecutionError: Unexpected error while running command.
2025-02-25 07:03:28.386 963387 DEBUG os_brick.remotefs.remotefs [None req-37844e8c-0a58-4243-88b3-cbd2ce2d2182 - - - - - -] Failed to do nfs mount. _mount_nfs /usr/lib/python3.9/site-packages/os_brick/remotefs/remotefs.py:157
2025-02-25 07:03:28.386 963387 DEBUG cinder.volume.drivers.nfs [None req-37844e8c-0a58-4243-88b3-cbd2ce2d2182 - - - - - -] Mount attempt 0 failed: NFS mount failed for share 10.46.29.88:/cinder_nfs. Error - {'pnfs': "Unexpected error whil
e running command.\nCommand: mount -t nfs -o vers=4,minorversion=1 10.46.29.88:/cinder_nfs /var/lib/cinder/mnt/de7de858b94dc496d8c1a0c52a2c79a8\nExit code: 32\nStdout: ''\nStderr: 'mount.nfs: access denied by server while mounting 10.46.2
9.88:/cinder_nfs\\n'", 'nfs': "Unexpected error while running command.\nCommand: mount -t nfs 10.46.29.88:/cinder_nfs /var/lib/cinder/mnt/de7de858b94dc496d8c1a0c52a2c79a8\nExit code: 32\nStdout: ''\nStderr: 'mount.nfs: access denied by se
rver while mounting 10.46.29.88:/cinder_nfs\\n'"}.






2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager [None req-37844e8c-0a58-4243-88b3-cbd2ce2d2182 - - - - - -] Failed to initialize driver.: cinder.exception.NfsNoSharesMounted: No mounted NFS shares found                         
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager Traceback (most recent call last):                                                                                                                                                 
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager   File "/usr/lib/python3.9/site-packages/cinder/volume/manager.py", line 524, in _init_host
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager     self.driver.do_setup(ctxt)                                                                                                                                                     
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager   File "/usr/lib/python3.9/site-packages/cinder/volume/volume_utils.py", line 1565, in trace_method_logging_wrapper
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager     return f(*args, **kwargs)                                                                                                                                                      
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager   File "/usr/lib/python3.9/site-packages/cinder/volume/volume_utils.py", line 1565, in trace_method_logging_wrapper                                                    
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager     return f(*args, **kwargs)                                                                                                                                                      
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager   File "/usr/lib/python3.9/site-packages/cinder/volume/drivers/netapp/dataontap/nfs_cmode.py", line 89, in do_setup
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager     super(NetAppCmodeNfsDriver, self).do_setup(context)                                                                                                                            
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager   File "/usr/lib/python3.9/site-packages/cinder/volume/volume_utils.py", line 1565, in trace_method_logging_wrapper                                                                
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager     return f(*args, **kwargs)                                                                                                                                                      
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager   File "/usr/lib/python3.9/site-packages/cinder/volume/drivers/netapp/dataontap/nfs_base.py", line 92, in do_setup                                                                 
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager     super(NetAppNfsDriver, self).do_setup(context)                                                                                                                                 
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager   File "/usr/lib/python3.9/site-packages/cinder/volume/drivers/nfs.py", line 222, in do_setup
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager     self.set_nas_security_options(self._is_voldb_empty_at_startup)
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager   File "/usr/lib/python3.9/site-packages/cinder/volume/drivers/nfs.py", line 433, in set_nas_security_options                                                                      
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager     raise exception.NfsNoSharesMounted()                                                                                                                                           
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager cinder.exception.NfsNoSharesMounted: No mounted NFS shares found                                                                                                                   
2025-02-25 07:03:54.079 963387 ERROR cinder.volume.manager                                                            



[zuul@shark19 manoj]$ oc describe po cinder-volume-ontap-nfs-0
. 
.
Events:
  Type     Reason          Age                    From               Message
  ----     ------          ----                   ----               -------
  Normal   Scheduled       32m                    default-scheduler  Successfully assigned openstack/cinder-volume-ontap-nfs-0 to rhoso-ctlplane-0.openshift.local
  Normal   AddedInterface  32m                    multus             Add eth0 [10.132.0.70/23] from ovn-kubernetes
  Normal   AddedInterface  32m                    multus             Add storage [172.18.0.35/24] from openstack/storage
  Normal   Pulling         32m                    kubelet            Pulling image "registry.redhat.io/rhoso/openstack-cinder-volume-rhel9@sha256:47b19d993bdfc790c508861dbcc87f0ec51302db8975698af8e1476a0f5209c7"
  Normal   Started         32m                    kubelet            Started container probe
  Normal   Pulled          32m                    kubelet            Container image "registry.redhat.io/rhoso/openstack-cinder-volume-rhel9@sha256:47b19d993bdfc790c508861dbcc87f0ec51302db8975698af8e1476a0f5209c7" already present on machine
  Normal   Created         32m                    kubelet            Created container probe
  Normal   Pulled          32m                    kubelet            Successfully pulled image "registry.redhat.io/rhoso/openstack-cinder-volume-rhel9@sha256:47b19d993bdfc790c508861dbcc87f0ec51302db8975698af8e1476a0f5209c7" in 3.419s (3.419s including waiting)
  Normal   Created         25m (x3 over 32m)      kubelet            Created container cinder-volume
  Normal   Started         25m (x3 over 32m)      kubelet            Started container cinder-volume
  Normal   Killing         22m (x3 over 28m)      kubelet            Container cinder-volume failed liveness probe, will be restarted
  Normal   Pulled          22m (x3 over 28m)      kubelet            Container image "registry.redhat.io/rhoso/openstack-cinder-volume-rhel9@sha256:47b19d993bdfc790c508861dbcc87f0ec51302db8975698af8e1476a0f5209c7" already present on machine
  Warning  Unhealthy       5m57s (x22 over 28m)   kubelet            Liveness probe failed: HTTP probe failed with statuscode: 500
  Warning  BackOff         2m6s (x20 over 5m46s)  kubelet            Back-off restarting failed container cinder-volume in pod cinder-volume-ontap-nfs-0_openstack(5e085b75-bcce-45f8-b15b-b2019e4715fc)










after updating the secrets and netapp for a different TLV netapp server



note: editing the same secret didnt update the cinder .conf, even after patching the ctlplane CR with netapp, delete the pod etc
so i create a new secret cinder-volume-ontap-nfs-secrets, updated the same in ctlplane CR


https://paste.opendev.org/show/bncaM0Wr2n5YpCJ0URn5/  has all the below conent


# before deploying netapp

[zuul@shark19 manoj]$ oc get pods | grep cinder
cinder-api-0                                                    2/2     Running     0          4d15h
cinder-backup-0                                                 2/2     Running     0          4d15h
cinder-db-purge-29004481-8c7gs                                  0/1     Completed   0          2d6h
cinder-db-purge-29005921-l8zkw                                  0/1     Completed   0          30h
cinder-db-purge-29007361-vmddl                                  0/1     Completed   0          6h20m
cinder-scheduler-0                                              2/2     Running     0          4d15h
cinder-volume-lvm-iscsi-0                                       2/2     Running     0          4d15h
[zuul@shark19 manoj]$ 

[zuul@shark19 manoj]$ oc rsh openstackclient openstack volume service list
+------------------+-------------------------------+------+---------+-------+----------------------------+
| Binary           | Host                          | Zone | Status  | State | Updated At                 |
+------------------+-------------------------------+------+---------+-------+----------------------------+
| cinder-backup    | cinder-backup-0               | nova | enabled | up    | 2025-02-25T06:23:13.000000 |
| cinder-scheduler | cinder-scheduler-0            | nova | enabled | up    | 2025-02-25T06:23:10.000000 |
| cinder-volume    | cinder-volume-lvm-iscsi-0@lvm | nova | enabled | up    | 2025-02-25T06:23:16.000000 |
+------------------+-------------------------------+------+---------+-------+----------------------------+
[zuul@shark19 manoj]$ 



# deploy netapp

[zuul@shark19 manoj]$ oc apply -f - <<EOF                                                                              
apiVersion: v1                                                                                                         
kind: Secret                                                                                                           
metadata:                                                                                                              
  labels:                                                                                                              
    service: cinder                                                                                                    
    component: cinder-volume                                                                                           
  name: cinder-volume-ontap-nfs-secrets                                                                                
type: Opaque                                                                                                           
stringData:                                                                                                            
  ontap-cinder-secrets: |                                                                                              
    [ontap-nfs]                                            
    netapp_login= cifmw_user                               
    netapp_password= Qum!8netd
    netapp_vserver= vserver-rhos-qe
    nas_host= 10.46.246.60                                 
    nas_share_path=/cinder_nfs
    netapp_pool_name_search_pattern=(cinder_nfs)
EOF                                                        
secret/cinder-volume-ontap-nfs-secrets created




[zuul@shark19 manoj]$ oc get secret/cinder-volume-ontap-nfs-secrets -o yaml
apiVersion: v1
data:
  ontap-cinder-secrets: W29udGFwLW5mc10KbmV0YXBwX2xvZ2luPSBjaWZtd191c2VyCm5ldGFwcF9wYXNzd29yZD0gUXVtIThuZXRkCm5ldGFwcF92c2VydmVyPSB2c2VydmVyLXJob3MtcWUKbmFzX2hvc3Q9IDEwLjQ2LjI0Ni42MApuYXNfc2hhcmVfcGF0aD0vY2luZGVyX25mcwpuZXRhcHBfcG9vbF9uYW1lX3NlYXJjaF9wYXR0ZXJuPShjaW5kZXJfbmZzKQo=
kind: Secret
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Secret","metadata":{"annotations":{},"labels":{"component":"cinder-volume","service":"cinder"},"name":"cinder-volume-ontap-nfs-secrets","namespace":"openstack"},"stringData":{"ontap-cinder-secrets":"[ontap-nfs]\nnetapp_login= cifmw_user\nnetapp_password= Qum!8netd\nnetapp_vserver= vserver-rhos-qe\nnas_host= 10.46.246.60\nnas_share_path=/cinder_nfs\nnetapp_pool_name_search_pattern=(cinder_nfs)\n"},"type":"Opaque"}
  creationTimestamp: "2025-02-25T12:56:41Z"
  labels:
    component: cinder-volume
    service: cinder
  name: cinder-volume-ontap-nfs-secrets
  namespace: openstack
  resourceVersion: "6861232"
  uid: 5093ee29-6357-4773-adae-47147bdfc950
type: Opaque





[zuul@shark19 manoj]$ cat cinder_NetappNFS.patch 
spec:
  cinder:
    enabled: true
    template:
      cinderVolumes:
        ontap-nfs:
          networkAttachments:
            - storage
          customServiceConfig: |
            [ontap-nfs]
            volume_backend_name=ontap-nfs
            volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
            nfs_snapshot_support=true
            nas_secure_file_operations=false
            nas_secure_file_permissions=false
            netapp_server_hostname=10.46.84.4
            netapp_server_port=80
            netapp_storage_protocol=nfs
            netapp_storage_family=ontap_cluster
          customServiceConfigSecrets:
          - cinder-volume-ontap-nfs-secrets
[zuul@shark19 manoj]$




[zuul@shark19 manoj]$ oc patch openstackcontrolplane openstack --type=merge --patch-file=cinder_NetappNFS.patch
openstackcontrolplane.core.openstack.org/openstack patched




[zuul@shark19 manoj]$  oc get pods | grep cinder
cinder-api-0                                                    2/2     Running     0          5d
cinder-backup-0                                                 2/2     Running     0          5d
cinder-db-purge-29004481-8c7gs                                  0/1     Completed   0          2d15h
cinder-db-purge-29005921-l8zkw                                  0/1     Completed   0          39h
cinder-db-purge-29007361-vmddl                                  0/1     Completed   0          15h
cinder-scheduler-0                                              2/2     Running     0          5d
cinder-volume-lvm-iscsi-0                                       2/2     Running     0          5d
cinder-volume-ontap-nfs-0                                       2/2     Running     0          147m

[zuul@shark19 manoj]$ oc rsh openstackclient openstack volume service list
+------------------+-------------------------------------+------+---------+-------+----------------------------+
| Binary           | Host                                | Zone | Status  | State | Updated At                 |
+------------------+-------------------------------------+------+---------+-------+----------------------------+
| cinder-backup    | cinder-backup-0                     | nova | enabled | up    | 2025-02-25T15:26:36.000000 |
| cinder-scheduler | cinder-scheduler-0                  | nova | enabled | up    | 2025-02-25T15:26:38.000000 |
| cinder-volume    | cinder-volume-lvm-iscsi-0@lvm       | nova | enabled | up    | 2025-02-25T15:26:37.000000 |
| cinder-volume    | cinder-volume-ontap-nfs-0@ontap-nfs | nova | enabled | up    | 2025-02-25T15:26:37.000000 |
+------------------+-------------------------------------+------+---------+-------+----------------------------+
[zuul@shark19 manoj]$ 




[zuul@shark19 ~]$ oc rsh cinder-volume-ontap-nfs-0 cat /etc/cinder/cinder.conf.d/03-service-custom.conf
Defaulted container "cinder-volume" out of: cinder-volume, probe
[DEFAULT]
enabled_backends=ontap-nfs
[ontap-nfs]
volume_backend_name=ontap-nfs
volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
nfs_snapshot_support=true
nas_secure_file_operations=false
nas_secure_file_permissions=false
netapp_server_hostname=10.46.84.4
netapp_server_port=80
netapp_storage_protocol=nfs
netapp_storage_family=ontap_cluster
[zuul@shark19 ~]$ 

[zuul@shark19 ~]$ oc rsh cinder-volume-ontap-nfs-0 cat /etc/cinder/cinder.conf.d/04-service-custom-secrets.conf
Defaulted container "cinder-volume" out of: cinder-volume, probe
[ontap-nfs]
netapp_login= cifmw_user
netapp_password= Qum!8netd
netapp_vserver= vserver-rhos-qe
nas_host= 10.46.246.60
nas_share_path=/cinder_nfs
netapp_pool_name_search_pattern=(cinder_nfs)



i also see the mounts

[zuul@shark19 ~]$ oc rsh cinder-volume-ontap-nfs-0 mount | grep cinder
Defaulted container "cinder-volume" out of: cinder-volume, probe
tmpfs on /etc/cinder/cinder.conf.d type tmpfs (ro,relatime,seclabel,size=31713336k,inode64)
/dev/vda4 on /var/lib/cinder type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,prjquota)
/dev/vda4 on /var/locks/openstack/cinder type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,prjquota)

10.46.246.60:/cinder_nfs on /var/lib/cinder/mnt/7ff28a46339f6cd32165cef2ec9fb1eb type nfs4 (rw,relatime,vers=4.1,rsize=65536,wsize=65536,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=10.132.1.18,local_lock=none,addr=10.46.246.60)
[zuul@shark19 ~]$ 



#oc logs -f cinder-volume-ontap-nfs-0

2025-02-25 12:59:18.156 2369758 INFO cinder.volume.manager [None req-cbf4c700-1c79-4205-9f84-1075cd08eba3 - - - - - -] Initializing RPC dependent components of volume driver NetAppCmodeNfsDriver (3.0.0)                                    2025-02-25 12:59:18.156 2369758 DEBUG cinder.volume.drivers.netapp.dataontap.nfs_cmode [None req-cbf4c700-1c79-4205-9f84-1075cd08eba3 - - - - - -] Updating volume stats _update_volume_stats /usr/lib/python3.9/site-packages/cinder/volume/d
rivers/netapp/dataontap/nfs_cmode.py:325                                                                                                                                                                                                      
2025-02-25 12:59:34.504 2369758 INFO cinder.volume.manager [None req-cbf4c700-1c79-4205-9f84-1075cd08eba3 - - - - - -] Driver post RPC initialization completed successfully. 




[zuul@shark19 manoj]$ oc rsh openstackclient openstack volume type create netapp_nfs_type
+-------------+--------------------------------------+
| Field       | Value                                |
+-------------+--------------------------------------+
| description | None                                 |
| id          | 761d0350-02bb-4346-a5d6-ddc14bc2f8c8 |
| is_public   | True                                 |
| name        | netapp_nfs_type                      |
+-------------+--------------------------------------+



[zuul@shark19 manoj]$ oc rsh openstackclient openstack volume type set --property "volume_backend_name=ontap-nfs" netapp_nfs_type
[zuul@shark19 manoj]$ oc rsh openstackclient openstack volume type show netapp_nfs_type
+--------------------+--------------------------------------+
| Field              | Value                                |
+--------------------+--------------------------------------+
| access_project_ids | None                                 |
| description        | None                                 |
| id                 | 761d0350-02bb-4346-a5d6-ddc14bc2f8c8 |
| is_public          | True                                 |
| name               | netapp_nfs_type                      |
| properties         | volume_backend_name='ontap-nfs'      |
| qos_specs_id       | None                                 |
+--------------------+--------------------------------------+
(reverse-i-search)`create': oc rsh openstackclient openstack volume type ^Ceate netapp_nfs_type
[zuul@shark19 manoj]$ oc rsh openstackclient openstack volume create --type netapp_nfs_type --size 1 netapp_nfs_vol1
+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| attachments         | []                                   |
| availability_zone   | nova                                 |
| bootable            | false                                |
| consistencygroup_id | None                                 |
| created_at          | 2025-02-25T13:04:31.455358           |
| description         | None                                 |
| encrypted           | False                                |
| id                  | 0ec7d6c3-cf87-45f2-9fa6-ecc7391d17d0 |
| migration_status    | None                                 |
| multiattach         | False                                |
| name                | netapp_nfs_vol1                      |
| properties          |                                      |
| replication_status  | None                                 |
| size                | 1                                    |
| snapshot_id         | None                                 |
| source_volid        | None                                 |
| status              | creating                             |
| type                | netapp_nfs_type                      |
| updated_at          | None                                 |
| user_id             | b5f8e8d627584e21b96b18c59f0954f8     |
+---------------------+--------------------------------------+


#oc logs -f cinder-volume-ontap-nfs-0


2025-02-25 13:04:32.733 2369758 DEBUG cinder.volume.manager [None req-c1abfa11-0ae0-40fe-bc35-85a81ee2146b b5f8e8d627584e21b96b18c59f0954f8 4fec8dd4454a40a0b22a0cf1e50caee5 - - - -] Task 'cinder.volume.flows.manager.create_volume.CreateVo
lumeOnFinishTask;volume:create, create.end' (ad44a091-74df-41e1-ac43-3d7c495592d2) transitioned into state 'SUCCESS' from state 'RUNNING' with result 'None' _task_receiver /usr/lib/python3.9/site-packages/taskflow/listeners/logging.py:178
2025-02-25 13:04:32.738 2369758 DEBUG cinder.volume.manager [None req-c1abfa11-0ae0-40fe-bc35-85a81ee2146b b5f8e8d627584e21b96b18c59f0954f8 4fec8dd4454a40a0b22a0cf1e50caee5 - - - -] Flow 'volume_create_manager' (ea0833ba-c6c5-49db-a1b2-66
69c083d1ff) transitioned into state 'SUCCESS' from state 'RUNNING' _flow_receiver /usr/lib/python3.9/site-packages/taskflow/listeners/logging.py:141
2025-02-25 13:04:32.747 2369758 INFO cinder.volume.manager [None req-c1abfa11-0ae0-40fe-bc35-85a81ee2146b b5f8e8d627584e21b96b18c59f0954f8 4fec8dd4454a40a0b22a0cf1e50caee5 - - - -] Created volume successfully.


[zuul@shark19 manoj]$ oc rsh openstackclient openstack volume list
+--------------------------------------+-----------------+-----------+------+-------------+
| ID                                   | Name            | Status    | Size | Attached to |
+--------------------------------------+-----------------+-----------+------+-------------+
| 0ec7d6c3-cf87-45f2-9fa6-ecc7391d17d0 | netapp_nfs_vol1 | available |    1 |             |
| 7b3e01fc-f38c-4136-b81d-0ac88e68d41c | lvm_volume_2    | error     |    1 |             |
| 0951a0b7-eea1-4184-87bc-d902ed78068d | lvm_volume_1    | error     |    1 |             |
+--------------------------------------+-----------------+-----------+------+-------------+
[zuul@shark19 manoj]$ 



















