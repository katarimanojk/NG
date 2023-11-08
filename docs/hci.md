source: https://github.com/fultonj/antelope/blob/main/docs/hci.md

- clone glance-operator before glance pv creation
- controlplane base deployment.yaml missing

 [manoj@shark13 out]$ TARGET=/home/manoj/antelope/crs/control_plane/base/deployment.yaml
[manoj@shark13 out]$ pwd
/home/manoj/install_yamls/out
[manoj@shark13 out]$ kustomize build openstack/openstack/cr/ > $TARGET

and then run

kustomize build control_plane/overlay/ceph | sed "s/_FSID_/${FSID}/" > control.yaml
