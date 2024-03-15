


1. create a hook playbook that disables swift in the control plane
2. call the hook in a scenario
3. use the scenario in the job (zuul.d/)




job results:


https://logserver.rdoproject.org/47/1347/9e242a763dc5b607b796326853189ca24142e57f/github-check/podified-multinode-hci-deployment-crc/1334e18/controller/ci-framework-data/logs/ci_script_003_run_kustomize_swift_in.log
PLAY [Kustomize ControlPlane for swift service] ********************************

TASK [Ensure the kustomizations dir exists path={{ cifmw_basedir }}/artifacts/manifests/kustomizations/controlplane, state=directory] ***
Monday 01 April 2024  01:23:55 -0400 (0:00:00.054)       0:00:00.054 ********** 
ok: [localhost]

TASK [Create kustomization to disable swift dest={{ cifmw_basedir }}/artifacts/manifests/kustomizations/controlplane/98-swift-kustomization.yaml, content=apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
namespace: {{ cifmw_install_yamls_defaults['NAMESPACE'] }}
patches:
- target:
    kind: OpenStackControlPlane
  patch: |-
    - op: add
      path: /spec/swift/enabled
      value: {{ cifmw_services_swift_enabled | default('false') }}] ***
Monday 01 April 2024  01:23:55 -0400 (0:00:00.303)       0:00:00.358 ********** 
changed: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

Monday 01 April 2024  01:23:56 -0400 (0:00:00.612)       0:00:00.971 ********** 
=============================================================================== 
Create kustomization to disable swift ----------------------------------- 0.61s
Ensure the kustomizations dir exists ------------------------------------ 0.30s 








2024-04-01 01:54:13.077358 | controller | TASK [cifmw_cephadm : Configure ceph object store to use external ceph object gateway _raw_params=configure_object.yml] ***
2024-04-01 01:54:13.077363 | controller | Monday 01 April 2024  01:54:13 -0400 (0:00:00.057)       0:33:45.919 **********
2024-04-01 01:54:13.120261 | controller | included: /home/zuul/src/github.com/openstack-k8s-operators/ci-framework/roles/cifmw_cephadm/tasks/configure_object.yml for compute-0
2024-04-01 01:54:13.120292 | controller |
2024-04-01 01:54:13.120298 | controller | TASK [cifmw_cephadm : Check if swift is enabled in deployed controlplane _raw_params=set -o pipefail && oc -n {{ cifmw_cephadm_ns }}  get $(oc get oscp -n openstack -o name) -o json| jq .spec.swift.enabled] ***
2024-04-01 01:54:13.120303 | controller | Monday 01 April 2024  01:54:13 -0400 (0:00:00.042)       0:33:45.962 **********
2024-04-01 01:54:13.786313 | controller | changed: [compute-0 -> localhost]
2024-04-01 01:54:13.786363 | controller |
2024-04-01 01:54:13.786376 | controller | TASK [cifmw_cephadm : Check if swift endpoint is already created _raw_params=set -o pipefail && oc -n {{ cifmw_cephadm_ns }} rsh openstackclient openstack endpoint list | grep 'swift.*object-store' | wc -l] ***
2024-04-01 01:54:13.786387 | controller | Monday 01 April 2024  01:54:13 -0400 (0:00:00.665)       0:33:46.628 **********
2024-04-01 01:54:18.051296 | controller | fatal: [compute-0 -> localhost]: FAILED! => {"changed": true, "cmd": "set -o pipefail && oc -n openstack rsh openstackclient openstack endpoint list | grep 'swift.*object-store' | wc -l", "delta": "0:00:04.031815", "end": "2024-04-01 01:54:18.003373", "msg": "non-zero return code", "rc": 1, "start": "2024-04-01 01:54:13.971558", "stderr": "", "stderr_lines": [], "stdout": "0", "stdout_lines": ["0"]}
2024-04-01 01:54:18.051489 | controller | ...ignoring
2024-04-01 01:54:18.051508 | controller |
2024-04-01 01:54:18.051523 | controller | TASK [cifmw_cephadm : Display a note about swift deployment msg=WARNING: Swift is deployed and the endpoint exists already, ceph RGW cannot be configured as object store service] ***
2024-04-01 01:54:18.051556 | controller | Monday 01 April 2024  01:54:18 -0400 (0:00:04.264)       0:33:50.893 **********
2024-04-01 01:54:18.137847 | controller | skipping: [compute-0]
2024-04-01 01:54:18.137892 | controller |
2024-04-01 01:54:18.137903 | controller | TASK [cifmw_cephadm : Configure object store to use rgw extra_args={'KUBECONFIG': '{{ cifmw_openshift_kubeconfig }}'}, output_dir=/home/zuul/ci-framework-data/artifacts, script=oc -n {{ cifmw_cephadm_ns }} rsh openstackclient openstack service create --name swift --description 'OpenStack Object Storage' object-store
2024-04-01 01:54:18.137913 | controller | oc -n {{ cifmw_cephadm_ns }} rsh openstackclient openstack user create --project service --password {{ cifmw_ceph_rgw_keystone_psw }}  swift
2024-04-01 01:54:18.137922 | controller | oc -n {{ cifmw_cephadm_ns }} rsh openstackclient openstack role create swiftoperator
2024-04-01 01:54:18.137930 | controller | oc -n {{ cifmw_cephadm_ns }} rsh openstackclient openstack role create ResellerAdmin
2024-04-01 01:54:18.137939 | controller | oc -n {{ cifmw_cephadm_ns }} rsh openstackclient openstack role add --user swift --project service member
2024-04-01 01:54:18.137947 | controller | oc -n {{ cifmw_cephadm_ns }} rsh openstackclient openstack role add --user swift --project service admin
2024-04-01 01:54:18.137956 | controller | oc -n {{ cifmw_cephadm_ns }} rsh openstackclient openstack endpoint create --region regionOne object-store public http://{{ cifmw_cephadm_vip }}:8080/swift/v1/AUTH_%\(tenant_id\)s
2024-04-01 01:54:18.137964 | controller | oc -n {{ cifmw_cephadm_ns }} rsh openstackclient openstack endpoint create --region regionOne object-store internal http://{{ cifmw_cephadm_vip }}:8080/swift/v1/AUTH_%\(tenant_id\)s
2024-04-01 01:54:18.137972 | controller | oc -n {{ cifmw_cephadm_ns }} rsh openstackclient openstack role add --project admin --user admin swiftoperator] ***
2024-04-01 01:54:18.137980 | controller | Monday 01 April 2024  01:54:18 -0400 (0:00:00.086)       0:33:50.979 **********
2024-04-01 01:54:37.612252 | controller | Follow script's output here: /home/zuul/ci-framework-data/logs/ci_script_013_configure_object_store_to_use.log
2024-04-01 01:54:37.612305 | controller | changed: [compute-0 -> localhost]




