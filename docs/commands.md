# git

# download a PR
[mkatari@fedora data-plane-adoption_myfork]$ #git fetch k8s-data-plane-adoption pull/745/head:pull_745
[mkatari@fedora data-plane-adoption_myfork]$ git remote -v
k8s-data-plane-adoption git@github.com:openstack-k8s-operators/data-plane-adoption.git (fetch)




# find the top 20 sized direcotires in the current dirctory
du -mh . | sort -nr | head -n 20

# find the most sized directores
sudo du -h -x -d1 /



# file system management

https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/lv_reduce#LV_reduce

Lv grow and shrink


# create  centos image of your own size
dd if=/dev/urandom of=centos-image bs=1M count=51200
