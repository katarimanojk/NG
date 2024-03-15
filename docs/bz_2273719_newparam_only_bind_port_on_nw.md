# Analysis

ceph team came up with a fix https://gitlab.cee.redhat.com/ceph/ceph/-/commit/5a2ce270f6ef776f1bbd463ce958b9d43166009b

where they introduce new spec paramter for grafana:

    service_type: grafana
    service_name: grafana
    placement:
      count: 1
    networks:
      - 10.2.1.0/24
    spec:
      only_bind_port_on_networks: true


# what i did

Test if the failure can be reprodcued loacally on sealusa: nope

the new parameter is supported ?

took the ceph image suggested by adam in the bz: 

- deployed ceph after removing the existing ceph cluster and osds 
   along with below changes 

[stack@undercloud-0 ~]$ diff -rub containers-prepare-parameter.yaml_bkp containers-prepare-parameter.yaml
--- containers-prepare-parameter.yaml_bkp       2024-04-12 09:42:31.238151821 +0000
+++ containers-prepare-parameter.yaml   2024-04-12 09:42:44.560202738 +0000
@@ -5,7 +5,7 @@


      #ceph_image: rhceph
      #ceph_namespace: registry-proxy.engineering.redhat.com/rh-osbs
      ceph_image: ceph
      ceph_namespace: quay.ceph.io/ceph-ci
     #ceph_tag: 6-199
      ceph_tag: reef


 parameter_defaults:
   ContainerImagePrepare:
-  - push_destination: true
+  - push_destination: false
     set:
       ceph_alertmanager_image: openshift-ose-prometheus-alertmanager
       ceph_alertmanager_namespace: rhos-qe-mirror.lab.eng.rdu2.redhat.com:5002/rh-osbs
[stack@undercloud-0 ~]$ 

- then try manualy applying spec in cephadm shell

- then upgate container prepare yaml in cepahdm dierectory and run cephadm playbook



TASK [tripleo_cephadm : Create the monitoring stack Daemon spec definition] ******************************************
ok: [controller-0] => (item={'daemon': 'grafana', 'port': '3100'}) => {"ansible_loop_var": "item", "changed": false, "cmd": ["podman", "run", "--rm", "--net=host", "-v", "/etc/ceph:/etc/ceph:z", "-v", "/var/lib/ceph/:/var/lib/ceph/:z", "-v", "/var/log/ceph/:/var/log/ceph/:z", "-v", "/home/ceph-admin/specs/grafana:/home/ceph-admin/specs/grafana:z", "--entrypoint=ceph", "quay.ceph.io/ceph-ci/ceph:reef", "-n", "client.admin", "-k", "/etc/ceph/ceph.client.admin.keyring", "--cluster", "ceph", "orch", "apply", "--in-file", "/home/ceph-admin/specs/grafana"], "delta": "0:00:00.994030", "end": "2024-04-12 11:31:05.354757", "item": {"daemon": "grafana", "port": "3100"}, "rc": 0, "start": "2024-04-12 11:31:04.360727", "stderr": "", "stderr_lines": [], "stdout": "Scheduled grafana update...", "stdout_lines": ["Scheduled grafana update..."]}                                                                                                               

ok: [controller-0] => (item={'daemon': 'prometheus', 'port': '9092'}) => {"ansible_loop_var": "item", "changed": false, "cmd": ["podman", "run", "--rm", "--net=host", "-v", "/etc/ceph:/etc/ceph:z", "-v", "/var/lib/ceph/:/var/lib/ceph/:z", "-v", "/var/log/ceph/:/var/log/ceph/:z", "-v", "/home/ceph-admin/specs/prometheus:/home/ceph-admin/specs/prometheus:z", "--entrypoint=ceph", "quay.ceph.io/ceph-ci/ceph:reef", "-n", "client.admin", "-k", "/etc/ceph/ceph.client.admin.keyring", "--cluster", "ceph", "orch", "apply", "--in-file", "/home/ceph-admin/specs/prometheus"], "delta": "0:00:00.941646", "end": "2024-04-12 11:31:07.011182", "item": {"daemon": "prometheus", "port": "9092"}, "rc": 0, "start": "2024-04-12 11:31:06.069536", "stderr": "", "stderr_lines": [], "stdout": "Scheduled prometheus update...", "stdout_lines": ["Scheduled prometheus update..."]}                                                                                          


failed: [controller-0] (item={'daemon': 'alertmanager', 'port': '9093'}) => {"ansible_loop_var": "item", "changed": false, "cmd": ["podman", "run", "--rm", "--net=host", "-v", "/etc/ceph:/etc/ceph:z", "-v", "/var/lib/ceph/:/var/lib/ceph/:z", "-v", "/var/log/ceph/:/var/log/ceph/:z", "-v", "/home/ceph-admin/specs/alertmanager:/home/ceph-admin/specs/alertmanager:z", "--entrypoint=ceph", "quay.ceph.io/ceph-ci/ceph:reef", "-n", "client.admin", "-k", "/etc/ceph/ceph.client.admin.keyring", "--cluster", "ceph", "orch", "apply", "--in-file", "/home/ceph-admin/specs/alertmanager"], "delta": "0:00:00.954323", "end": "2024-04-12 11:31:08.726237", "item": {"daemon": "alertmanager", "port": "9093"}, "rc": 22, "start": "2024-04-12 11:31:07.771914", "stderr": "Error EINVAL: ServiceSpec: __init__() got an unexpected keyword argument 'only_bind_port_on_networks'", "stderr_lines": ["Error EINVAL: ServiceSpec: __init__() got an unexpected keyword argument 'only_bind_port_on_networks'"], "stdout": "", "stdout_lines": [

