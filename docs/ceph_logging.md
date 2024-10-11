Logging:

https://docs.ceph.com/en/pacific/cephadm/operations/#ceph-daemon-logs

slack threa:
https://redhat-internal.slack.com/archives/C04MH4T5GPK/p1722420371399019

stdout: enabled by default, 
 - jourcetl -u <service name>  :  systemctl list-units | grep ceph and fetch the service name


in the controller

sudo cephadm shell -- ceph config set global log_to_file true

then go to /var/log/ceph/<fsid> and tail -f the client-ceph.rgw. log file


by defualt it is disabled and you see only ceph-volume.log

