
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




#oc get pods

oc get pods -l app=openstackansibleee

oc get pods --all-namespaces




# namespaces

oc new-project openstack  # new namespace
oc project openstack   # switch to namespace 

oc get namespaces





# crds

#oc get crds

oc get crd | grep "^openstack"

oc describe crd openstackcontrolplanes.core.openstack.org | less
[zuul@controller-0 ~]$ 
oc explain openstackcontrolplane.spec


wait for pods:

oc get pods -w -n openstack 


waiting on condition:
 oc wait osdpd edpm-deployment-pre-ceph --for condition=Ready --timeout=1200s -n openstack



#oc get <>


oc apply -f <operator directory>

oc get operatorgroup -o yaml

oc get po

oc get job
oc logs <job id>

oc get csv
oc get pods,csv

Oc get all  
Oc ger crds
Debugging:

Oc logs -f <podname>
Oc describe po <podname>


Oc describe pods


Oc get po <> -o yaml
#oc logs -f <podname>

#if oc delete pvc stuck in termninating
oc patch pvc edpm-ansible  -p '{"metadata":{"finalizers":null}}' 

Oc explain pods –recursive

oc get pods -l app=openstackansibleee


Oc get rs

Oc apply -f data.yaml   / oc apply -k . (current directory has the customization.yaml   )

Oc rsh <pod>

Oc exec <pod> – openstack volume list

 oc edit openstackcontrolplane openstack-galera-network-isolation 
 or
 oc get -o yaml > x.yaml, edit x.yaml, oc apply -f x.yaml
  
Oc api-resources  : to see all kinds

oc get pods -n openstack-operators | grep dataplane


oc patch network.operator cluster -p \
  '{"spec": {"defaultNetwork":{"ovnKubernetesConfig":{"gatewayConfig": {"ipForwarding": "Global", "routingViaHost": true}}}}}' --type=merge


Oc get deployments  ; oc describe deployment <name>
oc get svc -l service=dnsmasq -o json | jq -r '.items[0].status.loadBalancer.ingress[0].ip' 
Oc get services
Oc get replicasets

