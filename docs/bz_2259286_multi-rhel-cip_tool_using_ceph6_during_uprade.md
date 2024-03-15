

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

















