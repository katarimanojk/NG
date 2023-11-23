
## misc

ceph -W cephadm --watch-debug
ceph config set mgr mgr/cephadm/log_to_cluster_level debug





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

