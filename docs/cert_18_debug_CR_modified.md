---
apiVersion: test.openstack.org/v1beta1
kind: Tempest
metadata:
  labels:
    app: rhoso-cert
    component: cinder
  name: rhoso-cert-cinder
  namespace: RHOSO_CERT_NAMESPACE
spec:
  containerImage: RHOSO_CERT_TEMPEST_IMAGE
  tempestRun:
    concurrency: RHOSO_CERT_TEMPEST_CONCURRENCY
  tempestconfRun:
    create: true
    debug: true
    # Do not modify the following two lines (deployerInput and testAccounts).
    deployerInput: |
    testAccounts: |
    # In the overrides section:
    #   - Set volume-feature-enabled.consistency_group False if consistency groups are not supported
    #   - Set compute-feature-enabled.volume_multiattach False if multiattach volumes are not supported
    # Do NOT add a YAML comment ('#') in the overrides section.
    overrides: |
      auth.tempest_roles member,swiftoperator
      volume.volume_type_multiattach multiattach
      volume-feature-enabled.extend_attached_encrypted_volume True
      volume-feature-enabled.extend_attached_volume True
      volume-feature-enabled.manage_snapshot True
      volume-feature-enabled.manage_volume True
      volume-feature-enabled.volume_revert True
      volume-feature-enabled.consistency_group True
      compute-feature-enabled.volume_multiattach True
      image-feature-enabled.import_image True
  workflow:
    - stepName: volumes
      tempestRun:
        includeList: |
          tempest.api.compute.admin.test_volumes_negative.UpdateMultiattachVolumeNegativeTest.test_multiattach_rw_volume_update_failure
    - stepName: backups
      tempestRun:
        includeList: |
          tempest.api.volume.admin.test_volumes_backup.VolumesBackupsAdminTest.test_volume_backup_export_import
    - stepName: multi-attach-volume 
      tempestRun:
        includeList: |
          tempest.api.compute.admin.test_volumes_negative.UpdateMultiattachVolumeNegativeTest.test_multiattach_rw_volume_update_failure
        excludeList: |
          tempest.api.compute.volumes.test_attach_volume.AttachVolumeMultiAttachTest.test_boot_from_multiattach_volume_direct_lun
    - stepName: consistency-groups
      tempestRun:
        includeList: |
          cinder_tempest_plugin.api.volume.admin.test_consistencygroups.ConsistencyGroupsV2Test.test_consistencygroup_cgsnapshot_create_delete

