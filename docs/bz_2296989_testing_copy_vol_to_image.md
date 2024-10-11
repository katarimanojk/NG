# analysis

copy/upload vol to image  (or) create_image_from_volume

while uisng volume_utils.upload_volume() , tmp_file is used for image conversion 

instead

 attach a volume to cinder volume host ( intialize_connection)
 create glance image and upload data from attached volume directly.



# testing steps


17.1 deployment with


parameter_defaults:
  # Enable use of RBD backend in nova-compute
  NovaEnableRbdBackend: true
  # Enable use of RBD backend in cinder-volume
  CinderEnableRbdBackend: true
  # Backend to use for cinder-backup
  CinderBackupBackend: ceph
  # Backend to use for glance
  GlanceBackend: rbd




 create a cinder volume

 create image from the volume




openstack image create --volume SOURCE_VOLUME IMAGE_NAME







Testing:
vercloud) [stack@undercloud-0 ~]$ ##openstack volume type create rbd_type
(overcloud) [stack@undercloud-0 ~]$ #openstack volume type set --property "volume_backend_name=tripleo_ceph" rbd_type
(overcloud) [stack@undercloud-0 ~]$ #openstack volume create --type rbd_type --size 1 rbd_vol2_test


(overcloud) [stack@undercloud-0 ~]$ openstack image create --volume 9e9b246d-6b8d-4707-92af-80c00c726c2d rbd_vol1_image

+---------------------+--------------------------------------+
| container_format    | bare                                 |
| disk_format         | raw                                  |
| display_description | None                                 |
| id                  | 9e9b246d-6b8d-4707-92af-80c00c726c2d |
| image_id            | 9ac5b2d9-f576-47d3-8dfc-4c9a953c965b |
| image_name          | rbd_vol1_image                       |
| protected           | False                                |
| size                | 1                                    |
| status              | uploading                            |
| updated_at          | 2024-10-28T14:59:07.000000           |
| visibility          | shared                               |
| volume_type         | rbd_type                             |
+---------------------+--------------------------------------+
(overcloud) [stack@undercloud-0 ~]$ openstack image list
+--------------------------------------+----------------------------------+--------+
| ID                                   | Name                             | Status |
+--------------------------------------+----------------------------------+--------+
| 4a132e3d-ff7f-497d-8f93-c3dc36bd8b4a | cirros-0.5.2-x86_64-disk.img     | active |
| 8e8a6585-2b60-42ef-b298-61bfb9dbe9bb | cirros-0.5.2-x86_64-disk.img_alt | active |
| 0cb8b530-760c-536d-a707-53084b717559 | manila-service-image-master      | active |
| 24afb7d5-3ee7-599a-ac8d-55ac83bf2594 | manila-service-image-master_alt  | active |
| 9ac5b2d9-f576-47d3-8dfc-4c9a953c965b | rbd_vol1_image                   | active |
| a1232663-e061-4c94-8ab3-d5a74aa50b40 | test                             | queued |
+--------------------------------------+----------------------------------+--------+

/var/log/containers/cinder/cinder-volume.log

2024-10-28 17:49:22.406 11 DEBUG oslo_concurrency.processutils [req-6612c84e-27e6-459b-80e3-e0ce9f68793c 580b3eb43fce4034854def77dad342a2 d750f1e1780b42a9b7bf8fbbfaeecf75 - - -] Running cmd (subprocess): rbd export --pool volumes volume-9e9b246d-6b8d-4707-92af-80c00c726c2d /var/lib/cinder/conversion/volume-9e9b246d-6b8d-4707-92af-80c00c726c2d-9ac5b2d9-f576-47d3-8dfc-4c9a953c965b --id openstack --cluster ceph --conf /etc/ceph/ceph.conf execute /usr/lib/python3.9/site-packages/oslo_concurrency/processutils.py:384
2024-10-28 17:49:22.591 11 DEBUG oslo_service.periodic_task [req-6771cade-a3c3-45c9-80e6-8aa3f3ff0fa6 - - - - -] Running periodic task VolumeManager.publish_service_capabilities run_periodic_tasks /usr/lib/python3.9/site-packages/oslo_service/periodic_task.py:210
2024-10-28 17:49:22.593 11 DEBUG cinder.volume.drivers.rbd [req-6771cade-a3c3-45c9-80e6-8aa3f3ff0fa6 - - - - -] connecting to openstack@ceph (conf=/etc/ceph/ceph.conf, timeout=-1). _do_conn /usr/lib/python3.9/site-packages/cinder/volume/drivers/rbd.py:480
2024-10-28 17:49:22.637 11 DEBUG cinder.volume.drivers.rbd [req-6771cade-a3c3-45c9-80e6-8aa3f3ff0fa6 - - - - -] connecting to openstack@ceph (conf=/etc/ceph/ceph.conf, timeout=-1). _do_conn /usr/lib/python3.9/site-packages/cinder/volume/drivers/rbd.py:480
2024-10-28 17:49:22.671 11 DEBUG cinder.manager [req-6771cade-a3c3-45c9-80e6-8aa3f3ff0fa6 - - - - -] Notifying Schedulers of capabilities ... _publish_service_capabilities /usr/lib/python3.9/site-packages/cinder/manager.py:197           
2024-10-28 17:49:23.257 11 DEBUG oslo_concurrency.processutils [req-6612c84e-27e6-459b-80e3-e0ce9f68793c 580b3eb43fce4034854def77dad342a2 d750f1e1780b42a9b7bf8fbbfaeecf75 - - -] CMD "rbd export --pool volumes volume-9e9b246d-6b8d-4707-92af-80c00c726c2d /var/lib/cinder/conversion/volume-9e9b246d-6b8d-4707-92af-80c00c726c2d-9ac5b2d9-f576-47d3-8dfc-4c9a953c965b --id openstack --cluster ceph --conf /etc/ceph/ceph.conf" returned: 0 in 0.852s execute /usr/lib/python3.9/site-packages/oslo_concurrency/processutils.py:422
2024-10-28 17:49:23.270 11 DEBUG cinder.image.image_utils [req-6612c84e-27e6-459b-80e3-e0ce9f68793c 580b3eb43fce4034854def77dad342a2 d750f1e1780b42a9b7bf8fbbfaeecf75 - - -] 9ac5b2d9-f576-47d3-8dfc-4c9a953c965b was raw, no need to convert
to raw upload_volume /usr/lib/python3.9/site-packages/cinder/image/image_utils.py:976


with fix


(overcloud) [stack@undercloud-0 ~]$ openstack image create --volume 9e9b246d-6b8d-4707-92af-80c00c726c2d rbd_vol1_image                                                                                                                      
+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| container_format    | bare                                 |
| disk_format         | raw                                  |
| display_description | None                                 |
| id                  | 9e9b246d-6b8d-4707-92af-80c00c726c2d |
| image_id            | 03cbb1c9-8858-4e61-afb4-478449da2d39 |
| image_name          | rbd_vol1_image                       |
| protected           | False                                |
| size                | 1                                    |
| status              | uploading                            |
| updated_at          | 2024-10-30T15:43:03.000000           |
| visibility          | shared                               |
| volume_type         | rbd_type                             |
+---------------------+--------------------------------------+








2024-10-30 19:34:56.090 11 DEBUG oslo_concurrency.processutils [req-e5ac2b4c-1818-4f4b-9899-e5c294e2faff 580b3eb43fce4034854def77dad342a2 d750f1e1780b42a9b7bf8fbbfaeecf75 - - -] Running cmd (subprocess): ceph mon dump --format=json --id openstack --cluster ceph --conf /etc/ceph/ceph.conf execute /usr/lib/python3.9/site-packages/oslo_concurrency/processutils.py:384
2024-10-30 19:34:56.671 11 DEBUG oslo_concurrency.processutils [req-e5ac2b4c-1818-4f4b-9899-e5c294e2faff 580b3eb43fce4034854def77dad342a2 d750f1e1780b42a9b7bf8fbbfaeecf75 - - -] CMD "ceph mon dump --format=json --id openstack --cluster ceph --conf /etc/ceph/ceph.conf" returned: 0 in 0.582s execute /usr/lib/python3.9/site-packages/oslo_concurrency/processutils.py:422
2024-10-30 19:34:56.673 11 DEBUG cinder.volume.drivers.rbd [req-e5ac2b4c-1818-4f4b-9899-e5c294e2faff 580b3eb43fce4034854def77dad342a2 d750f1e1780b42a9b7bf8fbbfaeecf75 - - -] connection data: {'driver_volume_type': 'rbd', 'data': {'name': 'volumes/volume-9e9b246d-6b8d-4707-92af-80c00c726c2d', 'hosts': ['172.17.3.56', '172.17.3.130', '172.17.3.148'], 'ports': ['6789', '6789', '6789'], 'cluster_name': 'ceph', 'auth_enabled': True, 'auth_username': 'openstack', 'secret_type': 'ceph', 'secret_uuid': 'a6ae4f9d-392a-5e5d-b3c4-0023a6f8e45b', 'volume_id': '9e9b246d-6b8d-4707-92af-80c00c726c2d', 'discard': True}} initialize_connection /usr/lib/python3.9/site-packages/cinder/volume/drivers/rbd.py:1535
2024-10-30 19:34:56.674 11 DEBUG os_brick.initiator.connector [req-e5ac2b4c-1818-4f4b-9899-e5c294e2faff 580b3eb43fce4034854def77dad342a2 d750f1e1780b42a9b7bf8fbbfaeecf75 - - -] Factory for rbd on None factory /usr/lib/python3.9/site-packages/os_brick/initiator/connector.py:278
2024-10-30 19:34:56.676 11 DEBUG os_brick.initiator.linuxrbd [req-e5ac2b4c-1818-4f4b-9899-e5c294e2faff 580b3eb43fce4034854def77dad342a2 d750f1e1780b42a9b7bf8fbbfaeecf75 - - -] opening connection to ceph cluster (timeout=-1). connect /usr/lib/python3.9/site-packages/os_brick/initiator/linuxrbd.py:70
2024-10-30 19:34:56.743 11 DEBUG cinder.image.image_utils [req-e5ac2b4c-1818-4f4b-9899-e5c294e2faff 580b3eb43fce4034854def77dad342a2 d750f1e1780b42a9b7bf8fbbfaeecf75 - - -] 03cbb1c9-8858-4e61-afb4-478449da2d39 was raw, no need to convert to raw upload_volume /usr/lib/python3.9/site-packages/cinder/image/image_utils.py:987
2024-10-30 19:35:12.344 11 DEBUG cinder.volume.manager [req-e5ac2b4c-1818-4f4b-9899-e5c294e2faff 580b3eb43fce4034854def77dad342a2 d750f1e1780b42a9b7bf8fbbfaeecf75 - - -] Uploaded volume to glance image-id: 03cbb1c9-8858-4e61-afb4-478449da2d39. copy_volume_to_image /usr/lib/python3.9/site-packages/cinder/volume/manager.py:1714
2024-10-30 19:35:12.393 11 INFO cinder.volume.manager [req-e5ac2b4c-1818-4f4b-9899-e5c294e2faff 580b3eb43fce4034854def77dad342a2 d750f1e1780b42a9b7bf8fbbfaeecf75 - - -] Copy volume to image completed successfully.




(overcloud) [stack@undercloud-0 ~]$ openstack image list
+--------------------------------------+----------------------------------+--------+
| ID                                   | Name                             | Status |
+--------------------------------------+----------------------------------+--------+
| 4a132e3d-ff7f-497d-8f93-c3dc36bd8b4a | cirros-0.5.2-x86_64-disk.img     | active |
| 8e8a6585-2b60-42ef-b298-61bfb9dbe9bb | cirros-0.5.2-x86_64-disk.img_alt | active |
| 0cb8b530-760c-536d-a707-53084b717559 | manila-service-image-master      | active |
| 24afb7d5-3ee7-599a-ac8d-55ac83bf2594 | manila-service-image-master_alt  | active |
| 49007c74-ecf9-4243-afc6-6ba6ef8a865f | mybigtestimage_1                 | active |
| a8ad3e33-944c-4dd9-815b-51f61352dde4 | mybigtestimage_2                 | active |
| e59e4c5a-68d5-4831-bab0-56d451aa759c | mybigtestimage_4                 | active |
| 03cbb1c9-8858-4e61-afb4-478449da2d39 | rbd_vol1_image                   | active |
| a1232663-e061-4c94-8ab3-d5a74aa50b40 | test                             | queued |
+--------------------------------------+----------------------------------+--------+
(overcloud) [stack@undercloud-0 ~]$ 










