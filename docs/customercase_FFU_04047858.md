https://redhat-internal.slack.com/archives/C04J1D40W4W/p1738691351369549





Jan 31 09:37:49 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd-logind[2555]: System is rebooting (Reboot initiated by Ansible).
Jan 31 09:37:49 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: Stopping Ceph mon.b52-41-2-46-15 for 10460b03-1b0a-4206-a989-1a01cee8b865...
Jan 31 09:37:49 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: Stopping Ceph mgr.b52-41-2-46-15 for 10460b03-1b0a-4206-a989-1a01cee8b865...
Jan 31 09:37:49 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: Stopping Ceph rgw.b52-41-2-46-15.b52-41-2-46-15.usxijb for 10460b03-1b0a-4206-a989-1a01cee8b865...

Jan 31 09:37:50 b52-41-2-46-15.mgmt.it-b52.cloud.internal bash[933330]: Error: no container with name or ID "ceph-10460b03-1b0a-4206-a989-1a01cee8b865-rgw.b52-41-2-46-15.b52-41-2-46-15.usxijb" found: no such container

Jan 31 09:37:50 b52-41-2-46-15.mgmt.it-b52.cloud.internal conmon[12314]: debug 2025-01-31T09:37:50.270+0000 7f0662cba700 -1 received  signal: Terminated from /dev/init -- /usr/bin/radosgw -n client.rgw.b52-41-2-46-15.b52-41-2-46-15.usxijb -f --setuser ceph --setgroup ceph --default-log-to-file=false --default-log-to-stderr=true --default-log-stderr-prefix=debug   (PID: 1) UID: 0





I see a reboot here:


Jan 31 09:51:26 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd-logind[3512]: The system will reboot now!
Jan 31 09:51:26 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd-logind[3512]: System is rebooting.




after that rgw failed to comeup for sometime


Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: Starting Ceph mon.b52-41-2-46-15 for 10460b03-1b0a-4206-a989-1a01cee8b865...
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: Stopped Ceph rgw.b52-41-2-46-15.b52-41-2-46-15.usxijb for 10460b03-1b0a-4206-a989-1a01cee8b865.
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal podman[21631]: unhealthy
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: Starting Ceph rgw.b52-41-2-46-15.b52-41-2-46-15.usxijb for 10460b03-1b0a-4206-a989-1a01cee8b865...
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: e9d30e803218ff225a696eb4baa663d53693c44e737c6d2ba51356338e905782.service: Main process exited, code=exited, status=1/FAILURE
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: e9d30e803218ff225a696eb4baa663d53693c44e737c6d2ba51356338e905782.service: Failed with result 'exit-code'.
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal bash[22848]: Error: statfs /var/log/ceph/10460b03-1b0a-4206-a989-1a01cee8b865: no such file or directory
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal podman[22848]: 2025-01-31 09:55:13.33687738 +0000 UTC m=+0.039584977 image pull  director.ctlplane.mgmt.it-b52.cloud.internal:8787/h3a_cloudplatforms-dev-composite_rhosp-rhospv17_images-rhceph-5-rhel8@sha256:67b22119a0efc149b1ecc10324244b469de5433a4e4ce396b93b55f904d9517e
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: ceph-10460b03-1b0a-4206-a989-1a01cee8b865@rgw.b52-41-2-46-15.b52-41-2-46-15.usxijb.service: Control process exited, code=exited, status=125/n/a
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: ceph-10460b03-1b0a-4206-a989-1a01cee8b865@rgw.b52-41-2-46-15.b52-41-2-46-15.usxijb.service: Failed with result 'exit-code'.
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: Failed to start Ceph rgw.b52-41-2-46-15.b52-41-2-46-15.usxijb for 10460b03-1b0a-4206-a989-1a01cee8b865.
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal bash[22849]: Error: statfs /var/log/ceph/10460b03-1b0a-4206-a989-1a01cee8b865: no such file or directory
Jan 31 09:55:13 b52-41-2-46-15.mgmt.it-b52.cloud.internal podman[22849]: 2025-01-31 09:55:13.350000262 +0000 UTC m=+0.052140886 image pull  director.ctlplane.mgmt.it-b52.cloud.internal:8787/h3a_cloudplatforms-dev-composite_rhosp-rhospv17_images-rhceph-5-rhel8:5-519




Jan 31 09:56:04 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: ceph-10460b03-1b0a-4206-a989-1a01cee8b865@rgw.b52-41-2-46-15.b52-41-2-46-15.usxijb.service: Failed with result 'exit-code'.
Jan 31 09:56:04 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: Failed to start Ceph rgw.b52-41-2-46-15.b52-41-2-46-15.usxijb for 10460b03-1b0a-4206-a989-1a01cee8b865.
Jan 31 09:56:04 b52-41-2-46-15.mgmt.it-b52.cloud.internal rsyslogd[2066]: imjournal: journal files changed, reloading...  [v8.2102.0-113.el9_2.2 try https://www.rsyslog.com/e/0 ]
Jan 31 09:56:04 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: Started User Manager for UID 1002.
Jan 31 09:56:04 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: Started Session 4 of User ceph-admin.
Jan 31 09:56:04 b52-41-2-46-15.mgmt.it-b52.cloud.internal sshd[37728]: pam_unix(sshd:session): session opened for user ceph-admin(uid=1002) by (uid=0)
Jan 31 09:56:05 b52-41-2-46-15.mgmt.it-b52.cloud.internal bash[38013]: ./Error: statfs /var/log/ceph/10460b03-1b0a-4206-a989-1a01cee8b865: no such file or directory
Jan 31 09:56:05 b52-41-2-46-15.mgmt.it-b52.cloud.internal podman[38013]: 2025-01-31 09:56:05.104353775 +0000 UTC m=+0.040409591 image pull  director.ctlplane.mgmt.it-b52.cloud.internal:8787/h3a_cloudplatforms-dev-composite_rhosp-rhospv17_
images-rhceph-5-rhel8@sha256:67b22119a0efc149b1ecc10324244b469de5433a4e4ce396b93b55f904d9517e






rgw service started here:


Jan 31 09:56:15 b52-41-2-46-15.mgmt.it-b52.cloud.internal systemd[1]: Started Ceph rgw.b52-41-2-46-15.b52-41-2-46-15.usxijb for 10460b03-1b0a-4206-a989-1a01cee8b865.
Jan 31 09:56:15 b52-41-2-46-15.mgmt.it-b52.cloud.internal ceph-10460b03-1b0a-4206-a989-1a01cee8b865-rgw-b52-41-2-46-15-b52-41-2-46-15-usxijb[40843]: debug 2025-01-31T09:56:15.363+0000 7f4f6b39c8c0  0 deferred set uid:gid to 167:167 (ceph:ceph)
Jan 31 09:56:15 b52-41-2-46-15.mgmt.it-b52.cloud.internal ceph-10460b03-1b0a-4206-a989-1a01cee8b865-rgw-b52-41-2-46-15-b52-41-2-46-15-usxijb[40843]: debug 2025-01-31T09:56:15.363+0000 7f4f6b39c8c0  0 ceph version 16.2.10-266.el8cp (07823b29a11c047cffc11d81c3c975986573a225) pacific (stable), process radosgw, pid 7
Jan 31 09:56:15 b52-41-2-46-15.mgmt.it-b52.cloud.internal ceph-10460b03-1b0a-4206-a989-1a01cee8b865-rgw-b52-41-2-46-15-b52-41-2-46-15-usxijb[40843]: debug 2025-01-31T09:56:15.363+0000 7f4f6b39c8c0  0 framework: beast
Jan 31 09:56:15 b52-41-2-46-15.mgmt.it-b52.cloud.internal ceph-10460b03-1b0a-4206-a989-1a01cee8b865-rgw-b52-41-2-46-15-b52-41-2-46-15-usxijb[40843]: debug 2025-01-31T09:56:15.363+0000 7f4f6b39c8c0  0 framework conf key: ssl_endpoint, val: 172.23.60.134:8080
Jan 31 09:56:15 b52-41-2-46-15.mgmt.it-b52.cloud.internal ceph-10460b03-1b0a-4206-a989-1a01cee8b865-rgw-b52-41-2-46-15-b52-41-2-46-15-usxijb[40843]: debug 2025-01-31T09:56:15.363+0000 7f4f6b39c8c0  0 framework conf key: ssl_certificate, val: config://rgw/cert/rgw.b52-41-2-46-15
Jan 31 09:56:15 b52-41-2-46-15.mgmt.it-b52.cloud.internal ceph-10460b03-1b0a-4206-a989-1a01cee8b865-rgw-b52-41-2-46-15-b52-41-2-46-15-usxijb[40843]: debug 2025-01-31T09:56:15.363+0000 7f4f6b39c8c0  1 radosgw_Main not setting numa affinity
Jan 31 09:56:15 b52-41-2-46-15.mgmt.it-b52.cloud.internal podman[40950]: 









 
