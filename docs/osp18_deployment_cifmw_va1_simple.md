# Validated Architecture (VA) virtual layout (3 nodes OCP cluster)
- Latest (main) documentation can be found here:  https://ci-framework.pages.redhat.com/docs/main/ci-framework/deploy_va.html#
- Previous (stable branch) : https://ci-framework.pages.redhat.com/docs/stable/ci-framework/05_deploy_va.html 
  - you have to do many steps manually

## Prerequisites:
- RHEL9.3 / Centosstream9   
- 100GB ram


## 1. passwordless ssh from you laptop
[laptop]$ cat ~/.ssh/id_rsa.pub 

copy it to remote server ~/.ssh/authorized_keys


## 2. on your laptop
```
[laptop]$ git clone https://github.com/openstack-k8s-operators/ci-framework ci-framework
[laptop]$ cd ci-framework
[laptop]$ make setup_molecule
[laptop]$ source ~/test-python/bin/activate
```
Note: Keep updating ci-framework repo on your laptop 

## 3. update inventory file to use the remote host
(test-python) [mkatari@fedora ci-framework]$ cat custom/inventory.yml 
```
---
localhosts:
  hosts:
    localhost:
      ansible_connection: local
    hypervisor-1:
      ansible_user: zuul  # note: you want to match the "remote_user" set in the bootstrap play
      ansible_host: 10.9.x.x
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
    hypervisor-2:
      ansible_user: zuul  # note: you want to match the "remote_user" set in the bootstrap play
      ansible_host: 10.16.20.x
      ansible_ssh_private_key_file: ~/.ssh/id_rsa
(test-python) [mkatari@fedora ci-framework]$ 
```


## 4.boostrap hypervisor
* #curl -o bootstrap-hypervisor.yml https://gitlab.cee.redhat.com/ci-framework/docs/-/raw/main/sources/files/bootstrap-hypervisor.yml
* #ansible-playbook -i custom/inventory.yml                   -e ansible_user=root                   -e cifmw_target_host=hypervisor-2                   bootstrap-hypervisor.yml


## 5. prepare env variables before deployment

### default_vars:
[laptop]$ curl https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/raw/main/scenarios/baremetal/default-vars.yaml \
                   -o custom/default-vars.yml


### hci vars: This is optional , it is all ceph configuration
[laptop]$ curl https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/raw/main/scenarios/ceph/hci.yaml  \
                  -o custom/hci.yml

### secret vars
#### pull secret:
* Access https://console.redhat.com/openshift/create/local
* Choose “Download pull secret”
* Save the file to a secure place


#### create ci_token: this token is used to login to openshift console (oc login --token)
* Go to https://console-openshift-console.apps.ci.l2s4.p1.openshiftapps.com/
* Click on your name in the top right corner
* Click on Copy login command
* It will take you to Log in with … Click on Redhat_Internal_SSO
* Click on Display Token
* Copy the content starting with sha256~ to ~/ci_token file

Note: Token expires quite often, ensure to have a valid token before deployment. 

```
(test-python) [manoj@shark19 ci-framework]$ cat custom/secret.yml 
cifmw_manage_secrets_citoken_file:  "{{ lookup('env', 'HOME') }}/ci_token"
cifmw_manage_secrets_pullsecret_file: "{{ lookup('env', 'HOME') }}/pull-secret.txt"
```


## 6. deploy

### OCP +RHOSO:

```
ansible-playbook reproducer.yml     -i custom/inventory.yml     -e cifmw_target_host=hypervisor-2     -e @scenarios/reproducers/va-hci.yml     -e @scenarios/reproducers/networking-definition.yml     -e @custom/secrets.yml   -e @custom/hci.yml   -e@custom/default-vars.yml  -e cifmw_deploy_architecture=true
```

Note: if ceph deploy fails, ensure to pass the right /tmp/overrides.yaml
if you run ocp and deploy_architecutre separetely, you should pass https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/raw/main/scenarios/ceph/hci.yaml via ci-framework_data/parameters/manoj.yml and add the the manoj.yaml to deploy_architectrure.sh
