
https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/17.1/html-single/framework_for_upgrades_16.2_to_17.1/index#proc_ceph-upgrade-5-6-update-image-prepare-file_post-upgrade-internal-ceph

in 13.1.4, it calls

https://access.redhat.com/documentation/en-us/red_hat_ceph_storage/6/html/upgrade_guide/upgrade-a-red-hat-ceph-storage-cluster-using-cephadm




testing:



-- testing the steps in comment 9,10




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





-- testing without redeploy



-- before upgrade

[tripleo-admin@controller-0 ~]$ sudo cephadm shell -- ceph config dump | grep image
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
[tripleo-admin@controller-0 ~]$ 
[tripleo-admin@controller-0 ~]$ 
[tripleo-admin@controller-0 ~]$ 
[tripleo-admin@controller-0 ~]$ sudo podman ps | grep -iE '(grafana|prometheus|alertmanager|node-exporter)'
a1a93ab06ee6  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.10                                    --no-collector.ti...  3 minutes ago  Up 3 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-node-exporter-controller-0
93aeceef32c8  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.10                                     --cluster.listen-...  3 minutes ago  Up 3 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-alertmanager-controller-0
c059746c3642  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                                                                        3 minutes ago  Up 3 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-grafana-controller-0
2bcaa096b287  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.10                                                  --config.file=/et...  3 minutes ago  Up 3 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-prometheus-controller-0
[tripleo-admin@controller-0 ~]$ 





-- upgrade start


[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph orch upgrade start --image undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
Initiating upgrade to undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6
[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph orch upgrade status
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
{
    "target_image": "undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6",
    "in_progress": true,
    "which": "Upgrading all daemon types on all hosts",
    "services_complete": [],
    "progress": "",
    "message": "Doing first pull of undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6 image"
}
[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph orch upgrade status
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id '72d512a15e58' and tag '5-446' created on 2023-07-07 03:19:28 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:ffd8626d2a603a618646125d0739a0d6fa10b14623327a6442faafca06101eea
{
    "target_image": "undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6",
    "in_progress": true,
    "which": "Upgrading all daemon types on all hosts",
    "services_complete": [],
    "progress": "0/48 daemons upgraded",
    "message": "Pulling undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6 image on host controller-1"




[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph status
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id 'ceae6c596672' and tag '6' created on 2024-04-16 20:00:03 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:0e8fcaf340946dd2881027da80d977066726f5f2bdd454c2b61bcb8ce5aba58b
  cluster:
    id:     e14864ba-e171-552d-864a-db189e445ef5
    health: HEALTH_WARN
            noout,noscrub,nodeep-scrub flag(s) set
 
  services:
    mon: 3 daemons, quorum controller-0,controller-1,controller-2 (age 16s)
    mgr: controller-0.kxazet(active, since 70s), standbys: controller-2.ipoxll, controller-1.auuiew
    mds: 1/1 daemons up, 2 standby
    osd: 15 osds: 15 up (since 6d), 15 in (since 6d)
         flags noout,noscrub,nodeep-scrub
    rgw: 3 daemons active (3 hosts, 1 zones)
 
  data:
    volumes: 1/1 healthy
    pools:   11 pools, 321 pgs
    objects: 251 objects, 463 KiB
    usage:   2.8 GiB used, 477 GiB / 480 GiB avail
    pgs:     321 active+clean
 
  progress:
    Upgrade to 17.2.6-216.el9cp (17s)
      [==..........................] (remaining: 2m)
 
[tripleo-admin@controller-0 ~]$ 



[tripleo-admin@controller-0 ~]$ sudo podman ps | grep -iE '(grafana|prometheus|alertmanager|node-exporter|mon|mgr)'
47b0e77fe20e  cluster.common.tag/haproxy:pcmklatest                                                                                           /bin/bash /usr/lo...  6 days ago      Up 6 days                          haproxy-bundle-podman-0
45b9c333f8f6  cluster.common.tag/mariadb:pcmklatest                                                                                           /bin/bash /usr/lo...  6 days ago      Up 6 days                          galera-bundle-podman-0
2363b938c8e2  cluster.common.tag/rabbitmq:pcmklatest                                                                                          /bin/bash /usr/lo...  6 days ago      Up 6 days                          rabbitmq-bundle-podman-0
f567cd0a4d95  cluster.common.tag/redis:pcmklatest                                                                                             /bin/bash /usr/lo...  6 days ago      Up 6 days                          redis-bundle-podman-0
3347232b344a  cluster.common.tag/manila-share:pcmklatest                                                                                      /bin/bash /usr/lo...  6 days ago      Up 6 days                          openstack-manila-share-podman-0
a1a93ab06ee6  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.10                                    --no-collector.ti...  30 minutes ago  Up 30 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-node-exporter-controller-0
93aeceef32c8  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.10                                     --cluster.listen-...  30 minutes ago  Up 30 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-alertmanager-controller-0
c059746c3642  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                                                                        30 minutes ago  Up 30 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-grafana-controller-0
2bcaa096b287  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.10                                                  --config.file=/et...  30 minutes ago  Up 30 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-prometheus-controller-0
7a488bc44d8d  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                                        -n mgr.controller...  3 minutes ago   Up 3 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-mgr-controller-0-kxazet
fada48d3bbf9  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                                        -n mon.controller...  2 minutes ago   Up 2 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-mon-controller-0
[tripleo-admin@controller-0 ~]$ 


[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph orch upgrade status
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id 'ceae6c596672' and tag '6' created on 2024-04-16 20:00:03 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:0e8fcaf340946dd2881027da80d977066726f5f2bdd454c2b61bcb8ce5aba58b
{
    "target_image": "undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6",
    "in_progress": true,
    "which": "Upgrading all daemon types on all hosts",
    "services_complete": [
        "mgr",
        "mon"
    ],
    "progress": "6/48 daemons upgraded",
    "message": "Pulling undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6 image on host cephstorage-2",
    "is_paused": false
}






[tripleo-admin@controller-0 ~]$ sudo podman ps | grep -i ceph
6d9bf957ea5c  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:5-446                                                                        6 days ago          Up 6 days                          ceph-nfs-pacemaker
93aeceef32c8  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.10                   --cluster.listen-...  37 minutes ago      Up 37 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-alertmanager-controller-0
c059746c3642  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                                                      37 minutes ago      Up 37 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-grafana-controller-0
2bcaa096b287  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.10                                --config.file=/et...  37 minutes ago      Up 37 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-prometheus-controller-0
7a488bc44d8d  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n mgr.controller...  10 minutes ago      Up 10 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-mgr-controller-0-kxazet
fada48d3bbf9  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n mon.controller...  9 minutes ago       Up 9 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-mon-controller-0
e1eac1f12d50  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n client.crash.c...  6 minutes ago       Up 6 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-crash-controller-0
3ba2c9b3f593  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n mds.mds.contro...  About a minute ago  Up About a minute                  ceph-e14864ba-e171-552d-864a-db189e445ef5-mds-mds-controller-0-dlqvyc
c71943e0d253  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n client.rgw.rgw...  53 seconds ago      Up 53 seconds                      ceph-e14864ba-e171-552d-864a-db189e445ef5-rgw-rgw-controller-0-rvqzyt
f0ef1598feea  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.12                  --no-collector.ti...  10 seconds ago      Up 11 seconds                      ceph-e14864ba-e171-552d-864a-db189e445ef5-node-exporter-controller-0


### even monitoring stack is updated during upgrade

[tripleo-admin@controller-0 ~]$ sudo podman ps | grep -i ceph
6d9bf957ea5c  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:5-446                                                                        6 days ago          Up 6 days                          ceph-nfs-pacemaker
7a488bc44d8d  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n mgr.controller...  12 minutes ago      Up 12 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-mgr-controller-0-kxazet
fada48d3bbf9  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n mon.controller...  11 minutes ago      Up 11 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-mon-controller-0
e1eac1f12d50  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n client.crash.c...  7 minutes ago       Up 7 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-crash-controller-0
3ba2c9b3f593  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n mds.mds.contro...  3 minutes ago       Up 3 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-mds-mds-controller-0-dlqvyc
c71943e0d253  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n client.rgw.rgw...  2 minutes ago       Up 2 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-rgw-rgw-controller-0-rvqzyt
f0ef1598feea  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.12                  --no-collector.ti...  About a minute ago  Up About a minute                  ceph-e14864ba-e171-552d-864a-db189e445ef5-node-exporter-controller-0
5e389808c1d1  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.12                                --config.file=/et...  About a minute ago  Up About a minute                  ceph-e14864ba-e171-552d-864a-db189e445ef5-prometheus-controller-0
edfed1dd3241  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.12                   --cluster.listen-...  47 seconds ago      Up 48 seconds                      ceph-e14864ba-e171-552d-864a-db189e445ef5-alertmanager-controller-0
80cd5f58e515  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                                                      19 seconds ago      Up 19 seconds                      ceph-e14864ba-e171-552d-864a-db189e445ef5-grafana-controller-0
[tripleo-admin@controller-0 ~]$ 



..now the upgrade seems to be completed


[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph status
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id 'ceae6c596672' and tag '6' created on 2024-04-16 20:00:03 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:0e8fcaf340946dd2881027da80d977066726f5f2bdd454c2b61bcb8ce5aba58b
  cluster:
    id:     e14864ba-e171-552d-864a-db189e445ef5
    health: HEALTH_WARN
            noout,noscrub,nodeep-scrub flag(s) set
 
  services:
    mon: 3 daemons, quorum controller-0,controller-1,controller-2 (age 11m)
    mgr: controller-0.kxazet(active, since 12m), standbys: controller-2.ipoxll, controller-1.auuiew
    mds: 1/1 daemons up, 2 standby
    osd: 15 osds: 15 up (since 4m), 15 in (since 6d)
         flags noout,noscrub,nodeep-scrub
    rgw: 3 daemons active (3 hosts, 1 zones)
 
  data:
    volumes: 1/1 healthy
    pools:   11 pools, 321 pgs
    objects: 253 objects, 464 KiB
    usage:   624 MiB used, 479 GiB / 480 GiB avail
    pgs:     321 active+clean
 
[tripleo-admin@controller-0 ~]$ sudo cephadm shell ceph orch upgrade status
Inferring fsid e14864ba-e171-552d-864a-db189e445ef5
Inferring config /var/lib/ceph/e14864ba-e171-552d-864a-db189e445ef5/mon.controller-0/config
Using ceph image with id 'ceae6c596672' and tag '6' created on 2024-04-16 20:00:03 +0000 UTC
undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph@sha256:0e8fcaf340946dd2881027da80d977066726f5f2bdd454c2b61bcb8ce5aba58b
{
    "target_image": null,
    "in_progress": false,
    "which": "<unknown>",
    "services_complete": [],
    "progress": null,
    "message": "",
    "is_paused": false
}

mon, mgr, crash, mds, rgw and monitoring stack are move to 6 , except ceph-nfs-pacemaker

[tripleo-admin@controller-0 ~]$ sudo podman ps | grep -i ceph
6d9bf957ea5c  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:5-446                                                                        6 days ago      Up 6 days                          ceph-nfs-pacemaker
7a488bc44d8d  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n mgr.controller...  14 minutes ago  Up 14 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-mgr-controller-0-kxazet
fada48d3bbf9  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n mon.controller...  13 minutes ago  Up 13 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-mon-controller-0
e1eac1f12d50  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n client.crash.c...  10 minutes ago  Up 10 minutes                      ceph-e14864ba-e171-552d-864a-db189e445ef5-crash-controller-0
3ba2c9b3f593  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n mds.mds.contro...  6 minutes ago   Up 6 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-mds-mds-controller-0-dlqvyc
c71943e0d253  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/rhceph:6                                                      -n client.rgw.rgw...  5 minutes ago   Up 5 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-rgw-rgw-controller-0-rvqzyt
f0ef1598feea  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-node-exporter:v4.12                  --no-collector.ti...  4 minutes ago   Up 4 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-node-exporter-controller-0
5e389808c1d1  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus:v4.12                                --config.file=/et...  3 minutes ago   Up 3 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-prometheus-controller-0
edfed1dd3241  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/openshift-ose-prometheus-alertmanager:v4.12                   --cluster.listen-...  3 minutes ago   Up 3 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-alertmanager-controller-0
80cd5f58e515  undercloud-0.ctlplane.redhat.local:8787/rh-osbs/grafana:latest                                                                      2 minutes ago   Up 2 minutes                       ceph-e14864ba-e171-552d-864a-db189e445ef5-grafana-controller-0



# ceph-nfs (ganesha)

(undercloud) [stack@undercloud-0 ~]$ ansible-playbook -i $HOME/overcloud-deploy/overcloud/config-download/overcloud/cephadm/inventory.yml /usr/share/ansible/tripleo-playbooks/ceph-update-ganesha.yml \                                     
 -e @$HOME/overcloud-deploy/overcloud/config-download/overcloud/global_vars.yaml \
 -e @$HOME/overcloud-deploy/overcloud/config-download/overcloud/cephadm/cephadm-extra-vars-heat.yml \
  -e @$HOME/ganesha_update_extravars.yaml
[WARNING]: Invalid characters were found in group names but not replaced, use -vvvv to see details

PLAY [ceph_nfs] ******************************************************************************************************************************************************************************************************************************

TASK [Render ganesha systemd unit] ***********************************************************************************************************************************************************************************************************
changed: [controller-0]
changed: [controller-2]
changed: [controller-1]

TASK [Restart Pacemaker resource] ************************************************************************************************************************************************************************************************************
changed: [controller-0]

PLAY RECAP ***********************************************************************************************************************************************************************************************************************************
controller-0               : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
controller-1               : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
controller-2               : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


