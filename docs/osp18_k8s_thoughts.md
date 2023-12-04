# thoughts from scratch

osp 17 uses tripleo (o on o) , using undercloud and we install openstack on overcloud (controller + compute + storage(ceph) nodes)


Let us get back to basics

## Cloud:
 - distributed set of servers that host s/w and infra.
   - e.g. gmail is an app running in cloud infra
 -  cloud enables anyone with an internet connection to access IT resources on-demand.
 e.g. : openstack, aws, azure, googlecloud etc

## openstack: IAAS 
OpenStack is a free, open-source cloud computing platform for public and private cloud management.

### what exactly is it ?
 - it is a collection of s/w modules (projects) that work together to create + manage cloud infrastracture
    i.e  collection of cinder :manila: swift : glance (storage) + nova (instances) + neutron (network) + keystone (identity) projects
 - Iaas : pools , provisions, manages compute, storage , network resources.

 - Paas examples : aws , azure 
#### Pros
 - vendor lockin , opensource
#### cons
 - complexity (staff with knowldege), support 

### deployment:

 - different ways like devstack, juju , chef , puppet etc
 - tripleo is the preferred way in redhat osp.
   - uses heat orch + puppet + ansible to deploy different services



## openshift : PAAS (Iaas + tools/sofware )
### openshift vs openstack
openstack : Infra orchestration (vms, storage) :  for admins
openshift : containers orchestration: for developers

RH openshift : based on k8s : container orchestration (automation of container lifecycle)
RHOSP : based on openstack

OpenShift allows running containerized applications on Kubernetes without the need to master Kubernetes intricacies
OpenShift can be used to deploy and manage applications on top of an OpenStack cloud,


# OSP17 -> OSP18:

To reduce the complexity of tripleo deployment till osp17, we move to NG formfactor.

- tht to CRDs(customer resource Definitions) in kurbernetes


# OSP18:
we use OpenShift to manage a containerized instance of OpenStack’s control plane, though the workloads remain fully in OpenStack.

Dual env situation in next-gen:

## [1] Controlplane:
 - OSP control plane is podified using operators.
 - Ctrlplane is deployed in pods 
    - Services in controlplane run in containers, containers are grouped into pods, 
      and the pods are managed by operators.
 - openstack-operator a 'meta' that controls all other operator
    - https://github.com/openstack-k8s-operators/openstack-operator?tab=readme-ov-file#openstack-operator
 - control plane on coreos
 
 - dataplane (edpm) on RHEL
 - Compute nodes live externally and are controlled by control plane

 - We have different operators for different jobs
    Cinder-operator
    Glance-operator
    Dataplane-operator (edpm stuff)

## [2] EDPM (compute nodes are collectively called as external data plane)

 - Compute nodes (cannot be podified) should be on RHEL to provide stability needed by our customers.
 - Openshift doesn’t support deploying on RHEL nodes but only coreOS(fedora)
    - Does it mean control plane doesnot use RHEL ? yes 
 
   - moved tripleo-ansible code to edpm-ansible

## [1] and [2] communication ?

  - Ansible EE (bridge between oc pods and edpm) copies the data created by CR into RHEL nodes

  - ansible EE operator (repo: openstack-ansibleee-operator) ensures to run ansible execution environment pods/contianers on openshift.
    - # oc get osaee 

  - using edpm ansible from the oc pods
    -  https://github.com/openstack-k8s-operators/openstack-ansibleee-operator?tab=readme-ov-file#using-openstack-ansibleee-operator-with-edpm-ansible

## dataplane operator ?
    - This operator creates below CRs
       -  openstackdataplanedeployment 
       -  openstackdataplanenodeset
       -  openstackdataplaneservices
    - https://github.com/openstack-k8s-operators/dataplane-operator?tab=readme-ov-file#dataplane-operator

