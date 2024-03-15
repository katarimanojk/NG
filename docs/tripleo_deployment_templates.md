base env file  environments/cephadm/cephadm.yaml which has client, osd, mon, mgr and rgw deployed but no cephfs





# with cephfs for manila

[stack@undercloud-0 ~]$ grep ceph overcloud_deploy.sh
  --environment-file /usr/share/openstack-tripleo-heat-templates/environments/manila-cephfsganesha-config.yaml \
  --environment-file /usr/share/openstack-tripleo-heat-templates/environments/cephadm/ceph-mds.yaml \
  -e /home/stack/templates/overcloud-ceph-deployed.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/cephadm/cephadm.yaml \
-e /home/stack/composable_roles/manila-cephganesha.yaml \
[stack@undercloud-0 ~]$ 

