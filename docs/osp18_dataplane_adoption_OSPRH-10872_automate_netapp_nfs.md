
https://issues.redhat.com/browse/OSPRH-10614 : this is Luigis epic that does uni02beta job implementaiton

https://issues.redhat.com/browse/OSPRH-10872 is the epic for this work

OSPRH-13615 is the story for this work



slack thread discussion wiht tosky: https://redhat-internal.slack.com/archives/C04GLFJE57Y/p1739785898269289



cinder-operator has:
"config/samples/backends/netapp/ontap/nfs/backend.yaml"  : which is generally used during openstack_deploy to customize the controlplane to use netapp nfs



reference from unigamma: 
OSPRH - 7885 : mikolaj

10614: unibeta luigi


uni alpha: it is lvm (nvme based), better to disable cinder adoption as there is no point in migrating lvm


pure strorage with nvme/FC would be available next year


uni gamma work:

https://gitlab.cee.redhat.com/ci-framework/ci-framework-testproject/-/merge_requests/286
https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/merge_requests/1300




# how cinder-operator configures netapp backend in the ctlplane




[mkatari@fedora ontap]$ cat nfs/backend.yaml 
# To be able to use this sample it is necessary to:
# - Have a NetApp ONTAP backend with NFS support
# - Have the NetApp storage credentials and NFS configuration in cinder-volume-ontap-secrets.yaml
#
# NOTE: Rather than using a shares-config file, the driver uses the nas_host
# and nas_share_path parameters in the secrets file. For multiple shares,
# configure a separate cinder-volume backend and secrets file for each share.

apiVersion: core.openstack.org/v1beta1
kind: OpenStackControlPlane
metadata:
  name: openstack
spec:
  cinder:
    template:
      cinderVolumes:
        ontap-nfs:
          networkAttachments:
          - storage
          customServiceConfig: |
            [ontap]
            volume_backend_name=ontap
            volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
            nfs_snapshot_support=true
            nas_secure_file_operations=false
            nas_secure_file_permissions=false
            netapp_server_hostname=hostname
            netapp_server_port=80
            netapp_storage_protocol=nfs
            netapp_storage_family=ontap_cluster
          customServiceConfigSecrets:
          - cinder-volume-ontap-secrets



[mkatari@fedora ontap]$ cat iscsi/cinder-volume-ontap-secrets.yaml 
# Define the "cinder-volume-ontap-secrets" Secret that contains sensitive
# information pertaining to the [ontap] backend.
apiVersion: v1
kind: Secret
metadata:
  labels:
    service: cinder
    component: cinder-volume
  name: cinder-volume-ontap-secrets
type: Opaque
stringData:
  ontap-secrets.conf: |
    [ontap]
    netapp_login=admin_username
    netapp_password=admin_password
    netapp_vserver=svm_name
    netapp_server_hostname=hostname
    netapp_server_port=80
[mkatari@fedora ontap]$ cat nfs/cinder-volume-ontap-secrets.yaml 
# Define the "cinder-volume-ontap-secrets" Secret that contains sensitive
# information pertaining to the [ontap] backend.
apiVersion: v1
kind: Secret
metadata:
  labels:
    service: cinder
    component: cinder-volume
  name: cinder-volume-ontap-secrets
type: Opaque
stringData:
  ontap-cinder-secrets: |
    [ontap]
    netapp_login=admin_username
    netapp_password=admin_password
    netapp_vserver=svm_name
    nas_host=10.63.165.215
    nas_share_path=/nfs/test
[mkatari@fedora ontap]$ pwd
/home/mkatari/checkouts/NG/cinder-operator_myfork/config/samples/backends/netapp/ontap
[mkatari@fedora ontap]$ 








# After applying secrets CR and then patch the control plane





[zuul@shark19 manoj]$ cat cinder-volume-ontap-secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  labels:
    service: cinder
    component: cinder-volume
  name: cinder-volume-ontap-secrets
type: Opaque
stringData:
  ontap-cinder-secrets: |
    [ontap]
    netapp_login=admin_username
    netapp_password=admin_password
    netapp_vserver=svm_name
    nas_host=10.63.165.215
    nas_share_path=/nfs/test

[zuul@shark19 manoj]$ cat cinder_netapp_nfs.yaml
spec:
  cinder:
    template:
      cinderVolumes:
        ontap-nfs:
          networkAttachments:
            - storage
          customServiceConfig: |
            [nfs_netapp]
            volume_backend_name=nfs_netapp
            volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
            nfs_snapshot_support=true
            nas_secure_file_operations=false
            nas_secure_file_permissions=false
            netapp_server_hostname=hostname
            netapp_server_port=80
            netapp_storage_protocol=nfs
            netapp_storage_family=ontap_cluster
          customServiceConfigSecrets:
          - cinder-volume-ontap-secrets
[zuul@shark19 manoj]$ 



[zuul@shark19 manoj]$ oc apply -f cinder-volume-ontap-secrets.yaml                                                      
secret/cinder-volume-ontap-secrets created


[zuul@shark19 manoj]$ oc get secret/cinder-volume-ontap-secrets                                    
NAME                          TYPE     DATA   AGE                                                                      
cinder-volume-ontap-secrets   Opaque   1      31s 








[zuul@shark19 manoj]$ oc patch openstackcontrolplane openstack --type=merge --patch-file=/home/zuul/manoj/cinder_netapp_nfs.yaml
openstackcontrolplane.core.openstack.org/openstack patched (no change) 



ctlplane is configured like this

        ontap-nfs:
          customServiceConfig: |
            [nfs_netapp]
            volume_backend_name=nfs_netapp
            volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
            nfs_snapshot_support=true
            nas_secure_file_operations=false
            nas_secure_file_permissions=false
            netapp_server_hostname=hostname
            netapp_server_port=80
            netapp_storage_protocol=nfs
            netapp_storage_family=ontap_cluster
          customServiceConfigSecrets:
          - cinder-volume-ontap-secrets






sh-5.1# ls -lrth
total 0
lrwxrwxrwx. 1 root root 37 Feb  3 05:56 04-service-custom-secrets.conf -> ..data/04-service-custom-secrets.conf
lrwxrwxrwx. 1 root root 29 Feb  3 05:56 03-service-custom.conf -> ..data/03-service-custom.conf
lrwxrwxrwx. 1 root root 28 Feb  3 05:56 02-global-custom.conf -> ..data/02-global-custom.conf
lrwxrwxrwx. 1 root root 31 Feb  3 05:56 01-service-defaults.conf -> ..data/01-service-defaults.conf
lrwxrwxrwx. 1 root root 30 Feb  3 05:56 00-global-defaults.conf -> ..data/00-global-defaults.conf
sh-5.1# date
Mon Feb  3 06:04:29 AM UTC 2025
sh-5.1# cat 04-service-custom-secrets.conf 
[ontap]
netapp_login=admin_username
netapp_password=admin_password
netapp_vserver=svm_name
nas_host=10.63.165.215
nas_share_path=/nfs/test

sh-5.1# cat 03-service-custom.conf 
[DEFAULT]
enabled_backends=nfs_netapp
[nfs_netapp]
volume_backend_name=nfs_netapp
volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
nfs_snapshot_support=true
nas_secure_file_operations=false
nas_secure_file_permissions=false
netapp_server_hostname=hostname
netapp_server_port=80
netapp_storage_protocol=nfs
netapp_storage_family=ontap_cluster
sh-5.1# 






test project job: https://review.rdoproject.org/r/c/testproject/+/55840




TASK [cinder_adoption : Create ontap secret] ***********************************
changed: [localhost] => {"changed": true, "cmd": "set -euxo pipefail\n\n\ncat /home/zuul/src/github.com/openstack-k8s-operators/data-plane-adoption/tests/roles/cinder_adoption/files/cinder-volume-ontap-secrets.yaml | oc apply -f -\n", "delta": "0:00:00.206411", "end": "2025-02-03 11:26:11.224803", "msg": "", "rc": 0, "start": "2025-02-03 11:26:11.018392", "stderr": "+ cat /home/zuul/src/github.com/openstack-k8s-operators/data-plane-adoption/tests/roles/cinder_adoption/files/cinder-volume-ontap-secrets.yaml\n+ oc apply -f -", "stderr_lines": ["+ cat /home/zuul/src/github.com/openstack-k8s-operators/data-plane-adoption/tests/roles/cinder_adoption/files/cinder-volume-ontap-secrets.yaml", "+ oc apply -f -"], "stdout": "secret/cinder-volume-ontap-secrets created", "stdout_lines": ["secret/cinder-volume-ontap-secrets created"]}

TASK [cinder_adoption : Configure netapp NFS backend] **************************
changed: [localhost] => {"changed": true, "cmd": "set -euxo pipefail\n\n\noc patch openstackcontrolplane openstack --type=merge --patch-file=/home/zuul/src/github.com/openstack-k8s-operators/data-plane-adoption/tests/roles/cinder_adoption/files/cinder_netapp_nfs.yaml\n", "delta": "0:00:00.322523", "end": "2025-02-03 11:26:11.875598", "msg": "", "rc": 0, "start": "2025-02-03 11:26:11.553075", "stderr": "+ oc patch openstackcontrolplane openstack --type=merge --patch-file=/home/zuul/src/github.com/openstack-k8s-operators/data-plane-adoption/tests/roles/cinder_adoption/files/cinder_netapp_nfs.yaml", "stderr_lines": ["+ oc patch openstackcontrolplane openstack --type=merge --patch-file=/home/zuul/src/github.com/openstack-k8s-operators/data-plane-adoption/tests/roles/cinder_adoption/files/cinder_netapp_nfs.yaml"], "stdout": "openstackcontrolplane.core.openstack.org/openstack patched", "stdout_lines": ["openstackcontrolplane.core.openstack.org/openstack patched"]}

TASK [cinder_adoption : Deploy cinder-backup if necessary] *********************
skipping: [localhost] => {"changed": false, "false_condition": "cinder_backup_backend | default('') != ''", "skip_reason": "Conditional result was False"}







[zuul@shark19 manoj]$ oc patch openstackcontrolplane openstack --type=merge --patch-file=/home/zuul/manoj/cinder_netapp_nfs.yaml                                                                                                              
openstackcontrolplane.core.openstack.org/openstack patched (no change)                                                                                                                                                                        
[zuul@shark19 manoj]$ oc get openstackcontrolplane.core.openstack.org/openstack -o yaml > feb3_ctlplane.yaml




# luigi  netapp tlv server: https://gitlab.cee.redhat.com/eng/openstack/rhos-infrared/-/blob/master/private/storage/netapp_tlv_multi_iscsi_nfs.yaml?ref_type=heads




/usr/share/openstack-tripleo-heat-templates/environments/netapp_nfs_tlv_config.yaml


---
parameter_defaults:
    CinderEnableIscsiBackend: false
    CinderNetappLogin: 'vsadmin'
    CinderNetappPassword: 'qum5net'
    CinderNetappServerHostname: '10.46.29.74'
    CinderNetappServerPort: '80'
    CinderNetappSizeMultiplier: '1.2'
    CinderNetappTransportType: 'http'
    CinderNetappStorageProtocol: 'iscsi'
    CinderNetappVserver: 'ntap-rhv-dev-rhos'
    # until rocky, and stein as deprecated (https://review.opendev.org/633055):
    CinderNetappStoragePools: '(cinder_volumes)'
    # from train as only value (https://review.opendev.org/679266)
    CinderNetappPoolNameSearchPattern: '(cinder_volumes)'
    CinderEnableNfsBackend: true
    # TLV2 Dev Netapp
    CinderNfsServers: "10.46.29.88:/cinder_nfs"
    GlanceBackend: cinder


## when used ^ in osp deployment, netapp config looks like this



[tripleo_netapp]
backend_host=hostgroup
nfs_mount_options=context=system_u:object_r:container_file_t:s0
volume_backend_name=tripleo_netapp
volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
netapp_login=vsadmin
netapp_password=qum5net
netapp_server_hostname=10.46.29.74
netapp_server_port=80
netapp_size_multiplier=1.2
netapp_storage_family=ontap_cluster
netapp_storage_protocol=iscsi
netapp_transport_type=http
netapp_vfiler=
netapp_vserver=ntap-rhv-dev-rhos
netapp_partner_backend_name=
expiry_thres_minutes=720
thres_avl_size_perc_start=20
thres_avl_size_perc_stop=60
nfs_shares_config=/etc/cinder/shares.conf
netapp_copyoffload_tool_path=
netapp_controller_ips=
netapp_sa_password=
netapp_pool_name_search_pattern=(cinder_volumes)
netapp_host_type=
netapp_webservice_path=/devmgr/v2
nas_secure_file_operations=False
nas_secure_file_permissions=False


[tripleo_nfs]
backend_host=hostgroup
volume_backend_name=tripleo_nfs
volume_driver=cinder.volume.drivers.nfs.NfsDriver
nfs_shares_config=/etc/cinder/shares-nfs.conf
nfs_mount_options=context=system_u:object_r:container_file_t:s0
nfs_snapshot_support=False
nas_secure_file_operations=False
nas_secure_file_permissions=False





secrets to be captured from tripleo:

netapp_login=vsadmin
netapp_password=qum5net
netapp_vserver=ntap-rhv-dev-rhos


netapp_server_hostname=10.46.29.74




[zuul@osp-controller-di8bdupq-0 ~]$ sudo python3 -c "import configparser; c = configparser.ConfigParser(); c.read('/var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf'); print(c['tripleo_netapp']['netapp_login'])"
vsadmin


[zuul@osp-controller-di8bdupq-0 ~]$ sudo python3 -c "import configparser; c = configparser.ConfigParser(); c.read('/var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf'); print(c['tripleo_netapp']['netapp_password'])"
qum5net

[zuul@osp-controller-di8bdupq-0 ~]$ sudo python3 -c "import configparser; c = configparser.ConfigParser(); c.read('/var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf'); print(c['tripleo_netapp']['netapp_vserver'])"
ntap-rhv-dev-rhos
[zuul@osp-controller-di8bdupq-0 ~]$



[zuul@osp-controller-di8bdupq-0 ~]$ sudo python3 -c "import configparser; c = configparser.ConfigParser(); c.read('/var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf'); print(c['tripleo_netapp']['netapp_server_hostname'])"
10.46.29.74
[zuul@osp-controller-di8bdupq-0 ~]$ sudo python3 -c "import configparser; c = configparser.ConfigParser(); c.read('/var/lib/config-data/puppet-generated/cinder/etc/cinder/cinder.conf'); print(c['tripleo_netapp']['nfs_shares_config'])"
/etc/cinder/shares.conf
[zuul@osp-controller-di8bdupq-0 ~]$




Doutbs:

can we look at unibeta deployment job cinder.conf ? how is the ontap secrets file edited to use the netapp server details ?


# unibeta (greenfield) deployment job:  https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/blob/main/scenarios/uni/uni02beta/04-scenario-vars.yaml?ref_type=heads



## TLV2 NetApp access info
cifmw_architecture_netapp:
  cluster_ip: 10.46.84.4
  credentials: "{{ lookup('file', '/home/zuul/secrets/netapp_access.yaml') | from_yaml }}"
  vserver: vserver-rhos-qe
  nfs_lif_ip: 10.46.246.60
  nfs_path: /cinder_nfs
  glance_nfs_path: /glance_nfs_uni02beta
  cinder_pool: cinder_nfs
  nova_nfs_path: nova_nfs_uni02beta
  nova_cluster_ip: 10.46.246.77


cifmw_architecture_user_kustomize:
  stage_1:
    service-values:
      data:
        cinderVolumes:
          ontap-nfs:
            customServiceConfig: |
              [ontap]
              nfs_snapshot_support=true
              nas_secure_file_operations=false
              nas_secure_file_permissions=false
              volume_backend_name=ontap
              volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
              netapp_server_hostname={{ cifmw_architecture_netapp.cluster_ip }}
              netapp_server_port=80
              netapp_storage_protocol=nfs
              netapp_storage_family=ontap_cluster
        ontap-cinder-secrets.conf: |
          [ontap]
          netapp_login = {{ cifmw_architecture_netapp.credentials.username }}
          netapp_password = {{ cifmw_architecture_netapp.credentials.password }}
          netapp_vserver = {{ cifmw_architecture_netapp.vserver }}
          nas_host = {{ cifmw_architecture_netapp.nfs_lif_ip }}
          nas_share_path = {{ cifmw_architecture_netapp.nfs_path }}
          netapp_pool_name_search_pattern = ({{ cifmw_architecture_netapp.cinder_pool }})

## file is copied from 
[mkatari@fedora ci-framework-jobs_myfork]$ grep -inr netapp_access .
./playbooks/baremetal/prepare-controller.yaml:127:        src: "{{ credential_path }}/netapp_access.yaml"
./playbooks/baremetal/prepare-controller.yaml:128:        dest: "{{ ansible_user_dir }}/secrets/netapp_access.yaml"

credential_path: "/var/tmp/qe-secrets"


another netapp tlv server: https://gitlab.cee.redhat.com/eng/openstack/rhos-infrared/-/blob/master/private/storage/netapp_tlv_multi_iscsi_nfs.yaml?ref_type=heads




/usr/share/openstack-tripleo-heat-templates/environments/netapp_nfs_tlv_config.yaml


---
parameter_defaults:
    CinderEnableIscsiBackend: false
    CinderNetappLogin: 'vsadmin'
    CinderNetappPassword: 'qum5net'
    CinderNetappServerHostname: '10.46.29.74'
    CinderNetappServerPort: '80'
    CinderNetappSizeMultiplier: '1.2'
    CinderNetappTransportType: 'http'
    CinderNetappStorageProtocol: 'iscsi'
    CinderNetappVserver: 'ntap-rhv-dev-rhos'
    # until rocky, and stein as deprecated (https://review.opendev.org/633055):
    CinderNetappStoragePools: '(cinder_volumes)'
    # from train as only value (https://review.opendev.org/679266)
    CinderNetappPoolNameSearchPattern: '(cinder_volumes)'
    CinderEnableNfsBackend: true
    # TLV2 Dev Netapp
    CinderNfsServers: "10.46.29.88:/cinder_nfs"
    GlanceBackend: cinder









# keeping the rdo testing bit aside as it is of no use

[mkatari@fedora data-plane-adoption_myfork]$ git diff
diff --git a/tests/playbooks/test_minimal.yaml b/tests/playbooks/test_minimal.yaml
index 6d6886c..572b859 100644
--- a/tests/playbooks/test_minimal.yaml
+++ b/tests/playbooks/test_minimal.yaml
@@ -4,6 +4,9 @@
 - name: Adoption
   hosts: "{{ adoption_host | default('localhost') }}"
   gather_facts: false
+  #testing purpose, will be removed later
+  vars:
+    cinder_volume_backend: ontap-nfs
   force_handlers: true
   module_defaults:
     ansible.builtin.shell:
[mkatari@fedora data-plane-adoption_myfork]$ 
