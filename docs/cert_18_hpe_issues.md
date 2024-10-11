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
   Entire stps followed by hpe: https://paste.opendev.org/show/bGtAnQc3MqUa2zviwNWM/
    ImageSetConfiguration CR for LVM Storage
    Policy CR to install and configure LVM Storage ?
    LVMCluster CR YAML file 



What happend till now:

- srini is using storageclass fix and even test-operator fix as Alan patched their rhoso-cert-cinder.yaml

- mulitpath machineconfig not applied ? we reapplied with master instead of worker , it worked but pvc pending issue is there
    - may be master multipath should be applied freshly

    - even when i tried locally on my single node crc, machine config using worker is not applied properly.

- redeployed controlplane, but faced issue with lvmscluster issue.

- redeploy ocp also (from scatch)
  - without mulitpathd , lvmcluster and controlplane are deployed, everything is fine
  - after applying mutlipathd (worker), when rhcert is run it was fine but we felt multipath is not applied
     - srini manually applied conf and restarted the multipathd, boom pvc pending issue again

   seems like the actual  problem is from lvm accessing the underlying multipath device
    sh-5.1# pvs
    WARNING: devices file is missing /dev/mapper/331402ec0190c7691 (253:14) using multipath component /dev/sda.
    See lvmdevices --update for devices file update. (edited) 

- redeploy with updated order
   1. rhocp deploy (lvms-operator)
   2. apply machineconfig multipath
   3. apply lvmcluster CR
   4. deploy controlplane
   5. run cert tool to create the rhcert-cinder pvc and pods
  
  multipath worker machineconfig is not creating multipah.conf and mutlipathd service is inactive
  
  srini manually didnt change multipathd.conf, and may  restarted service

  sh-5.1# multipath -ll
  33621.681810 | /etc/multipath.conf does not exist, blacklisting all devices.
  33621.681852 | You can run "/sbin/mpathconf --enable" to create
  33621.681860 | /etc/multipath.conf. See man mpathconf(8) for more details 

   - restart multipathd service and ensure it is up and then run cert
         - we ran into same issue as we are enabling multipath    
- try multipath with master from scratch

  [zuul@shark19 devsetup]$ oc get mcp
  NAME     CONFIG                                             UPDATED   UPDATING   DEGRADED   MACHINECOUNT   READYMACHINECOUNT   UPDATEDMACHINECOUNT   DEGRADEDMACHINECOUNT   AGE
  master   rendered-master-48042cd04c79c04bf88d3b72b3e2ae06   True      False      False      1              1                   1                     0                      22d
  worker   rendered-worker-b61217e6dd2a7956ad4d59ce382b003a   True      False      False      0              0                   0                     0                      22d

  if the worker node is registered with MACHINECOUNT=0 , then MachineConfig with machineconfiguration.openshift.io/role: worker is not applied anywhere. this should be the reason for missing multipathd.conf
 

  lvm cluster failed again with error pointing to /dev/sdb

  by-path
 
 
  lvm can't use the device ad it has an invalid filestystem signature.
   may be we need to create a device and padd it to lvm cluster
   lvm cannont accept the device as it find the mtpah singaure on the device
 
 
 we excluded it (/dev/sdb) from mutlipath (blacklist) but it didnt work
 
 cleanup: sudo dd if=/dev/zero of=/dev/sdX bs=1M status=progress
blacklist {
    wwid "3600508b400105e210000900000490000"
}
 
and then tried

blacklist {
    devnode "^sdb$"
}

it didn't help and multipath -ll became empty

 
    
 when the lvm cluster is created using /dev/disk bypath, it is trying to create using multipath
   - create lvms-vg1 on the multipath
 
 we passed /dev/mapper path, lvm cluster is good and cert pvc is bound

Spec:
  Storage:
    Device Classes:
      Default:  true
      Device Selector:
        Force Wipe Devices And Destroy All Data:  true
        Paths:
          /dev/mapper/331402ec0190c7691
 
 
 
so the order can also be 
   1. rhocp deploy (lvms-operator)
   2. apply lvmcluster CR
   3. apply machineconfig multipath
   4. deploy controlplane
   5. run cert tool to create the rhcert-cinder pvc and pods
machineconfig should be applied before controlplane deployment 



  



 
chatgpt conclusion:
----------------------


The path you used earlier:

paths:
  - '/dev/disk/by-path/pci-0000:47:00.0-sas-0x31402ec0190c7691-lun-0'
...caused issues because it's a symlink managed by udev, and more importantly:

🔍 Why it caused problems:
Multipathd blacklisted it initially:

Without a valid /etc/multipath.conf, multipathd blacklists all devices by default.

So this specific path never became available under /dev/mapper/, which is where multipath devices live.

Device not claimed as multipath:

by-path/... resolves to the physical device path.

But in a multipath setup, you should always use /dev/mapper/* because that's the multipath abstraction layer.

Using the by-path device directly bypasses multipath and can result in corrupted or duplicate access.

✅ Correct Fix (what you used and worked):
paths:
  - /dev/mapper/331402ec0190c7691
This points to the multipath-managed device and avoids:

Device duplication,

Path conflict,

Misalignment between multipath and LVM.

💡 Best Practice:
For multipath-enabled clusters (RHCOS/OpenShift with LVM or LocalVolume):

Always ensure multipathd is active.

Use /dev/mapper/… paths in any LVMCluster or storage CRs.

If you're using udev aliases like by-path, ensure they're compatible and mapped via multipath.

Let me know if you’d like help validating the final LVMVolumeGroup or matching PV creation.  
