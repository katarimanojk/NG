

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







