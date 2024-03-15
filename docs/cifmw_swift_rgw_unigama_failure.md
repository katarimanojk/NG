

- even after updating keystone url to use https,  below command fails with 401 error

[zuul@controller-0 ci-framework]$ oc rsh openstackclient openstack container list  
Unrecognized schema in response body. (HTTP 401) (Request-ID: tx00000319df43b2ba3803e-006661531f-6350-default)
command terminated with exit code 1

# swift list of objects
oc rsh openstackclient openstack container list

- if we observe keystone logs, it fails with errors like "Couldn't find user admin"

- /fp told about srbac diabsle, it is not enabled in my case, so did nothing
 [zuul@controller-0 ci-framework]$ oc get $(oc get oscp -n openstack -o name) -o json| jq .spec.keystone.template.enableSecureRBAC.enabled
null

- then used UUIDs in most of the commands and we didn see the 401 error but keystone reports errors even for new roles like swiftoperator, ResellerAdmin

- even a simple list command is showing keystone errors, after using all uuids, we don't see such error for the congfiguration commands

- but all the list commands are showing the error, see keystone bug


## enable debugging in keystone before testing ^

[zuul@controller-0 ci-framework]$ oc -n openstack exec keystone-649c85f8f-ktmqk -c keystone-api --stdin --tty -- /bin/bash
[root@keystone-649c85f8f-ktmqk /]# vi /etc/keystone/
credential-keys/            fernet-keys/                keystone.conf.d/            policy.d/                   sso_callback_template.html  
default_catalog.templates   keystone.conf               logging.conf                policy.json                 
[root@keystone-649c85f8f-ktmqk /]# vi /etc/keystone/keystone.conf
[root@keystone-649c85f8f-ktmqk /]# 
[cifmw] 0:ssh*Z 1:ssh-          

[root@keystone-649c85f8f-ktmqk /]# grep debug /etc/keystone/keystone.conf
debug = true
[root@keystone-649c85f8f-ktmqk /]# 


## logs

oc logs -f keystone-649c85f8f-ktmqk --tail=0 > keystonelogs


# keystone bug :  
 - https://issues.redhat.com/browse/OSPRH-7533 
