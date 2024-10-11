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


# cleanup after adoption /var 100%
rm /home/zuul/ci-framework-data/workload/*
sudo reboot
ansible-playbook reproducer-clean.yml --tags=deepscrub


# network

curl -v -k 172.18.0.106:8082 # connect to rgw at tcp layer level
curl -v -k https://172.18.0.106:8082 # connect to rgw at http layer

curl -v -k https://172.18.0.100:8080 # connect to ingress (keepalive maintains the vip for reaching rgw backend)

curl --trace --key /etc/pki/tls/example.com.key --cert /etc/pki/tls/example.com.crt -v https://172.18.0.100:8080

curl --trace - rgw-external.ceph.local:8080  #using dns




# using swift or cinder cli instead of openstack cli 

oc rsh openstacklient
source /home/cloud-admin/cloudrc

