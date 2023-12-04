# Analysis

Deploy a overcloud with a external Ceph cluster with multiple filesystems and Manila
but we cannot set cephfs_filesystem_name 
so it manila cephfs driver fails with this error :  
2023-12-19 17:12:47.543 9 ERROR manila.share.manager manila.exception.ShareBackendException: Share backend error: Specify Ceph filesystem name using 'cephfs_filesystem_name' driver option.

# patches

t-h-t : https://review.opendev.org/c/openstack/tripleo-heat-templates/+/904034 : introduce the new parameter ManilaCephFSFileSystemName and set cephfs_filesystem_name
py-t-c: https://review.opendev.org/c/openstack/tripleo-heat-templates/+/904034 : to ensure that the new paramter is passed only for external ceph and not internal(deployed) ceph



# testing

updated py-t-c in  /usr/lib/python3.9/site-packages/tripleoclient/
 and tht patch and env file environments/manila-cephfsganesha-config.yaml , and ensure to use the env in overcloud deploy command.

 parameter_defaults:
   ManilaCephFSBackendName: cephfs
+  ManilaCephFSFileSystemName: manoj
   ManilaCephFSDriverHandlesShareServers: false

if  ManilaCephFSFileSystemName: cephfs is used, deployment succeeded.

logs:


2024-01-04 06:50:12.330 943900 INFO tripleoclient.v1.overcloud_deploy.DeployOvercloud [-] Processing templates in the directory /home/stack/overcloud-deploy/overcloud/tripleo-heat-templates

2024-01-04 06:50:16.242 943900 WARNING tripleoclient.utils.safe_write [-] The output file /home/stack/overcloud-deploy/overcloud/overcloud-deployment_status.yaml will be overriden: tripleoclient.exceptions.InvalidConfiguration: ManilaCephFSFileSystemName should not be configured for internal ceph cluster

2024-01-04 06:50:16.242 943900 INFO tripleoclient.v1.overcloud_deploy.DeployOvercloud [-] Stopping ephemeral heat.
2024-01-04 06:50:16.364 943900 INFO tripleoclient.heat_launcher [-] Killing pod: ephemeral-heat
7bf723c75bae3adaff6f4323d4eaf6fc25dca970f8a6c06653ad01910e7c3daa
2024-01-04 06:50:16.509 943900 INFO tripleoclient.heat_launcher [-] Killed pod: ephemeral-heat
2024-01-04 06:50:16.687 943900 INFO tripleoclient.heat_launcher [-] Starting back up of heat db
2024-01-04 06:50:16.919 943900 INFO tripleoclient.heat_launcher [-] Created tarfile /home/stack/overcloud-deploy/overcloud/heat-launcher/heat-db.sql-1704351002.4668493.tar.bzip2
2024-01-04 06:50:16.920 943900 INFO tripleoclient.heat_launcher [-] Deleting /home/stack/overcloud-deploy/overcloud/heat-launcher/heat-db.sql
2024-01-04 06:50:17.405 943900 INFO tripleoclient.heat_launcher [-] Removing pod: ephemeral-heat
7bf723c75bae3adaff6f4323d4eaf6fc25dca970f8a6c06653ad01910e7c3daa
2024-01-04 06:50:17.576 943900 INFO tripleoclient.heat_launcher [-] Created tarfile /home/stack/overcloud-deploy/overcloud/heat-launcher/log/heat-1704351002.4668493.log-1704351002.4668493.tar.bzip2
2024-01-04 06:50:17.576 943900 INFO tripleoclient.heat_launcher [-] Deleting /home/stack/overcloud-deploy/overcloud/heat-launcher/log/heat-1704351002.4668493.log


2024-01-04 06:50:17.577 943900 ERROR openstack [-] ManilaCephFSFileSystemName should not be configured for internal ceph cluster: tripleoclient.exceptions.InvalidConfiguration: ManilaCephFSFileSystemName should not be configured for internal ceph cluster


