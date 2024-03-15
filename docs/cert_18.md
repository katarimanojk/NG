
doc:

 partner guide for 18: https://access.redhat.com/documentation/en-us/red_hat_openstack_services_on_openshift/18.0-beta/html/partner_integration/index

 policy guide:

 workflow guide:

 storage configuration: https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0-beta/html-single/configuring_storage/index

vipin/javed : qe team
abhishek - certops
marco randria / rob laundry

notes:
  - Alan came up with minimum viable alternative for running tempest tests based on abhishek's tempest list of test
     - Alan used the CRs as per: https://openstack-k8s-operators.github.io/test-operator/crds.html
  - nextgen test-operator
  - cert code is just there to collect the artifacts and the ship
     - instead of rhcert tool, we run the tests and collect the data, we need their help to ship

# how rhoso-cert tool is built

https://openstack-k8s-operators.github.io/test-operator/crds.html

Test-opertor has different ways to run tempest tests
  - one of them is create tempest CRs that are accepeted by test-operator



# rhoso-cert tool contains

https://gitlab.cee.redhat.com/abishop/rhcert-test

Read me file gives clear picture
https://gitlab.cee.redhat.com/abishop/rhcert-test/-/blob/main/README.md?ref_type=heads
     
-  bunch of scripts:    
  init -  test-operator CR apply and wait for operator to be in place
  run - apply the selected CR and wait in a loop on the created pods for the CR and report the status.
  logs - spawn a logs pod which access the PV that has data (during run) and copy data from it
  cleanup
  
- bunch of yaml files:cinder, debug, manila tempest CRs
   -  manila : dhss (driver has shared store)
   - tempestconfRun , edits tempest conf using overrides
   - Alan used workflows of tests to mimic how we group things in triploe
      - tempestRun: include list, as we have workflows


# before run checks

## test-operator service is running, which should run tempest for us
zuul@controller-0 rhcert-test]$ oc get pods | grep test-op
test-operator-catalog-tzjdr                                       1/1     Running     0             41d
test-operator-controller-manager-5cc48f644-9zpb4                  2/2     Running     0             41d
test-operator-logs-pod-tempest                                    1/1     Running     0             41d
[zuul@controller-0 rhcert-test]$ 


## cinder-volume service is runing
[zuul@controller-0 rhcert-test]$ oc get pods -l service=cinder
NAME                             READY   STATUS      RESTARTS   AGE
cinder-api-0                     2/2     Running     0          41d
cinder-api-1                     2/2     Running     0          41d
cinder-api-2                     2/2     Running     0          15d
cinder-backup-0                  2/2     Running     0          41d
cinder-backup-1                  2/2     Running     0          41d
cinder-backup-2                  2/2     Running     0          41d
cinder-db-purge-28683361-7l2k8   0/1     Completed   0          2d7h
cinder-db-purge-28684801-plzbw   0/1     Completed   0          31h
cinder-db-purge-28686241-wcq25   0/1     Completed   0          7h29m
cinder-scheduler-0               2/2     Running     0          41d
cinder-volume-ceph-0             2/2     Running     0          41d



# for cinder run, a pod each for every workflow will be created.
[zuul@controller-0 rhcert-test]$ oc get pods -l instanceName=rhcert-cinder
NAME                                                      READY   STATUS      RESTARTS   AGE
rhcert-cinder-backups-workflow-step-1-6s2xc               0/1     Completed   0          28m
rhcert-cinder-consistency-groups-workflow-step-3-fs5gf    0/1     Error       0          25m
rhcert-cinder-multi-attach-volume-workflow-step-2-xn9xs   0/1     Error       0          26m
rhcert-cinder-volumes-workflow-step-0-sz2fc               0/1     Error       0          33m
[zuul@controller-0 rhcert-test]$ 


every pod is a shell script that drives full process of
   - temptest init
   - discover tempest settings
   - running whitelist tests for the group


# rhcert-debug

run one test single test that fails



# rhcert-logs

Durng the run all the data is stored on a openshit persistent volume (PV)

[zuul@controller-0 rhcert-test]$ oc get pvc -l instanceName=rhcert-cinder
NAME                  STATUS   VOLUME                     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
rhcert-cinder-31f22   Bound    local-storage10-master-0   10Gi       RWO,ROX,RWX    local-storage   40m
[zuul@controller-0 rhcert-test]$

when a log script is run, it spawns a pod to access the pv


## copy the logs accessed by the pod

oc cp rhcert-cinder-logs:/mnt $RHCERT_LOGS_DIR
   - here it copies all the workflow directories

standard full tempest logs for cert-ops team to analyze (abhishek)

## script then takes each worflow pod 

[zuul@controller-0 rhcert-test]$ oc get pods -l instanceName=rhcert-cinder,workflowStep=0 -o name
pod/rhcert-cinder-volumes-workflow-step-0-sz2fc
[zuul@controller-0 rhcert-test]$ 


and then copy the pod's log file 'rhcert-cinder-volumes-workflow-step-0-sz2fc.log' to $RHCERT_LOGS_DIR
 - in this logs you can see the main steps like
    
   + tempest init openshift
    
   + discover-tempest-config --create --debug auth.tempest_roles member,swiftoperator volume.volume_type_multiattach multiattach volume-feature-enabled.extend_attached_encrypted_volume True volume-feature-enabled.extend_attached_volume True volume-feature-enabled.manage_snapshot True volume-feature-enabled.manage_volume True volume-feature-enabled.volume_revert True volume-feature-enabled.consistency_group True compute-feature-enabled.volume_multiattach True image-feature-enabled.import_image True identity.v3_endpoint_type public load_balancer.test_server_path /usr/libexec/octavia-tempest-plugin-tests-httpd

   + tempest run --include-list /etc/test_operator/include.txt --exclude-list /var/lib/tempest/external_files/exclude.txt

## must-gather: OpenStack control plane logs and data collection

which has all the artifacts which inculde information about control plane

 - all the openstack related namespaces and pods in openshift cluster
 - all the cinder pods info
 - which has info like ... what container image c-vol is using and all c-vol logs



[zuul@controller-0 registry-redhat-io-rhoso-podified-beta-openstack-must-gather-rhel9-sha256-68c5328e567a60b3ff0d470475d440a621aba228fd11a314fce971b49739dd61]$ pwd
/home/zuul/rhcert-test/rhcert-cinder-2024-Jul-17_06-30-02/must-gather/registry-redhat-io-rhoso-podified-beta-openstack-must-gather-rhel9-sha256-68c5328e567a60b3ff0d470475d440a621aba228fd11a314fce971b49739dd61

[zuul@controller-0 registry-redhat-io-rhoso-podified-beta-openstack-must-gather-rhel9-sha256-68c5328e567a60b3ff0d470475d440a621aba228fd11a314fce971b49739dd61]$ ls
apiservices  crd  csv  ctlplane  namespaces  network  nodes  packagemanifests  run.log  sos-reports  webhooks

/home/zuul/rhcert-test/rhcert-cinder-2024-Jul-17_06-30-02/must-gather/registry-redhat-io-rhoso-podified-beta-openstack-must-gather-rhel9-sha256-68c5328e567a60b3ff0d470475d440a621aba228fd11a314fce971b49739dd61/namespaces/openstack/pods/cinder-volume-ceph-0

[zuul@controller-0 cinder-volume-ceph-0]$ ls
cinder-volume-ceph-0-describe  logs

[zuul@controller-0 logs]$ vi cinder-volume.log 
[zuul@controller-0 logs]$ 



## Large files in must-gather 
[zuul@controller-0 must-gather]$ du -mh . | grep "M" | sort -nr   | head -50
989M    ./quay-io-openshift-release-dev-ocp-v4-0-art-dev-sha256-48358d457c0da36aa8d821d3bf3c739063b066b94b2db63d2dbdf0d381a0e3bd/namespaces/openshift-kni-infra
987M    ./quay-io-openshift-release-dev-ocp-v4-0-art-dev-sha256-48358d457c0da36aa8d821d3bf3c739063b066b94b2db63d2dbdf0d381a0e3bd/namespaces/openshift-kni-infra/pods
882M    ./registry-redhat-io-rhoso-podified-beta-openstack-must-gather-rhel9-sha256-68c5328e567a60b3ff0d470475d440a621aba228fd11a314fce971b49739dd61/namespaces/openstack
879M    ./registry-redhat-io-rhoso-podified-beta-openstack-must-gather-rhel9-sha256-68c5328e567a60b3ff0d470475d440a621aba228fd11a314fce971b49739dd61/namespaces/openstack/pods
718M    ./quay-io-openshift-release-dev-ocp-v4-0-art-dev-sha256-48358d457c0da36aa8d821d3bf3c739063b066b94b2db63d2dbdf0d381a0e3bd/namespaces/openshift-machine-api
715M    ./quay-io-openshift-release-dev-ocp-v4-0-art-dev-sha256-48358d457c0da36aa8d821d3bf3c739063b066b94b2db63d2dbdf0d381a0e3bd/namespaces/openshift-machine-api/pods
632M    ./quay-io-openshift-release-dev-ocp-v4-0-art-dev-sha256-48358d457c0da36aa8d821d3bf3c739063b066b94b2db63d2dbdf0d381a0e3bd/namespaces/openshift-ovn-kubernetes
630M    ./quay-io-openshift-release-dev-ocp-v4-0-art-dev-sha256-48358d457c0da36aa8d821d3bf3c739063b066b94b2db63d2dbdf0d381a0e3bd/namespaces/openshift-ovn-kubernetes/pods
452M    ./quay-io-openshift-release-dev-ocp-v4-0-art-dev-sha256-48358d457c0da36aa8d821d3bf3c739063b066b94b2db63d2dbdf0d381a0e3bd/namespaces/openstack-operators
445M    ./quay-io-openshift-release-dev-ocp-v4-0-art-dev-sha256-48358d457c0da36aa8d821d3bf3c739063b066b94b2db63d2dbdf0d381a0e3bd/namespaces/openstack-operators/pods
384M    ./quay-io-openshift-release-dev-ocp-v4-0-art-dev-sha256-48358d457c0da36aa8d821d3bf3c739063b066b94b2db63d2dbdf0d381a0e3bd/namespaces/openshift-machine-api/pods/metal3-57df648485-2c7b4



cinder.conf:
/etc/cinder/cinder.conf.d/service-custom.conf



oc edit openstackcontrolplane and update your backed in cindervolume section
