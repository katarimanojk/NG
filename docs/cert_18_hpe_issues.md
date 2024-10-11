# post rhoso with multipathd, oc get pvc shows rhoso-cert-cinder pvc pending , 

[root@rhel92-ocp-vm rhoso-cert]# oc get pvc
NAME                                       STATUS    VOLUME                                     CAPACITY    ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
mysql-db-openstack-cell1-galera-0          Bound     pvc-a45bad2a-20fa-43f3-ad36-aab3fd5da8de   4882816Ki   RWO            lvms-vg1       <unset>                 4d20h
mysql-db-openstack-galera-0                Bound     pvc-00dbfbaa-1e8c-4fb1-935a-aa84f78eb8cd   4882816Ki   RWO            lvms-vg1       <unset>                 4d20h
ovndbcluster-nb-etc-ovn-ovsdbserver-nb-0   Bound     pvc-5fe698aa-49f8-4f80-a3eb-ab58048a3f76   9765628Ki   RWO            lvms-vg1       <unset>                 4d19h
ovndbcluster-nb-etc-ovn-ovsdbserver-nb-1   Bound     pvc-d0678e10-499a-4bd7-8586-37361b4fe712   9765628Ki   RWO            lvms-vg1       <unset>                 4d19h
ovndbcluster-nb-etc-ovn-ovsdbserver-nb-2   Bound     pvc-761db1ce-d93d-43e0-a871-f52d6ca5f5ab   9765628Ki   RWO            lvms-vg1       <unset>                 4d19h
ovndbcluster-sb-etc-ovn-ovsdbserver-sb-0   Bound     pvc-0606e705-8a07-40df-b760-0d1cddf00e8b   9765628Ki   RWO            lvms-vg1       <unset>                 4d19h
persistence-rabbitmq-cell1-server-0        Bound     pvc-eb5eaefc-8d5b-4068-844d-8995594a37a0   10Gi        RWO            lvms-vg1       <unset>                 4d19h
persistence-rabbitmq-server-0              Bound     pvc-59f25c48-ccf8-49cf-b2e3-9570f249f9b8   10Gi        RWO            lvms-vg1       <unset>                 4d19h
rhoso-cert-cinder-0-5b842                  Pending                                                                         lvms-vg1       <unset>                 2m48s
swift-swift-storage-0                      Bound     pvc-14c9ecec-b3f9-48db-b22e-2f09dd897fe6   10Gi        RWO            lvms-vg1       <unset>                 4d20h



# what they say:

The rhoso-cert-cinder pvc is always in "pending" state when the multipath-machineconfig is applied to the OCP cluster. rhoso-cert is in hung state until it is terminated forcefully.
I went ahead and deleted the multipath-machineconfig CR and after this, the pvc is bound and the rhoso-cert runs. The logs attached above are run with multipath-machineconfig being deleted.



# what i heard from alan before he went on pto:

- hpe has some cinder fixe backported and they are waiting for them to be published, meanwhile they wanted to do dry-run

- storageclss fix is rhoso-cert tool is not published, javed and team published the release
   - alan updated the fix in hpe directly

- test-operator is updated, instead of main storageclass, they have it in workflow, 

  it was using the default storage class (localstorage)
   persistence-rabbitmq-server-2              Bound     pvc-5e3a2ded-86cb-4ff6-a677-4c88ea47ecc5   10Gi        RWO            lvms-vg1        <unset>                 19d
   rhoso-cert-cinder-0-d5343                  Pending                                                                         local-storage   <unset>                 3d21h
   swift-swift-storage-0                      Bound     pvc-4d965025-68ab-4e3a-9253-53a0ec6df143   10Gi        RWO            lvms-vg1        <unset>     
   
   issue in test-operator:
    resources and storageclass parameter value in the main section is not considered if worflow pod doesn't mention it (uses the worflow's default i.e local_storage/resources)
    https://issues.redhat.com/browse/OSPRH-16131
    https://issues.redhat.com/browse/OSPRH-17024
  
   - it won't impact hpe as alan patched rhoso-cert-cinder.yaml (mentioned lvms storage class in cinder workflow)
   - if they use latest test-operator (which has fix), they need not use the patched rhoso-cert-cinder.yaml
      fix : make sure the main section is considered by removing the default values of every workflow.

# AI

 - resolve pv pending issue
   - used master multiconfig config instead of worker helped creating multipath.conf and systemd servie
      - not needed as we generally run on workers only
   - but still pvc claim issue is there

- why lvms and not the local storage ?
   - multipath support is not there in localstorage
    Local Storage = static, simple, manual, good for basic cases
    LVMS = dynamic, LVM-managed, more flexible for production    

- i tried lvms storage class in install_yamls
   make lvms
   make lvms_deploy

[zuul@shark19 install_yamls]$  oc get lvmcluster -n openshift-storage
NAME         STATUS
lvmcluster   Ready



- how did lvms-operator is deployed ?
    ImageSetConfiguration CR for LVM Storage
    Policy CR to install and configure LVM Storage ?
    LVMCluster CR YAML file 
