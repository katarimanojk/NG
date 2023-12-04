rgw apply spec with the below command

openssl req -x509 -newkey rsa:4096 -sha256 -days 3650   -nodes -keyout example.com.key -out example.com.crt -subj "/CN=example.com"   -addext "subjectAltName=DNS:e
xample.com,DNS:*.example.com,IP:10.0.0.1"


has a multiline certficate, which result in the error


ASK [cifmw_cephadm : Apply spec _raw_params={{ cifmw_cephadm_ceph_cli }} orch apply --in-file {{ cifmw_cephadm_container_spec }}] ***********************************************************
fatal: [192.168.122.100]: FAILED! => {"changed": true, "cmd": ["podman", "run", "--rm", "--net=host", "--ipc=host", "--volume", "/etc/ceph:/etc/ceph:z", "--volume", "/home/ceph-admin/assimil
ate_ceph.conf:/home/assimilate_ceph.conf:z", "--volume", "/tmp/ceph_rgw.yml:/home/ceph_spec.yaml:z", "--entrypoint", "ceph", "quay.io/ceph/ceph:v18.2", "--fsid", "b4cab80c-922b-5dc9-9f38-84f
6dacc6029", "-c", "/etc/ceph/ceph.conf", "-k", "/etc/ceph/ceph.client.admin.keyring", "orch", "apply", "--in-file", "/home/ceph_spec.yaml"], "delta": "0:00:00.964983", "end": "2023-12-12 05:
33:19.649339", "msg": "non-zero return code", "rc": 22, "start": "2023-12-12 05:33:18.684356", "stderr": "Error EINVAL: Traceback (most recent call last):\n  File \"/usr/share/ceph/mgr/mgr_m
odule.py\", line 1774, in _handle_command\n    return self.handle_command(inbuf, cmd)\n  File \"/usr/share/ceph/mgr/orchestrator/_interface.py\", line 171, in handle_command\n    return disp
atch[cmd['prefix']].call(self, cmd, inbuf)\n  File \"/usr/share/ceph/mgr/mgr_module.py\", line 474, in call\n    return self.func(mgr, **kwargs)\n  File \"/usr/share/ceph/mgr/orchestrator/_i
nterface.py\", line 107, in <lambda>\n    wrapper_copy = lambda *l_args, **l_kwargs: wrapper(*l_args, **l_kwargs)  # noqa: E731\n 



when run manually 

yaml.scanner.ScannerError: while scanning a simple key                              
  in "<unicode string>", line 18, column 1:                                       
    MIIFOzCCAyOgAwIBAgIUWAZ7VocJxDgC ...                     
    ^                                                                                      
could not find expected ':'                                                   
  in "<unicode string>", line 19, column 1:                                              
    BQAwFjEUMBIGA1UEAwwLZXhhbXBsZS5j ...                                    
    ^      

something wrong witht the format,

after converting it into single line: 

cat example.com.crt | awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}'  > example.com.crt_singleline

it worked!!!



#in the container
vi rgw # put the spec in it
ceph orch apply -i rgw

#in the edpm node ensure to have correct spec generated in /tmp/ceph_rgw.yml
sudo podman run --rm --net=host --ipc=host --volume /etc/ceph:/etc/ceph:z --volume /home/ceph-admin/assimilate_ceph.conf:/home/assimilate_ceph.conf:z --volume /tmp/ceph_rgw.yml:/home/ceph_spec.yaml:z --entrypoint ceph quay.io/ceph/ceph:v18.2 --fsid b4cab80c-922b-5dc9-9f38-84f6dacc6029 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring orch apply --in-file /home/ceph_spec.yaml

#run the ceph playbook and see if it generates spec in /tmp/ceph_rgw.yml using /etc/pki/tls/example.com.crt set in default/main.yaml





# ade lee patch to generate certificate

https://github.com/openstack-k8s-operators/dataplane-operator/pull/553/files
https://github.com/openstack-k8s-operators/edpm-ansible/pull/525  and https://github.com/openstack-k8s-operators/dataplane-operator/pull/585

above PRs add feature in data plane operator to generate certs and edpm role to install certificate for specific service 
adds the service 'install-certs' in dataplane 

iiuc , we can update nova service with 2 params belwo

 tlsCertsEnabled: True
  issuers:
    default: osp-rootca-issuer-internal

services/dataplane_v1beta1_openstackdataplaneservice_nova_custom_ceph.yaml

simillar to https://github.com/openstack-k8s-operators/dataplane-operator/blob/ab98fc72a06d01a8523b1d2d5164bc93f7e14588/config/services/dataplane_v1beta1_openstackdataplaneservice_nova.yaml#L14

which should generate certificate on compute nodes at 

cert : /var/lib/openstack/certs/<service>/tls.crt  
key: /var/lib/openstack/certs/<service>.tls.key

and then use the path in ceph overrides




## testing 



podman run --rm --net=host --ipc=host --volume /etc/ceph:/etc/ceph:z --volume /home/ceph-admin/assimilate_ceph.conf:/home/assimilate_ceph.conf:z --volume /tmp/ceph_rgw.yml:/home/ceph_spec.yaml:z --entrypoint ceph quay.io/ceph/ceph:v18.2 --fsid b4cab80c-922b-5dc9-9f38-84f6dacc6029 -c /etc/ceph/ceph.conf -k /etc/ceph/ceph.client.admin.keyring orch apply --in-file /home/ceph_spec.yaml





  rgw_frontend_port: 8082
  rgw_realm: default
  rgw_zone: default
  ssl: true
  rgw_frontend_ssl_certificate: |
    -----BEGIN CERTIFICATE-----MIIFOzCCAyOgAwIBAgIUWAZ7VocJxDgCTupqWx6AFnljeA8wDQYJKoZIhvcNAQELBQAwFjEUMBIGA1UEAwwLZXhhbXBsZS5jb20wHhcNMjMxMjA2MTA0NDI5WhcNMzMxMjAzMTA0NDI5WjAWMRQwEgYDVQQDDAtleGFtcGxlLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALOYXSKquKnaJoI2g6/Q0stXqxP6g7ADcuY15wM5HRoK9KIaxVIL7mO3zl1AtzJGhNy4+vYpugyOZ4gFOHV93WLhMdhC1rG2BLHv4+ZsriZoTmbNqnM1d5yooVGIe8B9/bzC1i8B2fkIGJWsS79DKuuWIZd5+S9dTUakZLtNCkXacEkTlxYhI7jmLNqR0saWSD5Xo2CckNfBI/VIf3bYTC4IUALOKZxylFohQQz+F6QelnWwncbo7ntzXMMyThHIFCEFQ8INn9hRr6y7hCLRgJkfSwO9V5os5+p5fw1TRMw6LbPF2HpZ4DviViE15Q6J+pzeq8/YdW4+S7cYaUocg5r5NkxcLvfx3/IlHtR6b4CARsmi+brk487b3joaJdfWvE4zawcE0hLeLQvSsUhEn8iXYtzLwRM0xiDQaXGCHecKT2yEiUE+1a98lTWbXPUPcjL6lJMB8MCyAG1clpLlDCVweyZLDtJ9JVXGoVqYcari1OBbgaFTv99/l0uxtJbw4Sdu4F/0AHQd4X4LFanPD9xtFFvrarN2/ZoWczyHVdamSrsC8v1DiL8ZvtfiF/A+u9M0VXSAxsNPeExr8EB7OBTfRL+MgsIqJ/p+jio4xcSn57bPveqrhtszQCNTzZ46f34AW4pw4pBx0sgQ+6mptyrhyYdeu7lin4T39UBJPAfLAgMBAAGjgYAwfjAdBgNVHQ4EFgQU3rO4T3NG14JQPWGbi3tcx6CoCNwwHwYDVR0jBBgwFoAU3rO4T3NG14JQPWGbi3tcx6CoCNwwDwYDVR0TAQH/BAUwAwEB/zArBgNVHREEJDAiggtleGFtcGxlLmNvbYINKi5leGFtcGxlLmNvbYcECgAAATANBgkqhkiG9w0BAQsFAAOCAgEApMauaRE20b9mRLnz4fr21OBfuEAuqRMPKya1abiG1lzIzYa0nH5G+9FSWjwfEtuB3UyKiu1QNiAd5ET0goQWQHYiYoUFPtSsyhOCXBSjIFJNvVVGrgL2oqLXtH38wL/SQcQ5MJ/SmMGPHY0CnH5NKotyf0Ej1ItXSPnxcpK9dbQiumzcyXXaml9bymklYSSJGKK7XOyHc5lcLo4dfqQCUoq7s9oD+HJfalwtDydUHNsvTi5BN2srOxrw/sdNrYg3ofDRgrTaSfyvy7CRZ+jgbXeCnhxpZ+haQhQW9F03y/63cZliYP/9AnNr/X9Jr/qZ7bJai6dK4mbUcf3BGr4Nv2UEecHzqYxoNCgbdtMC78curb9bAHdvuL9ZQrrMlH9vcEGedtIdcFaQRmJCJRH7fAgQlpvCTYxZln65vBYueKgukk24bt+E8tp6D1tRWxYCz//EWduAZRfobej92SrIXM+HwgHGMPqTohjxkh/hqQbNBltkNzBR6NSkh0a7huF22cYSkSPs96x485aXtm23aU8PD/ajPNQGZn1K/956LJ9J1vsZ5PEck80tGCynxkJ6w7Se66+UqrlprsA/2pCMPIQbx4v7ODPdq8Iz55K13BzWAh308EIBeqEpnNa8mk9rD/ZWq3xqKVfGdzTgVZiTN2AeK4nasL4dw2VqkCdDp8g=-----END CERTIFICATE-----

---
service_type: ingress
service_id: rgw.default
service_name: ingress.rgw.default
placement:
  count: 1
spec:
  backend_service: rgw.rgw
  frontend_port: 8080
  monitor_port: 8999
  virtual_ip: 172.18.0.2/24
  virtual_interface_networks:
  - 172.18.0.0/24
  ssl: true
  rgw_frontend_ssl_certificate: |
    -----BEGIN CERTIFICATE-----MIIFOzCCAyOgAwIBAgIUWAZ7VocJxDgCTupqWx6AFnljeA8wDQYJKoZIhvcNAQELBQAwFjEUMBIGA1UEAwwLZXhhbXBsZS5jb20wHhcNMjMxMjA2MTA0NDI5WhcNMzMxMjAzMTA0NDI5WjAWMRQwEgYDVQQDDAtleGFtcGxlLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALOYXSKquKnaJoI2g6/Q0stXqxP6g7ADcuY15wM5HRoK9KIaxVIL7mO3zl1AtzJGhNy4+vYpugyOZ4gFOHV93WLhMdhC1rG2BLHv4+ZsriZoTmbNqnM1d5yooVGIe8B9/bzC1i8B2fkIGJWsS79DKuuWIZd5+S9dTUakZLtNCkXacEkTlxYhI7jmLNqR0saWSD5Xo2CckNfBI/VIf3bYTC4IUALOKZxylFohQQz+F6QelnWwncbo7ntzXMMyThHIFCEFQ8INn9hRr6y7hCLRgJkfSwO9V5os5+p5fw1TRMw6LbPF2HpZ4DviViE15Q6J+pzeq8/YdW4+S7cYaUocg5r5NkxcLvfx3/IlHtR6b4CARsmi+brk487b3joaJdfWvE4zawcE0hLeLQvSsUhEn8iXYtzLwRM0xiDQaXGCHecKT2yEiUE+1a98lTWbXPUPcjL6lJMB8MCyAG1clpLlDCVweyZLDtJ9JVXGoVqYcari1OBbgaFTv99/l0uxtJbw4Sdu4F/0AHQd4X4LFanPD9xtFFvrarN2/ZoWczyHVdamSrsC8v1DiL8ZvtfiF/A+u9M0VXSAxsNPeExr8EB7OBTfRL+MgsIqJ/p+jio4xcSn57bPveqrhtszQCNTzZ46f34AW4pw4pBx0sgQ+6mptyrhyYdeu7lin4T39UBJPAfLAgMBAAGjgYAwfjAdBgNVHQ4EFgQU3rO4T3NG14JQPWGbi3tcx6CoCNwwHwYDVR0jBBgwFoAU3rO4T3NG14JQPWGbi3tcx6CoCNwwDwYDVR0TAQH/BAUwAwEB/zArBgNVHREEJDAiggtleGFtcGxlLmNvbYINKi5leGFtcGxlLmNvbYcECgAAATANBgkqhkiG9w0BAQsFAAOCAgEApMauaRE20b9mRLnz4fr21OBfuEAuqRMPKya1abiG1lzIzYa0nH5G+9FSWjwfEtuB3UyKiu1QNiAd5ET0goQWQHYiYoUFPtSsyhOCXBSjIFJNvVVGrgL2oqLXtH38wL/SQcQ5MJ/SmMGPHY0CnH5NKotyf0Ej1ItXSPnxcpK9dbQiumzcyXXaml9bymklYSSJGKK7XOyHc5lcLo4dfqQCUoq7s9oD+HJfalwtDydUHNsvTi5BN2srOxrw/sdNrYg3ofDRgrTaSfyvy7CRZ+jgbXeCnhxpZ+haQhQW9F03y/63cZliYP/9AnNr/X9Jr/qZ7bJai6dK4mbUcf3BGr4Nv2UEecHzqYxoNCgbdtMC78curb9bAHdvuL9ZQrrMlH9vcEGedtIdcFaQRmJCJRH7fAgQlpvCTYxZln65vBYueKgukk24bt+E8tp6D1tRWxYCz//EWduAZRfobej92SrIXM+HwgHGMPqTohjxkh/hqQbNBltkNzBR6NSkh0a7huF22cYSkSPs96x485aXtm23aU8PD/ajPNQGZn1K/956LJ9J1vsZ5PEck80tGCynxkJ6w7Se66+UqrlprsA/2pCMPIQbx4v7ODPdq8Iz55K13BzWAh308EIBeqEpnNa8mk9rD/ZWq3xqKVfGdzTgVZiTN2AeK4nasL4dw2VqkCdDp8g=-----END CERTIFICATE-----


