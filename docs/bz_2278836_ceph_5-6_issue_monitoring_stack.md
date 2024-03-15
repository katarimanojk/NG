
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/17.1/html-single/framework_for_upgrades_16.2_to_17.1/index#proc_ceph-upgrade-5-6-update-image-prepare-file_post-upgrade-internal-ceph

in 13.1.4, it calls

https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/6/html/upgrade_guide/upgrade-a-red-hat-ceph-storage-cluster-using-cephadm




testing:






[tripleo-admin@controller-0 ~]$ sudo cephadm shell -- ceph config dump | grep image                                                                                                                                                          
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5                                                                   
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config                          
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC                      
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
global                                        basic     container_image                                undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:5-446                                  *
  mgr                                         advanced  mgr/cephadm/container_image_alertmanager       undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.10   *
  mgr                                         advanced  mgr/cephadm/container_image_base               undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph
  mgr                                         advanced  mgr/cephadm/container_image_grafana            undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                *
  mgr                                         advanced  mgr/cephadm/container_image_node_exporter      undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.10  *
  mgr                                         advanced  mgr/cephadm/container_image_prometheus         undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.10                *
[tripleo-admin@controller-0 ~]$ sudo cephadm shell -- ceph config set mgr mgr/cephadm/container_image_alertmanager undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.12
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
[tripleo-admin@controller-0 ~]$ sudo cephadm shell -- ceph config dump | grep image
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5                           
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config                          
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC                                                      
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
global                                        basic     container_image                                undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:5-446                                  *
  mgr                                         advanced  mgr/cephadm/container_image_alertmanager       undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.12   *
  mgr                                         advanced  mgr/cephadm/container_image_base               undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph
  mgr                                         advanced  mgr/cephadm/container_image_grafana            undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                *
  mgr                                         advanced  mgr/cephadm/container_image_node_exporter      undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.10  *
  mgr                                         advanced  mgr/cephadm/container_image_prometheus         undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.10                *
[tripleo-admin@controller-0 ~]$ sudo cephadm shell -- ceph config set mgr mgr/cephadm/container_image_grafana undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
[tripleo-admin@controller-0 ~]$ sudo cephadm shell -- ceph config set mgr mgr/cephadm/container_image_node_exporter undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.12
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101ee




tripleo-admin@controller-0 ~]$ sudo cephadm shell -- ceph config dump | grep image
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
global                                        basic     container_image                                undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:5-446                                  * 
  mgr                                         advanced  mgr/cephadm/container_image_alertmanager       undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.12   * 
  mgr                                         advanced  mgr/cephadm/container_image_base               undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph                                          
  mgr                                         advanced  mgr/cephadm/container_image_grafana            undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                * 
  mgr                                         advanced  mgr/cephadm/container_image_node_exporter      undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.12  * 
  mgr                                         advanced  mgr/cephadm/container_image_prometheus         undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.12                * 
[tripleo-admin@controller-0 ~]$ sudo podman ps | grep -iE '(grafana|prometheus|alertmanager|node-exporter)'
a0c40e007d5c  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.10                                    --no-collector.ti...  12 hours ago  Up 12 hours                          ceph-e14864ba-e171-552d-864a-db189e445ef5-node-exporter-controller-0
a6698a880eb0  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.10                                                  --config.file=/et...  12 hours ago  Up 12 hours                          ceph-e14864ba-e171-552d-864a-db189e445ef5-prometheus-controller-0
9f7119b06c8b  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.10                                     --cluster.listen-...  12 hours ago  Up 12 hours                          ceph-e14864ba-e171-552d-864a-db189e445ef5-alertmanager-controller-0
6effaea53072  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                                                                        12 hours ago  Up 12 hours                          ceph-e14864ba-e171-552d-864a-db189e445ef5-grafana-controller-0
[tripleo-admin@controller-0 ~]$ for daemon in node-exporter grafana alertmanager prometheus; do sudo cephadm shell -- ceph orch redeploy $daemon; done
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
Scheduled to redeploy node-exporter.cephstorage-0 on host 'cephstorage-0'
Scheduled to redeploy node-exporter.cephstorage-1 on host 'cephstorage-1'
Scheduled to redeploy node-exporter.cephstorage-2 on host 'cephstorage-2'
Scheduled to redeploy node-exporter.controller-0 on host 'controller-0'
Scheduled to redeploy node-exporter.controller-1 on host 'controller-1'
Scheduled to redeploy node-exporter.controller-2 on host 'controller-2'
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
Scheduled to redeploy grafana.controller-0 on host 'controller-0'
Scheduled to redeploy grafana.controller-1 on host 'controller-1'
Scheduled to redeploy grafana.controller-2 on host 'controller-2'
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
Scheduled to redeploy alertmanager.controller-0 on host 'controller-0'
Scheduled to redeploy alertmanager.controller-1 on host 'controller-1'
Scheduled to redeploy alertmanager.controller-2 on host 'controller-2'
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
Scheduled to redeploy prometheus.controller-0 on host 'controller-0'
Scheduled to redeploy prometheus.controller-1 on host 'controller-1'
Scheduled to redeploy prometheus.controller-2 on host 'controller-2'
[tripleo-admin@controller-0 ~]$ 


[tripleo-admin@controller-0 ~]$ sudo podman ps | grep -iE '(grafana|prometheus|alertmanager|node-exporter)'
fd154a3f2e22  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.12                                    --no-collector.ti...  About a minute ago  Up About a minute                    ceph-e14864ba-e171-552d-864a-db189e445ef5-node-exporter-controller-0
83eda5d26d14  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.12                                     --cluster.listen-...  About a minute ago  Up About a minute                    ceph-e14864ba-e171-552d-864a-db189e445ef5-alertmanager-controller-0
a236d90ec1cf  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                                                                        About a minute ago  Up About a minute                    ceph-e14864ba-e171-552d-864a-db189e445ef5-grafana-controller-0
7b9d6646d5f2  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.12                                                  --config.file=/et...  About a minute ago  Up About a minute                    ceph-e14864ba-e171-552d-864a-db189e445ef5-prometheus-controller-0
[tripleo-admin@controller-0 ~]$ 

