
github.com/openstack-k8s-operators/ci-framework/pull/1713/files




defualt case:  
  cephfs_enabled: true
  ceph_nfs_enabled: false
  
  
TASK [cifmw_cephadm : Create a Ceph MDS spec src=templates/ceph_mds.yml.j2, dest={{ cifmw_ceph_mds_spec_path }}, mode=0644, force=True] ******************************************************************************************************
Monday 27 May 2024  07:02:18 -0400 (0:00:00.031)       0:00:43.932 ************ 
ok: [192.168.122.100]

TASK [cifmw_cephadm : Get ceph_cli _raw_params=ceph_cli.yml] *********************************************************************************************************************************************************************************
Monday 27 May 2024  07:02:19 -0400 (0:00:00.407)       0:00:44.339 ************ 
included: /home/zuul/src/github.com/openstack-k8s-operators/ci-framework/roles/cifmw_cephadm/tasks/ceph_cli.yml for 192.168.122.100

TASK [cifmw_cephadm : Set ceph CLI cifmw_cephadm_ceph_cli={{ cifmw_cephadm_container_cli }} run --rm {{ cifmw_cephadm_container_options }} {% if mount_certs|default(false) %} --volume {{ cifmw_cephadm_certs }}:/etc/pki/tls:z {% endif %} {% if sensitive_data|default(false) %} --interactive {% endif %} --volume {{ cifmw_cephadm_config_home }}:/etc/ceph:z {% if not (external_cluster|default(false) or crush_rules|default(false)) -%} --volume {{ cifmw_cephadm_assimilate_conf }}:{{ cifmw_cephadm_assimilate_conf_container }}:z {% endif %} {% if mount_spec|default(false) %} --volume {{ cifmw_cephadm_spec }}:{{ cifmw_cephadm_container_spec }}:z {% endif %} {% if admin_daemon|default(false) %} --volume /var/run/ceph/{{ cifmw_cephadm_fsid }}:/var/run/ceph:z {% endif %} --entrypoint {{ ceph_command | default('ceph') }} {{ cifmw_cephadm_container_ns }}/{{ cifmw_cephadm_container_image }}:{{ cifmw_cephadm_container_tag }} {% if ceph_command|default('ceph') == 'ceph' or ceph_command|default('ceph') == 'rados' or ceph_command|default('ceph') == 'rbd' -%}
  {% if not admin_daemon|default(false) -%}
  --fsid {{ cifmw_cephadm_fsid }} -c /etc/ceph/{{ cifmw_cephadm_cluster }}.conf -k /etc/ceph/{{ cifmw_cephadm_cluster }}.client.{{ select_keyring| default('admin') }}.keyring
  {%- endif %}
  {% if external_cluster|default(false) -%}
  -n client.{{ select_keyring }}
  {%- endif %}
{%- endif %}] ***
Monday 27 May 2024  07:02:19 -0400 (0:00:00.029)       0:00:44.368 ************ 
ok: [192.168.122.100]

TASK [cifmw_cephadm : Apply cephfs volume _raw_params={{ cifmw_cephadm_ceph_cli }} fs volume create {{ cifmw_cephadm_cephfs_name }} '--placement={{ placement }}'
] ***************************************************************************
Monday 27 May 2024  07:02:19 -0400 (0:00:00.030)       0:00:44.399 ************ 
ok: [192.168.122.100]

TASK [cifmw_cephadm : Apply the MDS spec _raw_params={{ cifmw_cephadm_ceph_cli }} orch apply --in-file {{ cifmw_cephadm_container_spec }}] ***************************************************************************************************
Monday 27 May 2024  07:02:19 -0400 (0:00:00.581)       0:00:44.980 ************ 
changed: [192.168.122.100]

TASK [cifmw_cephadm : Create NFS Ganesha Cluster _raw_params={{ cifmw_cephadm_ceph_cli }} nfs cluster create {{ cifmw_cephadm_cephfs_name }} --ingress --virtual-ip={{ cifmw_cephadm_nfs_vip }} --ingress-mode=haproxy-protocol '--placement={{ placement }}'
] ***
Monday 27 May 2024  07:02:20 -0400 (0:00:00.591)       0:00:45.571 ************ 
skipping: [192.168.122.100]

  
  
  
  
  
  
  
  
  
nfs ganesha enabled:
  cephfs_enabled: true
  ceph_nfs_enabled: true
  

TASK [cifmw_cephadm : Create a Ceph MDS spec src=templates/ceph_mds.yml.j2, dest={{ cifmw_ceph_mds_spec_path }}, mode=0644, force=True] ******************************************************************************************************
Monday 27 May 2024  07:05:03 -0400 (0:00:00.030)       0:00:44.727 ************ 
ok: [192.168.122.100]

TASK [cifmw_cephadm : Get ceph_cli _raw_params=ceph_cli.yml] *********************************************************************************************************************************************************************************
Monday 27 May 2024  07:05:03 -0400 (0:00:00.452)       0:00:45.179 ************ 
included: /home/zuul/src/github.com/openstack-k8s-operators/ci-framework/roles/cifmw_cephadm/tasks/ceph_cli.yml for 192.168.122.100

TASK [cifmw_cephadm : Set ceph CLI cifmw_cephadm_ceph_cli={{ cifmw_cephadm_container_cli }} run --rm {{ cifmw_cephadm_container_options }} {% if mount_certs|default(false) %} --volume {{ cifmw_cephadm_certs }}:/etc/pki/tls:z {% endif %} {% if sensitive_data|default(false) %} --interactive {% endif %} --volume {{ cifmw_cephadm_config_home }}:/etc/ceph:z {% if not (external_cluster|default(false) or crush_rules|default(false)) -%} --volume {{ cifmw_cephadm_assimilate_conf }}:{{ cifmw_cephadm_assimilate_conf_container }}:z {% endif %} {% if mount_spec|default(false) %} --volume {{ cifmw_cephadm_spec }}:{{ cifmw_cephadm_container_spec }}:z {% endif %} {% if admin_daemon|default(false) %} --volume /var/run/ceph/{{ cifmw_cephadm_fsid }}:/var/run/ceph:z {% endif %} --entrypoint {{ ceph_command | default('ceph') }} {{ cifmw_cephadm_container_ns }}/{{ cifmw_cephadm_container_image }}:{{ cifmw_cephadm_container_tag }} {% if ceph_command|default('ceph') == 'ceph' or ceph_command|default('ceph') == 'rados' or ceph_command|default('ceph') == 'rbd' -%}
  {% if not admin_daemon|default(false) -%}
  --fsid {{ cifmw_cephadm_fsid }} -c /etc/ceph/{{ cifmw_cephadm_cluster }}.conf -k /etc/ceph/{{ cifmw_cephadm_cluster }}.client.{{ select_keyring| default('admin') }}.keyring
  {%- endif %}
  {% if external_cluster|default(false) -%}
  -n client.{{ select_keyring }}
  {%- endif %}
{%- endif %}] ***
Monday 27 May 2024  07:05:03 -0400 (0:00:00.030)       0:00:45.210 ************ 
ok: [192.168.122.100]

TASK [cifmw_cephadm : Apply cephfs volume _raw_params={{ cifmw_cephadm_ceph_cli }} fs volume create {{ cifmw_cephadm_cephfs_name }} '--placement={{ placement }}'
] ***************************************************************************
Monday 27 May 2024  07:05:03 -0400 (0:00:00.032)       0:00:45.243 ************ 
ok: [192.168.122.100]

TASK [cifmw_cephadm : Apply the MDS spec _raw_params={{ cifmw_cephadm_ceph_cli }} orch apply --in-file {{ cifmw_cephadm_container_spec }}] ***************************************************************************************************
Monday 27 May 2024  07:05:04 -0400 (0:00:00.647)       0:00:45.891 ************ 
changed: [192.168.122.100]

TASK [cifmw_cephadm : Create NFS Ganesha Cluster _raw_params={{ cifmw_cephadm_ceph_cli }} nfs cluster create {{ cifmw_cephadm_cephfs_name }} --ingress --virtual-ip={{ cifmw_cephadm_nfs_vip }} --ingress-mode=haproxy-protocol '--placement={{ placement }}'
] ***
Monday 27 May 2024  07:05:04 -0400 (0:00:00.651)       0:00:46.542 ************ 
ok: [192.168.122.100]














cephfs disabled:
  cephfs_enabled: false
  ceph_nfs_enabled: false 
  
  
 TASK [cifmw_cephadm : Create a Ceph MDS spec src=templates/ceph_mds.yml.j2, dest={{ cifmw_ceph_mds_spec_path }}, mode=0644, force=True] ******************************************************************************************************
Monday 27 May 2024  07:00:21 -0400 (0:00:00.020)       0:00:44.170 ************ 
skipping: [192.168.122.100]

TASK [cifmw_cephadm : Get ceph_cli _raw_params=ceph_cli.yml] *********************************************************************************************************************************************************************************
Monday 27 May 2024  07:00:21 -0400 (0:00:00.020)       0:00:44.191 ************ 
skipping: [192.168.122.100]

TASK [cifmw_cephadm : Apply cephfs volume _raw_params={{ cifmw_cephadm_ceph_cli }} fs volume create {{ cifmw_cephadm_cephfs_name }} '--placement={{ placement }}'
] ***************************************************************************
Monday 27 May 2024  07:00:21 -0400 (0:00:00.020)       0:00:44.212 ************ 
skipping: [192.168.122.100]

TASK [cifmw_cephadm : Apply the MDS spec _raw_params={{ cifmw_cephadm_ceph_cli }} orch apply --in-file {{ cifmw_cephadm_container_spec }}] ***************************************************************************************************
Monday 27 May 2024  07:00:21 -0400 (0:00:00.020)       0:00:44.232 ************ 
skipping: [192.168.122.100]

TASK [cifmw_cephadm : Create NFS Ganesha Cluster _raw_params={{ cifmw_cephadm_ceph_cli }} nfs cluster create {{ cifmw_cephadm_cephfs_name }} --ingress --virtual-ip={{ cifmw_cephadm_nfs_vip }} --ingress-mode=haproxy-protocol '--placement={{ placement }}'
] ***
Monday 27 May 2024  07:00:21 -0400 (0:00:00.026)       0:00:44.258 ************ 
skipping: [192.168.122.100]

  
may not be valid case: but our code works. 
cephfs disabled:
  cephfs_enabled: false
  ceph_nfs_enabled: true
  

TASK [cifmw_cephadm : Create a Ceph MDS spec src=templates/ceph_mds.yml.j2, dest={{ cifmw_ceph_mds_spec_path }}, mode=0644, force=True] ******************************************************************************************************
Monday 27 May 2024  07:09:22 -0400 (0:00:00.035)       0:00:44.494 ************ 
ok: [192.168.122.100]

TASK [cifmw_cephadm : Get ceph_cli _raw_params=ceph_cli.yml] *********************************************************************************************************************************************************************************
Monday 27 May 2024  07:09:22 -0400 (0:00:00.444)       0:00:44.939 ************ 
included: /home/zuul/src/github.com/openstack-k8s-operators/ci-framework/roles/cifmw_cephadm/tasks/ceph_cli.yml for 192.168.122.100

TASK [cifmw_cephadm : Set ceph CLI cifmw_cephadm_ceph_cli={{ cifmw_cephadm_container_cli }} run --rm {{ cifmw_cephadm_container_options }} {% if mount_certs|default(false) %} --volume {{ cifmw_cephadm_certs }}:/etc/pki/tls:z {% endif %} {% if sensitive_data|default(false) %} --interactive {% endif %} --volume {{ cifmw_cephadm_config_home }}:/etc/ceph:z {% if not (external_cluster|default(false) or crush_rules|default(false)) -%} --volume {{ cifmw_cephadm_assimilate_conf }}:{{ cifmw_cephadm_assimilate_conf_container }}:z {% endif %} {% if mount_spec|default(false) %} --volume {{ cifmw_cephadm_spec }}:{{ cifmw_cephadm_container_spec }}:z {% endif %} {% if admin_daemon|default(false) %} --volume /var/run/ceph/{{ cifmw_cephadm_fsid }}:/var/run/ceph:z {% endif %} --entrypoint {{ ceph_command | default('ceph') }} {{ cifmw_cephadm_container_ns }}/{{ cifmw_cephadm_container_image }}:{{ cifmw_cephadm_container_tag }} {% if ceph_command|default('ceph') == 'ceph' or ceph_command|default('ceph') == 'rados' or ceph_command|default('ceph') == 'rbd' -%}
  {% if not admin_daemon|default(false) -%}
  --fsid {{ cifmw_cephadm_fsid }} -c /etc/ceph/{{ cifmw_cephadm_cluster }}.conf -k /etc/ceph/{{ cifmw_cephadm_cluster }}.client.{{ select_keyring| default('admin') }}.keyring
  {%- endif %}
  {% if external_cluster|default(false) -%}
  -n client.{{ select_keyring }}
  {%- endif %}
{%- endif %}] ***
Monday 27 May 2024  07:09:22 -0400 (0:00:00.030)       0:00:44.970 ************ 
ok: [192.168.122.100]

TASK [cifmw_cephadm : Apply cephfs volume _raw_params={{ cifmw_cephadm_ceph_cli }} fs volume create {{ cifmw_cephadm_cephfs_name }} '--placement={{ placement }}'
] ***************************************************************************
Monday 27 May 2024  07:09:22 -0400 (0:00:00.031)       0:00:45.001 ************ 
ok: [192.168.122.100]

TASK [cifmw_cephadm : Apply the MDS spec _raw_params={{ cifmw_cephadm_ceph_cli }} orch apply --in-file {{ cifmw_cephadm_container_spec }}] ***************************************************************************************************
Monday 27 May 2024  07:09:23 -0400 (0:00:00.654)       0:00:45.655 ************ 
changed: [192.168.122.100]

TASK [cifmw_cephadm : Create NFS Ganesha Cluster _raw_params={{ cifmw_cephadm_ceph_cli }} nfs cluster create {{ cifmw_cephadm_cephfs_name }} --ingress --virtual-ip={{ cifmw_cephadm_nfs_vip }} --ingress-mode=haproxy-protocol '--placement={{ placement }}'
] ***
Monday 27 May 2024  07:09:24 -0400 (0:00:00.631)       0:00:46.286 ************ 
ok: [192.168.122.100]






