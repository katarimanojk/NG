
use the custom patch to 

1. use the latest RHEL9.2 distro (beaker_distro_tree_id) 
2. mention your node gropu (sharks) under respective vars

eg patch: https://code.engineering.redhat.com/gerrit/c/rhos-qe-jenkins/+/438626/14..16/infra/slaves/hosts


start a build in https://rhos-ci-jenkins.lab.eng.tlv2.redhat.com/job/setup-slaves

against your slave (eg: shark19) , gerritid



follow:

https://rhos-qe-mirror.lab.eng.tlv2.redhat.com/infrared/slaves.html#preparing-a-slave
