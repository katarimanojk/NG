
JIRA: https://issues.redhat.com/browse/OSPRH-14376



cifmw_external_dns role implemented by john (https://github.com/openstack-k8s-operators/ci-framework/pull/1865/files) can be used
  - creates dns , dns forwarding using cordnds
  - creates certficates with OpenStack public root 



greenfield doc: 

https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0/html/configuring_persistent_storage/assembly_configuring-red-hat-ceph-storage-as-the-backend-for-rhosp-storage#proc_ceph-configure-rgw-with-tls_ceph-back-end

do we need a simillar doc for adoption (brownfield) too  ?



[zuul@shark20 ci-framework]$ cat playbooks/configure_rgw_with_tls.yaml 
- name: Configure rgw with tls
  tags: cephadm
  hosts: "{{ groups['ComputeHCI'][0] }}"
    #hosts: "{{ hostvars[inventory_hostname].groups.ComputeHCI[0] }}"
    #hosts: "{{ groups['overcloud'][0] | default([]) }}"
  gather_facts: false
  tasks:
    - name: print target_nodes
      debug:
        msg: "{{ target_nodes }}"
          #msg: "{{ hostvars[inventory_hostname].groups.ComputeHCI[0] }}"
    - name: Deploy RGW
      when: cifmw_ceph_daemons_layout.rgw_enabled | default(true) | bool
      ansible.builtin.import_role:
        name: cifmw_cephadm
        tasks_from: rgw
      vars:
        cifmw_cephadm_rgw_vip: "{{ ceph_storage_net_prefix }}.100"
        cifmw_ceph_target: "{{ target_nodes }}"
        _hosts: "{{ target_nodes }}"
        cifmw_cephadm_certificate: "/etc/pki/tls/example.com.crt"
        cifmw_cephadm_key: "/etc/pki/tls/example.com.key"
        cifmw_openshift_kubeconfig: "~/.kube/config"
          #ansible_user_dir: "{{ lookup('env', 'HOME') }}"
        cifmw_cephadm_rgw_network: "{{ ceph_storage_net_prefix }}.0/24"
        cidr: "24"
        cifmw_cephadm_fsid: "c9c94b45-3b77-5a01-b4a4-da38108f0d73"
        cifmw_cephadm_first_mon_ip: "{{ ceph_storage_net_prefix }}.106"
[zuul@shark20 ci-framework]



[zuul@shark20 ci-framework]$ ansible-playbook -v -i ~/tripleo-ansible-inventory.yaml -e @/home/zuul/rdo-jobs/playbooks/data_plane_adoption/ceph_overrides.yaml playbooks/configure_rgw_with_tls.yaml

for upstream multinode job:    https://review.rdoproject.org/r/c/testproject/+/55643/8/.zuul.yaml

copy the tripleo-ansible-inventory.yaml from undercloud to compute node

ansible-playbook -v -i ~/tripleo-ansible-inventory.yaml -e @/home/zuul/src/review.rdoproject.org/rdo-jobs/playbooks/data_plane_adoption/ceph_overrides.yaml playbooks/configure_rgw_with_tls.yaml

addoitionally in the playbook : ansible_user_dir: "{{ lookup('env', 'HOME') }}"



additional changes:

in ~/tripleo-ansible-inventory.yaml

 vars:
    ansible_ssh_private_key_file: "/home/zuul/.ssh/cifmw_reproducer_key"

for upstream mutlinode job:
    vars:
      ansible_ssh_private_key_file: "/home/zuul/.ssh/id_cifw"





rgw spec:




before:
---------

sudo cephadm shell -- ceph orch ls --export rgw


[zuul@osp-compute-an2r7t2a-0 ~]$ cat rgw.spec 
service_type: rgw
service_id: rgw
service_name: rgw.rgw
placement:
  label: rgw
networks:
- 172.18.0.0/24
spec:
  rgw_frontend_port: 8090
  rgw_realm: default
  rgw_zone: default
[zuul@osp-compute-an2r7t2a-0 ~]$





after:
-------

sudo cephadm shell -- ceph orch ls --export rgw

service_type: rgw
service_id: rgw
service_name: rgw.rgw
placement:
  hosts:
  - osp-compute-an2r7t2a-0.example.com
  - osp-compute-an2r7t2a-1.example.com
  - osp-compute-an2r7t2a-2.example.com
networks:
- 172.18.0.0/24
spec:
  rgw_frontend_port: 8082
  rgw_frontend_ssl_certificate: '-----BEGIN CERTIFICATE-----
    MIIDpTCCAg2gAwIBAgIRAPynUTCwLrWSkb1dQ38zsEcwDQYJKoZIhvcNAQELBQAw
    GDEWMBQGA1UEAxMNcm9vdGNhLXB1YmxpYzAeFw0yNTAzMjUxNDUyMTFaFw0zMDAz
    MjQxNDUyMTFaMAAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCgMzak
    4vnkNYplMCqh358osQ1Voxfl6yT4/Ausu6ruMNDGMSKqxrVN6tBUoG6D/Ne0EgrD
    6U/xf53o3egCPfehAPLXfM9V0C+lU8P1bJt9lhKe+wOjSXUQ3xUe8iVVjtYHK5qN
    qWtA948YUkxcA7HQXWlYief/agCJ+Hj4+TKrXvEBHG+6hZRNtWTqJ2yqmgrGq8S7
    Fb6cuiOjXkGlWoOUY3KXJYY6VCke5CSMMMiKIcOXFVPcRnSxt9yLlkjfphCG8fDw
    vYyhBwq1FJr/i7EclIDB5jBCuUtn2W+V9FZwuMOiKQMFqS2fqwU5IgSEaA7fC6AK
    8uxIWGKh6xIc4IlpAgMBAAGjgYEwfzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/
    BAIwADAfBgNVHSMEGDAWgBSjG/ptuyR7GEvHOIAiMwwA9BdwQDA+BgNVHREBAf8E
    NDAyghdyZ3ctaW50ZXJuYWwuY2VwaC5sb2NhbIIXcmd3LWV4dGVybmFsLmNlcGgu
    bG9jYWwwDQYJKoZIhvcNAQELBQADggGBADX1AdMsloSLajHTbkU3vQlgJvEBzGYD
    dGbKBoc10QsxUXYMxRZbLvyNI3+mW3QS2HOeIXKwxgJanEPp9NQzuLmE/dlAOcyT
    TZHT8bdKv+WgH1o75XgBhkXJ3aq68iIcS5fG01uDYc7fvGl0xUhTnWSt5X/oGj8i
    y8fctRwPZS+eSgXvPnIkmctP4nva9L+JxRs5RrGrFG9mK5WX0PxBTHnVko3JXzIk
    jeDuXO0d+JsBBNFbu5SPkYTb2t9Zh3C7mWgeo+Y9wcti7eurKrp73m1OnNzJxcvF
    JIA3g6u/Zt84lpslfpbz1Ho2aRZe0nKXgQT6+AD8oxHYJbtdTy4yk2ln8mjE3qvn
    JcPg1QwnHwzr42WqvcKUMv2XVVno69dkOQaOMxPunBZYGyVOgDTd24HbTva6Ap1m
    d76l44csqIcDjTwGNpzBWOSb4MPFrN+8kpwigKTVVwoF2bBFcs0b03eRnYDSe0Ir
    sTUW9ssDrYV5Kes6pt0vZDgDkGn+yeyHwg==
    -----END CERTIFICATE-----
    -----BEGIN RSA PRIVATE KEY-----
    MIIEowIBAAKCAQEAoDM2pOL55DWKZTAqod+fKLENVaMX5esk+PwLrLuq7jDQxjEi
    qsa1TerQVKBug/zXtBIKw+lP8X+d6N3oAj33oQDy13zPVdAvpVPD9WybfZYSnvsD
    o0l1EN8VHvIlVY7WByuajalrQPePGFJMXAOx0F1pWInn/2oAifh4+Pkyq17xARxv
    uoWUTbVk6idsqpoKxqvEuxW+nLojo15BpVqDlGNylyWGOlQpHuQkjDDIiiHDlxVT
    3EZ0sbfci5ZI36YQhvHw8L2MoQcKtRSa/4uxHJSAweYwQrlLZ9lvlfRWcLjDoikD
    Baktn6sFOSIEhGgO3wugCvLsSFhioesSHOCJaQIDAQABAoIBAQCDd+P1Rwwam1G7
    Ht8tvs3n3/z4dYLMPcA20Oln1Q8+sDL1Iye3DKGHkxdrC8oGaT4/2bqZ8mOX5coa
    a9nV1TLeH2ArNZMVcmdXfznGtF2an8kiTQ88NrFqqhi0L7Yx06mTctZAQXPyefcl
    14wwyxtmyvIEJhCNTFmq4I2ujRtnBJN74J/sR7v7GGjw0ETR8UToo04GfKEAKRdK
    V0FuYiqKs0Q5bMwm4TM/lZA8SmtjK2nUVVciqDB+sZlQk4iWAMPhG/PVf4+S2gly
    LQra7LweVw0ylIpYgvcVxSF4/abRffW6fZRqsGRhJu33aw87SzTstdJ8faGWWEa1
    V8DQ0/kxAoGBAMGUrUHUdGHRUp/PSx8HRqibI1U+1gPKk3z9bFGXf19cYLQK2KD0
    u0GFnuzX1cM6HWK8hZH2L7gJFBLdy/yFABoZxbjwUH8IKHWUwmxBa8cAvgh14liA
    LGrrKd0BZOgamAMRX1GUVCRvEoDLPB8iKl5Wvuqaj66OE8iHvg/MsbFlAoGBANPb
    F1itFDMO0Qlw+GhDgR8rq4M3S1xOIX5vTwcM/xQu9VdFF7cxcARNPyUVqI5HnLQi
    NM7yEpcjI6qYmZqh4MfmOzP94KkTh0LmBRPMFloJZHknzGU8voFVcv9RpTyjUd0N
    HnFqm327jJQ4i2cwPcFTXJFURAtpQXNffdhaKlm1AoGAfktGog0/BNZxJmwyoYK4
    uaXFboc5T23pvYEFG1JQumFlgfEVliU0yjGoFvNVtjIDG/jM2Aaa6WGa5BgqToxj
    HaQ02EyI5+flpZixI7mm3EWCtbhbPMwaroLQZCzVrYw0IsRBwNKZ9s80biyqA9Hh
    fHzxv9Oo7AQrqgfNmzc7svUCgYBzhiAX+eFu6iBw7op2iIDrl2uiVM+iWPSItne4
    l4ys2+JrIUEKY0n6/oh1V3cfhstbqt9zDau3gLDdQPNZz/X7637THhiY+g4jG70f
    C4YQuNhx/JLHjbUwX4Ei2smo5EIqsRGttP1vNYs19BOIRFUYi7WJhhLIyi+nkyXT
    iW9YlQKBgDUHQ7t1JlXNFUT1p1+HjQg1ZooNGzG7gUmYsk0GOB5Rz5mHn4AkIdJL
    jmATij2nL8kRBhjjEM24Qoe5tOY4eey7H3E7ylEGlOa/cWvXP2nr2twiHcYDSDa7
    yAyxqI3QR9Ul5OkN/ENGwlt9zKyR/zrMya7CS5er2lF1ZWdPxTuc
    -----END RSA PRIVATE KEY-----
    '
  rgw_realm: default
  rgw_zone: default
  ssl: true



# after configuring swift endpoint



    - name: Configure ceph object store to use external ceph object gateway
      ansible.builtin.import_role:
        name: cifmw_cephadm
        tasks_from: configure_object.yml
      vars:
        cifmw_cephadm_rgw_vip: "{{ ceph_storage_net_prefix }}.100"
        cifmw_openshift_kubeconfig: "~/.kube/config"
        cifmw_cephadm_certificate: "/etc/pki/tls/example.com.crt"
        cifmw_cephadm_key: "/etc/pki/tls/example.com.key"


changes to roles/cifmw_cephadm/tasks/configure_object.yml


- comment kubeconfig env lines


- comment few commands
 #- name: Create swift service, user and roles

based on what is already available using the commands below


[zuul@shark20 ci-framework]$ oc rsh openstackclient openstack service list | grep swift
[zuul@shark20 ci-framework]$ oc rsh openstackclient openstack role list | grep swift
| bd20a39aa9f5434489367cca4549eba9 | swiftoperator             |
\
[zuul@shark20 ci-framework]$ oc rsh openstackclient openstack role list | grep -i resel
| 8db43439f80548ce80fdbfe33e2841c6 | ResellerAdmin             |
\
[zuul@shark20 ci-framework]$ oc rsh openstackclient openstack user list | grep swift
| 009d266762794689a8c93c3e690e43d2 | swift                   |
[zuul@shark20 ci-framework]$ 






5. Ensure that rgw and ingress service is up and reachable after configuring tls

# ssh osp-compute-0
# sudo cephadm shell -- ceph orch ls
# sudo cephadm shell -- ceph orch ps

# curl to all rgw services
# curl -k https://172.18.0.106:8082
# curl -k https://172.18.0.107:8082
# curl -k https://172.18.0.108:8082

if rgw is not up, 
# sudo cephadm shell -- ceph orch ls --export rgw > rgw
# update the cert part of the spec
# sudo cephadm shell -m rgw
## ceph orch rm rgw.rgw
## ceph orch apply -i /mnt/rgw
## ceph orch redeploy rgw.rgw


# curl to ingress service
# curl -k  https://172.18.0.100:8080




[zuul@shark19 ~]$ oc get cert ceph-local-cert -o yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  creationTimestamp: "2025-04-03T11:30:16Z"
  generation: 1
  name: ceph-local-cert
  namespace: openstack
  resourceVersion: "167606"
  uid: 66447340-6e25-411b-b636-c1e640140197
spec:
  dnsNames:
  - rgw-internal.ceph.local
  - rgw-external.ceph.local
  duration: 43800h0m0s
  issuerRef:
    group: cert-manager.io
    kind: Issuer
    name: rootca-public
  secretName: ceph-local-cert
status:
  conditions:
  - lastTransitionTime: "2025-04-03T11:30:16Z"
    message: Certificate is up to date and has not expired
    observedGeneration: 1
    reason: Ready
    status: "True"
    type: Ready
  notAfter: "2030-04-02T11:30:16Z"
  notBefore: "2025-04-03T11:30:16Z"
  renewalTime: "2028-08-02T03:30:16Z"
  revision: 1




[zuul@shark19 tests]$  oc get dnsdata/ceph-local-dns -o yaml 
apiVersion: network.openstack.org/v1beta1
kind: DNSData
metadata:
  creationTimestamp: "2025-04-03T11:30:09Z"
  finalizers:
  - openstack.org/dnsdata
  generation: 1
  labels:
    component: ceph-storage
    service: ceph
  name: ceph-local-dns
  namespace: openstack
  resourceVersion: "167426"
  uid: 8093c49b-4b3c-4801-8c46-ecd0221f50d8
spec:
  dnsDataLabelSelectorValue: dnsdata
  hosts:
  - hostnames:
    - rgw-internal.ceph.local
    ip: 172.18.0.100
  - hostnames:
    - rgw-external.ceph.local
    ip: 172.18.0.100








## failing here as rgw is not in good shape with certs


[zuul@shark20 ci-framework]$ oc rsh openstackclient openstack endpoint list | grep swift
| a7aa6011bac9459c82d030446273b87f | regionOne | swift        | object-store   | True    | internal  | https://172.18.0.100:8080/swift/v1/AUTH_%(tenant_id)s                    |
| c33bcf0c8e834534bde439a1e0cb0f23 | regionOne | swift        | object-store   | True    | public    | https://172.18.0.100:8080/swift/v1/AUTH_%(tenant_id)s                    |
[zuul@shark20 ci-framework]$ oc rsh openstackclient openstack container list
SSL exception connecting to https://172.18.0.100:8080/swift/v1/AUTH_78023bc97f0e4a1ba48c1e05d0134b1d: HTTPSConnectionPool(host='172.18.0.100', port=8080): Max retries exceeded with url: /swift/v1/AUTH_78023bc97f0e4a1ba48c1e05d0134b1d?format=json (Caused by SSLError(SSLError(1, '[SSL] record layer failure (_ssl.c:1147)')))
command terminated with exit code 



### problem 1: rgw is down , failing to use the cert given in spec

Np-compute-pzojvra0-0 ~]$ curl -k https://172.18.0.106:8082                                                                                                                                                                            
curl: (7) Failed to connect to 172.18.0.106 port 8082: Connection refused

something wrong with rgw deamon and ingress response below is expected

[zuul@osp-compute-pzojvra0-0 ~]$ curl -k https://172.18.0.100:8080                                                      
<html><body><h1>503 Service Unavailable</h1>                                                                                                                                                                                                  
No server is available to handle this request.                                                                         
</body></html>                                                                                                                                                                                                                                
[zuul@osp-compute-pzojvra0-0 ~]te: 'openstack catalog list ' gives detailed view of endpoint list




[root@osp-compute-dgskzzfi-0 4b03232f-ef84-52b5-b133-840da55c83ac]# podman ps | grep rgw
f8c3b3e7ad84  registry.redhat.io/rhceph/rhceph-7-rhel9:latest                           -n client.rgw.rgw...  5 hours ago        Up 5 hours                          ceph-4b03232f-ef84-52b5-b133-840da55c83ac-rgw-rgw-osp-compute-dgskzzfi-0-zyfbez
[root@osp-compute-dgskzzfi-0 4b03232f-ef84-52b5-b133-840da55c83ac]# podman exec -it f8c3b3e7ad84 bash
[root@osp-compute-dgskzzfi-0 /]# ps -efwww
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 10:49 ?        00:00:00 /run/podman-init -- /usr/bin/radosgw -n client.rgw.rgw.osp-compute-dgskzzfi-0.zyfbez -f --setuser ceph --setgroup ceph --default-log-to-file=false --default-log-to-journald=true --default-log-to-stderr=false
root           2       1  0 10:49 ?        00:00:48 /usr/bin/radosgw -n client.rgw.rgw.osp-compute-dgskzzfi-0.zyfbez -f --setuser ceph --setgroup ceph --default-log-to-file=false --default-log-to-journald=true --default-log-to-stderr=false
root         103       0  0 15:38 pts/0    00:00:00 bash
root         111     103  0 15:38 pts/0    00:00:00 ps -efwww
[root@osp-compute-dgskzzfi-0 /]# /usr/bin/radosgw -n client.rgw.rgw.osp-compute-dgskzzfi-0.zyfbez -f --setuser ceph --setgroup ceph --default-log-to-file=false --default-log-to-journald=true --default-log-to-stderr=false
2025-04-01T15:38:27.048+0000 7fe721e16940 -1 ssl_private_key was not found: rgw/cert/default/default.key
2025-04-01T15:38:27.050+0000 7fe721e16940 -1 failed to use ssl_certificate=config://rgw/cert/rgw.rgw as a private key: unsupported (DECODER routines)
2025-04-01T15:38:27.050+0000 7fe721e16940 -1 no ssl_certificate configured for ssl_endpoint
2025-04-01T15:38:27.050+0000 7fe721e16940 -1 ERROR: failed initializing frontend
^C2025-04-01T15:41:43.424+0000 7fe71e5a6640 -1 received  signal: Interrupt, si_code : 128, si_value (int): 0, si_value (ptr): 0, si_errno: 0, si_pid : 0, si_uid : 0, si_addr0, si_status0
2025-04-01T15:41:43.424+0000 7fe721e16940 -1 shutting down
[root@osp-compute-dgskzzfi-0 /]#



so.... rgw is not able to use the cert and key configured via spec

we edited the spec manually and removed the quotes in the spec part and rgw and ingress was happy.

[ceph: root@osp-compute-sj15i5sa-0 /]# ceph orch rm rgw.rgw
Removed service rgw.rgw
[ceph: root@osp-compute-sj15i5sa-0 /]# ceph orch apply -i /mnt/rgw 
Scheduled rgw.rgw update...
[ceph: root@osp-compute-sj15i5sa-0 /]#




so need to edit cifmw code to gnerate the correc spec


## problem2 : we see two ingress dameons

after ceph migration we see ingress.ingress 

but rgw role roles/cifmw_cephadm/templates/ceph_rgw.yml.j2  is using different serviceid and service name, so two different daemons

so i pushed this patch https://github.com/openstack-k8s-operators/ci-framework/pull/2878/files to have vars for ingress servicename and serviceid




on unigamma env, i executed the role  using my playbbok with these additional vars
        cifmw_cephadm_rgw_ingress_service_name: "ingress.ingress"
        cifmw_cephadm_rgw_ingress_service_id: "ingress"

which avoided additional ingress daemon


## probem 3: even after using correct spec after reslving problem1, openstackclient pod cannot use CA issuer as TLS is not enabled in ctlplane


[zuul@shark20 ci-framework]$ oc rsh openstackclient curl -k https://172.18.0.100:8080
<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID><DisplayName></DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>[zuul@shark20 ci-framework]$ 

[zuul@shark20 ci-framework]$ oc rsh openstackclient curl -k https://rgw-external.ceph.local:8080
<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID><DisplayName></DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>[zuul@shark20 ci-framework]$ 
[zuul@shark20 ci-framework]$ oc rsh openstackclient curl -k https://rgw-internal.ceph.local:8080
<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID><DisplayName></DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>[zuul@shark20 ci-framework]$

[zuul@shark20 ci-framework]$ oc rsh openstackclient openstack container list
SSL exception connecting to https://172.18.0.100:8080/swift/v1/AUTH_5a743db1ce8642609a5906de32eb1ed7: HTTPSConnectionPool(host='172.18.0.100', port=8080): Max retries exceeded with url: /swift/v1/AUTH_5a743db1ce8642609a5906de32eb1ed7?format=json (Caused by SSLError(SSLCertVerificationError(1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1147)')))


thoughts on solving tls isue:

rdo job:
by passing 'enable_tls:true'  to rdo job, which used here rdo-jobs/playbooks/data_plane_adoption/deploy_tripleo_run_repo_tests.yaml to update 'enable_tlse:true' vars.yaml

   https://logserver.rdoproject.org/160/rdoproject.org/160218ff82ac45b380e7790d46adab20/controller/data-plane-adoption-tests-repo/data_plane_adoption/vars.yaml

this vars will be used during tls adoption in https://github.com/openstack-k8s-operators/data-plane-adoption/blob/main/tests/playbooks/test_with_ceph.yaml#L23

with enable_tls : 17.1 ceph deployment is failing

doubts:
  - is tls enabled in 17.1 job ?



unigamma:

1. deploy tls in 17.1 during unigamma adoption ? can we pass an option to deploy-osp-adoption.yml playbook ?
   - if it can be done, tls_adoption role can migrate IPA to cert-manger and we have the CA 
    - https://issues.redhat.com/browse/OSPRH-12150 will implemetn 17.1 tls, right now it is not yet supported.

without tls in 17.1 , if we force tls_adoption, we see this error

TASK [tls_adoption : Create Certificate Issuer with cert and key from IPA] *******************************************i
fatal: [localhost]: FAILED! => {"changed": true, "cmd": "set -euxo pipefail\n\n\nIPA_SSH=\"ssh -F ~/director_standalone/vagrant_ssh_config vagrant@standalone podman exec -ti freeipa-server-container\"\n$IPA_SSH pk12util -o /tmp/freeipa.p12 -n 'caSigningCert\\ cert-pki-ca' -d /etc/pki/pki-tomcat/alias -k /etc/pki/pki-tomcat/alias/pwdfile.txt -w /etc/pki/pki-tomcat/alias/pwdfile.txt\n\noc create secret generic rootca-internal\n\noc patch secret rootca-internal -n openstack -p=\"{\\\"data\\\":{\\\"ca.crt\\\": \\\"`$IPA_SSH openssl pkcs12 -in /tmp/freeipa.p12 -passin file:/etc/pki/pki-tomcat/alias/pwdfile.txt -nokeys | openssl x509 | base64 -w 0`\\\"}}\"\n\noc patch secret rootca-internal -n openstack -p=\"{\\\"data\\\":{\\\"tls.crt\\\": \\\"`$IPA_SSH openssl pkcs12 -in /tmp/freeipa.p12 -passin file:/etc/pki/pki-tomcat/alias/pwdfile.txt -nokeys | openssl x509 | base64 -w 0`\\\"}}\"\n\noc patch secret rootca-internal -n openstack -p=\"{\\\"data\\\":{\\\"tls.key\\\": \\\"`$IPA_SSH openssl pkcs12 -in /tmp/freeipa.p12 -passin file:/etc/pki/pki-tomcat/alias/pwdfile.txt -nocerts -noenc | openssl rsa | base64 -w 0`\\\"}}\"\n\noc apply -f - <<EOF\napiVersion: cert-manager.io/v1\nkind: Issuer\nmetadata:\n  name: rootca-internal\n  namespace: openstack\n  labels:\n    osp-rootca-issuer-public: \"\"\n    osp-rootca-issuer-internal: \"\"\n    osp-rootca-issuer-libvirt: \"\"\n    osp-rootca-issuer-ovn: \"\"\nspec:\n  ca:\n    secretName: rootca-internal\nEOF\n", "delta": "0:00:00.012853", "end": "2025-04-15 02:30:07.275368", "msg": "non-zero return code", "rc": 255, "start": "2025-04-15 02:30:07.262515", "stderr": "+ IPA_SSH='ssh -F ~/director_standalone/vagrant_ssh_config vagrant@standalone podman exec -ti freeipa-server-container'\n+ ssh -F '~/director_standalone/vagrant_ssh_config' vagrant@standalone podman exec -ti freeipa-server-container pk12util -o /tmp/freeipa.p12 -n 'caSigningCert\\ cert-pki-ca' -d /etc/pki/pki-tomcat/alias -k /etc/pki/pki-tomcat/alias/pwdfile.txt -w /etc/pki/pki-tomcat/alias/pwdfile.txt\nCan't open user config file ~/director_standalone/vagrant_ssh_config: No such file or directory", "stderr_lines": ["+ IPA_SSH='ssh -F ~/director_standalone/vagrant_ssh_config vagrant@standalone podman exec -ti freeipa-server-container'", "+ ssh -F '~/director_standalone/vagrant_ssh_config' vagrant@standalone podman exec -ti freeipa-server-container pk12util -o /tmp/freeipa.p12 -n 'caSigningCert\\ cert-pki-ca' -d /etc/pki/pki-tomcat/alias -k /etc/pki/pki-tomcat/alias/pwdfile.txt -w /etc/pki/pki-tomcat/alias/pwdfile.txt", "Can't open user config file ~/director_standalone/vagrant_ssh_config: No such file or directory"], "stdout": "", "stdout_lines": []}

 



2. 17/1 w/o tls to 18 and then use https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0/html-single/configuring_security_services/index#proc_enabling-TLS-on-a-RHOSO-environment-after-deployment_security-services

we see this error first
sh-5.1$ openstack endpoint list | grep swift
curl -k | 70455bcedf5d432e8375290dc5b364e8 | regionOne | swift        | object-store   | True    | internal  | https://rgw-internal.ceph.local:8080/swift/v1/AUTH_%(tenant_id)s         |
| f88c4e67f39f46f4a183ff1dffb7a9d2 | regionOne | swift        | object-store   | True    | public    | https://rgw-external.ceph.local:8080/swift/v1/AUTH_%(tenant_id)s         |
sh-5.1$ curl -k https://rgw-internal.ceph.local:8080
<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID><DisplayName></DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>sh-5.1$ ^C
sh-5.1$ curl -k https://rgw-external.ceph.local:8080
<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID><DisplayName></DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>sh-5.1$ ^C
sh-5.1$ openstack container list
SSL exception connecting to https://rgw-external.ceph.local:8080/swift/v1/AUTH_b8fa12e690ca4ec692d0d80e46706b57: HTTPSConnectionPool(host='rgw-external.ceph.local', port=8080): Max retries exceeded with url: /swift/v1/AUTH_b8fa12e690ca4ec692d0d80e46706b57?format=json (Caused by SSLError(SSLCertVerificationError(1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1147)')))
sh-5.1$ 


  - it worked by enabling ingress and podLevel in tls of ctlplane CR, all endpoint become https
  - https://redhat-internal.slack.com/archives/C04J1D40W4W/p1744788857395629
  - After enabling TLS, 'swift list' is getting access denied from keystone and from rgw logs we figured out that it is problem with keystone_url used in the ceph config

sh-5.1$ openstack container list
Unrecognized schema in response body. (HTTP 401) (Request-ID: tx000009af8d924a30f1e33-00682f2176-14b4f-default)

sh-5.1$ openstack container list --debug

  File "/usr/lib/python3.9/site-packages/keystoneauth1/session.py", line 986, in request                                                                                                                                                      
    raise exceptions.from_response(resp, method, url)                                                                                                                                                                                         
keystoneauth1.exceptions.http.Unauthorized: Unrecognized schema in response body. (HTTP 401) (Request-ID: tx00000c5c595a8c6b5d78e-00682f2271-175ae-default)                                                                                   clean_up ListContainer: Unrecognized schema in response body. (HTTP 401) (Request-ID: tx00000c5c595a8c6b5d78e-00682f2271-175ae-default)        

  - updated keystone_url in cephconfig using below command (keystone ip will be fetched correctly as we set it in build_ceph_overrides for migration) , may http is not changed to https

[zuul@osp-controller-0quss9gv-0 ~]$ sudo cephadm shell -- ceph config set global rgw_keystone_url https://172.17.0.80:5000
[zuul@osp-controller-0quss9gv-0 ~]$ sudo cephadm shell -- ceph orch redeploy rgw.rgw
Scheduled to redeploy rgw.rgw.osp-compute-0quss9gv-0.qfewzg on host 'osp-compute-0quss9gv-0.example.com'
Scheduled to redeploy rgw.rgw.osp-compute-0quss9gv-1.ldjkqu on host 'osp-compute-0quss9gv-1.example.com'
Scheduled to redeploy rgw.rgw.osp-compute-0quss9gv-2.ouoari on host 'osp-compute-0quss9gv-2.example.com' 

Note: after updating config, redpoy rgw is mandatory


# tls migration:

if tls-e is enabled in 17.1 we can use below steps to migrate cert issue to 18

- extract the CA signing certificate from the FreeIPA instance
- import them into cert-manager in the RHOSO
https://openstack-k8s-operators.github.io/data-plane-adoption/user/index.html#migrating-tls-everywhere_configuring-network



same thing is done here in automation:

https://github.com/openstack-k8s-operators/data-plane-adoption/blob/main/tests/roles/tls_adoption/tasks/main.yaml








 check if rgw backend is reachable from openstackclient pod

#oc rsh openstackclient curl -k https://172.18.0.100:8080
#oc rsh openstackclient curl -k https://rgw-external.ceph.local:8080
#oc rsh openstackclient curl -k https://rgw-internal.ceph.local:8080

 check if rgw backend can be accessed using swift client

#oc rsh openstackclient openstack container list





sh-5.1$ curl -k https://keystone-internal.openstack.svc:5000 
{"versions": {"values": [{"id": "v3.14", "status": "stable", "updated": "2020-04-07T00:00:00Z", "links": [{"rel": "self", "href": "https://keystone-internal.openstack.svc:5000/v3/"}], "media-types": [{"base": "application/json", "type": "application/vnd.openstack.identity-v3+json"}]}]}}sh-5.1$ 
^C
sh-5.1$ curl -k https://172.17.0.80:5000 
{"versions": {"values": [{"id": "v3.14", "status": "stable", "updated": "2020-04-07T00:00:00Z", "links": [{"rel": "self", "href": "https://172.17.0.80:5000/v3/"}], "media-types": [{"base": "application/json", "type": "application/vnd.opensh-5.1$ 





# podLevel: true in cltplane


[zuul@shark20 ci-framework]$ oc rsh openstackclient openstack endpoint list
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------------------------------------+
| ID                               | Region    | Service Name | Service Type | Enabled | Interface | URL                                                     |
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------------------------------------+
| 0489ef1528574b729c76a2c0843b0a22 | regionOne | barbican     | key-manager  | True    | public    | http://barbican-public-openstack.apps.ocp.openstack.lab |
| a3730e7029984a9fbf23afc5b6f2ae61 | regionOne | keystone     | identity     | True    | internal  | http://keystone-internal.openstack.svc:5000             |
| c001b1af822c44b3b1d6d3f3acbf5859 | regionOne | barbican     | key-manager  | True    | internal  | http://barbican-internal.openstack.svc:9311             |
| c71ec95294994ccdbddd6187f936fb1b | regionOne | keystone     | identity     | True    | public    | http://keystone-public-openstack.apps.ocp.openstack.lab |
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------------------------------------+
[zuul@shark20 ci-framework]$ oc get osctlplane -o yaml > openstack_control_plane.yaml
[zuul@shark20 ci-framework]$ vi openstack_control_plane.yaml 
[zuul@shark20 ci-framework]$ oc apply -f openstack_control_plane.yaml
openstackcontrolplane.core.openstack.org/openstack configured
[zuul@shark20 ci-framework]$ oc get osctlplane
NAME        STATUS   MESSAGE
openstack   False    OpenStackControlPlane RabbitMQ in progress
[zuul@shark20 ci-framework]$ oc rsh openstackclient openstack endpoint list
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------------------------------------+
| ID                               | Region    | Service Name | Service Type | Enabled | Interface | URL                                                     |
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------------------------------------+
| 0489ef1528574b729c76a2c0843b0a22 | regionOne | barbican     | key-manager  | True    | public    | http://barbican-public-openstack.apps.ocp.openstack.lab |
| a3730e7029984a9fbf23afc5b6f2ae61 | regionOne | keystone     | identity     | True    | internal  | https://keystone-internal.openstack.svc:5000            |
| c001b1af822c44b3b1d6d3f3acbf5859 | regionOne | barbican     | key-manager  | True    | internal  | http://barbican-internal.openstack.svc:9311             |
| c71ec95294994ccdbddd6187f936fb1b | regionOne | keystone     | identity     | True    | public    | http://keystone-public-openstack.apps.ocp.openstack.lab |
+----------------------------------+-----------+--------------+--------------+---------+-----------+---------------------------------------------------------+
[zuul@shark20 ci-framework]$ 

[zuul@shark20 ci-framework]$ oc get osctlplane
NAME        STATUS   MESSAGE
openstack   True     Setup complete
[zuul@shark20 ci-framework]$ oc rsh openstackclient openstack endpoint list
Failed to discover available identity versions when contacting http://keystone-public-openstack.apps.ocp.openstack.lab. Attempting to parse version from URL.
Could not find versioned identity endpoints when attempting to authenticate. Please check that your auth_url is correct. Bad Request (HTTP 400)
command terminated with exit code 1
[zuul@shark20 ci-framework]$ 



# pending

Adoption doc only talks about using the ingrss ip directly:https://openstack-k8s-operators.github.io/data-plane-adoption/user/index.html#updating-the-object-storage-endpoints_migrating-ceph-rgw

with tls, swift should use a fqdn which means tls + dns should be available:


add enable tls for rgw steps in manual doc ? (copy it from greenfield doc and edit, see john's slack chat)




# configure_object needed during adoption/migration


This change is not needed as migration is anywyas madatory and we need to update endpoints there

diff --git a/tests/roles/dataplane_adoption/tasks/main.yaml b/tests/roles/dataplane_adoption/tasks/main.yaml
index fe41f68..c62f655 100644
--- a/tests/roles/dataplane_adoption/tasks/main.yaml
+++ b/tests/roles/dataplane_adoption/tasks/main.yaml
@@ -606,3 +606,8 @@
 - name: Adopted Cinder post-checks
   ansible.builtin.include_tasks:
     file: cinder_verify.yaml
+
+- name: Configure swift to use rgw backend
+  when: ceph_daemons_layout.rgw | default(true) | bool
+  ansible.builtin.include_tasks:
+    file: configure_object.yaml
[zuul@shark19 tests]$ 


we call the new configure_object.yaml in dataplane adoption repo to create swift service and endpoints and tls is
not considered here

i.e http endpoint is created

when we call the cifmw to configure tls and object, it updates the endpoints with the fqdn


### after discussing with francesco , we decide to remove uri_scheme configuration during migration as we updated endpoints only in cifmw

diff --git a/tests/roles/ceph_migrate/defaults/main.yml b/tests/roles/ceph_migrate/defaults/main.yml
index 1f15e69..bab795a 100644
--- a/tests/roles/ceph_migrate/defaults/main.yml
+++ b/tests/roles/ceph_migrate/defaults/main.yml
@@ -48,3 +48,6 @@ ceph_node_exporter_container_image: "quay.io/prometheus/node-exporter:v1.5.0"
 ceph_prometheus_container_image: "quay.io/prometheus/prometheus:v2.43.0"
 ceph_storagenfs_nic: "nic2"
 ceph_storagenfs_vlan_id: "70"
+
+cifmw_cephadm_certificate: ""
+cifmw_cephadm_key: ""


tests/roles/ceph_migrate/tasks/configure_object.yaml

+- name: Update urischeme based on cert/key
+  ansible.builtin.set_fact:
+    cifmw_cephadm_urischeme: "https"
+  when:
+    - cifmw_cephadm_certificate | length > 0
+    - cifmw_cephadm_key | length > 0



# final issue of rgw not comming after tls rdeploy



rgw.rgw.osp-compute-7zjsbpha-0.kmibir             osp-compute-7zjsbpha-0.example.com  172.18.0.106:8082  running (2m)     52s ago   2m    56.9M        -  18.2.1-329.el9cp  2158460e011e  adb61178ce20  
rgw.rgw.osp-compute-7zjsbpha-1.sjknjh             osp-compute-7zjsbpha-1.example.com  172.18.0.107:8082  running (2m)     51s ago   2m    56.0M        -  18.2.1-329.el9cp  2158460e011e  0936fbec6a22  
rgw.rgw.osp-compute-7zjsbpha-2.mcvore             osp-compute-7zjsbpha-2.example.com  172.18.0.108:8082  running (2m)      2m ago   2m    55.7M        -  18.2.1-329.el9cp  2158460e011e  0b2ed9ec9d83  
[zuul@osp-compute-7zjsbpha-0 ~]$ curl -k https://172.18.0.106:8082
curl: (7) Failed to connect to 172.18.0.106 port 8082: Connection refused
[zuul@osp-compute-7zjsbpha-0 ~]$ curl -k 172.18.0.106:8082                                                              
curl: (7) Failed to connect to 172.18.0.106 port 8082: Connection refused


[ceph: root@osp-compute-7zjsbpha-0 /]# ceph orch redeploy rgw.rgw
Scheduled to redeploy rgw.rgw.osp-compute-7zjsbpha-0.kmibir on host 'osp-compute-7zjsbpha-0.example.com'
Scheduled to redeploy rgw.rgw.osp-compute-7zjsbpha-1.sjknjh on host 'osp-compute-7zjsbpha-1.example.com'
Scheduled to redeploy rgw.rgw.osp-compute-7zjsbpha-2.mcvore on host 'osp-compute-7zjsbpha-2.example.com'
[ceph: root@osp-compute-7zjsbpha-0 /]# exit
exit
[zuul@osp-compute-7zjsbpha-0 ~]$ curl -k 172.18.0.106:8082
curl: (52) Empty reply from server
[zuul@osp-compute-7zjsbpha-0 ~]$ curl -k https://172.18.0.106:8082
<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID><DisplayName></DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>[zuul@osp-compute-7zjsbpha-0 ~]$ ^C
[zuul@osp-compute-7zjsbpha-0 ~]$ curl -k https://172.18.0.107:8082
<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID><DisplayName></DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>[zuul@osp-compute-7zjsbpha-0 ~]$ 
[zuul@osp-compute-7zjsbpha-0 ~]$ curl -k https://172.18.0.108:8082
<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID><DisplayName></DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>[zuul@osp-compute-7zjsbpha-0 ~]$ 
[zuul@osp-compute-7zjsbpha-0 ~]$ curl -k https://172.18.0.100:8080
<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID><DisplayName></DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>[zuul@osp-compute-7zjsbpha-0 ~]$ 


Note: even after setting keystone url in ceph config, rgw redploy is needed





pending work: tls for dashboard

https://github.com/openstack-k8s-operators/ci-framework/blob/main/roles/cifmw_cephadm/tasks/monitoring.yml#L35

https://github.com/openstack-k8s-operators/ci-framework/blob/main/roles/cifmw_cephadm/tasks/dashboard/dashboard.yml#L48

may be create a taks with these commands^ and restart rgw is enought

or else call this entire task with required vars.
