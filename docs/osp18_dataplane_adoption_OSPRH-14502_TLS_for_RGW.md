
cifmw_external_dns role implemented by john (https://github.com/openstack-k8s-operators/ci-framework/pull/1865/files) can be used
  - creates dns , dns forwarding using cordnds
  - creates certficates with OpenStack public root 





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


additional changes:

in ~/tripleo-ansible-inventory.yaml

 vars:
    ansible_ssh_private_key_file: "/home/zuul/.ssh/cifmw_reproducer_key"


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

