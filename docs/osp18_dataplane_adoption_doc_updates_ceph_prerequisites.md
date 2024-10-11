https://openstack-k8s-operators.github.io/data-plane-adoption/user/index.html#red-hat-ceph-storage-prerequisites_configuring-network

[tripleo-admin@cephstorage-0 ~]$ ip -o -4 a
1: lo    inet 127.0.0.1/8 scope host lo\       valid_lft forever preferred_lft forever
2: enp1s0    inet 192.168.24.43/24 brd 192.168.24.255 scope global enp1s0\       valid_lft forever preferred_lft forever                                                                                                                     
8: br-ex    inet 10.0.0.113/24 brd 10.0.0.255 scope global br-ex\       valid_lft forever preferred_lft forever
9: vlan40    inet 172.17.4.16/24 brd 172.17.4.255 scope global vlan40\       valid_lft forever preferred_lft forever
10: vlan30    inet 172.17.3.29/24 brd 172.17.3.255 scope global vlan30\       valid_lft forever preferred_lft forever
11: vlan70    inet 172.17.5.63/24 brd 172.17.5.255 scope global vlan70\       valid_lft forever preferred_lft forever
[tripleo-admin@cephstorage-0 ~]$ 


target node should have these neworks propogared from tripleo 

br-ex : external network , network used as HAproxy frontend , ip reserved from this n/w will be used for rgw service
vlan30 : storage n/w
vlan40 : storage_mgmt n/w
vlan70 : storage_nfs n/w



after rgw,nfs prerequisites: 

changes in /home/stack/composable_roles/network/nic-configs/ceph-storage.j2 

- type: vlan
  device: nic2
  vlan_id: {{ storage_nfs_vlan_id }}
  addresses:
  - ip_netmask: {{ storage_nfs_ip }}/{{ storage_nfs_cidr }}
  routes: {{ storage_nfs_host_routes }}
- type: ovs_bridge
  name: {{ neutron_physical_bridge_name }}
  dns_servers: {{ ctlplane_dns_nameservers }}
  domain: {{ dns_search_domains }}
  use_dhcp: false
  addresses:
  - ip_netmask: {{ external_ip }}/{{ external_cidr }}
  routes: {{ external_host_routes }}
  members: []


changes in ~/composable_roles/network/baremetal_deployment.yaml
    - network: external
    - network: storage_nfs







nfs ganesha propogration:

(undercloud) [stack@undercloud-0 ~]$  openstack port list -c "Fixed IP Addresses" --network storage_nfs
+-----------------------------------------------------------------------------+
| Fixed IP Addresses                                                          |
+-----------------------------------------------------------------------------+
| ip_address='172.17.5.127', subnet_id='cbd8628f-7019-49fc-929d-ae4c1ee09646' |
| ip_address='172.17.5.63', subnet_id='cbd8628f-7019-49fc-929d-ae4c1ee09646'  |
| ip_address='172.17.5.95', subnet_id='cbd8628f-7019-49fc-929d-ae4c1ee09646'  |
| ip_address='172.17.5.25', subnet_id='cbd8628f-7019-49fc-929d-ae4c1ee09646'  |
| ip_address='172.17.5.129', subnet_id='cbd8628f-7019-49fc-929d-ae4c1ee09646' |
| ip_address='172.17.5.61', subnet_id='cbd8628f-7019-49fc-929d-ae4c1ee09646'  |
| ip_address='172.17.5.79', subnet_id='cbd8628f-7019-49fc-929d-ae4c1ee09646'  |
+-----------------------------------------------------------------------------+
(undercloud) [stack@undercloud-0 ~]$


[ceph: root@controller-0 /]# ceph orch host label add cephstorage-0 nfs
Added label nfs to host cephstorage-0
[ceph: root@controller-0 /]# ceph orch host label add cephstorage-1 nfs
Added label nfs to host cephstorage-1
[ceph: root@controller-0 /]# ceph orch host label add cephstorage-2 nfs
Added label nfs to host cephstorage-2
[ceph: root@controller-0 /]# ceph orch host ls
HOST           ADDR           LABELS          STATUS
cephstorage-0  192.168.24.43  osd,nfs
cephstorage-1  192.168.24.45  osd,nfs
cephstorage-2  192.168.24.39  osd,nfs
controller-0   192.168.24.8   _admin,mon,mgr
controller-1   192.168.24.40  mon,_admin,mgr
controller-2   192.168.24.41  mon,_admin,mgr
6 hosts in cluster
[ceph: root@controller-0 /]# 



[ceph: root@controller-0 /]# ceph nfs cluster create cephfs     "label:nfs"     --ingress     --virtual-ip=172.17.5.63
 --ingress-mode=haproxy-protocol
cephfs cluster already exists
[ceph: root@controller-0 /]# ceph nfs cluster ls
[
  "cephfs"
]
[ceph: root@controller-0 /]# 



[ceph: root@controller-0 /]# ceph nfs cluster info cephfs
{
  "cephfs": {
    "backend": [
      {
        "hostname": "cephstorage-0",
        "ip": "192.168.24.43",
        "port": 12049
      },
      {
        "hostname": "cephstorage-1",
        "ip": "192.168.24.45",
        "port": 12049
      },
      {
        "hostname": "cephstorage-2",
        "ip": "192.168.24.39",
        "port": 12049
      }
    ],
    "monitor_port": 9049,
    "port": 2049,
    "virtual_ip": "172.17.5.63"
  }
}
[ceph: root@controller-0 /]# 
[manoj] 0:ssh*Z 1:bash-Z          
