
Irrespective of ocp deployment, ceph migration can be tried directly when tripleo (osp) deployment is available.

slide from /fp session: https://docs.google.com/presentation/d/1TT-W6q6gIQIwPNf3v5gkWYb_8C9ZUKXqMhOkgdSFiWc/
https://openstack-k8s-operators.github.io/data-plane-adoption/user/index.html#ceph-migration_adopt-control-plane

logs:

https://review.rdoproject.org/zuul/build/19728b0728f744e89b373d0a848d664a/log/controller/data-plane-adoption-tests-repo/data-plane-adoption/tests/logs/test_ceph_migration_out_2024-12-13T10%3A20%3A32EST.log



After monitoring stack migration, ceph -s shows below message

  progress:
    Updating grafana deployment (+3 -> 3) (13s)
      [=========...................] (remaining: 27s





[tripleo-admin@cephstorage-0 ~]$ sudo podman ps | grep ceph
a5f1f8e98031  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n client.crash.c...  5 days ago  Up 5 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-crash-cephstorage-0 
290b8ca3cc76  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n osd.0 -f --set...  5 days ago  Up 5 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-osd-0               
0951b2b77bc2  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n osd.12 -f --se...  5 days ago  Up 5 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-osd-12              
6f6af07a4bf5  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n osd.3 -f --set...  5 days ago  Up 5 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-osd-3               
04ad9a3b7f85  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n osd.6 -f --set...  5 days ago  Up 5 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-osd-6               
60c0d48a16dd  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n osd.9 -f --set...  5 days ago  Up 5 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-osd-9               
d676cab3abf3  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.15  --no-collector.ti...  3 days ago  Up 3 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-node-exporter-cephstorage-0
e81e62d87de0  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -F -L STDERR -N N...  3 days ago  Up 3 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-nfs-cephfs-2-0-cephstorage-0-tevipd


after migrating monitoring stack and mds

[tripleo-admin@cephstorage-0 ~]$ sudo podman ps | grep ceph
a5f1f8e98031  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n client.crash.c...  8 days ago      Up 8 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-crash-cephstorage-0
290b8ca3cc76  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n osd.0 -f --set...  8 days ago      Up 8 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-osd-0           
0951b2b77bc2  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n osd.12 -f --se...  8 days ago      Up 8 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-osd-12          
6f6af07a4bf5  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n osd.3 -f --set...  8 days ago      Up 8 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-osd-3           
04ad9a3b7f85  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n osd.6 -f --set...  8 days ago      Up 8 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-osd-6           
60c0d48a16dd  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n osd.9 -f --set...  8 days ago      Up 8 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-osd-9           
d676cab3abf3  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.15  --no-collector.ti...  5 days ago      Up 5 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-node-exporter-cephstorage-0
e81e62d87de0  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -F -L STDERR -N N...  5 days ago      Up 5 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-nfs-cephfs-2-0-cephstorage-0-tevipd
f6e65cd0df49  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.15                --config.file=/et...  2 days ago      Up 2 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-prometheus-cephstorage-0
058cbebd7edf  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.15   --cluster.listen-...  2 days ago      Up 2 days                        ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-alertmanager-cephstorage-0
d5d62b074fb5  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:7                                      -n mds.mds.cephst...  54 seconds ago  Up 55 seconds                    ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e-mds-mds-cephstorage-0-oipgon
)




check the #ceph fs dump and caputre the mds domain details of cephstorage-0 and run the below command

[tripleo-admin@controller-0 ~]$ sudo cephadm shell -- ceph config set mds.mds.cephstorage-0.oipgon mds_join_fs cephfs


[mds.mds.cephstorage-0.oipgon{0:504603} state up:rejoin seq 342 join_fscid=1 addr [v2:172.17.3.29:6820/1825400810,v1:172.17.3.29:6821/1825400810] compat {c=[1],r=[1],i=[17ff]}]
 
 
Standby daemons:
 
[mds.mds.controller-0.rlehnz{-1:124464} state up:standby seq 1 addr [v2:172.17.3.68:6800/114565641,v1:172.17.3.68:6801/114565641] compat {c=[1],r=[1],i=[17ff]}]
[mds.mds.controller-2.aqqkoo{-1:144457} state up:standby seq 1 addr [v2:172.17.3.96:6800/1364925981,v1:172.17.3.96:6801/1364925981] compat {c=[1],r=[1],i=[17ff]}]
[mds.mds.cephstorage-1.mtpfqx{-1:504591} state up:standby seq 1 addr [v2:172.17.3.45:6820/3128659003,v1:172.17.3.45:6821/3128659003] compat {c=[1],r=[1],i=[17ff]}]
[mds.mds.cephstorage-2.gkiuil{-1:525739} state up:standby seq 1 addr [v2:172.17.3.117:6820/1168228370,v1:172.17.3.117:6821/1168228370] compat {c=[1],r=[1],i=[17ff]}]
[mds.mds.controller-1.wbuwog{-1:539933} state up:standby seq 1 addr [v2:172.17.3.136:6800/3927231619,v1:172.17.3.136:6801/3927231619] compat {c=[1],r=[1],i=[17ff]}]
dumped fsmap epoch 25
[tripleo-admin@controller-0 ~]$ 


[tripleo-admin@controller-0 ~]$ for i in 0 1 2; do sudo cephadm shell -- ceph orch host label rm "controller-$i.redhat.local" mds; done


qdb_cluster     leader: 504603 members: 504603
[mds.mds.cephstorage-0.oipgon{0:504603} state up:active seq 343 join_fscid=1 addr [v2:172.17.3.29:6820/1825400810,v1:172.17.3.29:6821/1825400810] compat {c=[1],r=[1],i=[17ff]}]
 
 
Standby daemons:
 
[mds.mds.cephstorage-1.mtpfqx{-1:504591} state up:standby seq 1 addr [v2:172.17.3.45:6820/3128659003,v1:172.17.3.45:6821/3128659003] compat {c=[1],r=[1],i=[17ff]}]
[mds.mds.cephstorage-2.gkiuil{-1:525739} state up:standby seq 1 addr [v2:172.17.3.117:6820/1168228370,v1:172.17.3.117:6821/1168228370] compat {c=[1],r=[1],i=[17ff]}]
dumped fsmap epoch 29




# rbd migration


after draining the controller node, mon ip on the controller is removed from ceph.conf

[tripleo-admin@controller-1 ~]$ cat /etc/ceph/ceph.conf 
# minimal ceph.conf for 279c19fd-1e4a-535c-a07a-ae91b536ab3e
[global]
        fsid = 279c19fd-1e4a-535c-a07a-ae91b536ab3e
        mon_host = [v2:172.17.3.68:3300/0,v1:172.17.3.68:6789/0] [v2:172.17.3.45:3300/0,v1:172.17.3.45:6789/0] [v2:172.17.3.117:3300/0,v1:172.17.3.117:6789/0] [v2:172.17.3.96:3300/0,v1:172.17.3.96:6789/0]

[tripleo-admin@controller-1 ~]$ cat $HOME/ceph_client_backup/ceph/ceph.conf
# minimal ceph.conf for 279c19fd-1e4a-535c-a07a-ae91b536ab3e
[global]
        fsid = 279c19fd-1e4a-535c-a07a-ae91b536ab3e
        mon_host = [v2:172.17.3.68:3300/0,v1:172.17.3.68:6789/0] [v2:172.17.3.45:3300/0,v1:172.17.3.45:6789/0] [v2:172.17.3.117:3300/0,v1:172.17.3.117:6789/0] [v2:172.17.3.136:3300/0,v1:172.17.3.136:6789/0] [v2:172.17.3.96:3300/0,v1:172.17.3.96:6789/0]
[tripleo-admin@controller-1 ~]$ 




during drain, we lose mon deamons on source node, but can still reach using backup conf

[tripleo-admin@controller-1 ~]$ sudo cephadm shell -m ceph_specs/mon -c $HOME/ceph_client_backup/ceph/ceph.conf -k $HOME/ceph_client_backup/ceph/ceph.client.admin.keyring -- ceph orch daemon rm mon.cephstorage-1 --force


Target after migration is:

ceph.conf will have 3 mons in quourum pointing to same ips as before , but on target (ceph) nodes 


in this example below, controller-0 and controller-1 are drained, and controller2 ip needs be configured for cephstorage3

4 mons at {cephstorage-0=[v2:172.17.3.68:3300/0,v1:172.17.3.68:6789/0],cephstorage-1=[v2:172.17.3.136:3300/0,v1:172.17.3.136:6789/0],cephstorage-2=[v2:172.17.3.117:3300/0,v1:172.17.3.117:6789/0],controller-2=[v2:172.17.3.96:3300/0,v1:172.17.3.96:6789/0]} 

[tripleo-admin@controller-2 ~]$ cat /etc/ceph/ceph.conf 
# minimal ceph.conf for 279c19fd-1e4a-535c-a07a-ae91b536ab3e
[global]
        fsid = 279c19fd-1e4a-535c-a07a-ae91b536ab3e
        mon_host = [v2:172.17.3.68:3300/0,v1:172.17.3.68:6789/0] [v2:172.17.3.136:3300/0,v1:172.17.3.136:6789/0] [v2:172.17.3.117:3300/0,v1:172.17.3.117:6789/0] [v2:172.17.3.96:3300/0,v1:172.17.3.96:6789/0]
[tripleo-admin@controller-2 ~]$ 


after completing rbd migration, it looks like

[tripleo-admin@controller-2 ~]$ sudo cephadm shell -m ${SPEC_DIR}/mon -c $HOME/ceph_client_backup/ceph/ceph.conf -k $HOME/ceph_client_backup/ceph/ceph.client.admin.keyring -- ceph mon stat
Inferring fsid 279c19fd-1e4a-535c-a07a-ae91b536ab3e
Using ceph image with id 'b7d23fe2ba12' and tag '7' created on 2024-11-08 19:34:07 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:2449fec13ce869a304cb923221c830aec77dba9e5cc8d04350612b924ebe45dc
e18: 3 mons at {cephstorage-0=[v2:172.17.3.68:3300/0,v1:172.17.3.68:6789/0],cephstorage-1=[v2:172.17.3.136:3300/0,v1:172.17.3.136:6789/0],cephstorage-2=[v2:172.17.3.96:3300/0,v1:172.17.3.96:6789/0]} removed_ranks: {} disallowed_leaders: {}, election epoch 164, leader 0 cephstorage-0, quorum 0,1,2 cephstorage-0,cephstorage-1,cephstorage-2
[tripleo-admin@controller-2 
