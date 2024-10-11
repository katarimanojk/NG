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
  osp18_k8s_thoughts.md

  k8s is container orchestartor system for automating 
    - deployment
    - scaling
    - management

  k8s Resource
    - A Kubernetes resource is an endpoint in the Kubernetes API that stores a collection of API objects of a certain kind;
    -  A resource is part of a declarative API, used by Kubernetes client libraries and CLIs, or kubectl.
    -  It can lead to "custom resource", an extension of the Kubernetes API that is not necessarily available in a default Kubernetes installation.
 
  k8s object:
    - A Kubernetes object is a persistent entities in the Kubernetes system.

    Analogy: restuarant
        - meal - application
        - ordering system : k8sapi
            - waiter : kubeclt/oc
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
  - manage compute, storage, networking resources 
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

🚀 Pods: Pods are the smallest deployable units in Kubernetes. They host one or more containers and share network and storage resources.
🚀 Services: Services provide network access to a set of pods. They ensure that your applications are discoverable within the cluster.
    - application recieve traffic because of service
    - ways to explose k8s service
      - clusterIP
      - NodePort
      - LoadBalancer : for service of this type, metalLB provies 
🚀 Deployments: Deployments manage the rollout and scaling of application replicas. They help maintain the desired state of your application.
🚀 ConfigMaps and Secrets: ConfigMaps store configuration data, while Secrets securely manage sensitive information.


imp: k8s playground online:  killercoda

### operators
 in a nut-shell : application/domain specific controller instead of native k8s controller.


   CR + customcontroller + app knownledge = operator

-  A custom resource (CR) that is created by a CRD and is the Kubernetes API extension.


 - k8s control loop (observe->diff->act) supports only state-less apps
   - it can complare desired state of the cluster to actual state and act if it doesn't match


 - i have custom , complex and stateful application (db) which needs
     - hand holding
     - human like decision making ability
 - makes use of custom resuources via k8s CRD
   - high -level configuration (desired) is provied via CR.
 - cutom contol loop based on the app specific requirement, that workds based on the CR


existing opearators are in operatorhub.

#### build your own operator
 - kubebuilder does the scaffolding for the operator
    - it creates basic directory structure , on top of it we need to modify the files and implement our requirements.

https://developers.redhat.com/articles/2021/06/22/kubernetes-operators-101-part-2-how-operators-work#kubernetes__workload_deployments


kubebuilder vs operator sdk

make manifests
make install



### operator framework:
  - sdk
  - OLM
  - metering

# OSP17 -> OSP18:

To reduce the complexity of tripleo deployment till osp17, we move to NG formfactor.

- tht to CRDs(customer resource Definitions) in kurbernetes





--------------- 



# RHOSO/OSP18:
- build a private/public Iaas on RHEL
   - Iaas services are implementted as collection of operarotors on rhocp cluster. 
   - these operators manage compute, storage, networking and other resources 
- we use OpenShift to manage a containerized instance of OpenStack’s control plane, though the workloads remain fully in OpenStack.
- RHOSO ctlplane hostted and managed as workload on rhocp cluster
- RHOSO dataplane hosted on edpm (rhel) nodes and managed with ansible automation program


Dual env situation in next-gen:



## [1] Controlplane:

 - RHOSO ctlplane vs RHOCP ctlplane 
    - compact topology (default): both use same nodes (or same cluster)  see https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0/html-single/planning_your_deployment/index#compact-topo-rhoso_rhoso-overview
    - dedicated  : different set of nodes 
    - RHOSO services run on RHOCP worker nodes (any worker node)
       - you can use nodeselector to use specific node for a service/pod.  see https://docs.redhat.com/en/documentation/openshift_container_platform/4.16/html/nodes/working-with-pods#nodes-scheduler-node-selectors-pod_nodes-pods-node-selectors
 -  RHOSO control plane is podified using operators.
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

## dataplane operator ? ( in june 2024, this is merged into openstack-operator)
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
   - 3-nodes.yaml (lightweight : 1 crc, 1 controller , 1 compute )
ciframework : VA 
   - will take over install_yamls and all dev/qe should use it
   - took kit for building ci jobs (upstream and dowsntream) unlike tripleo where upstream and downstram jobs are different (standalone/IR)
   - VA : validate architecutre is a set of CRs which customers can directly use.
   - VA1.yaml (3 ocp nodes, 1 controller, 3 computes)

### imp notes
- crc/ocp nodes will have CoreOS + openshift installed , we deploy openstack controlplane  here so it will have ctlplane services (pods/containers) 
- controller is not part of openstack control plane (not like the one used in tripleo), it is just for running ansible stuff.  but we do run all oc commands on controller no on ocp nodes.
- for deployment on these compute nodes, dataplane- operator is used(via dataplanenodeset, dataplanedeployment, dataplaneservices CRs), internally the services runs some ansible which are provided by ansibleee operato



it starts here
kustomize build architecture/examples/common/olm/kustomization.yaml > olm.yaml
oc apply -f olm.yaml

then build architecture/examples/common/metalb/kustomization.yaml and apply
oc get nodes



# openstack-operator : meta operator that install many operators that helps in installing openstack

- installs all the service operators like ironic, baremetal, cinder, compute, barbican etc see the complete list here: https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0/html-single/planning_your_deployment/index#assembly_red-hat-openstack-services-on-openshift-overview

see this https://github.com/openstack-k8s-operators/openstack-operator/tree/main/apis/bases  
 it covers
   - openstackclients
   - openstack contrlplanes
   - openstackversions
   - openstack dataplanenodesets
   - os dpdeployments
   - os dps

The OpenStack Operator runs Ansible jobs to configure the RHEL data plane nodes, such as the Compute nodes


after openstack-operator is intalled , all the dependant operators will be ready (i.e ocp cluster will be aware of the CRDS and have custom controllers in place)

once the control plane is kustomized and then deployed  (oc apply), all the services will be deployed as pods 

for eg:
after control plane is deployed, glance-operator will act based on the CR configuration and
 - deploy the glance container/pods
 - custom control loop of the operator will monitor the CR and reconcile to ensure the desired state

# nmstate operator:
  - host network management


# metaLB:
  - load balancer


# openstack-ansibleee-operator
Used by the OpenStack Operator to execute Ansible to deploy, configure, and orchestrate software on the data plane nodes. Ansible uses SSH to communicate with the data plane nodes.



# rhoso networks

https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0/html-single/planning_your_deployment/index#default-phys-networks_plan-network


# machineconfig

CoreOS is an immutable OS, and any changes applied by hand will be reverted. The process for modifying the OS uses k8s machine configurations.
At a minimum, RHOSO storage requires machine configs in order to run the iscsid and multipathd daemons, and install the kernel modules required for NVMe-TCP.

# storage class

  presistent volumes to RHOSO services,
   LVM storageclass : 
    https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0/html-single/deploying_red_hat_openstack_services_on_openshift/index#con_creating-storage-class_preparing
    https://docs.redhat.com/en/documentation/openshift_container_platform/4.16/html/storage/configuring-persistent-storage#install-lvms-operator-cli_logical-volume-manager-storage



# yaml strings:
## annotations:
  Annotations in Kubernetes (K8s) are metadata used to express additional information related to a resource or object.

  kind: Pod
  metadata:
    name: my-pod
    annotations:
      key1: value1
      key2: value2



