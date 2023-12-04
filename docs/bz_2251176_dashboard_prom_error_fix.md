before fix:

[ceph: root@controller-0 /]# ceph config dump | grep dash
mgr                                       advanced  mgr/dashboard/ALERTMANAGER_API_HOST            http://192.168.24.41:9093                                                                     * 
mgr                                       advanced  mgr/dashboard/GRAFANA_API_PASSWORD             1M0xFK0LNrYRTILHXTvxQVFGc                                                                     * 
mgr                                       advanced  mgr/dashboard/GRAFANA_API_SSL_VERIFY           false                                                                                         * 
mgr                                       advanced  mgr/dashboard/GRAFANA_API_URL                  https://192.168.24.27:3100                                                                    * 
mgr                                       advanced  mgr/dashboard/GRAFANA_API_USERNAME             admin                                                                                         * 
mgr                                       advanced  mgr/dashboard/PROMETHEUS_API_HOST              http://192.168.24.41:9092      




after fix:

prometheus and alermanager will use storage network (172.17.x) where as grafana (192.168.X.X) still used ctlplane network

[ceph: root@controller-0 /]# ceph config dump | grep dash
mgr                                       advanced  mgr/dashboard/ALERTMANAGER_API_HOST            http://172.17.3.10:9093                                                                       * 
mgr                                       advanced  mgr/dashboard/GRAFANA_API_PASSWORD             1M0xFK0LNrYRTILHXTvxQVFGc                                                                     * 
mgr                                       advanced  mgr/dashboard/GRAFANA_API_SSL_VERIFY           false                                                                                         * 
mgr                                       advanced  mgr/dashboard/GRAFANA_API_URL                  https://192.168.24.27:3100                                                                    * 
mgr                                       advanced  mgr/dashboard/GRAFANA_API_USERNAME             admin                                                                                         * 
mgr                                       advanced  mgr/dashboard/PROMETHEUS_API_HOST              http://172.17.3.10:9092                                                                       * 
mgr                                       advanced  mgr/dashboard/controller-0.eccisn/server_addr  172.17.3.10




[ceph: root@controller-0 /]# ceph dashboard get-alertmanager-api-host
http://172.17.3.10:9093
[ceph: root@controller-0 /]# ceph dashboard get-prometheus-api-host
http://172.17.3.10:9092




[tripleo-admin@controller-0 ~]$ sudo egrep -A1 "prometheus|alertmanager" /var/lib/config-data/puppet-generated/haproxy/etc/haproxy/haproxy.cfg 
listen ceph_alertmanager
  bind 172.17.3.126:9093 transparent ssl crt /etc/pki/tls/certs/haproxy/overcloud-haproxy-storage.pem
--
listen ceph_prometheus
  bind 172.17.3.126:9092 transparent ssl crt /etc/pki/tls/certs/haproxy/overcloud-haproxy-storage.pem
[tripleo-admin@controller-0 ~]$ 


HAproxy config points to different ip

so we have to use 
net_vip_map:
  ctlplane: 192.168.24.27    -> grafana_vip/dashaboard_frontend_vip
  storage: 172.17.3.126      -> prom vip








tested curl:

curl -k https://192.168.24.27:3100  grafana

curl -k https://192.168.24.27:8444  dashboard 

curl -k http://172.17.3.10:9092 prom
curl -k http://172.17.3.10:9093 alertmanager

 
