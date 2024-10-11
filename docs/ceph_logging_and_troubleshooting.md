# Logging:


https://www.ibm.com/docs/en/storage-ceph/7?topic=management-viewing-log-files-ceph-daemons
https://docs.ceph.com/en/pacific/cephadm/operations/#ceph-daemon-logs
slack threa:
https://redhat-internal.slack.com/archives/C04MH4T5GPK/p1722420371399019

stdout: enabled by default,
 - jourcetl -u <service name>  :  systemctl list-units | grep ceph and fetch the service name
 eg: journalctl -xef -u ceph-279c19fd-1e4a-535c-a07a-ae91b536ab3e@mon.cephstorage-0.service

in the controller

sudo cephadm shell -- ceph config set global log_to_file true

then go to /var/log/ceph/<fsid> and tail -f the client-ceph.rgw. log file


by defualt it is disabled and you see only ceph-volume.log



## debug:
https://docs.ceph.com/en/reef/rados/troubleshooting/log-and-debug/


### if a service is failing

- check the container sudo podman ps -a
- if the container is down or missing
- sudo systemctl list-untis | grp for service
- if service is missing then endbale debug and watch cephadm logs in the next step

### enable debug for cpehadm and watch 

ceph config set mgr mgr/cephadm/log_to_cluster_level debug
ceph -W cephadm --watch-debug


Use a single value for the log level and memory level to set them both to the same value. For example, debug_osd = 5 sets the debug level for the ceph-osd daemon to 5.

To use different values for the output log level and the memory level, separate the values with a forward slash (/). For example, debug_mon = 1/5 sets the debug log level for the ceph-mon daemon to 1 and its memory log level to 5.
### default log settings can be seen here
 https://docs.ceph.com/en/reef/rados/troubleshooting/log-and-debug/#subsystem-log-and-debug-settings


### set debug for rgw

https://access.redhat.com/solutions/2085183



# to add debut to a openshift service, add this to contlplane cr
       customServiceConfig: |
          [DEFAULT]
          debug = True

# keytone logs

oc logs -n openstack keystone-7bfff9d886-4wt9q -c keystone-api


# how to run only  one instance of rgw or any other damone while debugging

ceph orch ls --export rgw > rgw
edit the spec and remove the hosts 
ceph orch apply -i /mnt/rgw

method2:
remove the label form the two host 


# troubleshooting

## complete set of commands : 
   https://documentation.suse.com/ses/7.1/html/ses-all/preface-troubleshooting.html



## analyze jounral ctl log files

on the controller node,
cd /var/log/journal
journal --file x.journal 


# package download issues

dnf istall cephadm
Error: Error downloading packages:
  cephadm-2:18.2.1-314.el9cp.noarch: Cannot download, all mirrors were already tried without success

sol:
[zuul@compute-mr66ys71-2 ~]$ sudo dnf clean all



dns issue ?

[zuul@np0005229302 ~]$ cat /etc/resolv.conf
search localdomain
nameserver 10.255.255.25

1. able to reach the internet ? ping google ip

[zuul@np0005229302 ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=117 time=3.14 ms

2. ping google.com url and see if it is reachale

3. [root@shark20 ~]# nslookup google.com 127.0.0.1
Server:         127.0.0.1
Address:        127.0.0.1#53

Non-authoritative answer:
Name:   google.com
Address: 172.217.1.110
Name:   google.com
Address: 2607:f8b0:4009:801::200e

[root@shark20 ~]# 

