


[zuul@shark20 ~]$ oc get pods -l service=cinder
NAME                        READY   STATUS    RESTARTS   AGE
cinder-api-0                2/2     Running   0          56m
cinder-backup-0             2/2     Running   0          55m
cinder-scheduler-0          2/2     Running   0          55m
cinder-volume-lvm-iscsi-0   2/2     Running   0          52m
[zuul@shark20 ~]$ oc get pods -l instanceName=rhcert-cinder
No resources found in openstack namespace.
[zuul@shark20 ~]$ oc -n openstack get tempest
No resources found in openstack namespace.
[zuul@shark20 ~]$ 
[zuul@shark20 ~]$ 
[zuul@shark20 ~]$ 
[zuul@shark20 ~]$ oc get pods -l instanceName=rhcert-cinder
No resources found in openstack namespace.

[zuul@shark20 ~]$ oc -n openstack get tempest
NAME                STATUS   MESSAGE
rhoso-cert-cinder   False    Deployment in progress

[zuul@shark20 ~]$ oc -n openstack get tempest -o yaml > tempest.yaml

[zuul@shark20 ~]$ vi tempest.yaml 

[zuul@shark20 ~]$ oc get pods | grep cinder
cinder-api-0                                                    2/2     Running     0          59m
cinder-backup-0                                                 2/2     Running     0          58m
cinder-scheduler-0                                              2/2     Running     0          58m
cinder-volume-lvm-iscsi-0                                       2/2     Running     0          56m
rhoso-cert-cinder-backups-workflow-step-1-nz8wm                 1/1     Running     0          11s
rhoso-cert-cinder-volumes-workflow-step-0-g45rp                 0/1     Error       0          106s
[zuul@shark20 ~]$


      storageClass: local-storage
      storageClass: local-storage
      storageClass: local-storage
[zuul@shark20 ~]$ grep -i storageclass tempest.yaml | les





[zuul@shark20 rhoso-cert]$ ./rhoso-cert-cleanup 
job.batch "rhoso-cert-cinder-volumes-workflow-step-0" deleted
job.batch "rhoso-cert-cinder-backups-workflow-step-1" deleted
job.batch "rhoso-cert-cinder-multi-attach-volume-workflow-step-2" deleted
job.batch "rhoso-cert-cinder-consistency-groups-workflow-step-3" deleted
tempest.test.openstack.org "rhoso-cert-cinder" deleted
Done.
[zuul@shark20 rhoso-cert]$ 


[zuul@shark20 rhoso-cert]$ export RHOSO_CERT_STORAGE_CLASS="manoj"
[zuul@shark20 rhoso-cert]$ ./rhoso-cert-run 
tempest.test.openstack.org/rhoso-cert-cinder created



[zuul@shark20 ~]$ grep -inr "storageClass:" tempest.yaml 
31:    storageClass: manoj
81:      storageClass: local-storage
308:      storageClass: local-storage
323:      storageClass: local-storage
339:      storageClass: local-storage

