

Sol: as per discussion tool already supports explicit ceph_image , so we updated the doc accordingly

to make it safer


sol 1 : update tool to use default ceph image as 5 if the customer may overlook the documenation
sol 2 : add more validation in tht level 


sol1 implemation:
================
ceph6 will be considered from tripleo-common container image build as defualt if ceph 5 is not made default


NAMESPACE='"namespace":"example.redhat.com:5002",'
EL8_NAMESPACE='"namespace":"example.redhat.com:5002",'
NEUTRON_DRIVER='"neutron_driver":"ovn",'
EL8_TAGS='"tag":"rhel_8_rhosp17.1",'
EL9_TAGS='"tag":"rhel_9_rhosp17.1",'
CEPH_TAGS='"ceph_tag":"5-404",'


python3 /usr/share/openstack-tripleo-heat-templates/tools/multi-rhel-container-image-prepare.py \
     --role Compute \
     --role ControllerStorageNfs \
     --role CephStorage \
     --enable-multi-rhel \
     --excludes collectd \
     --excludes nova-libvirt \
     --minor-override "{${EL8_TAGS}${EL8_NAMESPACE}${CEPH_TAGS}${NEUTRON_DRIVER}\"no_tag\":\"not_used\"}" \
     --major-override "{${EL9_TAGS}${NAMESPACE}${CEPH_TAGS}${NEUTRON_DRIVER}\"no_tag\":\"not_used\"}" \
     --output-env-file \
    /home/stack/manoj_containers-prepare-parameter.yaml










[stack@undercloud-0 ~]$ python3 /usr/share/openstack-tripleo-heat-templates/tools/multi-rhel-container-image-prepare.py      --role Compute      --role ControllerStorageNfs      --role CephStorage      --enable-multi-rhel      --excludes collectd      --excludes nova-libvirt      --minor-override "{${EL8_TAGS}${EL8_NAMESPACE}${CEPH_OVERRIDE}${NEUTRON_DRIVER}\"no_tag\":\"not_used\"}"      --major-override "{${EL9_TAGS}${NAMESPACE}${CEPH_OVERRIDE}${NEUTRON_DRIVER}\"no_tag\":\"not_used\"}"      --output-env-file     /home/stack/manoj_containers-prepare-parameter.yaml

test1: when CEPH_OVERRIDE='"ceph_tag":"5-404"



{'tag_from_label': '{version}-{release}', 'set': {'namespace': 'registry.redhat.io/rhosp-rhel9', 'name_prefix': 'openstack-', 'name_suffix': '', 'tag': '17.1', 'rhel_containers': False, 'neutron_driver': 'ovn', 'ceph_namespace': 'registry.redhat.io/rhceph', 'ceph_image': 'rhceph-5-rhel8', 'ceph_tag': 'latest', 'ceph_prometheus_namespace': 'registry.redhat.io/openshift4', 'ceph_prometheus_image': 'ose-prometheus', 'ceph_prometheus_tag': 'v4.6', 'ceph_alertmanager_namespace': 'registry.redhat.io/openshift4', 'ceph_alertmanager_image': 'ose-prometheus-alertmanager', 'ceph_alertmanager_tag': 'v4.6', 'ceph_node_exporter_namespace': 'registry.redhat.io/openshift4', 'ceph_node_exporter_image': 'ose-prometheus-node-exporter', 'ceph_node_exporter_tag': 'v4.6', 'ceph_grafana_namespace': 'registry.redhat.io/rhceph', 'ceph_grafana_image': 'rhceph-6-dashboard-rhel9', 'ceph_grafana_tag': 'latest'}, 'includes': ['collectd', 'nova-libvirt']}
Manoj print cip_exc
[{'tag_from_label': '{version}-{release}', 'set': {'namespace': 'registry.redhat.io/rhosp-rhel9', 'name_prefix': 'openstack-', 'name_suffix': '', 'tag': '17.1', 'rhel_containers': False, 'neutron_driver': 'ovn', 'ceph_namespace': 'registry.redhat.io/rhceph', 'ceph_image': 'rhceph-5-rhel8', 'ceph_tag': 'latest', 'ceph_prometheus_namespace': 'registry.redhat.io/openshift4', 'ceph_prometheus_image': 'ose-prometheus', 'ceph_prometheus_tag': 'v4.6', 'ceph_alertmanager_namespace': 'registry.redhat.io/openshift4', 'ceph_alertmanager_image': 'ose-prometheus-alertmanager', 'ceph_alertmanager_tag': 'v4.6', 'ceph_node_exporter_namespace': 'registry.redhat.io/openshift4', 'ceph_node_exporter_image': 'ose-prometheus-node-exporter', 'ceph_node_exporter_tag': 'v4.6', 'ceph_grafana_namespace': 'registry.redhat.io/rhceph', 'ceph_grafana_image': 'rhceph-6-dashboard-rhel9', 'ceph_grafana_tag': 'latest'}, 'excludes': ['collectd', 'nova-libvirt']}]
Manoj print after  cip_inc[0]
{'tag_from_label': '{version}-{release}', 'set': {'namespace': 'example.redhat.com:5002', 'name_prefix': 'openstack-', 'name_suffix': '', 'tag': 'rhel_8_rhosp17.1', 'rhel_containers': False, 'neutron_driver': 'ovn', 'ceph_namespace': 'registry.redhat.io/rhceph', 'ceph_image': 'rhceph-5-rhel8', 'ceph_tag': '5-404', 'ceph_prometheus_namespace': 'registry.redhat.io/openshift4', 'ceph_prometheus_image': 'ose-prometheus', 'ceph_prometheus_tag': 'v4.6', 'ceph_alertmanager_namespace': 'registry.redhat.io/openshift4', 'ceph_alertmanager_image': 'ose-prometheus-alertmanager', 'ceph_alertmanager_tag': 'v4.6', 'ceph_node_exporter_namespace': 'registry.redhat.io/openshift4', 'ceph_node_exporter_image': 'ose-prometheus-node-exporter', 'ceph_node_exporter_tag': 'v4.6', 'ceph_grafana_namespace': 'registry.redhat.io/rhceph', 'ceph_grafana_image': 'rhceph-6-dashboard-rhel9', 'ceph_grafana_tag': 'latest'}, 'includes': ['collectd', 'nova-libvirt']}
Manoj print after cip_exc[0]
[{'tag_from_label': '{version}-{release}', 'set': {'namespace': 'example.redhat.com:5002', 'name_prefix': 'openstack-', 'name_suffix': '', 'tag': 'rhel_9_rhosp17.1', 'rhel_containers': False, 'neutron_driver': 'ovn', 'ceph_namespace': 'registry.redhat.io/rhceph', 'ceph_image': 'rhceph-5-rhel8', 'ceph_tag': '5-404', 'ceph_prometheus_namespace': 'registry.redhat.io/openshift4', 'ceph_prometheus_image': 'ose-prometheus', 'ceph_prometheus_tag': 'v4.6', 'ceph_alertmanager_namespace': 'registry.redhat.io/openshift4', 'ceph_alertmanager_image': 'ose-prometheus-alertmanager', 'ceph_alertmanager_tag': 'v4.6', 'ceph_node_exporter_namespace': 'registry.redhat.io/openshift4', 'ceph_node_exporter_image': 'ose-prometheus-node-exporter', 'ceph_node_exporter_tag': 'v4.6', 'ceph_grafana_namespace': 'registry.redhat.io/rhceph', 'ceph_grafana_image': 'rhceph-6-dashboard-rhel9', 'ceph_grafana_tag': 'latest'}, 'excludes': ['collectd', 'nova-libvirt']}]
Manoj print after base_role







[stack@undercloud-0 ~]$ cat manoj_containers-prepare-parameter.yaml
# Generated with the following on 2024-01-24T08:06:47.365759
#
parameter_defaults:
  ContainerImagePrepare:
  - tag_from_label: '{version}-{release}'
    set:
      namespace: example.redhat.com:5002
      name_prefix: openstack-
      name_suffix: ''
      tag: rhel_9_rhosp17.1
      rhel_containers: false
      neutron_driver: ovn
      ceph_namespace: registry.redhat.io/rhceph
      ceph_image: rhceph-5-rhel8
      ceph_tag: 5-404
      ceph_prometheus_namespace: registry.redhat.io/openshift4
      ceph_prometheus_image: ose-prometheus
      ceph_prometheus_tag: v4.6
      ceph_alertmanager_namespace: registry.redhat.io/openshift4
      ceph_alertmanager_image: ose-prometheus-alertmanager
      ceph_alertmanager_tag: v4.6
      ceph_node_exporter_namespace: registry.redhat.io/openshift4
      ceph_node_exporter_image: ose-prometheus-node-exporter
      ceph_node_exporter_tag: v4.6
      ceph_grafana_namespace: registry.redhat.io/rhceph
      ceph_grafana_image: rhceph-6-dashboard-rhel9
      ceph_grafana_tag: latest
  MultiRhelRoleContainerImagePrepare: &id001
  - tag_from_label: '{version}-{release}'
    set:
      namespace: example.redhat.com:5002
      name_prefix: openstack-
      name_suffix: ''
      tag: rhel_9_rhosp17.1
      rhel_containers: false
      neutron_driver: ovn
      ceph_namespace: registry.redhat.io/rhceph
      ceph_image: rhceph-5-rhel8
      ceph_tag: 5-404
      ceph_prometheus_namespace: registry.redhat.io/openshift4
      ceph_prometheus_image: ose-prometheus
      ceph_prometheus_tag: v4.6
      ceph_alertmanager_namespace: registry.redhat.io/openshift4
      ceph_alertmanager_image: ose-prometheus-alertmanager
      ceph_alertmanager_tag: v4.6
      ceph_node_exporter_namespace: registry.redhat.io/openshift4
      ceph_node_exporter_image: ose-prometheus-node-exporter
      ceph_node_exporter_tag: v4.6
      ceph_grafana_namespace: registry.redhat.io/rhceph
      ceph_grafana_image: rhceph-6-dashboard-rhel9
      ceph_grafana_tag: latest
    excludes:
    - collectd
    - nova-libvirt
  - tag_from_label: '{version}-{release}'
    set:
      namespace: example.redhat.com:5002
      name_prefix: openstack-
      name_suffix: ''
      tag: rhel_8_rhosp17.1
      rhel_containers: false
      neutron_driver: ovn
      ceph_namespace: registry.redhat.io/rhceph
      ceph_image: rhceph-5-rhel8
      ceph_tag: 5-404
      ceph_prometheus_namespace: registry.redhat.io/openshift4
      ceph_prometheus_image: ose-prometheus
      ceph_prometheus_tag: v4.6
      ceph_alertmanager_namespace: registry.redhat.io/openshift4
      ceph_alertmanager_image: ose-prometheus-alertmanager
      ceph_alertmanager_tag: v4.6
      ceph_node_exporter_namespace: registry.redhat.io/openshift4
      ceph_node_exporter_image: ose-prometheus-node-exporter
      ceph_node_exporter_tag: v4.6
      ceph_grafana_namespace: registry.redhat.io/rhceph
      ceph_grafana_image: rhceph-6-dashboard-rhel9
      ceph_grafana_tag: latest
    includes:
    - collectd
    - nova-libvirt
  ComputeContainerImagePrepare: *id001
  ControllerStorageNfsContainerImagePrepare: *id001
  CephStorageContainerImagePrepare: *id001
[stack@undercloud-0 ~]$ 





test2: with CEPH_OVERRIDE='"ceph_tag":"5-404"


CEPH_OVERRIDE='"ceph_image":"rhceph-5.4-rhel8","ceph_tag":"5-404",'
[stack@undercloud-0 ~]$ python3 /usr/share/openstack-tripleo-heat-templates/tools/multi-rhel-container-image-prepare.py      --role Compute      --role ControllerStorageNfs      --role CephStorage      --enable-multi-rhel      --excludes collectd      --excludes nova-libvirt      --minor-override "{${EL8_TAGS}${EL8_NAMESPACE}${CEPH_OVERRIDE}${NEUTRON_DRIVER}\"no_tag\":\"not_used\"}"      --major-override "{${EL9_TAGS}${NAMESPACE}${CEPH_OVERRIDE}${NEUTRON_DRIVER}\"no_tag\":\"not_used\"}"      --output-env-file     /home/stack/manoj_containers-prepare-parameter.yaml
Manoj print minor
{'tag': 'rhel_8_rhosp17.1', 'namespace': 'example.redhat.com:5002', 'ceph_image': 'rhceph-5.4-rhel8', 'ceph_tag': '5-404', 'neutron_driver': 'ovn', 'no_tag': 'not_used'}
Manoj print major
{'tag': 'rhel_9_rhosp17.1', 'namespace': 'example.redhat.com:5002', 'ceph_image': 'rhceph-5.4-rhel8', 'ceph_tag': '5-404', 'neutron_driver': 'ovn', 'no_tag': 'not_used'}
Manoj print cip_inc[0]
{'tag_from_label': '{version}-{release}', 'set': {'namespace': 'registry.redhat.io/rhosp-rhel9', 'name_prefix': 'openstack-', 'name_suffix': '', 'tag': '17.1', 'rhel_containers': False, 'neutron_driver': 'ovn', 'ceph_namespace': 'registry.redhat.io/rhceph', 'ceph_image': 'rhceph-5-rhel8', 'ceph_tag': 'latest', 'ceph_prometheus_namespace': 'registry.redhat.io/openshift4', 'ceph_prometheus_image': 'ose-prometheus', 'ceph_prometheus_tag': 'v4.6', 'ceph_alertmanager_namespace': 'registry.redhat.io/openshift4', 'ceph_alertmanager_image': 'ose-prometheus-alertmanager', 'ceph_alertmanager_tag': 'v4.6', 'ceph_node_exporter_namespace': 'registry.redhat.io/openshift4', 'ceph_node_exporter_image': 'ose-prometheus-node-exporter', 'ceph_node_exporter_tag': 'v4.6', 'ceph_grafana_namespace': 'registry.redhat.io/rhceph', 'ceph_grafana_image': 'rhceph-6-dashboard-rhel9', 'ceph_grafana_tag': 'latest'}, 'includes': ['collectd', 'nova-libvirt']}
Manoj print cip_exc
[{'tag_from_label': '{version}-{release}', 'set': {'namespace': 'registry.redhat.io/rhosp-rhel9', 'name_prefix': 'openstack-', 'name_suffix': '', 'tag': '17.1', 'rhel_containers': False, 'neutron_driver': 'ovn', 'ceph_namespace': 'registry.redhat.io/rhceph', 'ceph_image': 'rhceph-5-rhel8', 'ceph_tag': 'latest', 'ceph_prometheus_namespace': 'registry.redhat.io/openshift4', 'ceph_prometheus_image': 'ose-prometheus', 'ceph_prometheus_tag': 'v4.6', 'ceph_alertmanager_namespace': 'registry.redhat.io/openshift4', 'ceph_alertmanager_image': 'ose-prometheus-alertmanager', 'ceph_alertmanager_tag': 'v4.6', 'ceph_node_exporter_namespace': 'registry.redhat.io/openshift4', 'ceph_node_exporter_image': 'ose-prometheus-node-exporter', 'ceph_node_exporter_tag': 'v4.6', 'ceph_grafana_namespace': 'registry.redhat.io/rhceph', 'ceph_grafana_image': 'rhceph-6-dashboard-rhel9', 'ceph_grafana_tag': 'latest'}, 'excludes': ['collectd', 'nova-libvirt']}]
Manoj print after  cip_inc[0]
{'tag_from_label': '{version}-{release}', 'set': {'namespace': 'example.redhat.com:5002', 'name_prefix': 'openstack-', 'name_suffix': '', 'tag': 'rhel_8_rhosp17.1', 'rhel_containers': False, 'neutron_driver': 'ovn', 'ceph_namespace': 'registry.redhat.io/rhceph', 'ceph_image': 'rhceph-5.4-rhel8', 'ceph_tag': '5-404', 'ceph_prometheus_namespace': 'registry.redhat.io/openshift4', 'ceph_prometheus_image': 'ose-prometheus', 'ceph_prometheus_tag': 'v4.6', 'ceph_alertmanager_namespace': 'registry.redhat.io/openshift4', 'ceph_alertmanager_image': 'ose-prometheus-alertmanager', 'ceph_alertmanager_tag': 'v4.6', 'ceph_node_exporter_namespace': 'registry.redhat.io/openshift4', 'ceph_node_exporter_image': 'ose-prometheus-node-exporter', 'ceph_node_exporter_tag': 'v4.6', 'ceph_grafana_namespace': 'registry.redhat.io/rhceph', 'ceph_grafana_image': 'rhceph-6-dashboard-rhel9', 'ceph_grafana_tag': 'latest'}, 'includes': ['collectd', 'nova-libvirt']}
Manoj print after cip_exc[0]
[{'tag_from_label': '{version}-{release}', 'set': {'namespace': 'example.redhat.com:5002', 'name_prefix': 'openstack-', 'name_suffix': '', 'tag': 'rhel_9_rhosp17.1', 'rhel_containers': False, 'neutron_driver': 'ovn', 'ceph_namespace': 'registry.redhat.io/rhceph', 'ceph_image': 'rhceph-5.4-rhel8', 'ceph_tag': '5-404', 'ceph_prometheus_namespace': 'registry.redhat.io/openshift4', 'ceph_prometheus_image': 'ose-prometheus', 'ceph_prometheus_tag': 'v4.6', 'ceph_alertmanager_namespace': 'registry.redhat.io/openshift4', 'ceph_alertmanager_image': 'ose-prometheus-alertmanager', 'ceph_alertmanager_tag': 'v4.6', 'ceph_node_exporter_namespace': 'registry.redhat.io/openshift4', 'ceph_node_exporter_image': 'ose-prometheus-node-exporter', 'ceph_node_exporter_tag': 'v4.6', 'ceph_grafana_namespace': 'registry.redhat.io/rhceph', 'ceph_grafana_image': 'rhceph-6-dashboard-rhel9', 'ceph_grafana_tag': 'latest'}, 'excludes': ['collectd', 'nova-libvirt']}]
Output env file exists, moving it to backup.
[stack@undercloud-0 ~]$ 





[stack@undercloud-0 ~]$ cat manoj_containers-prepare-parameter.yaml 
# Generated with the following on 2024-01-24T08:09:51.003580
#
parameter_defaults:
  ContainerImagePrepare:
  - tag_from_label: '{version}-{release}'
    set:
      namespace: example.redhat.com:5002
      name_prefix: openstack-
      name_suffix: ''
      tag: rhel_9_rhosp17.1
      rhel_containers: false
      neutron_driver: ovn
      ceph_namespace: registry.redhat.io/rhceph
      ceph_image: rhceph-5.4-rhel8
      ceph_tag: 5-404
      ceph_prometheus_namespace: registry.redhat.io/openshift4
      ceph_prometheus_image: ose-prometheus
      ceph_prometheus_tag: v4.6
      ceph_alertmanager_namespace: registry.redhat.io/openshift4
      ceph_alertmanager_image: ose-prometheus-alertmanager
      ceph_alertmanager_tag: v4.6
      ceph_node_exporter_namespace: registry.redhat.io/openshift4
      ceph_node_exporter_image: ose-prometheus-node-exporter
      ceph_node_exporter_tag: v4.6
      ceph_grafana_namespace: registry.redhat.io/rhceph
      ceph_grafana_image: rhceph-6-dashboard-rhel9
      ceph_grafana_tag: latest
  MultiRhelRoleContainerImagePrepare: &id001
  - tag_from_label: '{version}-{release}'
    set:
      namespace: example.redhat.com:5002
      name_prefix: openstack-
      name_suffix: ''
      tag: rhel_9_rhosp17.1
      rhel_containers: false
      neutron_driver: ovn
      ceph_namespace: registry.redhat.io/rhceph
      ceph_image: rhceph-5.4-rhel8
      ceph_tag: 5-404
      ceph_prometheus_namespace: registry.redhat.io/openshift4
      ceph_prometheus_image: ose-prometheus
      ceph_prometheus_tag: v4.6
      ceph_alertmanager_namespace: registry.redhat.io/openshift4
      ceph_alertmanager_image: ose-prometheus-alertmanager
      ceph_alertmanager_tag: v4.6
      ceph_node_exporter_namespace: registry.redhat.io/openshift4
      ceph_node_exporter_image: ose-prometheus-node-exporter
      ceph_node_exporter_tag: v4.6
      ceph_grafana_namespace: registry.redhat.io/rhceph
      ceph_grafana_image: rhceph-6-dashboard-rhel9
      ceph_grafana_tag: latest
    excludes:
    - collectd
    - nova-libvirt
  - tag_from_label: '{version}-{release}'
    set:
      namespace: example.redhat.com:5002
      name_prefix: openstack-
      name_suffix: ''
      tag: rhel_8_rhosp17.1
      rhel_containers: false
      neutron_driver: ovn
      ceph_namespace: registry.redhat.io/rhceph
      ceph_image: rhceph-5.4-rhel8
      ceph_tag: 5-404
      ceph_prometheus_namespace: registry.redhat.io/openshift4
      ceph_prometheus_image: ose-prometheus
      ceph_prometheus_tag: v4.6
      ceph_alertmanager_namespace: registry.redhat.io/openshift4
      ceph_alertmanager_image: ose-prometheus-alertmanager
      ceph_alertmanager_tag: v4.6
      ceph_node_exporter_namespace: registry.redhat.io/openshift4
      ceph_node_exporter_image: ose-prometheus-node-exporter
      ceph_node_exporter_tag: v4.6
      ceph_grafana_namespace: registry.redhat.io/rhceph
      ceph_grafana_image: rhceph-6-dashboard-rhel9
      ceph_grafana_tag: latest
    includes:
    - collectd
    - nova-libvirt
  ComputeContainerImagePrepare: *id001
  ControllerStorageNfsContainerImagePrepare: *id001
  CephStorageContainerImagePrepare: *id001
[stack@undercloud-0 ~]$ 





sol2 implemanation:


/fp:
validation to stop upgrade below:

container-image-prepare -> tht deployment/ceph-ansible.yaml

check the version provided for that container.

cephadm adoption playbook can detect it

test: run a job , update the container



testing on sealusa controller:

tripleo-admin@controller-0 ~]$ cat play.yaml 
---
- hosts: localhost
  tasks:
    - include_role:
        name: ceph
        tasks_from: ceph-upgrade-version-check.yml
[tripleo-admin@controller-0 ~]$ 





[tripleo-admin@controller-0 ~]$ cat /etc/ansible/roles/ceph/tasks/ceph-upgrade-version-check.yml
---
- name: Check if ceph_mon is deployed
  become: true
  shell: hiera -c /etc/puppet/hiera.yaml enabled_services | egrep -sq ceph_mon
  ignore_errors: true
  register: ceph_mon_enabled
  changed_when: false
  #delegate_to: "{{ tripleo_delegate_to | first | default(omit) }}"

- when: "ceph_mon_enabled is succeeded"
  #delegate_to: "{{ tripleo_delegate_to | first | default(omit) }}"
  block:
    - name: Check for docker cli
      stat:
        path: "/var/run/docker.sock"
      register: check_docker_cli
      check_mode: false

    - name: Set container_client fact
      set_fact:
        container_client: |-
          {% set container_client = 'podman' %}
          {%   if check_docker_cli.stat.exists|bool %}
          {%     set container_client = 'docker' %}
          {%   endif %}
          {{ container_client }}

    - name: Set container filter format
      set_fact:
        container_filter_format: !unsafe "--format '{{ .Names }}'"

    - name: Set ceph_mon_container name
      become: true
      shell: "{{ container_client }} ps {{ container_filter_format }} | grep -i ceph | grep -i mon"
      register: ceph_mon_container
      changed_when: false

    - name: Set ceph cluster name
      become: true
      shell: find /etc/ceph -name '*.conf' -prune -print -quit | xargs basename -s '.conf'
      register: ceph_cluster_name
      changed_when: false

    - name: Get ceph version
      become: true
      shell: "{{ container_client }} exec {{ ceph_mon_container.stdout }} ceph --cluster {{ ceph_cluster_name.stdout }} -v | awk '{print $5}'"
      register: ceph_version

    - name: Check for valid ceph version during FFU
      fail:
        msg: Ceph version cannot be {{ ceph_version.stdout }} for FFU.
      when:
        - ceph_version.stdout == 'quincy'
[tripleo-admin@controller-0 ~]$    







after the fix juan observed some issue in the jobs


i see that juan updated containers-prepare-parameter.yaml for this recent runs

he used these
   ceph_namespace: registry.redhat.io/rhceph
      ceph_image: rhceph-5-rhel8
      ceph_tag: '5

instead of the values used in the jobs
   ceph_namespace: registry-proxy.engineering.redhat.com/rh-osbs
      ceph_image: rhceph
      ceph_tag: '5'



when we run

openstack overcloud external-upgrade run ${EXTERNAL_ANSWER} \
    --stack qe-Cloud-0 \
    --skip-tags "ceph_health,opendev-validation,ceph_ansible_remote_tmp" \
    --tags cephadm_adopt






it failed like this:

PLAY [External upgrade step 0] *************************************************
[WARNING]: any_errors_fatal only stops any future tasks running on the host
that fails with the tripleo_free strategy.
2024-04-30 14:34:14.158571 | 525400a1-1dc0-e1d1-0c27-00000000002f |       TASK | Get Ceph version
2024-04-30 14:34:14.853971 | 525400a1-1dc0-e1d1-0c27-00000000002f |    CHANGED | Get Ceph version | undercloud
2024-04-30 14:34:14.855653 | 525400a1-1dc0-e1d1-0c27-00000000002f |     TIMING | ceph : Get Ceph version | undercloud | 0:00:03.846157 | 0.70s
2024-04-30 14:34:14.871782 | 525400a1-1dc0-e1d1-0c27-000000000030 |       TASK | print
2024-04-30 14:34:14.902244 | 525400a1-1dc0-e1d1-0c27-000000000030 |         OK | print | undercloud | result={
    "changed": false,
    "msg": {
        "changed": true,
        "cmd": "podman run --rm --entrypoint=ceph registry.redhat.io/rhceph/rhceph-5-rhel8:5 -v | awk '{print $5}'",
        "delta": "0:00:00.238218",
        "end": "2024-04-30 14:34:14.823052",
        "failed": false,
        "rc": 0,
        "start": "2024-04-30 14:34:14.584834",
        "stderr": "Trying to pull registry.redhat.io/rhceph/rhceph-5-rhel8:5...\nError: Error initializing source docker://registry.redhat.io/rhceph/rhceph-5-rhel8:5: unable to retrieve auth token: invalid username/password: unauthorized: Please login to the Red Hat Registry using your Customer Portal credentials. Further instructions can be found here: https://access.redhat.com/RegistryAuthentication",
        "stderr_lines": [
            "Trying to pull registry.redhat.io/rhceph/rhceph-5-rhel8:5...",
            "Error: Error initializing source docker://registry.redhat.io/rhceph/rhceph-5-rhel8:5: unable to retrieve auth token: invalid username/password: unauthorized: Please login to the Red Hat Registry using your Customer Portal credentials. Further instructions can be found here: https://access.redhat.com/RegistryAuthentication"
        ],
        "stdout": "",
        "stdout_lines": []
    }
}
2024-04-30 14:34:14.904594 | 525400a1-1dc0-e1d1-0c27-000000000030 |     TIMING | ceph : print | undercloud | 0:00:03.895085 | 0.03s
2024-04-30 14:34:14.921235 | 525400a1-1dc0-e1d1-0c27-000000000031 |       TASK | Check for valid ceph version during FFU
2024-04-30 14:34:14.962755 | 525400a1-1dc0-e1d1-0c27-000000000031 |      FATAL | Check for valid ceph version during FFU | undercloud | error={"changed": false, "msg": "Target ceph version cannot be  for FFU."}


we had to to podman login registry.redhat.io from the undercloud to resolve this issue






