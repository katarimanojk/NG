
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




# res-work on jun 10

zuul@shark19 tests]$ pwd
/home/zuul/data-plane-adoption_netapp/tests

[zuul@shark19 tests]$ cat playbooks/netapp_test.yaml 
- name : test netapp
  hosts: localhost
  vars:
    cinder_volume_backend: 'ontap-nfs'
    cinder_conf_path: /tmp/cinder.conf
    cinder_netapp_backend: "tripleo_netapp"
    netapp_vars:
      - netapp_login
      - netapp_password
      - netapp_server_hostname
      - netapp_vserver
  tasks:
    - name: Deploy cinder-volume if necessary
      when: cinder_volume_backend | default('') != ''
      ansible.builtin.import_role:
        name: cinder_adoption
        tasks_from: volume_backend.yaml
[zuul@shark19 tests]$ 



[zuul@shark19 tests]$ git diff
diff --git a/tests/roles/cinder_adoption/tasks/volume_backend.yaml b/tests/roles/cinder_adoption/tasks/volume_backend.yaml
index 937f0e0..4a5c6a6 100644
--- a/tests/roles/cinder_adoption/tasks/volume_backend.yaml
+++ b/tests/roles/cinder_adoption/tasks/volume_backend.yaml
@@ -4,3 +4,7 @@
     {{ shell_header }}
     {{ oc_header }}
     oc patch openstackcontrolplane openstack --type=merge --patch '{{ cinder_volume_backend_patch }}'
+
+- name: deploy podified Cinder volume with netapp NFS
+  when: cinder_volume_backend == 'ontap-nfs'
+  ansible.builtin.include_tasks: netapp.yaml



[zuul@shark19 tests]$ cat roles/cinder_adoption/tasks/netapp.yaml
- name: Deploy Podified Manila - Netapp
  block:
    - name: Extract Netapp data from cinder.conf
      ansible.builtin.set_fact:
        netapp_config: "{{ netapp_config | default({}) | combine({item: lookup('ansible.builtin.ini', item, file=cinder_conf_path, section=cinder_netapp_backend, allow_no_value=True)}) }}"
      loop: "{{ netapp_vars }}"

    - name: print netapp_config
      debug:
        msg: "{{ netapp_config }}"

    - name: Fail if netapp_config params are not defined
      when: |
        netapp_config.netapp_login is not defined or
        netapp_config.netapp_password is not defined or
        netapp_config.netapp_vserver is not defined or
        netapp_config.netapp_server_hostname is not defined
      ansible.builtin.fail:
        msg:
          - 'Missing required Netapp input'

    - name: Render Netapp OpenShift Secret template
      ansible.builtin.template:
        src: "{{ role_path }}/templates/cinder-volume-ontap-secrets.yaml.j2"
        dest: /tmp/cinder-volume-ontap-secrets.yaml
        mode: "0600"

    - name: Apply the rendered Netapp secret in the openstack namespace
      ansible.builtin.shell: |
        #{{ shell_header }}
        #{{ oc_header }}
        oc apply -f /tmp/cinder-volume-ontap-secrets.yaml

    - name: Configure netapp NFS backend
      ansible.builtin.shell: |
        #{{ shell_header }}
        #{{ oc_header }}
        #oc patch openstackcontrolplane openstack --type=merge --patch-file={{ role_path }}/files/cinder_netapp_nfs.yaml
        oc patch openstackcontrolplane openstack-galera-network-isolation --type=merge --patch-file={{ role_path }}/files/cinder_netapp_nfs.yaml
[zuul@shark19 tests]$ 







## changed the below two files based on the netapp cert guide but if is failing with error

2025-06-11 18:32:57.174 2270546 ERROR cinder.volume.manager cinder.exception.NfsException: NFS config file at /etc/cinder/nfs_shares doesn't exist

/etc/cinder.nfs_shares is the default 

[zuul@shark19 tests]$ cat roles/cinder_adoption/templates/cinder-volume-ontap-secrets.yaml.j2 
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
    [ontap-nfs]
    netapp_server_hostname = {{ netapp_config.netapp_server_hostname }}
    netapp_login = {{ netapp_config.netapp_login }}
    netapp_password = {{ netapp_config.netapp_password }}
    netapp_vserver = {{ netapp_config.netapp_vserver }} 


[zuul@shark19 tests]$ cat roles/cinder_adoption/files/cinder_netapp_nfs.yaml 
spec:
  cinder:
    template:
      cinderVolumes:
        ontap-nfs:
          networkAttachments:
            - storage
          customServiceConfig: |
            [ontap-nfs]
            volume_backend_name=ontap-nfs
            volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
            netapp_storage_protocol=nfs
            netapp_storage_family=ontap_cluster
            nfs_snapshot_support=true
            nas_secure_file_operations=false
            nas_secure_file_permissions=false
            netapp_server_port=80
          customServiceConfigSecrets:
            - cinder-volume-ontap-secrets
[zuul@shark19 tests]$ 


based on tripleo, where nfs_shares_config always defaults to '/etc/cinder/shares.conf' i added nfs_shares_config= '/etc/cinder/shares.conf' to customServiceConfig:


which then fails with 
cinder.volume.manager cinder.exception.NfsException: NFS config file at /etc/cinder/shares.conf doesn't exist

which means we should copy the /etc/cinder/shares.conf from tripleo https://rhos-ci-logs.lab.eng.tlv2.redhat.com/logs/rcj/DFG-all-unified-17.1_d-rhel-vhost-3cont_2[…]r/lib/config-data/cinder/etc/cinder/shares.conf.gz

and injext into ocp cinder-volume container to avoid the error.

# nas_host + nas_share_path  vs nfs_share_config:


def do_setup(self, context):
        """Any initialization the volume driver does while starting."""
        super(NfsDriver, self).do_setup(context)

        nas_host = getattr(self.configuration,
                           'nas_host',
                           None)
        nas_share_path = getattr(self.configuration,
                                 'nas_share_path',
                                 None)

        # If both nas_host and nas_share_path are set we are not
        # going to use the nfs_shares_config file.  So, only check
        # for its existence if it is going to be used.
        if((not nas_host) or (not nas_share_path)):
            config = self.configuration.nfs_shares_config
            if not config:
                msg = (_("There's no NFS config file configured (%s)") %
                       'nfs_shares_config')


nfs backend example in cert deployment guide below tell us how to inject nfs_shares_config as secret to cinder-volume containers

https://netapp-openstack-dev.github.io/openstack-docs/antelope/cinder/configuration/cinder_config_files/section_rhoso18_configuration.html#deployment-steps




spec:
  cinder:
    template:
      extraMounts:
      - extraVol:
        - mounts:
          - name: nfs-config
            mountPath: /etc/cinder/nfs_shares
            subPath: nfs_shares
            readOnly: true
          propagation:
          - CinderVolume
          volumes:
          - name: nfs-config
            secret:
              secretName: cinder-nfs-shares-secrets
      cinderVolumes:
        ontap-nfs:
          networkAttachments:
            - storage
            - storageMgmt
          customServiceConfig: |
            [ontap-nfs]
            volume_backend_name=ontap-nfs
            volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
            netapp_storage_protocol=nfs
            netapp_storage_family=ontap_cluster
            nfs_snapshot_support=true
            nas_secure_file_operations=false
            nas_secure_file_permissions=false
            netapp_server_port=80
            nfs_shares_config= '/etc/cinder/nfs_shares'
          customServiceConfigSecrets:
            - cinder-volume-ontap-secrets
~                                         

and came up with this patch:  see the file same as this file name and with extramount
but as per francesco, archiecture uni02beta is just using nas_host and nas_shares_path in same secret

https://github.com/openstack-k8s-operators/architecture/blob/main/examples/dt/uni02beta/control-plane/service-values.yaml#L21
and also https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/blob/main/scenarios/uni/uni02beta/04-scenario-vars.yaml?ref_type=heads

even cinder-operator says it: 
https://github.com/openstack-k8s-operators/cinder-operator/blob/main/config/samples/backends/netapp/ontap/nfs/backend.yaml

so we don't need extramounts and just add nas




testing after adding back nas params and removing new secret  (latest patch):


[zuul@shark19 tests]$ ansible-playbook playbooks/netapp_test.yaml                                                      
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match  
'all'                                                      
                                                           
PLAY [test netapp] *************************************************************************************************** 
                                                           
TASK [Gathering Facts] ***********************************************************************************************                                                                                                                        
ok: [localhost]                                                                                                        
                                                                                                                       
TASK [cinder_adoption : deploy podified Cinder volume] *************************************************************** 
skipping: [localhost]                                                                                                  
                                                                                                                       
TASK [cinder_adoption : deploy podified Cinder volume with netapp NFS] *********************************************** 
included: /home/zuul/data-plane-adoption_netapp/tests/roles/cinder_adoption/tasks/netapp_nfs.yaml for localhost        
                                                                                                                       
TASK [cinder_adoption : Extract Netapp data from cinder.conf] ******************************************************** 
ok: [localhost] => (item=netapp_login)                                                                                 
ok: [localhost] => (item=netapp_password)                                                                              
ok: [localhost] => (item=netapp_server_hostname)                                                                       
ok: [localhost] => (item=netapp_vserver)                                                                               
                                                                                                                       
TASK [cinder_adoption : Extract nfs share vars from nfs_shares_conf_path] ******************************************** 
ok: [localhost]                                                                                                        
                                                                                                                       
TASK [cinder_adoption : print netapp_config] ************************************************************************* 
ok: [localhost] => {                                                                                                   
    "msg": {                                                                                                           
        "netapp_login": "cifmw_user",                                                                                  
        "netapp_password": "Qum!8netd",                                                                                
        "netapp_server_hostname": "10.46.84.4",                                                                        
        "netapp_vserver": "vserver-rhos-qe"                                                                            
    }                                                                                                                  
}                                                                                                                      
                                                                                                                       
TASK [cinder_adoption : Fail if netapp_config params are not defined] ************************************************ 
skipping: [localhost]                                                                                                  
                                                                                                                       
TASK [cinder_adoption : Render Netapp OpenShift Secret template] ***************************************************** 
changed: [localhost]                                                                                                   
                                                                                                                       
TASK [cinder_adoption : Apply the rendered Netapp secret in the openstack namespace] ********************************* 
changed: [localhost]                                                                                                   
                                                                                                                       
TASK [cinder_adoption : Configure netapp NFS backend] **************************************************************** 
changed: [localhost]                                       
                                                           
PLAY RECAP *********************************************************************************************************** 
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0     






[zuul@shark19 tests]$ cat playbooks/netapp_test.yaml
- name : test netapp
  hosts: localhost
  vars:
    cinder_volume_backend: 'ontap-nfs'
    cinder_conf_path: /tmp/cinder.conf
    nfs_shares_conf_path: /tmp/shares.conf
    cinder_netapp_backend: "tripleo_netapp"
    netapp_vars:
      - netapp_login
      - netapp_password
      - netapp_server_hostname
      - netapp_vserver
  tasks:
    - name: Deploy cinder-volume if necessary
      when: cinder_volume_backend | default('') != ''
      ansible.builtin.import_role:
        name: cinder_adoption
        tasks_from: volume_backend.yaml
[zuul@shark19 tests]$ 



[zuul@shark19 tests]$  oc rsh cinder-volume-ontap-nfs-0 cat /etc/cinder/cinder.conf.d/03-service-custom.conf                                                                                                                                  
Defaulted container "cinder-volume" out of: cinder-volume, probe                                   
[DEFAULT]                                                                                                                                                                                                                                     
enabled_backends=ontap-nfs                                                                                                                                                                                                                    [ontap-nfs]                                                                                                                                                                                                                                   
volume_backend_name=ontap-nfs                                                                                                                                                                                                                 volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver                                                                                                                                                                                
netapp_storage_protocol=nfs                                                                                                                                                                                                                   
netapp_storage_family=ontap_cluster                                                                                                                                                                                                           
nfs_snapshot_support=true                                                                                                                                                                                                                     
nas_secure_file_operations=false                                                                                                                                                                                                              
nas_secure_file_permissions=false                                                                                                                                                                                                             
netapp_server_port=80                                                                                                                                                                                                                         
#netapp_pool_name_search_pattern=(.+)                                                                                                                                                                                                         
#nfs_shares_config= '/etc/cinder/nfs_shares'                                                                                                                                                                                                  
[zuul@shark19 tests]$ oc rsh cinder-volume-ontap-nfs-0 cat /etc/cinder/cinder.conf.d/04-service-custom-secrets.conf                                                                                                                           
Defaulted container "cinder-volume" out of: cinder-volume, probe
[ontap-nfs]                                                                                                            
netapp_server_hostname = 10.46.84.4                  
netapp_login = cifmw_user                  
netapp_password = Qum!8netd                                                                                            
netapp_vserver = vserver-rhos-qe                                                                                                                                                                                                              
nas_host = 10.46.246.60 
nas_share_path = /cinder_nfs



[zuul@shark19 tests]$ oc delete pod cinder-volume-ontap-nfs-0                                                                                                                                                                                 
pod "cinder-volume-ontap-nfs-0" deleted                                                                                                                                                                                                       
[zuul@shark19 tests]$ oc logs -f cinder-volume-ontap-nfs-0                                                                                                                                                                                    
Defaulted container "cinder-volume" out of: cinder-volume, probe   


2025-06-13 12:12:21.043 716472 INFO cinder.service [-] Starting cinder-volume node (version 22.3.1)
2025-06-13 12:12:21.067 716472 INFO cinder.volume.manager [None req-47a304b5-834d-493e-bec2-15e1fb14eec6 - - - - - -] Starting volume driver NetAppCmodeNfsDriver (3.0.0)
2025-06-13 12:12:25.399 716472 WARNING cinder.volume.drivers.nfs [None req-47a304b5-834d-493e-bec2-15e1fb14eec6 - - - - - -] The NAS file permissions mode will be 666 (allowing other/world read & write access). This is considered an insecure NAS environment. Please see https://docs.openstack.org/cinder/latest/admin/blockstorage-nfs-backend.html for information on a secure NFS configuration.
2025-06-13 12:12:25.400 716472 WARNING cinder.volume.drivers.nfs [None req-47a304b5-834d-493e-bec2-15e1fb14eec6 - - - - - -] The NAS file operations will be run as root: allowing root level access at the storage backend. This is considered an insecure NAS environment. Please see https://docs.openstack.org/cinder/latest/admin/blockstorage-nfs-backend.html for information on a secure NAS configuration.
2025-06-13 12:12:27.200 716472 INFO cinder.volume.drivers.netapp.dataontap.client.client_cmode [None req-47a304b5-834d-493e-bec2-15e1fb14eec6 - - - - - -] Reported ONTAPI Version: 1.201
2025-06-13 12:12:32.444 716472 INFO cinder.volume.drivers.netapp.dataontap.utils.capabilities [None req-47a304b5-834d-493e-bec2-15e1fb14eec6 - - - - - -] Updating storage service catalog information for backend 'ontap-nfs'
2025-06-13 12:12:51.551 716472 INFO cinder.volume.driver [None req-47a304b5-834d-493e-bec2-15e1fb14eec6 - - - - - -] Driver hasn't implemented _init_vendor_properties()
2025-06-13 12:12:51.654 716472 INFO cinder.keymgr.migration [None req-023b6ced-0273-40ed-a537-d1053e597cbb - - - - - -] Not migrating encryption keys because the ConfKeyManager's fixed_key is not in use.
2025-06-13 12:13:07.944 716472 INFO cinder.volume.manager [None req-47a304b5-834d-493e-bec2-15e1fb14eec6 - - - - - -] Driver initialization completed successfully.
2025-06-13 12:13:07.945 716472 INFO cinder.manager [None req-47a304b5-834d-493e-bec2-15e1fb14eec6 - - - - - -] Initiating service 2 cleanup
2025-06-13 12:13:07.965 716472 INFO cinder.manager [None req-47a304b5-834d-493e-bec2-15e1fb14eec6 - - - - - -] Service 2 cleanup completed.
2025-06-13 12:13:08.068 716472 INFO cinder.volume.manager [None req-47a304b5-834d-493e-bec2-15e1fb14eec6 - - - - - -] Initializing RPC dependent components of volume driver NetAppCmodeNfsDriver (3.0.0)
2025-06-13 12:13:24.400 716472 INFO cinder.volume.manager [None req-47a304b5-834d-493e-bec2-15e1fb14eec6 - - - - - -] Driver post RPC initialization completed successfully.





2025-06-13 12:17:08.903 716472 INFO cinder.volume.flows.manager.create_volume [None req-8be1dd73-1a94-4c9c-a06f-078fbed86a7f 73b83a18ad0344cfa5df2dddb4a1a24b 988f47e9fd424e39b22b6a1ea20335f8 - - - -] Volume decc17b8-c803-4f45-9c99-c0d17062471e: being created as raw with specification: {'status': 'creating', 'volume_name': 'volume-decc17b8-c803-4f45-9c99-c0d17062471e', 'volume_size': 1}
2025-06-13 12:17:11.830 716472 WARNING cinder.volume.drivers.remotefs [None req-8be1dd73-1a94-4c9c-a06f-078fbed86a7f 73b83a18ad0344cfa5df2dddb4a1a24b 988f47e9fd424e39b22b6a1ea20335f8 - - - -] /var/lib/cinder/mnt/7ff28a46339f6cd32165cef2ec9fb1eb/volume-decc17b8-c803-4f45-9c99-c0d17062471e is being set with open permissions: ugo+rw
2025-06-13 12:17:12.573 716472 INFO cinder.volume.flows.manager.create_volume [None req-8be1dd73-1a94-4c9c-a06f-078fbed86a7f 73b83a18ad0344cfa5df2dddb4a1a24b 988f47e9fd424e39b22b6a1ea20335f8 - - - -] Volume volume-decc17b8-c803-4f45-9c99-c0d17062471e (decc17b8-c803-4f45-9c99-c0d17062471e): created successfully
2025-06-13 12:17:12.586 716472 INFO cinder.volume.manager [None req-8be1dd73-1a94-4c9c-a06f-078fbed86a7f 73b83a18ad0344cfa5df2dddb4a1a24b 988f47e9fd424e39b22b6a1ea20335f8 - - - -] Created volume successfully.




backup?







2025-06-16 15:47:09.115 2311837 INFO cinder.keymgr.migration [None req-d966ad15-9088-4bfd-bc73-737af2633dc7 - - - - - -] Not migrating encryption keys because the ConfKeyManager's fixed_key is not in use.
2025-06-16 15:47:10.026 2311837 INFO oslo.privsep.daemon [-] Spawned new privsep daemon via rootwrap
2025-06-16 15:47:09.878 2312451 INFO oslo.privsep.daemon [-] privsep daemon starting
2025-06-16 15:47:09.885 2312451 INFO oslo.privsep.daemon [-] privsep process running with uid/gid: 0/0
2025-06-16 15:47:09.888 2312451 INFO oslo.privsep.daemon [-] privsep process running with capabilities (eff/prm/inh): CAP_SYS_ADMIN/CAP_SYS_ADMIN/none
2025-06-16 15:47:09.888 2312451 INFO oslo.privsep.daemon [-] privsep daemon running as pid 2312451
2025-06-16 15:47:19.210 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:47:29.212 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:47:39.214 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:47:49.215 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:47:59.240 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:48:09.255 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:48:19.256 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:48:29.258 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:48:39.260 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:48:49.262 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:48:59.264 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:49:09.265 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:49:19.267 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:49:29.268 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:49:39.272 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:49:49.274 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:49:59.275 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
2025-06-16 15:50:09.276 2311837 ERROR cinder.service [-] Manager for service cinder-backup cinder-backup-0 is reporting problems, not sending heartbeat. Service will appear "down".
^@^C
[zuul@shark19 tests]$ oc logs -f cinder-backup-0


#  backup_mount_point_base

when i remove the parameter backup_mount_point_base, backup dirver failed to comeup


[zuul@shark19 tests]$ oc get pods | grep cinder-backup
cinder-backup-0                               0/2     Pending     0                26s

This is an optional parameter for swift/ceph backup driver whereas it mandatory for nfs based backup driver. 
It indicates the base directory where NFS shares for backups (backup_share) are mounted. i.e backup driver needs to mount the nfs filesystem to read/write backup data.
