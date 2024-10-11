



## misc




git pull --rebase k8s-cifmw main
git push -u origin cifmw_dashboard_validation -f



# debug
sudo cephadm shell ceph -W cephadm --watch-debug
sudo cephadm shell ceph config set mgr mgr/cephadm/log_to_cluster_level debug


refere ceph_logging_and_troubleshooting.md for detailed info

# ceph osd debugging

#ceph osd perf
#ceph tell osd.* bench
#ceph osd stat
#ceph osd tree
#rbd ls -l -p images
#rbd ls -l -p volumes
#ceph pg ls-by-pool images
#ceph pg ls-by-pool volumes
#ceph pg dump


#ceph tell osd.* config set debug_osd 20/20

find the pool num for images pool
#ceph osd pool ls detail

#find all the pgs in the pool images 
ceph pg dump | grep <poolnum>

#osds in the pg can be fetched using one of the commands
ceph pg {poolnum}.{pg-id} query


#ceph mgr module enable insights 
#ceph insights
 #The insights module collects and exposes system information to the Insights Core data analysis framework

osdmaptool  to experment and understand mapping
https://docs.ceph.com/en/reef/man/8/osdmaptool/


## podman

sudo podman ps --format '{{ .Names }}G

sudo podman run --rm --entrypoint ceph undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6-199 -v                       



## cephadm podman command

/bin/podman run --rm --ipc=host --net=host --privileged --group-add=disk --init -i -e CONTAINER_IMAGE=undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:3d75ca419b9ef00cf2c944680737e84e6e1059e0f3
3156bc21d4dbf76a7da5b1 -e NODE_NAME=controller-0 -e CEPH_USE_RANDOM_NONCE=1 -v /var/log/ceph/e14864ba-e171-552d-864a-db189e445ef5:/var/log/ceph:z -v /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/crash:/var/lib/ceph/crash:z -v /run/sy
stemd/journal:/run/systemd/journal -v /dev:/dev -v /run/udev:/run/udev -v /sys:/sys -v /run/lvm:/run/lvm -v /run/lock/lvm:/run/lock/lvm -v /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/selinux:/sys/fs/selinux:ro -v /:/rootfs -v /etc/
hosts:/etc/hosts:ro -v /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config:/etc/ceph/ceph.conf:z -v /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/config/ceph.client.admin.keyring:/etc/ceph/ceph.keyring:z --entr
ypoint ceph undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:3d75ca419b9ef00cf2c944680737e84e6e1059e0f33156bc21d4dbf76a7da5b1 health



### Apply a github PR as a patch
[controller-0]$ curl https://raw.githubusercontent.com/openstack-k8s-operators/ci-framework/24a10cacca06a5181b880b93af574f4597fb227e/ci_framework/roles/cifmw_cephadm/tasks/cephadm_config_set.yml > roles/cifmw_cephadm/tasks/cephadm_config_set.yml

[zuul@controller-0 ci-framework]$ sudo podman run --rm --entrypoint ceph quay.io/ceph/ceph:v18.2  -v
ceph version 18.2.1 (7fe91d5d5842e04be3b4f514d6dd990c54b29c76) reef (stable)


podman run --rm --net=host --ipc=host --volume /etc/ceph:/etc/ceph:z --volume /home/ceph-admin/assimilate_ceph.conf:/home/assimilate_ceph.conf:z --volume /tmp/ceph_rgw.yml:/home/ceph_spec.yaml:z --entrypoint ceph quay.io/ceph/ceph:v18.2 --fsid b4cab80c-922b-5dc9-9f38-84f6dacc6029 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring orch apply --in-file /home/ceph_spec.yaml



#in the container
vi rgw # put the spec in it
ceph orch apply -i rgw

#in the edpm node ensure to have correct spec generated in /tmp/ceph_rgw.yml
sudo podman run --rm --net=host --ipc=host --volume /etc/ceph:/etc/ceph:z --volume /home/ceph-admin/assimilate_ceph.conf:/home/assimilate_ceph.conf:z --volume /tmp/ceph_rgw.yml:/home/ceph_spec.yaml:z --entrypoint ceph quay.io/ceph/ceph:v18.2 --fsid b4cab80c-922b-5dc9-9f38-84f6dacc6029 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring orch apply --in-file /home/ceph_spec.yaml

#run the ceph playbook and see if it generates spec in /tmp/ceph_rgw.yml using /etc/pki/tls/example.com.crt set in default/main.yaml


cpeh orch host ls

device/osd:
ceph orch device ls
ceph-volume lvm list
lsblk

ceph orch ls --export ingress
ceph orch ls --export rgw



rbd -p images ls -l
rbd -p volues ls -l

 ceph config rm global osd_pool_default_pgp_num
 ceph config rm global osd_pool_default_pg_num

 ceph config set global osd_pool_default_pg_num 16                                                                                                                                                        [52/614]
 ceph config set global osd_pool_default_pgp_num 16


 ceph osd pool ls
 ceph osd pool ls detail


#mount a direcotry to cephadm sell/ container
sudo cephadm shell -m tmp_spec
ceph orch apply -i /mnt/tmp_spec/mon.spec;done


podman run --rm --net=host --ipc=host   --volume /etc/ceph:/etc/ceph:z --volume /home/ceph-admin/assimilate_ceph.conf:/home/assimilate_ceph.conf:z   --volume /home/ceph-admin/specs/ceph_spec.yaml:/home/ceph_spec.yaml:z   --entrypoint ceph registry-proxy.engineering.redhat.com/rh-osbs/rhceph:7 --fsid 427cfd09-53a9-5f6e-adf1-5ceb9ac56f47 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring   orch apply --in-file /home/ceph_spec.yaml


podman run --rm --net=host -v /etc/ceph:/etc/ceph:z -v /var/lib/ceph/:/var/lib/ceph/:z -v /var/log/ceph/:/var/log/ceph/:z -v /home/ceph-admin/specs/grafana:/home/ceph-admin/specs/grafana:z --entrypoint=ceph quay.ceph.io/ceph-ci/ceph:reef -n client.admin -k /etc/ceph/ceph.client.admin.keyring --cluster ceph orch apply --in-file /home/ceph-admin/specs/grafana


# redeploy
ceph orch redploy rgw.rgw

## redeploy monitoring stack after setting it new image in ceph mgr config
sudo cephadm shell -- ceph config set mgr mgr/cephadm/container_image_node_exporter undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.12 
for daemon in node-exporter grafana alertmanager prometheus; do sudo cephadm shell -- ceph orch redeploy $daemon; done



# dump rgw spec
ceph orch ls --export rgw 

vi rgw



#enable rgw daemon debug logs
ceph --admin-daemon /var/run/ceph/ceph-client.rgw.rgw.compute-0.umbshq.2.94082084575472.asok config set debug_rgw 20 
ceph --admin-daemon /var/run/ceph/ceph-client.rgw.rgw.compute-0.umbshq.2.94082084575472.asok config set debug_ms 1 

vi /var/log/ceph/cep

/var/run/ceph/ceph-client.rgw.rgw.compute-0.umbshq.2.94082084575472.asok


watch ceph orch ps



ceph osd map <pool name> <objectname>

# this will return the PG name that associates with the pool and object.


https://docs.ceph.com/en/reef/man/8/osdmaptool/

To create a simple map with 16 devices:
#osdmaptool --createsimple 16 osdmap --clobber

To view the result:
#osdmaptool --print osdmap

To view the mappings of placement groups for pool 1:
#osdmaptool osdmap --test-map-pgs-dump --pool 1




## cleanup



Cleanup cluster to run bootstrap again:
 sudo cephadm rm-cluster --fsid 3b5b2acd-8d7f-5e64-89fa-e7631acf98a8 --force
 Sudo cephadm ls

Cleanup osd:  on all ceph/compute nodes
—--
[tripleo-admin@cephstorage-2 ~]$ sudo systemctl list-units | grep ceph

for j in stop disable; { for i in 15 16 17 18 19; { sudo systemctl $j  ceph-3b5b2acd-8d7f-5e64-89fa-e7631acf98a8@osd.$i.service; }; }
sudo vgs | awk 'NR>1{print $1}' | sudo xargs vgremove -y
pvs
sudo pvremove /dev/vd{b,c,d,e,f} # wipe the pvs                              
—--



# rados
  directly interacting with librados instad of going via mon (ceph osd pool ls)


[zuul@ceph-uni04delta-ipv6-0 ~]$ rados --cluster ceph   --conf /etc/ceph/ceph.conf   --keyring /etc/ceph/ceph.client.openstack.keyring  -n client.openstack lspools
.mgr
vms
volumes
backups
images
cephfs.cephfs.meta
cephfs.cephfs.data
.rgw.root
default.rgw.log
default.rgw.control
default.rgw.meta



[zuul@ceph-uni04delta-ipv6-0 ~]$ sudo cephadm shell -- rados lspools
Inferring fsid 7f8c0b24-7afd-53eb-a443-f5b7da31bb60
Inferring config /var/lib/ceph/7f8c0b24-7afd-53eb-a443-f5b7da31bb60/mon.ceph-uni04delta-ipv6-0/config
Using ceph image with id '90d03ee72227' and tag '7' created on 2025-06-12 22:39:04 +0000 UTC
registry-proxy.engineering.redhat.com/rh-osbs/rhceph@sha256:d44a96fa8a29529caf7632f2be199f1a2a8a13f7114a6830bf5fbf6b3b4647b7
.mgr
vms
volumes
backups
images
cephfs.cephfs.meta
cephfs.cephfs.data
.rgw.root
default.rgw.log
default.rgw.control
default.rgw.meta


[zuul@ceph-uni04delta-ipv6-0 ~]$ rados --cluster ceph   --conf /etc/ceph/ceph.conf   --keyring /etc/ceph/ceph.client.manila.keyring   -n client.manila  -p volumes ls
rados_nobjects_list_next2: Operation not permitted
# manila keyring doesn't have premission 

[zuul@ceph-uni04delta-ipv6-0 ~]$ rados --cluster ceph   --conf /etc/ceph/ceph.conf   --keyring /etc/ceph/ceph.client.openstack.keyring  -n client.openstack -p volumes ls
[zuul@ceph-uni04delta-ipv6-0 ~]$ 

