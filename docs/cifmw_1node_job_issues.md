
#we reduced few resources like dashabord and rgw ingress for 1node


#then we faced mds deamon deployemnt failures, after analysis with john we found that having more osds will help the mds dameon deployment.

https://redhat-internal.slack.com/archives/C04J8S9G8NA/p1709216513287809



#testing addition of more osds to avoid pg errors and mds deamon failures
# 3-node setup, only 1 block device per nodes and one osd per node in spec.

[zuul@compute-0 ~]$ lsblk
NAME                MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
loop3                 7:3    0   7G  0 loop 
└─ceph_vg0-ceph_lv0 253:0    0   7G  0 lvm  
loop4                 7:4    0   7G  0 loop 
loop5                 7:5    0   7G  0 loop 
sda                   8:0    0  50G  0 disk 
└─sda1                8:1    0  50G  0 part /var/lib/containers/storage/overlay
                                            /
[zuul@compute-0 ~]$ 
[zuul@compute-0 ~]$ sudo lvs
  Devices file loop_file /var/lib/ceph-osd.img PVID nU8Sce2XDM80IH1bLEXR65iMxRuOLSi0 last seen on /dev/loop3 not found.
  LV       VG       Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  ceph_lv0 ceph_vg0 -wi-ao---- <7.00g                                                    
[zuul@compute-0 ~]$ 
[zuul@compute-0 ~]$ sudo vgs
  Devices file loop_file /var/lib/ceph-osd.img PVID nU8Sce2XDM80IH1bLEXR65iMxRuOLSi0 last seen on /dev/loop3 not found.
  VG       #PV #LV #SN Attr   VSize  VFree
  ceph_vg0   1   1   0 wz--n- <7.00g    0 
[zuul@compute-0 ~]$ 
[zuul@compute-0 ~]$ sudo pvs
  Devices file loop_file /var/lib/ceph-osd.img PVID nU8Sce2XDM80IH1bLEXR65iMxRuOLSi0 last seen on /dev/loop3 not found.
  PV         VG       Fmt  Attr PSize  PFree
  /dev/loop3 ceph_vg0 lvm2 a--  <7.00g    0 
[zuul@compute-0 ~]$ 
[zuul@compute-0 ~]$ sudo cephadm shell -- ceph -s
Inferring fsid 3c656f37-7ad6-5d30-9e03-fc4635c9a455
Inferring config /var/lib/ceph/3c656f37-7ad6-5d30-9e03-fc4635c9a455/mon.compute-0/config
Using ceph image with id '9b10134529c8' and tag '7' created on 2024-03-08 19:57:03 +0000 UTC
registry-proxy.engineering.redhat.com/rh-osbs/rhceph@sha256:936f4d841fcca5b0120c0268bfa75b2c20a8c09428bab6027c87153bbec2c936
  cluster:
    id:     3c656f37-7ad6-5d30-9e03-fc4635c9a455
    health: HEALTH_WARN
            Failed to place 2 daemon(s)
            2 failed cephadm daemon(s)
 
  services:
    mon: 1 daemons, quorum compute-0 (age 2h)
    mgr: compute-0.qwurhw(active, since 2h), standbys: compute-2.kvicps, compute-1.lansjl
    mds: 1/1 daemons up, 2 standby
    osd: 3 osds: 3 up (since 9m), 3 in (since 10m)
    rgw: 1 daemon active (1 hosts, 1 zones)
 
  data:
    volumes: 1/1 healthy
    pools:   11 pools, 529 pgs
    objects: 209 objects, 584 KiB
    usage:   149 MiB used, 21 GiB / 21 GiB avail
    pgs:     529 active+clean
 
[zuul@compute-0 ~]$ 




# single node testing

#just updated ceph inventory to use single node


/tmp/ceph_spec.yaml in controller

data_devices:
  paths:
  - /dev/ceph_vg0/ceph_lv0
  - /dev/ceph_vg1/ceph_lv1
  - /dev/ceph_vg2/ceph_lv2


[zuul@compute-0 ~]$ lsblk
NAME                MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
loop3                 7:3    0   7G  0 loop 
└─ceph_vg0-ceph_lv0 253:0    0   7G  0 lvm  
loop4                 7:4    0   7G  0 loop 
└─ceph_vg1-ceph_lv1 253:1    0   7G  0 lvm  
loop5                 7:5    0   7G  0 loop 
└─ceph_vg2-ceph_lv2 253:2    0   7G  0 lvm  


[zuul@compute-0 ~]$ sudo cephadm shell -- ceph -s
Inferring fsid be31d165-8aa4-5a10-925b-b39d2a55fbc0
Inferring config /var/lib/ceph/be31d165-8aa4-5a10-925b-b39d2a55fbc0/mon.compute-0/config
Using ceph image with id '9b10134529c8' and tag '7' created on 2024-03-08 19:57:03 +0000 UTC
registry-proxy.engineering.redhat.com/rh-osbs/rhceph@sha256:936f4d841fcca5b0120c0268bfa75b2c20a8c09428bab6027c87153bbec2c936
  cluster:
    id:     be31d165-8aa4-5a10-925b-b39d2a55fbc0
    health: HEALTH_OK
 
  services:
    mon: 1 daemons, quorum compute-0 (age 25m)
    mgr: compute-0.cvscxj(active, since 25m)
    mds: 1/1 daemons up
    osd: 3 osds: 3 up (since 23m), 3 in (since 24m)
    rgw: 1 daemon active (1 hosts, 1 zones)
 
  data:
    volumes: 1/1 healthy
    pools:   11 pools, 529 pgs
    objects: 206 objects, 584 KiB
    usage:   153 MiB used, 21 GiB / 21 GiB avail
    pgs:     529 active+clean
 

