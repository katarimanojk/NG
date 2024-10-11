


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





[zuul@shark19 ~]$ oc get -n openshift-dns dns.operator/default -o yaml | grep ceph-local-dns -B 5
  servers:
  - forwardPlugin:
      policy: Random
      upstreams:
      - 172.30.180.101:53
    name: ceph-local-dns
[zuul@shark19 ~]$ 

