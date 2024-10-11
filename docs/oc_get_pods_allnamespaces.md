mkatari@dell-7625-02 ~]$ kubectl get pods --all-namespaces
NAMESPACE                                          NAME                                                              READY   STATUS      RESTARTS      AGE
kcli-infra                                         coredns-rhoso-ctlplane-0.openshift.local                          1/1     Running     0             40m
kcli-infra                                         coredns-rhoso-ctlplane-1.openshift.local                          1/1     Running     0             40m
kcli-infra                                         coredns-rhoso-ctlplane-2.openshift.local                          1/1     Running     0             40m
kcli-infra                                         haproxy-rhoso-ctlplane-0.openshift.local                          1/1     Running     1 (38m ago)   40m
kcli-infra                                         haproxy-rhoso-ctlplane-1.openshift.local                          1/1     Running     1 (38m ago)   40m
kcli-infra                                         haproxy-rhoso-ctlplane-2.openshift.local                          1/1     Running     1 (38m ago)   40m
kcli-infra                                         keepalived-rhoso-ctlplane-0.openshift.local                       1/1     Running     0             40m
kcli-infra                                         keepalived-rhoso-ctlplane-1.openshift.local                       1/1     Running     0             40m
kcli-infra                                         keepalived-rhoso-ctlplane-2.openshift.local                       1/1     Running     0             41m
kcli-infra                                         mdns-rhoso-ctlplane-0.openshift.local                             1/1     Running     0             40m
kcli-infra                                         mdns-rhoso-ctlplane-1.openshift.local                             1/1     Running     0             40m
kcli-infra                                         mdns-rhoso-ctlplane-2.openshift.local                             1/1     Running     0             40m
openshift-apiserver-operator                       openshift-apiserver-operator-7dcf69b996-jpq8f                     1/1     Running     2 (31m ago)   41m
openshift-apiserver                                apiserver-56cf69ddc7-6rm8z                                        2/2     Running     0             26m
openshift-apiserver                                apiserver-56cf69ddc7-bvc6s                                        2/2     Running     0             25m
openshift-apiserver                                apiserver-56cf69ddc7-nr285                                        2/2     Running     0             23m
openshift-authentication-operator                  authentication-operator-8659c5b58f-bgjf7                          1/1     Running     2 (31m ago)   41m
openshift-authentication                           oauth-openshift-566db58574-c82st                                  1/1     Running     0             25m
openshift-authentication                           oauth-openshift-566db58574-s4fc5                                  1/1     Running     0             24m
openshift-authentication                           oauth-openshift-566db58574-wfxpj                                  1/1     Running     0             25m
openshift-cloud-controller-manager-operator        cluster-cloud-controller-manager-operator-6b9b9494c9-hcxrv        3/3     Running     8 (30m ago)   40m
openshift-cloud-credential-operator                cloud-credential-operator-77cd56fcbf-mc2rj                        2/2     Running     0             41m
openshift-cluster-machine-approver                 machine-approver-65bc87cd67-jnh4t                                 2/2     Running     1 (30m ago)   41m
openshift-cluster-node-tuning-operator             cluster-node-tuning-operator-6c48984c6-85zth                      1/1     Running     3 (30m ago)   41m
openshift-cluster-node-tuning-operator             tuned-kj9vd                                                       1/1     Running     0             39m
openshift-cluster-node-tuning-operator             tuned-wmfks                                                       1/1     Running     0             39m
openshift-cluster-node-tuning-operator             tuned-zj22k                                                       1/1     Running     0             39m
openshift-cluster-samples-operator                 cluster-samples-operator-66879647c9-btk62                         2/2     Running     0             37m
openshift-cluster-storage-operator                 cluster-storage-operator-5dcbd9ffd5-sl9rb                         1/1     Running     1 (31m ago)   41m
openshift-cluster-storage-operator                 csi-snapshot-controller-555459b95b-99pmd                          1/1     Running     2 (30m ago)   39m
openshift-cluster-storage-operator                 csi-snapshot-controller-555459b95b-cgpcl                          1/1     Running     0             39m
openshift-cluster-storage-operator                 csi-snapshot-controller-operator-66fbff45db-w5nt7                 1/1     Running     1 (30m ago)   41m
openshift-cluster-storage-operator                 csi-snapshot-webhook-69d44f745c-j9n2w                             1/1     Running     0             39m
openshift-cluster-storage-operator                 csi-snapshot-webhook-69d44f745c-zgzmn                             1/1     Running     0             39m
openshift-cluster-version                          cluster-version-operator-f67746dbd-q9gmw                          1/1     Running     1 (30m ago)   41m
openshift-config-operator                          openshift-config-operator-5cb9f97468-krw55                        1/1     Running     2 (30m ago)   41m
openshift-console-operator                         console-conversion-webhook-8675c49777-59sf4                       1/1     Running     0             26m
openshift-console-operator                         console-operator-5ddc6969bc-swq4n                                 1/1     Running     0             26m
openshift-console                                  console-6594f969c5-f4lf2                                          1/1     Running     0             21m
openshift-console                                  console-6594f969c5-vzzpk                                          1/1     Running     0             21m
openshift-console                                  downloads-6cb8d85d47-gh2nk                                        1/1     Running     0             26m
openshift-console                                  downloads-6cb8d85d47-pnggw                                        1/1     Running     0             26m
openshift-controller-manager-operator              openshift-controller-manager-operator-5c98f785dc-8tcxz            1/1     Running     2 (30m ago)   41m
openshift-controller-manager                       controller-manager-5b8949f79f-6qnh9                               1/1     Running     0             25m
openshift-controller-manager                       controller-manager-5b8949f79f-chdvp                               1/1     Running     0             25m
openshift-controller-manager                       controller-manager-5b8949f79f-wh5vn                               1/1     Running     0             25m
openshift-dns-operator                             dns-operator-7b4c78f9cd-m7pl2                                     2/2     Running     0             41m
openshift-dns                                      dns-default-8xd6z                                                 2/2     Running     0             39m
openshift-dns                                      dns-default-h5pl4                                                 2/2     Running     0             39m
openshift-dns                                      dns-default-vtbls                                                 2/2     Running     0             39m
openshift-dns                                      node-resolver-gdnqd                                               1/1     Running     0             39m
openshift-dns                                      node-resolver-jsfsd                                               1/1     Running     0             39m
openshift-dns                                      node-resolver-mgw9t                                               1/1     Running     0             39m
openshift-etcd-operator                            etcd-operator-5d858f7fb5-c7c6j                                    1/1     Running     2 (30m ago)   41m
openshift-etcd                                     etcd-guard-rhoso-ctlplane-0.openshift.local                       1/1     Running     0             37m
openshift-etcd                                     etcd-guard-rhoso-ctlplane-1.openshift.local                       1/1     Running     0             36m
openshift-etcd                                     etcd-guard-rhoso-ctlplane-2.openshift.local                       1/1     Running     0             34m
openshift-etcd                                     etcd-rhoso-ctlplane-0.openshift.local                             4/4     Running     0             22m
openshift-etcd                                     etcd-rhoso-ctlplane-1.openshift.local                             4/4     Running     0             20m
openshift-etcd                                     etcd-rhoso-ctlplane-2.openshift.local                             4/4     Running     0             18m
openshift-etcd                                     installer-5-rhoso-ctlplane-2.openshift.local                      0/1     Completed   0             35m
openshift-etcd                                     installer-7-rhoso-ctlplane-0.openshift.local                      0/1     Completed   0             34m
openshift-etcd                                     installer-7-rhoso-ctlplane-1.openshift.local                      0/1     Completed   0             27m
openshift-etcd                                     installer-7-rhoso-ctlplane-2.openshift.local                      0/1     Completed   0             25m
openshift-etcd                                     installer-8-rhoso-ctlplane-0.openshift.local                      0/1     Completed   0             23m
openshift-etcd                                     installer-8-rhoso-ctlplane-1.openshift.local                      0/1     Completed   0             21m
openshift-etcd                                     installer-8-rhoso-ctlplane-2.openshift.local                      0/1     Completed   0             19m
openshift-etcd                                     revision-pruner-7-rhoso-ctlplane-0.openshift.local                0/1     Completed   0             24m
openshift-etcd                                     revision-pruner-7-rhoso-ctlplane-1.openshift.local                0/1     Completed   0             24m
openshift-etcd                                     revision-pruner-7-rhoso-ctlplane-2.openshift.local                0/1     Completed   0             24m
openshift-etcd                                     revision-pruner-8-rhoso-ctlplane-0.openshift.local                0/1     Completed   0             23m
openshift-etcd                                     revision-pruner-8-rhoso-ctlplane-1.openshift.local                0/1     Completed   0             23m
openshift-etcd                                     revision-pruner-8-rhoso-ctlplane-2.openshift.local                0/1     Completed   0             23m
openshift-image-registry                           cluster-image-registry-operator-56b5cd75b6-h9hmn                  1/1     Running     1 (31m ago)   41m
openshift-image-registry                           image-registry-c5957bf54-l2hxf                                    1/1     Running     0             26m
openshift-image-registry                           node-ca-2pbhl                                                     1/1     Running     0             38m
openshift-image-registry                           node-ca-2xnxp                                                     1/1     Running     0             38m
openshift-image-registry                           node-ca-lc27l                                                     1/1     Running     0             38m
openshift-ingress-canary                           ingress-canary-9d5s4                                              1/1     Running     0             36m
openshift-ingress-canary                           ingress-canary-d6ktc                                              1/1     Running     0             36m
openshift-ingress-canary                           ingress-canary-ng5jg                                              1/1     Running     0             36m
openshift-ingress-operator                         ingress-operator-5599576d67-2qhnr                                 2/2     Running     5 (28m ago)   41m
openshift-ingress                                  router-default-68875db57c-6dvvw                                   1/1     Running     4 (27m ago)   38m
openshift-ingress                                  router-default-68875db57c-h4h52                                   1/1     Running     4 (27m ago)   38m
openshift-insights                                 insights-operator-85bdf667c-tx7mh                                 1/1     Running     1 (38m ago)   41m
openshift-kube-apiserver-operator                  kube-apiserver-operator-654bcbbcc8-cwwdp                          1/1     Running     2 (31m ago)   41m
openshift-kube-apiserver                           installer-5-rhoso-ctlplane-0.openshift.local                      0/1     Completed   0             33m
openshift-kube-apiserver                           installer-5-rhoso-ctlplane-1.openshift.local                      0/1     Completed   0             27m
openshift-kube-apiserver                           installer-8-rhoso-ctlplane-0.openshift.local                      0/1     Completed   0             23m
openshift-kube-apiserver                           installer-8-rhoso-ctlplane-1.openshift.local                      0/1     Completed   0             20m
openshift-kube-apiserver                           installer-8-rhoso-ctlplane-2.openshift.local                      0/1     Completed   0             24m
openshift-kube-apiserver                           kube-apiserver-guard-rhoso-ctlplane-0.openshift.local             1/1     Running     0             35m
openshift-kube-apiserver                           kube-apiserver-guard-rhoso-ctlplane-1.openshift.local             1/1     Running     0             26m
openshift-kube-apiserver                           kube-apiserver-guard-rhoso-ctlplane-2.openshift.local             1/1     Running     0             23m
openshift-kube-apiserver                           kube-apiserver-rhoso-ctlplane-0.openshift.local                   5/5     Running     0             21m
openshift-kube-apiserver                           kube-apiserver-rhoso-ctlplane-1.openshift.local                   5/5     Running     0             18m
openshift-kube-apiserver                           kube-apiserver-rhoso-ctlplane-2.openshift.local                   5/5     Running     0             24m
openshift-kube-apiserver                           revision-pruner-8-rhoso-ctlplane-0.openshift.local                0/1     Completed   0             17m
openshift-kube-apiserver                           revision-pruner-8-rhoso-ctlplane-1.openshift.local                0/1     Completed   0             17m
openshift-kube-apiserver                           revision-pruner-8-rhoso-ctlplane-2.openshift.local                0/1     Completed   0             17m
openshift-kube-controller-manager-operator         kube-controller-manager-operator-6bc888bd95-xkzdl                 1/1     Running     2 (31m ago)   41m
openshift-kube-controller-manager                  installer-3-rhoso-ctlplane-0.openshift.local                      0/1     Completed   0             37m
openshift-kube-controller-manager                  installer-3-rhoso-ctlplane-1.openshift.local                      0/1     Completed   0             36m
openshift-kube-controller-manager                  installer-4-rhoso-ctlplane-0.openshift.local                      0/1     Error       0             33m
openshift-kube-controller-manager                  installer-4-rhoso-ctlplane-2.openshift.local                      0/1     Completed   0             34m
openshift-kube-controller-manager                  installer-5-rhoso-ctlplane-0.openshift.local                      0/1     Completed   0             27m
openshift-kube-controller-manager                  installer-5-rhoso-ctlplane-1.openshift.local                      0/1     Completed   0             26m
openshift-kube-controller-manager                  installer-5-rhoso-ctlplane-2.openshift.local                      0/1     Completed   0             25m
openshift-kube-controller-manager                  kube-controller-manager-guard-rhoso-ctlplane-0.openshift.local    1/1     Running     0             36m
openshift-kube-controller-manager                  kube-controller-manager-guard-rhoso-ctlplane-1.openshift.local    1/1     Running     0             35m
openshift-kube-controller-manager                  kube-controller-manager-guard-rhoso-ctlplane-2.openshift.local    1/1     Running     0             34m
openshift-kube-controller-manager                  kube-controller-manager-rhoso-ctlplane-0.openshift.local          4/4     Running     0             26m
openshift-kube-controller-manager                  kube-controller-manager-rhoso-ctlplane-1.openshift.local          4/4     Running     0             25m
openshift-kube-controller-manager                  kube-controller-manager-rhoso-ctlplane-2.openshift.local          4/4     Running     0             24m
openshift-kube-scheduler-operator                  openshift-kube-scheduler-operator-5c55c9dc8d-88fdf                1/1     Running     2 (31m ago)   41m
openshift-kube-scheduler                           installer-3-rhoso-ctlplane-0.openshift.local                      0/1     Completed   0             38m
openshift-kube-scheduler                           installer-4-rhoso-ctlplane-0.openshift.local                      0/1     Completed   0             37m
openshift-kube-scheduler                           installer-4-rhoso-ctlplane-1.openshift.local                      0/1     Completed   0             35m
openshift-kube-scheduler                           installer-5-retry-1-rhoso-ctlplane-2.openshift.local              0/1     Completed   0             27m
openshift-kube-scheduler                           installer-5-rhoso-ctlplane-0.openshift.local                      0/1     Completed   0             26m
openshift-kube-scheduler                           installer-5-rhoso-ctlplane-1.openshift.local                      0/1     Completed   0             34m
openshift-kube-scheduler                           installer-5-rhoso-ctlplane-2.openshift.local                      0/1     Error       0             33m
openshift-kube-scheduler                           openshift-kube-scheduler-guard-rhoso-ctlplane-0.openshift.local   1/1     Running     0             37m
openshift-kube-scheduler                           openshift-kube-scheduler-guard-rhoso-ctlplane-1.openshift.local   1/1     Running     0             35m
openshift-kube-scheduler                           openshift-kube-scheduler-guard-rhoso-ctlplane-2.openshift.local   1/1     Running     0             27m
openshift-kube-scheduler                           openshift-kube-scheduler-rhoso-ctlplane-0.openshift.local         3/3     Running     0             25m
openshift-kube-scheduler                           openshift-kube-scheduler-rhoso-ctlplane-1.openshift.local         3/3     Running     0             33m
openshift-kube-scheduler                           openshift-kube-scheduler-rhoso-ctlplane-2.openshift.local         3/3     Running     0             27m
openshift-kube-storage-version-migrator-operator   kube-storage-version-migrator-operator-69f8588948-lmcbm           1/1     Running     2 (30m ago)   41m
openshift-kube-storage-version-migrator            migrator-5f59b4dc86-qpfcj                                         1/1     Running     0             39m
openshift-machine-api                              cluster-autoscaler-operator-5bfbd65dbd-2l994                      2/2     Running     2 (30m ago)   41m
openshift-machine-api                              cluster-baremetal-operator-86cd4ccf55-wjnzr                       2/2     Running     2 (30m ago)   41m
openshift-machine-api                              control-plane-machine-set-operator-575cbb9db4-9qx6h               1/1     Running     1 (30m ago)   41m
openshift-machine-api                              machine-api-operator-6dcfc65546-h5kvb                             2/2     Running     1 (31m ago)   41m
openshift-machine-config-operator                  kube-rbac-proxy-crio-rhoso-ctlplane-0.openshift.local             1/1     Running     4 (41m ago)   40m
openshift-machine-config-operator                  kube-rbac-proxy-crio-rhoso-ctlplane-1.openshift.local             1/1     Running     4 (41m ago)   40m
openshift-machine-config-operator                  kube-rbac-proxy-crio-rhoso-ctlplane-2.openshift.local             1/1     Running     4 (41m ago)   41m
openshift-machine-config-operator                  machine-config-controller-5c9b5bd49-xd9q8                         2/2     Running     1 (31m ago)   38m
openshift-machine-config-operator                  machine-config-daemon-479bx                                       2/2     Running     0             39m
openshift-machine-config-operator                  machine-config-daemon-dltlj                                       2/2     Running     0             39m
openshift-machine-config-operator                  machine-config-daemon-hvw9t                                       2/2     Running     0             39m
openshift-machine-config-operator                  machine-config-operator-84c7f75697-qfg8d                          2/2     Running     1 (30m ago)   41m
openshift-machine-config-operator                  machine-config-server-bk89t                                       1/1     Running     0             38m
openshift-machine-config-operator                  machine-config-server-h7sj4                                       1/1     Running     0             38m
openshift-machine-config-operator                  machine-config-server-qxhzh                                       1/1     Running     0             38m
openshift-marketplace                              certified-operators-zq78d                                         1/1     Running     0             26m
openshift-marketplace                              community-operators-rt274                                         1/1     Running     0             26m
openshift-marketplace                              marketplace-operator-65bd874c4f-lmt7g                             1/1     Running     4 (30m ago)   41m
openshift-marketplace                              redhat-marketplace-484lf                                          1/1     Running     0             26m
openshift-marketplace                              redhat-operators-kjbcr                                            1/1     Running     0             26m
openshift-monitoring                               alertmanager-main-0                                               6/6     Running     0             23m
openshift-monitoring                               alertmanager-main-1                                               6/6     Running     0             23m
openshift-monitoring                               cluster-monitoring-operator-6998dd7c7c-8stt4                      1/1     Running     0             41m
openshift-monitoring                               kube-state-metrics-b4fc4fbbc-dzvg5                                3/3     Running     0             38m
openshift-monitoring                               metrics-server-8ccfc884c-f5gn9                                    1/1     Running     0             33m
openshift-monitoring                               metrics-server-8ccfc884c-pfzvc                                    1/1     Running     0             33m
openshift-monitoring                               monitoring-plugin-65fb99d78c-bkhl2                                1/1     Running     0             26m
openshift-monitoring                               monitoring-plugin-65fb99d78c-n44cn                                1/1     Running     0             26m
openshift-monitoring                               node-exporter-4s9hv                                               2/2     Running     0             38m
openshift-monitoring                               node-exporter-jhcpk                                               2/2     Running     0             38m
openshift-monitoring                               node-exporter-ncq7j                                               2/2     Running     0             38m
openshift-monitoring                               openshift-state-metrics-747598fd55-s9hmp                          3/3     Running     0             38m
openshift-monitoring                               prometheus-k8s-0                                                  6/6     Running     0             23m
openshift-monitoring                               prometheus-k8s-1                                                  6/6     Running     0             23m
openshift-monitoring                               prometheus-operator-7cf68c7b79-d82k5                              2/2     Running     0             38m
openshift-monitoring                               prometheus-operator-admission-webhook-5ddc4f5bc8-f4swb            1/1     Running     0             38m
openshift-monitoring                               prometheus-operator-admission-webhook-5ddc4f5bc8-vr9sc            1/1     Running     0             38m
openshift-monitoring                               telemeter-client-85c64c6d96-jvbrq                                 3/3     Running     0             38m
openshift-monitoring                               thanos-querier-6d548d9b95-dzb8r                                   6/6     Running     0             23m
openshift-monitoring                               thanos-querier-6d548d9b95-g2glj                                   6/6     Running     0             23m
openshift-multus                                   multus-additional-cni-plugins-fkgrg                               1/1     Running     0             40m
openshift-multus                                   multus-additional-cni-plugins-hpknc                               1/1     Running     0             40m
openshift-multus                                   multus-additional-cni-plugins-nq66v                               1/1     Running     0             40m
openshift-multus                                   multus-admission-controller-57d596c9-cj5kc                        2/2     Running     0             38m
openshift-multus                                   multus-admission-controller-57d596c9-jtw2m                        2/2     Running     0             38m
openshift-multus                                   multus-fd4ng                                                      1/1     Running     0             40m
openshift-multus                                   multus-h5tr7                                                      1/1     Running     0             40m
openshift-multus                                   multus-jr9zw                                                      1/1     Running     0             40m
openshift-multus                                   network-metrics-daemon-2mw4k                                      2/2     Running     0             40m
openshift-multus                                   network-metrics-daemon-4rvdg                                      2/2     Running     0             40m
openshift-multus                                   network-metrics-daemon-tqfgk                                      2/2     Running     0             40m
openshift-network-diagnostics                      network-check-source-54447bcff9-l6c56                             1/1     Running     0             40m
openshift-network-diagnostics                      network-check-target-4pmgk                                        1/1     Running     0             40m
openshift-network-diagnostics                      network-check-target-mbh6n                                        1/1     Running     0             40m
openshift-network-diagnostics                      network-check-target-ttsxf                                        1/1     Running     0             40m
openshift-network-node-identity                    network-node-identity-7gh6m                                       2/2     Running     0             40m
openshift-network-node-identity                    network-node-identity-vttbp                                       2/2     Running     0             40m
openshift-network-node-identity                    network-node-identity-w44m2                                       2/2     Running     1 (31m ago)   40m
openshift-network-operator                         iptables-alerter-bg5xz                                            1/1     Running     0             39m
openshift-network-operator                         iptables-alerter-jwf4d                                            1/1     Running     1 (32m ago)   39m
openshift-network-operator                         iptables-alerter-kzdfj                                            1/1     Running     0             39m
openshift-network-operator                         network-operator-78dbf88f66-2fx9t                                 1/1     Running     2 (30m ago)   41m
openshift-oauth-apiserver                          apiserver-776b7fc5c7-fxgxp                                        1/1     Running     0             34m
openshift-oauth-apiserver                          apiserver-776b7fc5c7-hgmhs                                        1/1     Running     5 (31m ago)   33m
openshift-oauth-apiserver                          apiserver-776b7fc5c7-m44p4                                        1/1     Running     0             34m
openshift-operator-lifecycle-manager               catalog-operator-56c7c9d8ff-lt69s                                 1/1     Running     0             41m
openshift-operator-lifecycle-manager               collect-profiles-28787865-6tjbt                                   0/1     Completed   0             41m
openshift-operator-lifecycle-manager               collect-profiles-28787880-qbwsv                                   0/1     Completed   0             27m
openshift-operator-lifecycle-manager               collect-profiles-28787895-qjxjr                                   0/1     Completed   0             12m
openshift-operator-lifecycle-manager               olm-operator-5d564f5d95-tcln5                                     1/1     Running     0             41m
openshift-operator-lifecycle-manager               package-server-manager-6c88df5d59-nc49h                           2/2     Running     3 (30m ago)   41m
openshift-operator-lifecycle-manager               packageserver-5c95db5f4b-2p4pl                                    1/1     Running     0             38m
openshift-operator-lifecycle-manager               packageserver-5c95db5f4b-wsmbq                                    1/1     Running     0             38m
openshift-ovn-kubernetes                           ovnkube-control-plane-556547566-dwx9r                             2/2     Running     1 (30m ago)   40m
openshift-ovn-kubernetes                           ovnkube-control-plane-556547566-j8jrv                             2/2     Running     0             40m
openshift-ovn-kubernetes                           ovnkube-node-29qk9                                                8/8     Running     0             39m
openshift-ovn-kubernetes                           ovnkube-node-4pnpz                                                8/8     Running     0             39m
openshift-ovn-kubernetes                           ovnkube-node-ngxbk                                                8/8     Running     0             39m
openshift-route-controller-manager                 route-controller-manager-748b96bcf8-fbsrp                         1/1     Running     0             25m
openshift-route-controller-manager                 route-controller-manager-748b96bcf8-hwtrm                         1/1     Running     0             25m
openshift-route-controller-manager                 route-controller-manager-748b96bcf8-z5ltx                         1/1     Running     0             25m
openshift-service-ca-operator                      service-ca-operator-65d74dfd7c-qcqcs                              1/1     Running     2 (30m ago)   41m
openshift-service-ca                               service-ca-f89f94d4f-xx96c                                        1/1     Running     2 (30m ago)   39m
[mkatari@dell-7625-02 ~]$ 

