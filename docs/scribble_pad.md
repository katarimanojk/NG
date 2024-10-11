# rough book

FIR NO : 15203007251024039558



TG009/62237/2025/OR

38434



/unmesh 
Cursor IDE , claude code


rgw failure:

Aug 11 10:20:18 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-rgw-default-ceph-uni04delta-ipv6-0-buapwn[2775301]: [NOTICE]   (2) : haproxy version is 2.4.22-f8e3218
Aug 11 10:20:18 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-rgw-default-ceph-uni04delta-ipv6-0-buapwn[2775301]: [NOTICE]   (2) : path to executable is /usr/sbin/haproxy
Aug 11 10:20:18 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-rgw-default-ceph-uni04delta-ipv6-0-buapwn[2775301]: [ALERT]    (2) : Starting frontend stats: cannot bind socket (Cannot assign requested address) [2
620:cf:cf:cccc::2:8999]                      
Aug 11 10:20:18 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-rgw-default-ceph-uni04delta-ipv6-0-buapwn[2775301]: [ALERT]    (2) : Starting frontend frontend: cannot bind socket (Cannot assign requested address)
 [2620:cf:cf:cccc::2:8080]                                                                                                                                                                                                                    
Aug 11 10:20:18 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-rgw-default-ceph-uni04delta-ipv6-0-buapwn[2775301]: [ALERT]    (2) : [haproxy.main()] Some protocols failed to start their listeners! Exiting.


why it is tyring to use ::2 where as vip is set to ::4


but it is fixed with 
ceph orch redeploy ingress.rgw.default 

more details below:

TASK [print vip msg={{ cifmw_cephadm_vip }}] *************************************************************************************************************************************************************************************************
Tuesday 12 August 2025  07:18:26 +0000 (0:00:00.069)       0:00:31.571 ******** 
ok: [ceph-uni04delta-ipv6-0] => 
    msg: 2620:cf:cf:cccc::4


service_type: ingress                                                                                                                                                                                                                         
service_id: rgw.default                                                                                                
service_name: ingress.rgw.default                                                                                      
placement:                                                                                                                                                                                                                                    
  count: 2                                                                                                             
spec:                                                 
  backend_service: rgw.rgw                    
  first_virtual_router_id: 50                 
  frontend_port: 8080                            
  monitor_port: 8999                          
  virtual_interface_networks:                                                                                          
  - 2620:cf:cf:cccc::/64                              
  virtual_ip: 2620:cf:cf:cccc::4/64  


[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ls
NAME                     PORTS                         RUNNING  REFRESHED  AGE  PLACEMENT                                                              
crash                                                      3/3  5m ago     3d   *                                                                      
ingress.nfs.cephfs       2620:cf:cf:cccc::9:2049,9049      6/6  5m ago     14h  label:nfs                                                              
ingress.rgw.default      2620:cf:cf:cccc::4:8080,8999      3/4  5m ago     14h  count:2                                                                
mds.cephfs                                                 3/3  5m ago     23h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
mgr                                                        3/3  5m ago     23h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
mon                                                        3/3  5m ago     23h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
nfs.cephfs               ?:12049                           3/3  5m ago     14h  label:nfs                                                              
node-proxy                                                 0/0  -          3d   *                                                                      
osd.default_drive_group                                      3  5m ago     23h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  
rgw.rgw                  ?:8082                            3/3  5m ago     23h  ceph-uni04delta-ipv6-0;ceph-uni04delta-ipv6-1;ceph-uni04delta-ipv6-2  


[ceph: root@ceph-uni04delta-ipv6-0 /]# ceph orch ps                                                                                                                                                                                           
NAME                                                  HOST                    PORTS                     STATUS         REFRESHED  AGE  MEM USE  MEM LIM  VERSION           IMAGE ID      CONTAINER ID                                         
crash.ceph-uni04delta-ipv6-0                          ceph-uni04delta-ipv6-0                            running (3d)      2m ago   3d    6899k        -  18.2.1-340.el9cp  0fdba70d843f  f6df6480b5e6                                         
crash.ceph-uni04delta-ipv6-1                          ceph-uni04delta-ipv6-1                            running (3d)      2m ago   3d    6899k        -  18.2.1-340.el9cp  0fdba70d843f  1967d3c42397                                         
crash.ceph-uni04delta-ipv6-2                          ceph-uni04delta-ipv6-2                            running (3d)      2m ago   3d    6895k        -  18.2.1-340.el9cp  0fdba70d843f  c7c0ce4237e5                                         
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-0.fkapgr      ceph-uni04delta-ipv6-0  *:2049,9049               running (14h)     2m ago  14h    20.2M        -  2.4.22-f8e3218    0d7803e184cb  85fcad3f09c7                                         
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-1.oedabi      ceph-uni04delta-ipv6-1  *:2049,9049               running (14h)     2m ago  14h    11.8M        -  2.4.22-f8e3218    78aea9a8ef82  feaa75114261  
haproxy.nfs.cephfs.ceph-uni04delta-ipv6-2.elhhie      ceph-uni04delta-ipv6-2  *:2049,9049               running (14h)     2m ago  14h    9945k        -  2.4.22-f8e3218    0d7803e184cb  c41356f853ba  
haproxy.rgw.default.ceph-uni04delta-ipv6-0.buapwn     ceph-uni04delta-ipv6-0  *:8080,8999               error             2m ago   3d        -        -  <unknown>         <unknown>     <unknown>                                            
haproxy.rgw.default.ceph-uni04delta-ipv6-2.noenzd     ceph-uni04delta-ipv6-2  *:8080,8999               running (3d)      2m ago   3d    17.1M        -  2.4.22-f8e3218    0d7803e184cb  e3c8df0d57d6  
keepalived.nfs.cephfs.ceph-uni04delta-ipv6-0.akoeuz   ceph-uni04delta-ipv6-0                            running (14h)     2m ago  14h    1832k        -  2.2.8             169ed9896e5a  5ab592e35dd0  
keepalived.nfs.cephfs.ceph-uni04delta-ipv6-1.cjpfiq   ceph-uni04delta-ipv6-1                            running (14h)     2m ago  14h    1837k        -  2.2.8             a9af58a30668  3ce7952cbc7a  
keepalived.nfs.cephfs.ceph-uni04delta-ipv6-2.nxjlpw   ceph-uni04delta-ipv6-2                            running (14h)     2m ago  14h    1824k        -  2.2.8             169ed9896e5a  b6c851f2d305  
keepalived.rgw.default.ceph-uni04delta-ipv6-0.qtbehj  ceph-uni04delta-ipv6-0                            running (3d)      2m ago   3d    1824k        -  2.2.8             169ed9896e5a  3a5ac2cf73fa  
keepalived.rgw.default.ceph-uni04delta-ipv6-2.prvyyx  ceph-uni04delta-ipv6-2                            running (3d)      2m ago   3d    1832k        -  2.2.8             169ed9896e5a  3bd4aace668d  
mds.cephfs.ceph-uni04delta-ipv6-0.mgcdts              ceph-uni04delta-ipv6-0                            running (3d)      2m ago   3d    27.3M        -  18.2.1-340.el9cp  0fdba70d843f  cb3dfc6a9e68  
mds.cephfs.ceph-uni04delta-ipv6-1.jfasxk              ceph-uni04delta-ipv6-1                            running (3d)      2m ago   3d    26.2M        -  18.2.1-340.el9cp  0fdba70d843f  148cdf6bdd3b  
mds.cephfs.ceph-uni04delta-ipv6-2.ilqepn              ceph-uni04delta-ipv6-2                            running (3d)      2m ago   3d    31.6M        -  18.2.1-340.el9cp  0fdba70d843f  38586ff2770a  
mgr.ceph-uni04delta-ipv6-0.uoohds                     ceph-uni04delta-ipv6-0  *:9283,8765               running (3d)      2m ago   3d     682M        -  18.2.1-340.el9cp  0fdba70d843f  53d2869b93cd  
mgr.ceph-uni04delta-ipv6-1.dbyxco                     ceph-uni04delta-ipv6-1  *:8765                    running (3d)      2m ago   3d     457M        -  18.2.1-340.el9cp  0fdba70d843f  a7a808b36384  
mgr.ceph-uni04delta-ipv6-2.yszont                     ceph-uni04delta-ipv6-2  *:8765                    running (3d)      2m ago   3d     456M        -  18.2.1-340.el9cp  0fdba70d843f  511ee6730f29  
mon.ceph-uni04delta-ipv6-0                            ceph-uni04delta-ipv6-0                            running (3d)      2m ago   3d     459M    2048M  18.2.1-340.el9cp  0fdba70d843f  1ce0fa06b7c6  
mon.ceph-uni04delta-ipv6-1                            ceph-uni04delta-ipv6-1                            running (3d)      2m ago   3d     443M    2048M  18.2.1-340.el9cp  0fdba70d843f  67018f01d690  
mon.ceph-uni04delta-ipv6-2                            ceph-uni04delta-ipv6-2                            running (3d)      2m ago   3d     444M    2048M  18.2.1-340.el9cp  0fdba70d843f  577fa5015c7f  
nfs.cephfs.0.0.ceph-uni04delta-ipv6-1.epbrkv          ceph-uni04delta-ipv6-1  *:12049                   running (14h)     2m ago  14h    74.9M        -  5.7               0fdba70d843f  82c8b94c08a4  
nfs.cephfs.1.0.ceph-uni04delta-ipv6-2.mvikpe          ceph-uni04delta-ipv6-2  *:12049                   running (14h)     2m ago  14h    77.4M        -  5.7               0fdba70d843f  d8c3b93b1f5c  
nfs.cephfs.2.0.ceph-uni04delta-ipv6-0.jobpcu          ceph-uni04delta-ipv6-0  *:12049                   running (14h)     2m ago  14h    76.8M        -  5.7               0fdba70d843f  2d6cf5adb259  
osd.0                                                 ceph-uni04delta-ipv6-1                            running (3d)      2m ago   3d     321M    4096M  18.2.1-340.el9cp  0fdba70d843f  976bd58d223c  
osd.1                                                 ceph-uni04delta-ipv6-0                            running (3d)      2m ago   3d     345M    4096M  18.2.1-340.el9cp  0fdba70d843f  44139b8b0684  
osd.2                                                 ceph-uni04delta-ipv6-2                            running (3d)      2m ago   3d     283M    4096M  18.2.1-340.el9cp  0fdba70d843f  45e8c75b074b  
rgw.rgw.ceph-uni04delta-ipv6-0.qwycon                 ceph-uni04delta-ipv6-0  2620:cf:cf:cccc::6a:8082  running (3d)      2m ago   3d     121M        -  18.2.1-340.el9cp  0fdba70d843f  1e15e6998595  
rgw.rgw.ceph-uni04delta-ipv6-1.eyqgrd                 ceph-uni04delta-ipv6-1  2620:cf:cf:cccc::6b:8082  running (3d)      2m ago   3d     121M        -  18.2.1-340.el9cp  0fdba70d843f  cff522bbe505  
rgw.rgw.ceph-uni04delta-ipv6-2.gxegzy                 ceph-uni04delta-ipv6-2  2620:cf:cf:cccc::2:8082   running (3d)      2m ago   3d     121M        -  18.2.1-340.el9cp  0fdba70d843f  c5c8368c5894

[zuul@ceph-uni04delta-ipv6-0 ~]$ ip a  | grep cccc 
    inet6 2620:cf:cf:cccc::9/64 scope global nodad   --> vip created in storage network for nfs ganesha
    inet6 2620:cf:cf:cccc::6a/64 scope global 


[zuul@ceph-uni04delta-ipv6-2 ~]$ ip a | grep cccc
    inet6 2620:cf:cf:cccc::2/64 scope global nodad 
    inet6 2620:cf:cf:cccc::6c/64 scope global 
[zuul@ceph-uni04delta-ipv6-2 ~]$ 


nfs failure:

Aug 11 12:54:58 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-nfs-cephfs-ceph-uni04delta-ipv6-0-qedizz[2884747]: [NOTICE]   (2) : haproxy version is 2.4.22-f8e3218
Aug 11 12:54:58 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-nfs-cephfs-ceph-uni04delta-ipv6-0-qedizz[2884747]: [NOTICE]   (2) : path to executable is /usr/sbin/haproxy
Aug 11 12:54:58 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-nfs-cephfs-ceph-uni04delta-ipv6-0-qedizz[2884747]: [ALERT]    (2) : Starting frontend stats: cannot bind socket (Cannot assign requested address) [26
20:cf:cf:cf02::16a:9049]                     
Aug 11 12:54:58 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-nfs-cephfs-ceph-uni04delta-ipv6-0-qedizz[2884747]: [ALERT]    (2) : Starting frontend frontend: cannot bind socket (Cannot assign requested address) 
[2620:cf:cf:cf02::16a:2049]                                                                                                                                                                                                                   
Aug 11 12:54:58 ceph-uni04delta-ipv6-0 ceph-96303f71-564d-5cea-a699-a191d6e0ab1a-haproxy-nfs-cephfs-ceph-uni04delta-ipv6-0-qedizz[2884747]: [ALERT]    (2) : [haproxy.main()] Some protocols failed to start their listeners! Exiting.







jul25 /fp discussion

/fp: 
   network 


ceph 8 in unidelta ipv6 adoption ?
deploy tripleo ceph with ceph8


before adoption migrati
adoption with test_with_ceph
ceph migtraion not needed ? just jump to configure_object section (even ingress section can be ignored)




2620:cf:cf:cf02::161



  * ip-2620.cf.cf.cf02..161 
  - is onwed by pacemaker and moved to controller
  - is configured to ganesha


haproxy.cfg doesn't have nfs in tripleo


new cephnfs cluster created and managed by cephadm




overrides needed to run ceph_load

ceph_nfs_vip



note: adopt from 6 to 7



/ud monday 1:1
----

before adoption, volumes , operations after the adoption

udpate jira


--
Spike

entry criteria:
 - Dod is ready

exit:
 - 

 - spike
 
 
 
 story, 
   - name of the job
   - url of the job
   - what tests it is running
   - test results
   
---   
   
   




glance validaiton is not checking backend is correct or image















================

Volume:
At its core, a volume is a directory, possibly with some data in it, which is accessible to the containers in a pod

Ephemeral volume types have a lifetime of a pod, but persistent volumes exist beyond the lifetime of a pod.

Note:   https://github.com/openstack-k8s-operators/lib-common/tree/main/modules/storage/storage.go module handles volumes and volumemounts

extraMounts -> extra volumes

pod:
spec.volumes
spec.container.volumemounts : where to mount those volumes into container

propogation: 
  external : ability to allocate and mount a volume across operators
  internal : propogate an extraVolume with in a single operator

  global  -> all the entities in the operator can mount 
  group:  cinder-volume  -> all pods of cinder-volume 
  instance: volume1    -> mount the extravolume on the pod related to volume1 backend


eg:
 extraMounts:
  - name:
    region:
    extraVol:
     - propogation:
        - Glance  # extra volume is mounted to all 
        - volume1
       volumes:
        - name : ceph
       mounts:
        - name : ceph
          mountpah: "/etc/ceph"  
     - propogation:
       - compute    # edpmd ansible-ee-operator
       - cinderBackup 





compile and build the operator:

make generate && make manifests &&  make



operator:

define spec.ExtraMounts 



[mkatari@fedora cinder-operator_myfork]$ vi ./api/v1beta1/
cinderapi_types.go        cinderscheduler_types.go  cindervolume_types.go     common_types.go           groupversion_info.go      
cinderbackup_types.go     cinder_types.go           cinder_webhook.go         conditions.go             zz_generated.deepcopy.go  
[mkatari@fedora cinder-operator_myfork]$ find . -name cinder_types.go


at the end add 
ExtraMounts []storage.volMounts `json:"extraMounts"` 


and then add storage module in import section

and do 'go get github.com/openstack-k8s-operators/lib-common/tree/main/modules/storage/storage.go'

go mod tidy

make generate && make manifests &&  make


which should update the crds with extravolumes.


now update pkg/<operator_name>>/const.go with

horizon storage.propgationType = "Horion"
and import module

pkg/<operator_name>>/deployment.go  , update getvolumeMounts to accept a paramter for extramounts






logic to process extramounts  in deployemnts/statefulsets






















# imp


tht -> openshift CR

export ANSIBLE_REMOTE_USER=zuul
export ANSIBLE_SSH_PRIVATE_KEY=~/.ssh/id_cifw
export ANSIBLE_HOST_KEY_CHECKING=False

vpn: sudo nmcli --ask conn up "Pune (PNQ2)"



# with TLS selfsigned certificate , ceph dashbaord tasks executed 


##use the command below and generate the self-signed cet and key on edpm-0 node

cd /etc/pki/tls; 
openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 \
  -nodes -keyout example.com.key -out example.com.crt -subj "/CN=example.com" \
  -addext "subjectAltName=DNS:example.com,DNS:*.example.com,IP:10.0.0.1"


TASK [cifmw_cephadm : Set ceph CLI cifmw_cephadm_ceph_cli={{ cifmw_cephadm_container_cli }} run --rm {{ cifmw_cephadm_container_options }} {% if mount_certs|default(false) %} --vol[415/1863$
mw_cephadm_certs }}:/etc/pki/tls:z {% endif %} {% if sensitive_data|default(false) %} --interactive {% endif %} --volume {{ cifmw_cephadm_config_home }}:/etc/ceph:z {% if not (external_clust
er|default(false) or crush_rules|default(false)) -%} --volume {{ cifmw_cephadm_assimilate_conf }}:{{ cifmw_cephadm_assimilate_conf_container }}:z {% endif %} {% if mount_spec|default(false) 
%} --volume {{ cifmw_cephadm_spec }}:{{ cifmw_cephadm_container_spec }}:z {% endif %} {% if admin_daemon|default(false) %} --volume /var/run/ceph/{{ cifmw_cephadm_fsid }}:/var/run/ceph:z {% 
endif %} --entrypoint {{ ceph_command | default('ceph') }} {{ cifmw_cephadm_container_ns }}/{{ cifmw_cephadm_container_image }}:{{ cifmw_cephadm_container_tag }} {% if ceph_command|default('
ceph') == 'ceph' or ceph_command|default('ceph') == 'rados' or ceph_command|default('ceph') == 'rbd' -%}                                                                                      
  {% if not admin_daemon|default(false) -%}                                                                                                                                                   
  --fsid {{ cifmw_cephadm_fsid }} -c /etc/ceph/{{ cifmw_cephadm_cluster }}.conf -k /etc/ceph/{{ cifmw_cephadm_cluster }}.client.{{ select_keyring| default('admin') }}.keyring                
  {%- endif %}                                                                                                                                                                                
  {% if external_cluster|default(false) -%}                                                                                                                                                   
  -n client.{{ select_keyring }}                                                                                                                                                              
  {%- endif %}                                                                                                                                                                                
{%- endif %}] ***                                                                                                                                                                             
ok: [192.168.122.100]                                                                                                                                                                         
                                                                                                                                                                                              
TASK [cifmw_cephadm : import grafana certificate file _raw_params={{ cifmw_cephadm_ceph_cli }} config-key set mgr/cephadm/grafana_crt -i {{ cifmw_cephadm_dashboard_crt }}] ******************
ok: [192.168.122.100]                                                                                                                                                                         
                                                                                                                                                                                              
TASK [cifmw_cephadm : import grafana certificate key _raw_params={{ cifmw_cephadm_ceph_cli }} config-key set mgr/cephadm/grafana_key -i {{ cifmw_cephadm_dashboard_key }}] *******************
ok: [192.168.122.100]   


TASK [cifmw_cephadm : enable SSL for dashboard _raw_params={{ cifmw_cephadm_ceph_cli }} config set mgr mgr/dashboard/ssl true] ***************************************************************
changed: [192.168.122.100]                                    
     
TASK [cifmw_cephadm : import dashboard certificate file _raw_params={{ cifmw_cephadm_ceph_cli }} config-key set mgr/dashboard/crt -i {{ cifmw_cephadm_dashboard_crt }}] **********************
ok: [192.168.122.100]                                         
                                                                                                                                                                                              
TASK [cifmw_cephadm : import dashboard certificate key _raw_params={{ cifmw_cephadm_ceph_cli }} config-key set mgr/dashboard/key -i {{ cifmw_cephadm_dashboard_key }}] ***********************
ok: [192.168.122.100]



TASK [cifmw_cephadm : disable ssl verification for grafana _raw_params={{ cifmw_cephadm_ceph_cli }} dashboard set-grafana-api-ssl-verify False] **********************************************
ok: [192.168.122.100]





## misc

Ensure the public_network and cluster_network map to the same networks as storage and storage_mgmt.


ceph scale down or remove ceph node

https://docs.redhat.com/en/documentation/red_hat_openstack_platform/17.1/html-single/deploying_red_hat_ceph_storage_and_red_hat_openstack_platform_together_with_director/index#proc_scaling-down-and-replacing-ceph-storage-nodes_assembly_scaling-the-ceph-storage-cluster




## talk with alan on jan17

iscsi job that test lvm backend

Alan wants to develop his DT for cinder





install_yamls only for developers

deploy all the operators on crc node



ci_framework: 

  - tool kit for building ci jobs (both upstream and downstream)
      tripleo : upstream/IR


reproducer


create a vm called controller(ansible) not a openstack controller

and then execute other stuff on controlle







    - name: Run ceph config dump to get pool
      command: "{{ tripleo_cephadm_ceph_cli }} config dump --format json"
      register: ceph_config_dump
      become: true

    - name: Extract manoj dump_json
      set_fact:
        osd_pool_default_pg_num: "{{ item.value }}"
        #msg: "{{ (ceph_config_dump.stdout | from_json) |  map(attribute='osd_pool_default_pg_num') }}"
      loop: "{{ ceph_config_dump.stdout | from_json }}"
      when: item.name == 'osd_pool_default_pg_num'

    - name: manoj debug
      debug:
        msg: "{{ osd_pool_default_pg_num }}"



#tripleo_cephadm_container_ns: "quay.io/ceph"
#tripleo_cephadm_container_image: "ceph"
#tripleo_cephadm_container_tag: "v18"

tripleo_cephadm_container_ns: "undercloud-0.ctlplane.redhat.local:8787/rh-osbs"
tripleo_cephadm_container_image: "rhceph"
tripleo_cephadm_container_tag: "6-199"
~                                        





minimal cluster: bootstrap + osd 


overcloud:


pool creation:
 cinder : volumes
   nova : vms
   
   




To control the pg_autoscale_mode per pool, create a Heat environment file like pools.yaml with the content in [1] and include it in the openstack overcloud deploy command with a -e pools.yaml:

CephPools:
  - name: volumes
    pg_autoscale_mode: False
  - name: images
    pg_autoscale_mode: True
  - name: vms
    pg_autoscale_mode: False




[mkatari@fedora config-download]$ grep -inr tripleo_cephadm_pools .
./overcloud/cephadm/cephadm-extra-vars-ansible.yml:4:tripleo_cephadm_pools: [{'name': 'vms', 'pg_num': '16', 'rule_name': 'replicated_rule', 'application': 'rbd'}, {'name': 'volumes', 'pg_num': '16', 'rule_name': 'replicated_rule', 'application': 'rbd'}, {'name': 'images', 'pg_num': '16', 'rule_name': 'replicated_rule', 'application': 'rbd'}, {'name': 'backups', 'pg_num': '16', 'rule_name': 'replicated_rule', 'application': 'rbd'}]




We have an RGW key for ceph clients at:

  /etc/ceph/ceph.client.radosgw.keyring

but that's distinct from this key:

  /var/lib/ceph/radosgw/ceph-rgw.openstack/keyring





github 2FA request:
https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/recovering-your-account-if-you-lose-your-2fa-credentials#requesting-help-with-two-factor-authentication
