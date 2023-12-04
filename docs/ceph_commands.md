
## misc




git pull --rebase k8s-cifmw main
git push -u origin cifmw_dashboard_validation -f


### Apply a github PR as a patch
[controller-0]$ curl https://raw.githubusercontent.com/openstack-k8s-operators/ci-framework/24a10cacca06a5181b880b93af574f4597fb227e/ci_framework/roles/cifmw_cephadm/tasks/cephadm_config_set.yml > roles/cifmw_cephadm/tasks/cephadm_config_set.yml



podman run --rm --net=host --ipc=host --volume /etc/ceph:/etc/ceph:z --volume /home/ceph-admin/assimilate_ceph.conf:/home/assimilate_ceph.conf:z --volume /tmp/ceph_rgw.yml:/home/ceph_spec.yaml:z --entrypoint ceph quay.io/ceph/ceph:v18.2 --fsid b4cab80c-922b-5dc9-9f38-84f6dacc6029 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring orch apply --in-file /home/ceph_spec.yaml


ceph -W cephadm --watch-debug
ceph config set mgr mgr/cephadm/log_to_cluster_level debug

#in the container
vi rgw # put the spec in it
ceph orch apply -i rgw

#in the edpm node ensure to have correct spec generated in /tmp/ceph_rgw.yml
sudo podman run --rm --net=host --ipc=host --volume /etc/ceph:/etc/ceph:z --volume /home/ceph-admin/assimilate_ceph.conf:/home/assimilate_ceph.conf:z --volume /tmp/ceph_rgw.yml:/home/ceph_spec.yaml:z --entrypoint ceph quay.io/ceph/ceph:v18.2 --fsid b4cab80c-922b-5dc9-9f38-84f6dacc6029 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring orch apply --in-file /home/ceph_spec.yaml

#run the ceph playbook and see if it generates spec in /tmp/ceph_rgw.yml using /etc/pki/tls/example.com.crt set in default/main.yaml



ceph orch ls --export ingress
ceph orch ls --export rgw





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

