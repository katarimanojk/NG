HPE is trying to certify

guy doing certification is not really good

they have been struggling with variety of issues most of them about hpe inability


srini from hpe 
cinder enginner is in india



able to run some cert tests, one of the glance cert fails , glance to use cinder as backend.

exception thrown 
  - cinder api response

only testing upstream code against devstack

electra mp new product, upstream patch is fixed, patch is backported rhoso18.0.9  or 18.0.10 mostly.


3par image , create you account on quay.io and push the image, they can't do it.

container certifcation fialed as it has tainted rpm, certops published 18.0-test and it worked

and then they were able create glance image on cinder

back to run the certification tests, dry-run (until their patch is landed in 18.0.10)




- alan patched the storagecalls fix in hpe cert-cinder file as javed and team didnt make a release they did it now
   - dnf install should fetch new code

- testoperator has some bugs regarind main vs worflow  for storageclass and resoureces
  - if hpe uses the testoperator latest code, we may need to adjust



rhoso-cert
/etc/redhat-certfication


run  will sed will substitute the vars like RHOSO-CERT_NAMESPACE (filled by init) and apply -f 


initially storageClass  was not set as they only got lvms 

spawn the pod and pvclaim on local storage


oc get pvc issue

dnf install is giving them old rhoso-cert code


test operator updates:
   storageClass at every workflow , main storageClass should be able to propage through all workflow


katrina (replacement of lukas) : 


if partner runs into a problem with new verstion of test-operator, we gonna 

put storageclass: <backendname>

rhoso-cert-run and it hangs as pod never spawn , pvc 

oc get pvc will show mismatch between storageclass in test-operator vs storageclas we have



he is using crc on baremetal node which has 2 disks

lvms cluster is uing 

lvms-vg1 is for openstack contrlplane




bootstrap 
 - dataplane 
       - 




lsblk show additional mpath


we need to figure how his lvm susbysmtem is broken

goal: to get things working to the point where workflow pods are working












