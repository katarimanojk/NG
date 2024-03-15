
oc whoami


# login to openshift
oc login -u kubeadmin -p <password>
on controller: cat ~/.kube/*password

# login to a pod
oc rsh <podname>
cd /mnt

# copy data to pod from my local directory
oc cp

# list containers in a pod 
 oc -n openstack get pod cinder-volume-ceph-0 -o jsonpath="{.spec['containers'][*].name}"


# login to container through the pod
oc -n openstack exec cinder-volume-ceph-0 -c cinder-volume --stdin --tty -- /bin/bash


oc get cm openstack-config -o json | jq -r '.data["clouds.yaml"]'


oc get pods -l service=cinder
#oc get services
oc get pods -l instancename=rhcert-cinder

oc get catalogsources -A

# catalogsources are the bundles served to operators in the namespace for any queries

oc get packagemanifests :

# inspect the content of a index/catalog image
opm index export --index="quay.io/...." -c podman 


oc get nodes --show-labels 
# after metalb operator 


oc get csv #see all operators and installation state



 [zuul@controller-0 ci-framework]$ oc get $(oc get oscp -n openstack -o name) -o json| jq .spec.keystone.template.enableSecureRBAC.enabled
null

