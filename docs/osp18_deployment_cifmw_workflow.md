
all the custom vars you pass will be accumulated in

~/ci-framework-data/parameters/reproducer-variables.yml


# stages of hci deployment:
https://github.com/openstack-k8s-operators/architecture/blob/main/automation/vars/hci.yaml

start with 0 for every path

    
https://github.com/openstack-k8s-operators/architecture/tree/main/examples/va/hci#stages



# play aroung with rhoso deployment


https://ci-framework.pages.redhat.com/docs/main/ci-framework/cookbook.html#only-generate-values-yaml-during-the-deployment

 see this:  https://redhat-internal.slack.com/archives/C03MD4LG22Z/p1727432276757469


# deploy_architecture.sh

02-infra.yaml : runs devscripts: but it is skipped here as it is already run while creating ocp cluster.

deploy-edpm.yml -> playbooks/06-deploy-edpm.yml
   - deploy control plane
   - deploy edpm pre ceph
   - deploy ceph
   - post ceph update fsid and secret
   - post deploy





controlplane deployment:
./roles/edpm_prepare/tasks/kustomize_and_deploy.yml


data plane customize
roles/edpm_kustomize/README.md


data plane deploy
roles/edpm_deploy/README.md



# pre-ceph VS post-ceph

    name: edpm-deployment-pre-ceph
    namespace: openstack
    resourceVersion: "280414"
    uid: dfccdfc0-f3e8-4345-9232-6c3a0a570d35
  spec:
    backoffLimit: 6
    deploymentRequeueTime: 15
    nodeSets:
    - openstack-edpm
    preserveJobs: true
    servicesOverride:
    - bootstrap
    - configure-network
    - validate-network
    - install-os
    - ceph-hci-pre
    - configure-os
    - ssh-known-hosts
    - run-os
    - reboot-os


me: edpm-deployment-post-ceph
    namespace: openstack
    resourceVersion: "432795"
    uid: 634d648d-c28f-429a-b73a-05c05c593162
  spec:
    backoffLimit: 6
    deploymentRequeueTime: 15
    nodeSets:
    - openstack-edpm
    preserveJobs: true
    servicesOverride:
    - install-certs
    - ceph-client
    - ovn
    - neutron-metadata
    - libvirt
    - nova-custom-ceph


all these data plane related pods are run on edpm nodes using ansible ee

[zuul@controller-0 roles]$ oc get pods -l app=openstackansibleee
NAME                                                              READY   STATUS      RESTARTS   AGE
bootstrap-edpm-deployment-pre-ceph-openstack-edpm-jbcd7           0/1     Completed   0          6d5h
ceph-client-edpm-deployment-post-ceph-openstack-edpm-rdrh6        0/1     Completed   0          6d2h
ceph-hci-pre-edpm-deployment-pre-ceph-openstack-edpm-vxmg9        0/1     Completed   0          6d5h
configure-network-edpm-deployment-pre-ceph-openstack-edpm-wxshx   0/1     Completed   0          6d5h
configure-os-edpm-deployment-pre-ceph-openstack-edpm-r5l5r        0/1     Completed   0          6d5h
install-certs-edpm-deployment-post-ceph-openstack-edpm-vj6jb      0/1     Completed   0          6d2h
install-os-edpm-deployment-pre-ceph-openstack-edpm-vvzd9          0/1     Completed   0          6d5h
libvirt-edpm-deployment-post-ceph-openstack-edpm-qv8dt            0/1     Completed   0          6d2h
neutron-metadata-edpm-deployment-post-ceph-openstack-edpm-px9vb   0/1     Completed   0          6d2h
nova-custom-ceph-edpm-deployment-post-ceph-openstack-edpm-5d4nv   0/1     Completed   0          6d2h
ovn-edpm-deployment-post-ceph-openstack-edpm-czdpm                0/1     Completed   0          6d2h
reboot-os-edpm-deployment-pre-ceph-openstack-edpm-t686c           0/1     Completed   0          6d5h
run-os-edpm-deployment-pre-ceph-openstack-edpm-tkpft              0/1     Completed   0          6d5h
ssh-known-hosts-edpm-deployment-pre-ceph-j8crc                    0/1     Completed   0          6d5h
validate-network-edpm-deployment-pre-ceph-openstack-edpm-xq89x    0/1     Completed   0          6d5h



