diff --git a/tests/playbooks/test_minimal.yaml b/tests/playbooks/test_minimal.yaml
index 6d6886cdb..572b85989 100644
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
diff --git a/tests/roles/cinder_adoption/files/cinder-volume-ontap-secrets.yaml b/tests/roles/cinder_adoption/files/cinder-volume-ontap-secrets.yaml
new file mode 100644
index 000000000..73e585da5
--- /dev/null
+++ b/tests/roles/cinder_adoption/files/cinder-volume-ontap-secrets.yaml
@@ -0,0 +1,19 @@
+# Define the "cinder-volume-ontap-secrets" Secret that contains sensitive
+# information pertaining to the [ontap] backend.
+apiVersion: v1
+kind: Secret
+metadata:
+  labels:
+    service: cinder
+    component: cinder-volume
+  name: cinder-volume-ontap-secrets
+type: Opaque
+stringData:
+  ontap-cinder-secrets: |
+    [ontap-nfs]
+    netapp_login=vsadmin
+    netapp_password=qum5net
+    netapp_vserver=ntap-rhv-dev-rhos
+    nas_host=10.46.29.88
+    nas_share_path=/cinder_nfs
+    netapp_pool_name_search_pattern=(cinder_volumes)
diff --git a/tests/roles/cinder_adoption/files/cinder_netapp_nfs.yaml b/tests/roles/cinder_adoption/files/cinder_netapp_nfs.yaml
new file mode 100644
index 000000000..f9ae74a79
--- /dev/null
+++ b/tests/roles/cinder_adoption/files/cinder_netapp_nfs.yaml
@@ -0,0 +1,21 @@
+spec:
+  cinder:
+    template:
+      cinderVolumes:
+        ontap-nfs:
+          networkAttachments:
+            - storage
+          customServiceConfig: |
+            [ontap-nfs]
+            volume_backend_name=ontap-nfs
+            volume_driver=cinder.volume.drivers.netapp.common.NetAppDriver
+            nfs_snapshot_support=true
+            nas_secure_file_operations=false
+            nas_secure_file_permissions=false
+            # TLV netapp host
+            netapp_server_hostname=10.46.29.74
+            netapp_server_port=80
+            netapp_storage_protocol=nfs
+            netapp_storage_family=ontap_cluster
+          customServiceConfigSecrets:
+          - cinder-volume-ontap-secrets
diff --git a/tests/roles/cinder_adoption/tasks/volume_backend.yaml b/tests/roles/cinder_adoption/tasks/volume_backend.yaml
index 937f0e0f0..13e8eab27 100644
--- a/tests/roles/cinder_adoption/tasks/volume_backend.yaml
+++ b/tests/roles/cinder_adoption/tasks/volume_backend.yaml
@@ -1,6 +1,21 @@
-- name: deploy podified Cinder volume
+- name: deploy podified Cinder volume with ceph
   when: cinder_volume_backend == 'ceph'
   ansible.builtin.shell: |
     {{ shell_header }}
     {{ oc_header }}
     oc patch openstackcontrolplane openstack --type=merge --patch '{{ cinder_volume_backend_patch }}'
+
+- name: deploy podified Cinder volume with netapp NFS
+  when: cinder_volume_backend == 'ontap-nfs'
+  block:
+    - name: Create ontap secret
+      ansible.builtin.shell: |
+        {{ shell_header }}
+        {{ oc_header }}
+        cat {{ role_path }}/files/cinder-volume-ontap-secrets.yaml | oc apply -f -
+
+    - name: Configure netapp NFS backend
+      ansible.builtin.shell: |
+        {{ shell_header }}
+        {{ oc_header }}
+        oc patch openstackcontrolplane openstack --type=merge --patch-file={{ role_path }}/files/cinder_netapp_nfs.yaml
