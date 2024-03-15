# Bug 2293735 - Upgrade [FFU 16.2 to 17.1] fails on 6.2.3 with cephadm command not found.

step 6.2.3 in 
https://docs.redhat.com/en/documentation/red_hat_openstack_platform/17.1/html-single/framework_for_upgrades_16.2_to_17.1/index#upgrading-to-ceph-storage-5-upgrading-ceph


~~~
$ openstack overcloud external-upgrade run \
   --skip-tags "ceph_ansible_remote_tmp" \
   --stack <stack> \
   --tags ceph,facts 2>&1
~~~


failed like this

~~~
2024-06-22 03:39:33,118 p=110525 u=stack n=ansible | 2024-06-22 03:39:33.116753 | 525400d9-4fc3-fd7e-3600-00000000054f |      FATAL | Get ceph health | undercloud -> CEPH_NODE | error={"changed": true, "cmd": "cephadm shell -- ceph health", "delta": "0:00:00.003073", "end": "2024-06-22 03:39:33.097073", "msg": "non-zero return code", "rc": 127, "start": "2024-06-22 03:39:33.094000", "stderr": "/bin/sh: cephadm: command not found", "stderr_lines": ["/bin/sh: cephadm: command not found"], "stdout": "", "stdout_lines": []}
~~~


-> cephadm is actually installed in 5.1.10 , why is not installed ?  

upgrade prepare script which uses the upgrades-environment.yaml file created in 5.1.10 should have installed cephadm


./0030-sosreport-director-2024-06-22-hsbuftr.tar.xz/sosreport-director-2024-06-22-hsbuftr/home/stack/.tripleo/history 


2024-06-20 23:45:56.940889 overcloud-upgrade-prepare templates=/usr/share/openstack-tripleo-heat-templates, stack=overcloud, timeout=600, libvirt_type=kvm, ntp_server=samay1.nic.in,samay2.nic.in, no_proxy=*.meg1pvt.nic.in,10.166.40.11,10.166.40.12,172.16.0.0/24,10.0.0.0/8,127.0.0.1,10.166.32.0/22,10.166.32.11,10.166.32.13,10.166.32.14,10.166.32.12,10.166.41.10,prd.del.meg1pvt.nic.in,prod.del.meg1pvt.nic.in,prod.ctlplane.prd.del.meg1pvt.nic.in,prod.internalapi.prd.del.meg1pvt.nic.in,10.166.24.110,10.166.14.13,10.193.18.216,10.193.18.213,10.193.18.102,10.193.18.103, overcloud_ssh_user=tripleo-admin, overcloud_ssh_key=None, overcloud_ssh_network=ctlplane, overcloud_ssh_enable_timeout=600, overcloud_ssh_port_timeout=600, environment_files=['/home/stack/templates/network-environment.yaml', '/home/stack/overcloud-deploy/overcloud/overcloud-network-environment.yaml', '/home/stack/overcloud_adopt/baremetal-deployment.yaml', '/home/stack/overcloud_adopt/generated-networks-deployed.yaml', '/home/stack/overcloud_adopt/generated-vip-deployed.yaml', '/home/stack/templates/predictive_ips.yaml', '/home/stack/templates/node_info.yaml', '/usr/share/openstack-tripleo-heat-templates/environments/services/neutron-ovn-dvr-ha.yaml', '/home/stack/templates/cloud_names.yaml', '/home/stack/templates/custom_ceph.yaml', '/home/stack/templates/scheduler_hints.yaml', '/home/stack/upgrades-environment.yaml', '/home/stack/skip_rhel_release.yaml', '/home/stack/templates/configure-timezones.yaml', '/usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml', '/usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-mds.yaml', '/usr/share/openstack-tripleo-heat-templates/environments/cinder-backup.yaml', '/usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-rgw.yaml', '/home/stack/templates/ceph-storage-environment.yaml', '/home/stack/node_data_lookup_osd006_to_osd012.yaml', '/home/stack/ceph_params.yaml', '/home/stack/rhosp_upgrade_container/containers-prepare-parameter_test.yaml', '/usr/share/openstack-tripleo-heat-templates/environments/services/octavia.yaml', '/home/stack/templates/my-octavia-environment.yaml', '/home/stack/nova-hw-machine-type-upgrade.yaml', '/home/stack/templates/fencing.yaml', '/home/stack/migration.yaml', '/home/stack/neutronphybridge.yaml', '/usr/share/openstack-tripleo-heat-templates/environments/compute-instanceha.yaml', '/usr/share/openstack-tripleo-heat-templates/environments/services/barbican.yaml', '/usr/share/openstack-tripleo-heat-templates/environments/barbican-backend-simple-crypto.yaml', '/home/stack/templates/configure-barbican.yaml', '/home/stack/templates/enable-tls.yaml', '/home/stack/templates/inject-trust-anchor-hiera.yaml', '/usr/share/openstack-tripleo-heat-templates/environments/ssl/tls-endpoints-public-dns.yaml', '/home/stack/templates/keystone_domain_specific_ldap_backend.yaml', '/home/stack/templates/cinder_hpexp.yaml', '/home/stack/templates/custom_kernel_settings.yaml'], environment_directories=['/home/stack/.tripleo/environments'], roles_file=/home/stack/templates/roles_data_custom.yaml, networks_file=/home/stack/templates/network_data.yaml, vip_file=None, no_cleanup=False, update_plan_only=False, validation_errors_fatal=True, validation_warnings_fatal=False, disable_validations=True, inflight=False, dry_run=False, run_validations=False, skip_postconfig=False, force_postconfig=False, skip_deploy_identifier=False, answers_file=None, heat_config_vars_file=None, disable_password_generation=False, deployed_server=True, config_download=True, stack_only=False, config_download_only=False, setup_only=False, config_dir=None, config_type=None, preserve_config_dir=True, output_dir=None, override_ansible_cfg=None, config_download_timeout=None, deployment_python_interpreter=None, baremetal_deployment=None, network_config=False, limit=None, tags=None, skip_tags=None, ansible_forks=None, disable_container_prepare=False, working_dir=None, heat_type=pod, heat_container_api_image=localhost/tripleo/openstack-heat-api:ephemeral, heat_container_engine_image=localhost/tripleo/openstack-heat-engine:ephemeral, rm_heat=False, skip_heat_pull=False, disable_protected_resource_types=False, yes=True, allow_deprecated_network_data=False



conclusion:


in brownfield, cephadm is not required until 6.2.7 cephadm_adopt, cephadm is installed in 6.2.6

so the validation to check ceph health using cephadm is not correct in brownfield.






[tripleo-admin@controller-0 ~]$ sudo find / -name ceph.client.admin.keyring
/var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/config/ceph.client.admin.keyring
/etc/ceph/ceph.client.admin.keyring   



ceph.conf:
/var/lib/tripleo-config/ceph/ceph.conf
/var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/config/ceph.conf
/home/tripleo-admin/.local/share/containers/storage/overlay/f5a99eba0a243ab8dee7d9109c8581e04cd4d1ded9d264796712991bb62570ad/diff/etc/ganesha/ceph.conf
/etc/ceph/ceph.conf




testing:

---
- hosts: localhost
  tasks:
    - name: Set container filter format
      set_fact:
        container_filter_format: !unsafe "--format '{{ .Names }}'"

    - name: Set container filter format                                                                                                                                                                                                      
      set_fact:
        container_filter_image_format: !unsafe "--format '{{ .Image }}'"

    - name: print
      debug:
        msg: "{{ container_filter_format }}"

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

    - name: Set ceph_mon_container name
      become: true
      shell: "{{ container_client | default('podman') }} ps {{ container_filter_format }} | grep ceph | grep mon"
      register: ceph_mon_container
      changed_when: false
 
    - name: print
      debug:
        msg: "{{ ceph_mon_container.stdout }}"

    - name: Set ceph_mon_cont_image name
      become: true
      shell: "{{ container_client | default('podman') }}  inspect {{ container_filter_image_format }} {{ ceph_mon_container.stdout }}"
      register: ceph_mon_cont_image
      changed_when: false

    - name: Set ceph cluster name
      become: true
      shell: find /etc/ceph -name '*.conf' -prune -print -quit | xargs basename -s '.conf'
      register: ceph_cluster_name
      changed_when: false

    - name: check ceph health
      become: true
      shell: |
        if [[ -e /usr/sbin/cephadm ]]
        then
            cephadm shell -- ceph --cluster {{ ceph_cluster_name.stdout }} health | awk '{print $1}'
        else
            {{ container_client | default('podman') }} run --rm -v /etc/ceph/ceph.client.admin.keyring:/etc/ceph/ceph.keyring:z -v /etc/ceph/ceph.conf:/etc/ceph/ceph.conf:z --entrypoint ceph 5412073bd7693a6a3dd757df8ea45c8442acb7666bd993355de4e44342b0b240 --cluster {{ ceph_cluster_name.stdout }} health | awk '{print $1}'
        fi
      register: output
    - name: print
      debug:
        msg: "{{ output.stdout }}"

