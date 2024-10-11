

pre-commit run --all-files

yamllint tests/roles/ceph_migrate/tasks/configure_object.yaml

podman run --rm --net=host -v /etc/ceph:/etc/ceph:z -v /var/lib/ceph/:/var/lib/ceph/:z -v /var/log/ceph/:/var/log/ceph/:z -v /home/ceph-admin/specs/grafana:/home/ceph-admin/specs/grafana:z --entrypoint=ceph quay.ceph.io/ceph-ci/ceph:reef -n client.admin -k /etc/ceph/ceph.client.admin.keyring --cluster ceph orch apply --in-file /home/ceph-admin/specs/grafana



podman run --rm --net=host --ipc=host --volume /etc/ceph:/etc/ceph:z --volume /home/ceph-admin/assimilate_ceph.conf:/home/assimilate_ceph.conf:z --volume /tmp/ceph_rgw.yml:/home/ceph_spec.yaml:z --entrypoint ceph quay.io/ceph/ceph:v18 --fsid f78b22dd-7fbf-5bb9-8242-ab4a9377b3c1 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring config set global rgw_keystone_accepted_reader_roles SwiftSystemReader



podman  run  --tls-verify=false --rm --entrypoint ceph quay.io/ceph/ceph:v18 --version 



(undercloud) [stack@undercloud-0 ~]$ podman run --rm --entrypoint=ceph quay.io/ceph/ceph:v18 -v                                                                                                                                              
ceph version 18.2.2 (531c0d11a1c5d39fbfe6aa8a521f023abf3bf3e2) reef (stable)
