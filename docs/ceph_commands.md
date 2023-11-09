


## cleanup

sudo cephadm rm-cluster --fsid <fsid> --force

for node in CephStorageNodes {
sudo vgs | awk 'NR>1{print $1}' | sudo xargs vgremove -y
sudo pvremove /dev/vd{b,c,d,e,f} # wipe the pvs
}
