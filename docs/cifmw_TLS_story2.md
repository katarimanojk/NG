
This task can be verified with

#cifmw_cephadm_certificate: ""
#cifmw_cephadm_key: ""
cifmw_cephadm_certificate: "/etc/pki/tls/example.com.crt"
cifmw_cephadm_key: "/etc/pki/tls/example.com.key"


The certificate should be created in edpm node in

/etc/pki/tls

for eg: /etc/pki/tls/example.com.crt

when i use the same certificate https://docs.ceph.com/en/latest/cephadm/services/rgw/#setting-up-https

and result in this error

yaml.scanner.ScannerError: while scanning a simple key
  in "<unicode string>", line 19, column 1:
    V2VyIGRhcyBsaWVzdCBpc3QgZG9vZi4g ... 
    ^
could not find expected ':'
  in "<unicode string>", line 20, column 1:
    ZXQsIGNvbnNldGV0dXIgc2FkaXBzY2lu ... 
    ^

solution to this is 

    - name: convert to single line cert
      register: rgw_frontend_cert
      shell: echo "{{ slurp_cert.get('content', '') | b64decode }}" | awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}'
    - name : Set rgw_frontend_cert for rgw spec
      set_fact:
        rgw_frontend_cert: "{{ rgw_frontend_cert.stdout }}"


found a solution to indent the content in jinja using  :  {{ rgw_frontend_cert | indent( width=4 ) }}


#Note : CI cannot verify this unless we set 'cifmw_cephadm_certificate' and cerfificate is added to edpm node 
