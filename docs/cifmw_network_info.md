[zuul@controller-0 ci-framework]$ cat /tmp/initial_ceph.conf 
[global]
osd pool default size = 1
public_network = 172.18.0.0/24
cluster_network = 172.20.0.0/24
[mon]
mon_warn_on_pool_no_redundancy = false
[zuul@controller-0 ci-framework]$ 


public network is also called as storage network (cinder,manila, glance interact )
cluster netwrok is called as stroage_mgnt netowrk (ceph internal network)
managment network
