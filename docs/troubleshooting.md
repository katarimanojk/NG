# Error: initializing source docker://registry-proxy.engineering.redhat.com/rh-osbs/rhceph:7: pinging container registry registry-proxy.engineering.redhat.com: Get \"https://registry-proxy.engineering.redhat.com/v2/\": tls: failed to verify certificate: x509: certificate signed by unknown authority" 


sol:

[root@shark13 ~]# openssl s_client -showcerts -connect registry-proxy.engineering.redhat.com:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ca.crt
depth=3 C = US, ST = North Carolina, L = Raleigh, O = "Red Hat, Inc.", OU = Red Hat IT, CN = Red Hat IT Root CA, emailAddress = infosec@redhat.com
verify return:1
depth=2 C = US, ST = North Carolina, L = Raleigh, O = "Red Hat, Inc.", OU = Red Hat IT, CN = Internal Root CA, emailAddress = infosec@redhat.com
verify return:1
depth=1 O = Red Hat, OU = prod, CN = 2023 Certificate Authority RHCSv2
verify return:1
depth=0 C = US, ST = North Carolina, L = Raleigh, O = Red Hat, OU = Container-Build-Guild, emailAddress = container-buildsys-alerts@redhat.com, CN = registry-proxy.engineering.redhat.com
verify return:1
DONE

https://www.redhat.com/sysadmin/configure-ca-trust-list





