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


Use a single value for the log level and memory level to set them both to the same value. For example, debug_osd = 5 sets the debug level for the ceph-osd daemon to 5.

To use different values for the output log level and the memory level, separate the values with a forward slash (/). For example, debug_mon = 1/5 sets the debug log level for the ceph-mon daemon to 1 and its memory log level to 5.
### default log settings can be seen here
 https://docs.ceph.com/en/reef/rados/troubleshooting/log-and-debug/#subsystem-log-and-debug-settings


# troubleshooting

## complete set of commands : 
   https://documentation.suse.com/ses/7.1/html/ses-all/preface-troubleshooting.html



## analyze jounral ctl log files

on the controller node,
cd /var/log/journal
journal --file x.journal 



