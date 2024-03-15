[ceph: root@controller-0 /]# ceph orch ls
NAME                     PORTS        RUNNING  REFRESHED  AGE  PLACEMENT
alertmanager             ?:9093,9094      3/3  4m ago     13h  controller-0;controller-1;controller-2
crash                                     6/6  6m ago     16h  *
grafana                  ?:3100           3/3  4m ago     13h  controller-0;controller-1;controller-2
mds.mds                                   3/3  4m ago     13h  controller-0;controller-1;controller-2
mgr                                       3/3  4m ago     15h  controller-0;controller-1;controller-2
mon                                       3/3  4m ago     15h  controller-0;controller-1;controller-2
node-exporter            ?:9100           6/6  6m ago     13h  *
osd.default_drive_group                    15  6m ago     15h  cephstorage-0;cephstorage-1;cephstorage-2
prometheus               ?:9092           3/3  4m ago     13h  controller-0;controller-1;controller-2
rgw.rgw                  ?:8080           3/3  4m ago     13h  controller-0;controller-1;controller-2
[ceph: root@controller-0 /]# ceph orch ps | grep grafana
grafana.controller-0         controller-0   172.17.3.101:3100       running (13h)     4m ago  13h    86.0M        -  <unknown>         b44d40750cb7  03a11a14b670                                                                            
grafana.controller-1         controller-1   172.17.3.39:3100        running (13h)     4m ago  13h    86.7M        -  <unknown>         b44d40750cb7  7572bade131b                                                                            
grafana.controller-2         controller-2   172.17.3.105:3100       running (13h)     4m ago  13h    87.7M        -  <unknown>         b44d40750cb7  78b7344dd655                                                                            
[ceph: root@controller-0 /]#




Definition of services:


prometheus: monitoring and alert manager
   - constant monitoring of the server/services/processes/application
   - for every type of target, there will different units/metrics captured
   - scraping: fetch data from target system endpoints at regular intervals
   - what to scrape and when ?  prometheus.yml
   - service discovery: to find the endpoints/targets
   
prometheus pulls/collects metrics from http  (hostaddress/metricss)   

- pulls vs push system (where application push metrics to centralized node, overload)


Exporter: monitoring agent that is installed on target machines
             used by promethous to fetch data
         - some servers by default exposes metrics/ endpoints where nodeexporter is not needed
         - what it does
              1. fetches metrics from target
              2. convert to correct format which prometheus understands
              3. expose metrics
         - there is list of official exporters for prometheus.
            eg: linux server needes a node-exporter
         - there are continers that install exporters for respective service
            eg: mysql db service has a custome exporter contianer.

   

grafana  : visual / web UI
          - uses promql to use prometheus data
          
          
          
          
          
    - name: get Grafana instance(s) addresses
      set_fact:
        grafana_server_addrs: "{{ (grafana_server_addrs | default([])) | union(hostvars[item][all_addresses] | ansible.utils.ipaddr(cifmw_cephadm_rgw_network)) }}"
      loop: "{{ groups['edpm'] | list }}"
