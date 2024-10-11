
# refer notes

https://docs.google.com/document/d/1SUqBejlTPAGComw2rKRBcwEXaTtD5CPqXAErvHQY8Uk/edit?tab=t.0





# Ways to store, use, and expose data¶

## source: 
   https://docs.openstack.org/cinder/latest/configuration/block-storage/drivers/ceph-rbd-volume-driver.html

To store and access your data, you can use the following storage systems:

RADOS
Use as an object, default storage mechanism.

RBD
Use as a block device. The Linux kernel RBD (RADOS block device) driver allows striping a Linux block device over multiple distributed object store data objects. It is compatible with the KVM RBD image.

CephFS
Use as a file, POSIX-compliant file system.

Ceph exposes RADOS; you can access it through the following interfaces:

RADOS Gateway
OpenStack Object Storage and Amazon-S3 compatible RESTful interface (see RADOS_Gateway).

librados
and its related C/C++ bindings

RBD and QEMU-RBD
Linux kernel and QEMU block devices that stripe data across multiple objects.



# bootstrap ceph and access ceph cluster


cephadm bootstrap --mon-ip <mon-ip>

 - cephadm bootstrap writes to /etc/ceph files needed to access the new cluster




# cephadm downstream package download:

https://access.redhat.com/downloads/content/cephadm/18.2.1-229.el9cp/noarch/fd431d51/package


[root@edpm-compute-0 ~]# curl -O https://access.cdn.redhat.com/content/origin/rpms/cephadm/18.2.1/229.el9cp/fd431d51/cephadm-18.2.1-229.el9cp.noarch.rpm
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
[root@edpm-compute-0 ~]# ls
 cephadm-18.2.1-229.el9cp.noarch.rpm 


sudo dnf remove cephadm

#rpm -i cephadm-18.2.1-229.el9cp.noarch.rpm


# how ceph osd uses disks blocks

## alternative ?
   ceph-volume lvm create --data /dev/sdb

## loop back device helps computer file accessible as block device

- name: Use dd and losetup to create the loop device
  become: true
  ansible.builtin.shell:
    cmd: |-
      dd if=/dev/zero of={{ cifmw_block_device_image_file }} bs=1 count=0 seek={{ cifmw_block_device_size }}
      losetup {{ cifmw_block_device_loop }} {{ cifmw_block_device_image_file }}
      lsblk

- name: Use {pv,vg,lv}create to create logical volume on loop device
  become: true
  ansible.builtin.shell:
    cmd: |-
      pvcreate {{ cifmw_block_device_loop }}
      vgcreate {{ cifmw_block_vg_name }} {{ cifmw_block_device_loop }}
      lvcreate -n {{ cifmw_block_lv_name }} -l +100%FREE {{ cifmw_block_vg_name }}
      lvs


## manual commands to create loopback device, pv, vg, lv

sudo dd if=/dev/zero of=/var/lib/ceph-osd0.img bs=1 count=0 seek=50G
sudo dd if=/dev/zero of=/var/lib/ceph-osd1.img bs=1 count=0 seek=50G
sudo dd if=/dev/zero of=/var/lib/ceph-osd2.img bs=1 count=0 seek=50G
sudo losetup /dev/loop4 /var/lib/ceph-osd0.img
sudo losetup /dev/loop5 /var/lib/ceph-osd1.img
sudo losetup /dev/loop6 /var/lib/ceph-osd2.img
sudo pvcreate /dev/loop4
sudo vgcreate ceph_vg0 /dev/loop4
sudo lvcreate -n ceph_lv_data0 -l +100%FREE ceph_vg0
sudo pvcreate /dev/loop5
sudo vgcreate ceph_vg1 /dev/loop5
sudo lvcreate -n ceph_lv_data1 -l +100%FREE ceph_vg1
sudo pvcreate /dev/loop6
sudo vgcreate ceph_vg2 /dev/loop6
sudo lvcreate -n ceph_lv_data2 -l +100%FREE ceph_vg2


and the ceph spec will have

      data_devices:
        paths:
          - /dev/ceph_vg0/ceph_lv_data0
          - /dev/ceph_vg1/ceph_lv_data1
          - /dev/ceph_vg2/ceph_lv_data2




## every lv ->vg -> pv
[heat-admin@ceph-1 ~]$ sudo pvs
  PV         VG                                        Fmt  Attr PSize   PFree
  /dev/vdb   ceph-69d81161-98fd-41f9-ae90-940e4bbc0c38 lvm2 a--  <47.00g    0 
  /dev/vdc   ceph-378e0b5f-1de8-49b1-82eb-205134b6bdfe lvm2 a--  <47.00g    0 
  /dev/vdd   ceph-891eedda-ad63-4a69-98b9-d682a5096c8a lvm2 a--  <47.00g    0 
  /dev/vde   ceph-6bceec1e-73e2-41ab-8a8b-ea330f3a7c12 lvm2 a--  <47.00g    0 
  /dev/vdf   ceph-e96c3275-c4e6-4cd6-bb65-7194d45af7e8 lvm2 a--  <47.00g    0 
[heat-admin@ceph-1 ~]$ sudo lvs
  LV                                             VG                                        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  osd-block-8e7179ed-fc92-4603-a1f2-c8de8daf46be ceph-378e0b5f-1de8-49b1-82eb-205134b6bdfe -wi-ao---- <47.00g                                                    
  osd-block-833072f8-51f2-4287-8d71-7e07c861512a ceph-69d81161-98fd-41f9-ae90-940e4bbc0c38 -wi-ao---- <47.00g                                                    
  osd-block-d840c8f5-ca07-4ef8-9c9f-20569db5bb09 ceph-6bceec1e-73e2-41ab-8a8b-ea330f3a7c12 -wi-ao---- <47.00g                                                    
  osd-block-1fecd8fb-37e2-452d-a8ce-93e91c71655c ceph-891eedda-ad63-4a69-98b9-d682a5096c8a -wi-ao---- <47.00g                                                    
  osd-block-29ff7c95-6189-4c6f-bcb1-b20bbfbb9152 ceph-e96c3275-c4e6-4cd6-bb65-7194d45af7e8 -wi-ao---- <47.00g                                                    
[heat-admin@ceph-1 ~]$ sudo vgs
  VG                                        #PV #LV #SN Attr   VSize   VFree
  ceph-378e0b5f-1de8-49b1-82eb-205134b6bdfe   1   1   0 wz--n- <47.00g    0 
  ceph-69d81161-98fd-41f9-ae90-940e4bbc0c38   1   1   0 wz--n- <47.00g    0 
  ceph-6bceec1e-73e2-41ab-8a8b-ea330f3a7c12   1   1   0 wz--n- <47.00g    0 
  ceph-891eedda-ad63-4a69-98b9-d682a5096c8a   1   1   0 wz--n- <47.00g    0 
  ceph-e96c3275-c4e6-4cd6-bb65-7194d45af7e8   1   1   0 wz--n- <47.00g    0 
[heat-admin@ceph-1 ~]$ lsblk




[heat-admin@ceph-1 ~]$ lsblk
NAME                                                                                                  MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
vda                                                                                                   252:0    0  46G  0 disk 
├─vda1                                                                                                252:1    0   1M  0 part 
└─vda2                                                                                                252:2    0  46G  0 part /
vdb                                                                                                   252:16   0  47G  0 disk 
└─ceph--69d81161--98fd--41f9--ae90--940e4bbc0c38-osd--block--833072f8--51f2--4287--8d71--7e07c861512a 253:0    0  47G  0 lvm  
vdc                                                                                                   252:32   0  47G  0 disk 
└─ceph--378e0b5f--1de8--49b1--82eb--205134b6bdfe-osd--block--8e7179ed--fc92--4603--a1f2--c8de8daf46be 253:1    0  47G  0 lvm  
vdd                                                                                                   252:48   0  47G  0 disk 
└─ceph--891eedda--ad63--4a69--98b9--d682a5096c8a-osd--block--1fecd8fb--37e2--452d--a8ce--93e91c71655c 253:2    0  47G  0 lvm  
vde                                                                                                   252:64   0  47G  0 disk 
└─ceph--6bceec1e--73e2--41ab--8a8b--ea330f3a7c12-osd--block--d840c8f5--ca07--4ef8--9c9f--20569db5bb09 253:3    0  47G  0 lvm  
vdf                                                                                                   252:80   0  47G  0 disk 
└─ceph--e96c3275--c4e6--4cd6--bb65--7194d45af7e8-osd--block--29ff7c95--6189--4c6f--bcb1--b20bbfbb9152 253:4    0  47G  0 lvm  
[heat-admin@ceph-1 ~]$ 




# osp17 ceph

- director deploys ceph by running mons/mgrs on controllers and ceph OSDs on ceph-storage nodes

Dec 09 01:00:24 <fultonj>       https://docs.ceph.com/en/octopus/mgr/orchestrator/#orchestrator-cli-service-spec
Dec 09 01:04:22 <fultonj>       https://docs.openstack.org/project-deploy-guide/tripleo-docs/latest/features/deployed_ceph.html#service-placement-options
Dec 09 01:10:47 <fultonj>       https://www.redhat.com/en/blog/red-hat-ceph-storage-5-introducing-cephadm
Dec 09 01:18:59 <fultonj>       https://github.com/fultonj/xena/tree/main/ir/undercloud
Dec 09 01:21:31 <fultonj>       https://github.com/fultonj/xena/blob/main/metalsmith/clean-disks.sh




# ingress

In order to provide HA (high available) object storage, we use an ingress service on top of Ceph RGW service.
