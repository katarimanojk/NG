# rough book



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
