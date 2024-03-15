






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
