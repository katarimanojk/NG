# Different ways to deploy RHOSO:

- RHOCP stands for 'RedHat Openshift Container Platform'
- RHOSO stands for 'RedHat Openstack Services on Openshift'

## Option 1: Official documentation 

### Planning the deloyment:
 - https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0/html/planning_your_deployment/index
### Deployment steps:
 - https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0/html/deploying_red_hat_openstack_services_on_openshift

#### **** Main steps ****:
 1. deploy RHOCP cluster
 2. install openstack-operator
 3. storage class needed ?
    - presistant volumes for RHOSO pods , install lvm operator (local storage)
 4. openstack name space exist 
 5. secure access to rhoso services ?
    - create secret CR (openstack_service_secret.yaml) that has all passwords per service.
 6. networks:
    - default networks: ctlplane (192.168.122.x), external(10.0.0.0), internalapi(172.17.0.0), storage(172.18.0.0), tenant(172.19.0.0), storagemgmt(172.20.0.0)
    - use nmstate operator : connect workernodes to required isolated networks.
    - configure nncp and NetworkAttachmentDefinition (net-attach-def) custom resource (CR) for each isolated network to attach service pods to the isolated networks,
    - use the MetalLB Operator to expose internal service endpoints on the isolated networks
    - dataplane network using netconfig CR
   
 7. create contrlplane:
    - create a CR with all the requirements, use the example CR and build on top of it.
    - use storageclass and secret created in step 3,5
 8. create dataplane:
    - dataplane secrets CRs : for secure access between dataplane nodes
    - OpenStackDataPlaneNodeSet CR
    - OpenStackDataPlaneDeployment CR : confiure services and deploy the dataplane
  



## Option 2: single node ocp  + install_yamls
- RHOCP: single node crc (codre ready containers) where single vm works as both master and worker for k8s (All-in-one)
  see [rhocp_deployment_using crc](https://github.com/katarimanojk/NG/blob/main/rhoso_deployment_docs/osp18_deployment_option_crc.md)
- RHOSO: install_yamls make files
  see [rhoso_deployment_using install_yamls](https://github.com/katarimanojk/NG/blob/main/rhoso_deployment_docs/osp18_deployment_option_install_yamls.md)


## Option 3: multinode ocp  + install_yamls

- RHOCP:  kcli or m3 dev scripts 

  - kcli : mutlininode ocp 
    ```
    #kcli create cluster openshift --paramfile rhoso-cluster.yml rhoso     : 30 mins
    Downloading openshift-install from https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-4.16
    Move downloaded openshift-install somewhere in your PATH if you want to reuse it
    Using installer version 4.16.12
    ```
  refer:
   - Alan's kcli doc : https://github.com/katarimanojk/NG/blob/main/rhoso_deployment_docs/rhoso-kcli.org
   - for rhoso-cluster.yml see https://github.com/katarimanojk/NG/blob/main/rhoso_deployment_docs/rhoso-cluster.yml
   - m3 dev scripts:    https://github.com/openshift-metal3/dev-scripts

- RHOSO: install_yamls make files
  - see [rhoso_deployment_using install_yamls](https://github.com/katarimanojk/NG/blob/main/rhoso_deployment_docs/osp18_deployment_option_install_yamls.md)


## Option 4: cifmw : va-hci.yaml reproducer single command for ocp  + rhoso

- RHOCP: ansible playbooks that use devscripts : 2hours after deep-clean (approx, it may vary based  on hypervisor and connectivity)
- RHOSO: ansible plyabook (deploy_edpm.yaml) that does `oc apply` on the CRDS and run tempest suite at the end  : 45 mins
  - Here is the command:
  ```
    ansible-playbook reproducer.yml     -i custom/inventory.yml     -e cifmw_target_host=hypervisor-1     -e @scenarios/reproducers/va-hci.yml     -e @scenarios/reproducers/networking-definition.yml     -e @custom/secrets.yml   -e @custom/hci.yml   -e@custom/default-vars.yml  -e cifmw_deploy_architecture=true
  ```
  - follow [cifmw_va_hci doc](https://github.com/katarimanojk/NG/blob/main/rhoso_deployment_docs/osp18_deployment_option_cifmw_va1.md) for complete details.


## Option 5: cifmw : va-hci.yaml reproducer for ocp + manual rhoso

- RHOCP : ansible playbooks that use devscripts , along with rhocp cluster it also creates 3 compute (edpm nodes)
  ``` 
    ansible-playbook reproducer.yml     -i custom/inventory.yml     -e cifmw_target_host=hypervisor-1     -e @scenarios/reproducers/va-hci.yml     -e @scenarios/reproducers/networking-definition.yml     -e @custom/secrets.yml   -e @custom/hci.yml   -e@custom/default-vars.yml  
  ```

- RHOSO: ansible playbook to just prepeare CRS and manually apply them using https://github.com/openstack-k8s-operators/architecture/tree/main/examples/va/hci#stages
  - Login to controller and do dry-run to just generate CRs

   ```
   ./deploy-architecture.sh -e cifmw_kustomize_deploy_generate_crs_only=true -e cifmw_deploy_architecture_stopper=post_apply_stage_3
   ```
   see https://ci-framework.pages.redhat.com/docs/main/ci-framework/cookbook.html#only-generate-values-yaml-during-the-deployment 

   and then apply generated values for every stage in the below directory
   ```
   [zuul@controller-0 architecture]$ cd /home/zuul/ci-framework-data/artifacts/kustomize_deploy
   [zuul@controller-0 kustomize_deploy]$ ls
   control-plane.yaml  deployment-post-ceph.yaml  deployment-pre-ceph.yaml  metallb.yaml  nmstate.yaml  nncp.yaml  nodeset-post-ceph.yaml  nodeset-pre-ceph.yaml  olm.yaml
   [zuul@controller-0 kustomize_deploy]$ 
   ```
   refer : https://github.com/openstack-k8s-operators/architecture/tree/main/examples/va/hci#stages for order of crds to be applied

  - After pre-ceph dataplane deployment (stage3 ),  deploy ceph using https://ci-framework.pages.redhat.com/docs/stable/ci-framework/05_deploy_va.html#ceph

  - Once the ceph is deployed, apply post-ceph CRs as per https://github.com/openstack-k8s-operators/architecture/blob/main/examples/va/hci/dataplane-post-ceph.md
    - Note: before running post-ceph , ensure to update ceph cluster's FSID in ctlplane where nova, glance and cinder uses ceph backend.

  - Alternatively without generating values, you can do everything manually
    - 'oc kustomize at all stages of https://github.com/openstack-k8s-operators/architecture/tree/main/examples/va/hci#stages and do "oc apply" at every stage by following the va-hci deployment steps: refer https://ci-framework.pages.redhat.com/docs/stable/ci-framework/05_deploy_va.html





