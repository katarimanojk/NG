
# deployment

## doc:

https://ci-framework.pages.redhat.com/docs/ci-framework/00_intro.html

## slide deck from chandan
https://docs.google.com/presentation/d/124z09L2W_CqrbZI3OkMcpu8ig3iAkqKBHJwUy7F7Hc4/edit#slide=id.g2c38c11486a_1_135



## steps

### step1:
useradd manoj
passwd manoj
vi /etc/sudoers 
add "manoj   ALL=(ALL)       NOPASSWD: ALL"


git clone https://github.com/openstack-k8s-operators/ci-framework ci-framework
cd ci-framework
make setup_molecule
source ~/test-python/bin/activate





# not needed if you are using localhost as hypervisor
(test-python) [root@shark14 ci-framework]# cat custom/inventory.yml 
all:
  hosts:
    localhost:
      ansible_connection: local
    hypervisor-1:
      ansible_host: localhost
      ansible_user: zuul  # note: you want to match the "remote_user" set in the bootstrap playi
      #ansible_ssh_private_key_file: ~/.ssh/jenkins_key
(test-python) [root@shark14 ci-framework]# 


### step2:
curl -o bootstrap-hypervisor.yml https://gitlab.cee.redhat.com/ci-framework/docs/-/raw/main/sources/files/bootstrap-hypervisor.yml

ansible-playbook  -e ansible_user=root     -e cifmw_target_host=localhost    bootstrap-hypervisor.yml
Note: it complained about permisons so ran it as root user

ansible-playbook -i custom/inventory.yml \
                  -e ansible_user=root \
                  -e cifmw_target_host=hypervisor-2 \
                  bootstrap-hypervisor.yml


#### downstream vars
curl https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/raw/main/scenarios/baremetal/default-vars.yaml    -o custom/rh-internal.yml

#### ceph vars
curl https://gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/-/raw/main/scenarios/ceph/hci.yaml   -o custom/hci.yml


#### secret vars with ci_token and pull_secret
create ci_token: 
Go to https://console-openshift-console.apps.ci.l2s4.p1.openshiftapps.com/
Click on your name in the top right corner
Click on Copy login command
It will take you to Log in with … Click on Redhat_Internal_SSO
Click on Display Token
Copy the content starting with sha256~ to ~/ci_token file

create pull_secret:

(test-python) [manoj@shark19 ci-framework]$ cat custom/secret.yml 
---
cifmw_manage_secrets_citoken_file:  "{{ lookup('env', 'HOME') }}/ci_token"
cifmw_manage_secrets_pullsecret_file: "{{ lookup('env', 'HOME') }}/pull-secret.txt"






# skip
if the below error is seen 

TASK [libvirt_manager : Ensure networks are created/started command=create, name={{ item.name }}, uri=qemu:///system] ************************************************************************************************************************
Thursday 18 January 2024  18:32:28 +0000 (0:00:01.017)       0:00:40.368 ****** 
failed: [localhost] (item=cifmw-osp_trunk) => {"ansible_loop_var": "item", "changed": false, "item": {"name": "cifmw-osp_trunk", "xml": "<network>\n  <name>cifmw-osp_trunk</name>\n  <forward mode='nat'/>\n  <bridge name='cifmw-osp_trunk' stp='on' delay='0'/>\n  <mtu size='9000'/>\n  <ip family='ipv4' address='192.168.122.1' prefix='24'>\n  </ip>\n</network>\n"}, "msg": "internal error: Network is already in use by interface virbr0"}

sol:
virsh -c qemu:///system net-destroy default
virsh -c qemu:///system net-start cifmw-osp_trunk



# skip 
below reproducer command may not work
ansible-playbook -e cifmw_target_host=localhost \
    -e @scenarios/reproducers/validated-architecture-1.yml \
    -e @custom/custom-params.yml \
    reproducer.yml


TASK [reproducer : Assert no conflicting parameters were passed that=['(cifmw_libvirt_manager_configuration.vms.crc is defined) or (cifmw_libvirt_manager_configuration.vms.ocp is defined)', 'not ((cifmw_libvirt_manager_configuration.vms.c
rc is defined) and (cifmw_libvirt_manager_configuration.vms.ocp is defined))'], quiet=True, msg=You cannot get both OpenShift cluster types. Please chose between CRC and OCP cluster.] ***                                                   
Wednesday 20 March 2024  05:29:27 +0000 (0:00:00.033)       0:00:07.501 *******                                                                                                                                                               
fatal: [localhost]: FAILED! => {"assertion": "(cifmw_libvirt_manager_configuration.vms.crc is defined) or (cifmw_libvirt_manager_configuration.vms.ocp is defined)", "changed": false, "evaluated_to": false, "msg": "You cannot get both Open
Shift cluster types. Please chose between CRC and OCP cluster."}                                                                                                                                                                              
                                                                    

missing 'scenarios/reproducers/networking-definition.yml' caused it.


### step3
-working reproducer command

#### ocp
(test-python) [manoj@shark19 ci-framework]$ ansible-playbook reproducer.yml    -e @scenarios/reproducers/va-hci.yml  -e @scenarios/reproducers/networking-definition.yml -e @custom/rh-internal.yml  -e @custom/hci.yml     -e @custom/secret.yml



(test-python) [manoj@shark19 ci-framework]$ sudo virsh list
 Id   Name                 State
------------------------------------
 8    cifmw-compute-0      running
 9    cifmw-compute-1      running
 10   cifmw-compute-2      running
 11   cifmw-controller-0   running
 12   cifmw-ocp-0          running
 13   cifmw-ocp-1          running
 14   cifmw-ocp-2          running

(test-python) [manoj@shark19 ci-framework]$ vi ~/src/github.com/openshift-metal3/dev-scripts/logs/
01_install_requirements-2024-03-20-145251.log   03_build_installer-2024-03-20-145525.log        05_create_install_config-2024-03-20-145606.log  installer-status.txt
02_configure_host-2024-03-20-145437.log         04_setup_ironic-2024-03-20-145539.log           06_create_cluster-2024-03-20-145610.log         

(test-python) [manoj@shark19 ci-framework]$ virsh -c qemu:///system list --all 
 Id   Name                 State
------------------------------------
 8    cifmw-compute-0      running
 9    cifmw-compute-1      running
 10   cifmw-compute-2      running
 11   cifmw-controller-0   running
 12   cifmw-ocp-0          running
 13   cifmw-ocp-1          running
 14   cifmw-ocp-2          running

(test-python) [manoj@shark19 ci-framework]$ virsh -c qemu:///system net-list --all
 Name              State    Autostart   Persistent
----------------------------------------------------
 cifmw-osp_trunk   active   yes         yes
 ocpbm             active   yes         yes
 ocppr             active   yes         yes

(test-python) [manoj@shark19 ci-framework]$ 



or

#### ocp + RHOSO
(test-python) [manoj@shark19 ci-framework]$ ansible-playbook reproducer.yml    -e @scenarios/reproducers/va-hci.yml  -e @scenarios/reproducers/networking-definition.yml -e @custom/rh-internal.yml  -e @custom/hci.yml     -e @custom/secret.yml -e cifmw_deploy_architecture=true


## using cifmw_deploy_architecture_stopper to stop after pre-ceph
(test-python) [mkatari@fedora ci-framework]$ ansible-playbook reproducer.yml     -i custom/inventory.yml     -e cifmw_target_host=hypervisor-1     -e @scenarios/reproducers/va-hci.yml     -e @scenarios/reproducers/networking-definition.yml     -e @custom/secrets.yml   -e @custom/hci.yml   -e@custom/default-vars.yml  -e cifmw_deploy_architecture=true -e cifmw_deploy_architecture_stopper=post_apply_stage_3 --flush-cache


stage will be decided base on the '-path' count in below file.
https://github.com/openstack-k8s-operators/architecture/blob/main/automation/vars/default.yaml#L49

it fails here with stopper tag:
TASK [reproducer : Run deployment if instructed to] ******************************************************************************************************************************************************************************************
Thursday 16 May 2024  17:36:03 +0530 (0:00:00.046)       1:32:13.966 ********** 
ASYNC POLL on hypervisor-1: jid=j50125318954.20560 started=1 finished=0
.
ASYNC POLL on hypervisor-1: jid=j50125318954.20560 started=1 finished=0
ASYNC POLL on hypervisor-1: jid=j50125318954.20560 started=1 finished=0
ASYNC POLL on hypervisor-1: jid=j50125318954.20560 started=1 finished=0
ASYNC FAILED on hypervisor-1: jid=None
fatal: [hypervisor-1 -> controller-0(192.168.111.23)]: FAILED! => changed=true 
  censored: 'the output has been hidden due to the fact that ''no_log: true'' was specified for this result'


see controller-0:~/ansible-deploy-architecture.log to see why it stopped.

more tips on stopping:
https://ci-framework.pages.redhat.com/docs/main/ci-framework/cookbook.html#stop-automated-deployment-in-a-specific-stage



run ceph playbook
https://ci-framework.pages.redhat.com/docs/stable/ci-framework/05_deploy_va.html#ceph


inventory:
[zuul@controller-0 ci-framework]$ cp ~/reproducer-inventory/compute-group.yml inventory.yml

export ANSIBLE_REMOTE_USER=zuul
export ANSIBLE_SSH_PRIVATE_KEY=~/.ssh/id_cifw
export ANSIBLE_HOST_KEY_CHECKING=False


ANSIBLE_GATHERING=implicit ansible-playbook playbooks/ceph.yml -e @/tmp/ceph_overrides.yml


# #step4

controller-0]$ ./deploy-architecture.sh




# cleanup

ansible-playbook  -i custom/inventory.yml -e cifmw_target_host=hypervisor-1 reproducer-clean.yml

ansible-playbook reproducer-clean.yml --tags deepscrub

https://ci-framework.readthedocs.io/en/latest/quickstart/99_FAQ.html#deep-cleaning
