[zuul@controller-0 ci-framework]$ cat /tmp/initial_ceph.conf 
[global]
osd pool default size = 1
public_network = 172.18.0.0/24
cluster_network = 172.20.0.0/24
[mon]
mon_warn_on_pool_no_redundancy = false
[zuul@controller-0 ci-framework]$ 



Red Hat Ceph Storage uses the 'Storage network' as the Red Hat Ceph Storage 'public_network' and the 'Storage Management network' as the 'cluster_network'.

Ceph public network is  storage network (cinder,manila, glance or any clinet interacts with ceph mons)

Ceph cluster network is  stroage_mgnt netowrk ( storage backend like cephrbd, nfs, pure network)
 -  For ceph, storagemgmt is required on the edpm nodes for OSDs traffic
 -  ceph cluster networik is used to replicate data



