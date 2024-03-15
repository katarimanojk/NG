# thoughts from scratch

osp 17 uses tripleo (o on o) , using undercloud and we install openstack on overcloud (controller + compute + storage(ceph) nodes)


Let us get back to basics

## Cloud:
 - distributed set of servers that host s/w and infra.
   - e.g. gmail is an app running in cloud infra
 -  cloud enables anyone with an internet connection to access IT resources on-demand.
 e.g. : openstack, aws, azure, googlecloud etc

but webservers were there even before cloud, isn't it cloud computing ?

### web hosting vs cloud hosting(cloud computing)
  - web servers work on the conecpt of web hosting, client relies on physical resource
    - for example on a single server, is a traditional standard through which you’d store files, pages and business logic on a physical unit or machine
    - A shared web server will have multiple client can only stretch a little, can serve only finite needs.

  - cloud computing relies on VMs , deploy your cloud computing s/w on the server and boom
    - you have vms where you can do web hosting and with access to scalable resources.


## types of cloud:

### private:
    - known as internal or corporate cloud
    - single tenant (your organization)
    - propriety architecture
        - doesn't share the infra, computing env, storage with any other user
    - it pitches in when public cloud do things like
      - meet the uptime needed ?
      - security ?
      - insuffiecient storage ?
    vendors:
     - redhat, hpe, vmware, ibm, dellemc, microsoft
     
### public:
    - multiple tenants will use the cloud resources hosted on the web.
    - 3rd party provider like aws, azure maintains and owns infra, computing env, storage 
       - infra is located at the premises of the company that provides service.
       - it is shared across multiple tenants (multi-tenancy)
          - many organziation data is stored in a shared env


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

RH hybrid cloud applicaiton platform
 - traditional apps
 - cloud-native apps
 - modern AI/ML

What is openshift:

1. container: os process that package application + dependecies on a shared linux host

2. kubernetes:
 - we may need to manage multiple containers across multiple hosts (orchestrate yeahh....), kubernetes is here
 - wraps multiple containers into a pod
 - buitlin heathchecks and switch a pod to another host to maintain highavailability

    Analogy: restuarant
        - meal - application
        - ordering system : k8sapi
        - head chef : k8s controlplane
        - junior chefs: k8s workers
        - kitchen equipment:  k8sengine and core services
3. trusted content:
     - deliver integrated secuirty at every phase of software dev cycle

    Analogy: restuarnt
        - kithen equipment from trusted vendors
        - certified tools 
        - vegetables from tursted vendors

4. comprehensive applicaiton platform: build and deliver the application
    - apart from kubertners, integrated devops services, advanced management and securities


conclustion: openshift is more than containers, kubernetes, it bundles devops tools , security, etc


### openshift vs openstack
openstack : Infra orchestration (vms, storage) :  for admins
openshift : containers orchestration: for developers

RH openshift : based on k8s : container orchestration (automation of container lifecycle)
RHOSP : based on openstack

OpenShift allows running containerized applications on Kubernetes without the need to master Kubernetes intricacies
OpenShift can be used to deploy and manage applications on top of an OpenStack cloud,


- k8s/openshift native resources
    - pod
    - deployment
    - service
    - statefulset
    - CRD

imp: k8s playground online:  killercoda

### operators
 in a nut-shell : application/domain specific controller instead of native k8s controller.


   CR + customcontroller + app knownledge = operator


 - k8s control loop (observe->diff->act) supports only state-less apps
   - it can complare desired state of the cluster to actual state and act if it doesn't match


 - i have custom , complex and stateful application (db) which needs
     - hand holding
     - human like decision making ability
 - makes use of custom resuources via k8s CRD
   - high -level configuration (desired) is provied via CR.
 - cutom contol loop based on the app specific requirement, that workds based on the CR


existing opearators are in operatorhub.


### operator framework:
  - sdk
  - OLM
  - metering

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

 - #make openstack_deploy : will run a script that does 'oc create -f' on the CRD result in openstack-opertator pod that deploys required services/config.
    - operator control loop (logic) will look for various defined resources and do the needful.

## [2] EDPM (compute nodes are collectively called as external data plane)

 - Compute nodes (cannot be podified) should be on RHEL to provide stability needed by our customers.
 - Openshift doesn’t support deploying on RHEL nodes but only coreOS(fedora)
    - Does it mean control plane doesnot use RHEL ? yes 
 
   - moved tripleo-ansible code to edpm-ansible
 - they are called datplane nodes (instead of just compute) because it does additional stuff like swift or ceph or support hci etc
## [1] and [2] communication ?

  - Ansible EE (bridge between oc pods and edpm) copies the data created by CR into RHEL nodes

  - ansible EE operator (repo: openstack-ansibleee-operator) ensures to run ansible execution environment pods/contianers on openshift.
    - #oc get osaee 

  - using edpm ansible from the oc pods
    -  https://github.com/openstack-k8s-operators/openstack-ansibleee-operator?tab=readme-ov-file#using-openstack-ansibleee-operator-with-edpm-ansible

  - An openstack-ansibleee-runner image is hosted at quay.io/openstack-k8s-operators/openstack-ansibleee-runner which contains edpm-ansible. 

## dataplane operator ?
    - This operator creates below main base CRs
       -  openstackdataplanedeployment 
       -  openstackdataplanenodeset
       -  openstackdataplaneservices
    - https://github.com/openstack-k8s-operators/dataplane-operator?tab=readme-ov-file#dataplane-operator

    - dataplane operator -> openstackansibleee -> jobs -> edpm_ansible
    - from the dataplane operator you can run the playbook in edpm_ansible by configuring a service
       config/services/dataplane_v1beta1_openstackdataplaneservice_ceph_client.yaml
        spec:
           label: ceph-client
           playbook: osp.edpm.ceph_client
      This service should be mentioned in openstackdataplanenodeset CR under services

     - openstackdataplanedeployment resource will have nodeset pointing to the configured openstackdataplanenodeset


## how to deploy osp18

install_yamls : only for developers (may not be used)
   - deploy all operators on CRC node

ciframework : VA 
   - will take over install_yamls and all dev/qe should use it
   - took kit for building ci jobs (upstream and dowsntream) unlike tripleo where upstream and downstram jobs are different (standalone/IR)
   - VA : validate architecutre is a set of CRs which customers can directly use.

it starts here
kustomize build architecture/examples/common/olm/kustomization.yaml > olm.yaml
oc apply -f olm.yaml

then build architecture/examples/common/metalb/kustomization.yaml and apply
oc get nodes

