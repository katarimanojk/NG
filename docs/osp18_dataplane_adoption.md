# Adoption:

docs:
  https://ci-framework.pages.redhat.com/docs/main/adoption/adoption_ci.html
  https://ci-framework.pages.redhat.com/docs/main/adoption/adoption_uni_jobs.html#deploy-osp-17-1
  https://openstack-k8s-operators.github.io/data-plane-adoption/user/index.html#adopting-the-block-storage-service_adopt-control-plane

  https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0/html-single/adopting_a_red_hat_openstack_platform_17.1_deployment/index#adopting-the-block-storage-service_adopt-control-plane

 rdo jobs:
  https://github.com/rdo-infra/rdo-jobs/blob/master/zuul.d/container-jobs-antelope-centos9.yaml#L261
  https://github.com/rdo-infra/rdo-jobs/blob/master/playbooks/data_plane_adoption/deploy_tripleo_run.yaml#L24



- currently adoption uses 17.1 standalone and also mutlinode env.
- customers can only do it manually , the adoption code ( https://github.com/openstack-k8s-operators/data-plane-adoption/blob/main/tests/playbooks/test_with_ceph.yaml ) is only for CI
  - without proper testing we can't publish documenation, we tested it using CI.

- currently there only two jobs ceph and non-ceph for both upstream and downstream
  - soon the adoption will be added to unijobs

- ceph backend configuraiton role just confiures the ceph backend whereas ceph_migrate role does the ceph migration saperately.

upstream standalone jobs are run on every github PR of data-plane-adoption repo




Note:

 during adoption we deploy ocp first and then migrate service by service on to the rhoso controlplane

  edpm (OpenStackDataPlaneNodeSet  and OpenStackDataPlaneDeplyment) is deployed during adoption.  OSP Computes will become edpm nodes



## jobs rdo
standalone
adoption-standalone-to-crc-ceph 
adoption-standalone-to-crc-no-ceph 

mutlinode
- periodic-adoption-multinode-to-crc-ceph
- periodic-adoption-multinode-to-crc-no-ceph
   https://review.rdoproject.org/r/c/testproject/+/55840 runs periodic-adoption-multinode-to-crc-no-ceph  job.


## Tripleo to Rhoso ( tripleo controlplane to OCP)

adotptoin for ceph is not simple because

- ODF is there already, no support for internal ceph
- can't podify part of ceph deamons as ceph is external



### procedure (mainly for ceph)

1. decomission the controllers
2. move the dameons to set of target nodes (ceph/compute(hci))
3. make it external
4. converge to 18 usecase where ceph is external


Note: ceph migration needs just the osp17.1 tripleo deployment, migration can be done irrespective of the ocp/rhoso deployment, as we just externalize the cluster


## ceph_migration (after adoption) logs:
https://sf.hosted.upshift.rdu2.redhat.com/logs/77/777/9047b63d6261c3b9a0d65d1eff8a63230483c30e/check-gitlab-cee/periodic-internal-adoption-multinode-to-crc-ceph/faada5f/controller/data-plane-adoption-tests-repo/data-plane-adoption/tests/logs/test_ceph_migration_out_2024-10-22T22:25:31EDT.log  



## 17.1 greenfield deployment before adoption

## fpantano rhcs6->7 patch
cifmw does it in adoption_osp_deploy role
see https://github.com/openstack-k8s-operators/ci-framework/pull/2471/files 

previously install_yamls did it
see https://github.com/openstack-k8s-operators/install_yamls/pull/930

https://github.com/openstack-k8s-operators/data-plane-adoption/pull/668/files



### multinode 17.1 for unigamma using cifmw

https://docs.google.com/document/d/1xXEmhwdVh7a2t0yB6Th_3gYZIp3XkcsV330eb7M5xCk/edit?tab=t.0

on laptop: 
  - bootstrap hypervisor   (document suggests to use prepare hypervisor, but i face few errors)



sudo yum install -y git make tmux
git clone https://github.com/openstack-k8s-operators/ci-framework.git
git clone https://github.com/openstack-k8s-operators/data-plane-adoption.git


mkdir -p .config/redhat/

cd ~/ci-framework
make setup_molecule



#### crate base infra

cd ~/ci-framework
cat > release_vars.yaml<<EOF
---
osp_base_img_url: http://download.devel.redhat.com/rhel-9/rel-eng/RHEL-9/latest-RHEL-9.2/compose/BaseOS/x86_64/images/rhel-guest-image-9.2-20230414.17.x86_64.qcow2
osp_base_img_sha256: d3fb677836ce9f52a8b670c6a781d342b122e855c94baa1d338833110ac762c5
EOF

ansible-playbook  create-infra.yml -e @scenarios/reproducers/va-hci.yml    -e @scenarios/reproducers/networking-definition.yml -e @release_vars.yaml --flush-cache




[zuul@shark19 ci-framework]$ sudo virsh list --all
 Id   Name                              State
--------------------------------------------------
 -    cifmw-controller-0                shut off
 -    cifmw-osp-compute-7dyx3wdy-0      shut off
 -    cifmw-osp-compute-7dyx3wdy-1      shut off
 -    cifmw-osp-compute-7dyx3wdy-2      shut off
 -    cifmw-osp-controller-7dyx3wdy-0   shut off
 -    cifmw-osp-controller-7dyx3wdy-1   shut off
 -    cifmw-osp-controller-7dyx3wdy-2   shut off
 -    cifmw-osp-undercloud-7dyx3wdy-0   shut off




create key and add repos using the below link:
https://gitlab.cee.redhat.com/ci-framework/docs/-/merge_requests/168/diffs#bf7d319845925b501373842ca0a833f7cc04c34f_0_86

[zuul@shark19 ci-framework]$ cat osp_secrets.yaml 
cifmw_adoption_osp_deploy_rhsm_org: "11009103"
cifmw_adoption_osp_deploy_rhsm_key: "cifmw_adoption_osp_deploy_rhsm_key"
cifmw_adoption_osp_deploy_container_user: "rh-ee-mkatari"
cifmw_adoption_osp_deploy_container_registry: "registry.redhat.io"
cifmw_adoption_osp_deploy_container_password: "TANVIkanthi111!!!"
[zuul@shark19 ci-framework]$



# deploy osp17.1

[zuul@shark19 ci-framework]$ ansible-playbook deploy-osp-adoption.yml -e cifmw_architecture_scenario=hci -e @osp_secrets.yaml -e "cifmw_adoption_source_scenario_path=/home/zuul/adoption_multinode/data-plane-adoption/scenarios" -e "cifmw_adoption_osp_deploy_ntp_server=clock.redhat.com" --flush-cache



# deploy ocp
ansible-playbook -v deploy-ocp.yml  -e @scenarios/reproducers/va-hci.yml -e @scenarios/reproducers/networking-definition.yml -e @ocp-secrets.yaml --flush-cache

[zuul@shark19 ci-framework]$ sudo virsh list
 Id   Name                              State
-------------------------------------------------
 1    cifmw-osp-undercloud-7dyx3wdy-0   running
 2    cifmw-controller-0                running
 3    cifmw-osp-compute-7dyx3wdy-0      running
 4    cifmw-osp-compute-7dyx3wdy-1      running
 5    cifmw-osp-compute-7dyx3wdy-2      running
 6    cifmw-osp-controller-7dyx3wdy-0   running
 7    cifmw-osp-controller-7dyx3wdy-1   running
 8    cifmw-osp-controller-7dyx3wdy-2   running
 18   cifmw-ocp-master-0                running
 19   cifmw-ocp-master-1                running
 20   cifmw-ocp-master-2                running

[zuul@shark19 ci-framework]$ 








adoption failed here:

TASK [dataplane_adoption : Wait for the validation deployment to finish] *********************************************************************************************************************************************************************
                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                              

fatal: [localhost]: FAILED! => {"changed": true, "cmd": "set -euxo pipefail\n\n\n\nDEPLOYMENT_NAME=openstack-pre-adoption\nTRIES=180\nDELAY=10\nALLOWED_JOB_RETRIES=1\n\nfor i in $(seq $TRIES)\ndo\n    ready=$(oc get osdpd/$DEPLOYMENT_NAME
 -o jsonpath='{.status.conditions[0].status}')\n    if [ \"$ready\" == \"True\" ]; then\n        echo \"Pre adoption validation Deployment is Ready\"\n        exit 0\n    else\n        failed=$(oc get jobs -l openstackdataplanedeployment=
$DEPLOYMENT_NAME -o jsonpath=\"{.items[?(@.status.failed > $ALLOWED_JOB_RETRIES)].metadata.name}\")\n        if [ ! -z \"${failed}\" ]; then\n            echo \"There are failed AnsibleEE jobs: $failed\"\n            exit 1\n        fi\n 
   fi\n\nsleep $DELAY\ndone\n\necho \"Run out of retries\"\nexit 2\n", "delta": "0:31:04.015206", "end": "2025-01-02 17:50:56.963293", "msg": "non-zero return code", "rc": 2, "start": "2025-01-02 17:19:52.948087", "stderr": "+ DEPLOYMENT_
NAME=openstack-pre-adoption\n+ TRIES=180\n+ DELAY=10\n+ ALLOWED_JOB_RETRIES=1\n++ seq 180\n+ for i in $(seq $TRIES)\n++ oc get osdpd/openstack-pre-adoption -o 'jsonpath={.status.conditions[0].status}'\n+ ready=Unknown\n+ '[' Unknown == Tr
ue ']'\n++ oc get jobs -l openstackdataplanedeployment=openstack-pre-adoption -o 'jsonpath={.items[?(@.status.failed > 1)].metadata.name}'\n+ failed=\n+ '[' '!' -z '' ']'\n+ sleep 10\n+ for i in $(seq $TRIES)\n++ oc get osdpd/openstack-pr






other adoption failure:

TASK [ceph_backend_configuration : update the openstack keyring caps for Manila] *************************************************************************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": true, "cmd": "set -euxo pipefail\n\n\nCEPH_SSH=\"ssh -i /home/zuul/.ssh/id_cifw -o StrictHostKeyChecking=accept-new  root@192.168.122.103\"\nCEPH_CAPS=\"mgr 'allow *' mon 'allow r, profile rbd' osd 'profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups, allow rw pool manila_data'\"\nOSP_KEYRING=\"client.openstack\"\nCEPH_ADM=$($CEPH_SSH \"cephadm shell -- ceph auth caps $OSP_KEYRING $CEPH_CAPS\")\n", "delta": "0:00:00.063550", "end": "2025-01-06 05:45:22.546943", "msg": "non-zero return code", "rc": 255, "start": "2025-01-06 05:45:22.483393", "stderr": "+ CEPH_SSH='ssh -i /home/zuul/.ssh/id_cifw -o StrictHostKeyChecking=accept-new  root@192.168.122.103'\n+ CEPH_CAPS='mgr '\\''allow *'\\'' mon '\\''allow r, profile rbd'\\'' osd '\\''profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups, allow rw pool manila_data'\\'''\n+ OSP_KEYRING=client.openstack\n++ ssh -i /home/zuul/.ssh/id_cifw -o StrictHostKeyChecking=accept-new root@192.168.122.103 'cephadm shell -- ceph auth caps client.openstack mgr '\\''allow *'\\'' mon '\\''allow r, profile rbd'\\'' osd '\\''profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups, allow rw pool manila_data'\\'''\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\n@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @\r\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\nIT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!\r\nSomeone could be eavesdropping on you right now (man-in-the-middle attack)!\r\nIt is also possible that a host key has just been changed.\r\nThe fingerprint for the ED25519 key sent by the remote host is\nSHA256:DMXLEZJoWpStLn9Q3ULr1HX8Do+xrbyOJDlYcgiceDw.\r\nPlease contact your system administrator.\r\nAdd correct host key in /home/zuul/.ssh/known_hosts to get rid of this message.\r\nOffending ECDSA key in /home/zuul/.ssh/known_hosts:7\r\nHost key for 192.168.122.103 has changed and you have requested strict checking.\r\nHost key verification failed.\r\n+ CEPH_ADM=", "stderr_lines": ["+ CEPH_SSH='ssh -i /home/zuul/.ssh/id_cifw -o StrictHostKeyChecking=accept-new  root@192.168.122.103'", "+ CEPH_CAPS='mgr '\\''allow *'\\'' mon '\\''allow r, profile rbd'\\'' osd '\\''profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups, allow rw pool manila_data'\\'''", "+ OSP_KEYRING=client.openstack", "++ ssh -i /home/zuul/.ssh/id_cifw -o StrictHostKeyChecking=accept-new root@192.168.122.103 'cephadm shell -- ceph auth caps client.openstack mgr '\\''allow *'\\'' mon '\\''allow r, profile rbd'\\'' osd '\\''profile rbd pool=vms, profile rbd pool=volumes, profile rbd pool=images, profile rbd pool=backups, allow rw pool manila_data'\\'''", "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", "@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @", "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", "IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!", "Someone could be eavesdropping on you right now (man-in-the-middle attack)!", "It is also possible that a host key has just been changed.", "The fingerprint for the ED25519 key sent by the remote host is", "SHA256:DMXLEZJoWpStLn9Q3ULr1HX8Do+xrbyOJDlYcgiceDw.", "Please contact your system administrator.", "Add correct host key in /home/zuul/.ssh/known_hosts to get rid of this message.", "Offending ECDSA key in /home/zuul/.ssh/known_hosts:7", "Host key for 192.168.122.103 has changed and you have requested strict checking.", "Host key verification failed.", "+ CEPH_ADM="], "stdout": "", "stdout_lines": []}












### standalone  17.1 using install_yamls 
 - https://openstack-k8s-operators.github.io/data-plane-adoption/dev/#_development_environment

below jobs should use standalone adopiton devenv
adoption-standalone-to-crc-ceph 
adoption-standalone-to-crc-no-ceph 

Notes:
- /tmp/standalone_repos will change after 'make staandalone', recreate it after standalone_clenaup
- chrony ntp server downstream
 - export NTP_SERVER=${NTP_SERVER:-"clock.corp.redhat.com"} in ./scripts/standalone.sh


[zuul@dell-r730-068 devsetup]$ vi scripts/gen-edpm-node.sh  creates edpm-compute-0 where tripleo standalone RHOSP is deployed.

[zuul@dell-r730-068 devsetup]$ sudo virsh list
 Id   Name             State
--------------------------------
 1    crc              running
 5    edpm-compute-0   running

[zuul@dell-r730-068 devsetup]$ ssh root@192.168.122.100 / 12345678


- fix the cephadm - ceph version mismatch
"ERROR: Container release reef != cephadm release quincy; please use matching version of cephadm (pass --allow-mismatched-release to continue anyway)\"]

ceph/deploy.sh: add --allow-mismatched-release at L564 for bootstrap command  (didn't reflect in the bootstrap command)
can update standalone/ceph.sh : not supported
(or)
in the vm, update the cephadm from quicy to reef 

fix:  sudo rhos-release ceph-7.1-rhel-9 -r 9.4











make crc






cat <<EOF > /tmp/standalone_repos
sudo curl -o /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt https://password.corp.redhat.com/RH-IT-Root-CA.crt
sudo curl -o /etc/pki/ca-trust/source/anchors/legacy.crt https://password.corp.redhat.com/legacy.crt
sudo curl -k -o /etc/pki/ca-trust/source/anchors/Eng-CA.crt https://engineering.redhat.com/Eng-CA.crt
sudo curl -k -o /etc/pki/ca-trust/source/anchors/2022-IT-Root-CA.pem https://certs.corp.redhat.com/certs/2022-IT-Root-CA.pem
sudo /usr/bin/update-ca-trust extract
sudo curl -k -o /tmp/rhos-release.rpm https://download.eng.brq.redhat.com/rcm-guest/puddles/OpenStack/rhos-release/rhos-release-latest.noarch.rpm
sudo dnf install -y /tmp/rhos-release.rpm
sudo rhos-release -x
sudo rhos-release 17.1
# Install ceph 7.1 tools repository for reef based cephadm
sudo rhos-release ceph-7.1-rhel-9 -r 9.4
sudo sed -i -e 's/enabled=1/enabled=1\nsslverify=0/g' \$(ls /etc/yum.repos.d/*)
sudo dnf install -y vim git curl util-linux lvm2 tmux wget
sudo dnf install -y podman python3-tripleoclient util-linux lvm2 cephadm
EOF

 
RH_REGISTRY_USER="<registry.redhat.io user>"
RH_REGISTRY_PWD="<registry.redhat.io password>"
cd ~/install_yamls/devsetup
 
# this is non-TLS setup
STANDALONE_EXTRA_CMD="bash -c 'sudo /bin/podman login registry.redhat.io -u \"$RH_REGISTRY_USER\" --password-stdin <<<\"$RH_REGISTRY_PWD\"'" \
    CENTOS_9_STREAM_URL=https://download.eng.brq.redhat.com/rhel-9/rel-eng/RHEL-9/latest-RHEL-9.2.0/compose/BaseOS/x86_64/images/rhel-guest-image-9.2-20230414.17.x86_64.qcow2 \
    BASE_DISK_FILENAME="rhel-9-base.qcow2" \
    REPO_SETUP_CMDS=/tmp/standalone_repos \
    make standalone



                                                                                                                                                                                                                                              
########################################################                                                               
                                                           
Deployment successful!                                                                                                 
                                                           
######################################################## 
                                                                                                                       
##########################################################
                                                           
Useful files:                                                                                                                                                                                                                                 
                                                                                                                                                                                                                                              
The clouds.yaml file is at ~/.config/openstack/clouds.yaml
                                                                                                                       
Use "export OS_CLOUD=standalone" before running the
openstack command.               
                        


[zuul@dell-r730-068 ~]$ cd install_yamls/devsetup/                                                                                                                                                                                            
[zuul@dell-r730-068 devsetup]$ make standalone_snapshot                                                                                                                                                                                       
virsh --connect=qemu:///system detach-device-alias edpm-compute-0 fs0 --live || true                                                                                                                                                          
Device detach request sent successfully

sleep 3
virsh --connect=qemu:///system snapshot-create-as --atomic --domain edpm-compute-0 --name clean                                                                                                                                               
Domain snapshot clean created
[zuul@dell-r730-068 devsetup]$ sudo virsh list
 Id   Name             State
--------------------------------
 1    crc              running
 12   edpm-compute-0   running

[zuul@dell-r730-068 devsetup]$






[zuul@dell-r730-068 devsetup]$ EDPM_BRIDGE=$(sudo virsh dumpxml edpm-compute-0 | grep -oP "(?<=bridge=').*(?=')")                                                                                                                             
sudo ip link add link $EDPM_BRIDGE name vlan20 type vlan id 20                                                                                                                                                                                
sudo ip addr add dev vlan20 172.17.0.222/24                                                                                                                                                                                                   
sudo ip link set up dev vlan20                                                                                                                                                                                                                
[zuul@dell-r730-068 devsetup]$ EDPM_BRIDGE=$(sudo virsh dumpxml edpm-compute-0 | grep -oP "(?<=bridge=').*(?=')")                                                                                                                             
sudo ip link add link $EDPM_BRIDGE name vlan23 type vlan id 23                                                                                                                                                                                
sudo ip addr add dev vlan23 172.20.0.222/24                                                                                                                                                                                                   
sudo ip link set up dev vlan23                                                                                                                                                                                                                
[zuul@dell-r730-068 devsetup]$ alias openstack="ssh -i ~/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa root@192.168.122.100                                                                                                                 
> ^C                                                                                                                                                                                                                                          
[zuul@dell-r730-068 devsetup]$ alias openstack="ssh -i ~/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa root@192.168.122.100"^C                                                                                                              
[zuul@dell-r730-068 devsetup]$ alias openstack="ssh -i ~/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa root@192.168.122.100 OS_CLOUD=standalone openstack"                                                                                  
[zuul@dell-r730-068 devsetup]$ openstack volume service list                                                                                                                                                                                  
+------------------+------------------------+------+---------+-------+----------------------------+                                                                                                                                           
| Binary           | Host                   | Zone | Status  | State | Updated At                 |                                                                                                                                           
+------------------+------------------------+------+---------+-------+----------------------------+                                                                                                                                           
| cinder-scheduler | standalone.localdomain | nova | enabled | up    | 2024-11-11T10:01:12.000000 |                                                                                                                                           
| cinder-backup    | standalone.localdomain | nova | enabled | up    | 2024-11-11T10:01:18.000000 |                                                                                                                                           
| cinder-volume    | hostgroup@tripleo_ceph | nova | enabled | up    | 2024-11-11T10:01:21.000000 |                                                                                                                                           
+------------------+------------------------+------+---------+-------+----------------------------+                                                                                                                                           
                                                                                                                                                                                                                                              
[zuul@dell-r730-068 devsetup]$                                                                                         
[zuul@dell-r730-068 devsetup]$ cd ~/data-plane-adoption                                                                
[zuul@dell-r730-068 data-plane-adoption]$ export CINDER_VOLUME_BACKEND_CONFIGURED=true                                                                                                                                                        
export CINDER_BACKUP_BACKEND_CONFIGURED=true                                                                           
[zuul@dell-r730-068 data-plane-adoption]$ export OPENSTACK_COMMAND="ssh -i ~/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa root@192.168.122.100 OS_CLOUD=standalone openstack                                                               
> ^C                                                                                                                   
[zuul@dell-r730-068 data-plane-adoption]$ export OPENSTACK_COMMAND="ssh -i ~/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa root@192.168.122.100 OS_CLOUD=standalone openstack"                                                              
[zuul@dell-r730-068 data-plane-adoption]$ OS_CLOUD_IP=192.168.122.100 OS_CLOUD_NAME=standalone \                                                                                                                                              
    bash tests/roles/development_environment/files/pre_launch.bash   

after pre_launch.bash

[zuul@dell-r730-068 data-plane-adoption]$ openstack volume list
/usr/lib/python3.9/site-packages/osc_lib/utils/__init__.py:515: DeprecationWarning: The usage of formatter functions is now discouraged. Consider using cliff.columns.FormattableColumn instead. See reviews linked with bug 1687955 for more detail.
  warnings.warn(
+--------------------------------------+-------------+--------+------+-------------------------------------+
| ID                                   | Name        | Status | Size | Attached to                         |
+--------------------------------------+-------------+--------+------+-------------------------------------+
| d710adc0-7036-4118-a704-67efff315415 | boot-volume | in-use |    1 | Attached to bfv-server on /dev/vda  |
| e3741dd3-87f6-49ec-b9e4-6296b19c567e | disk        | in-use |    1 | Attached to test on /dev/vdc        |
+--------------------------------------+-------------+--------+------+-------------------------------------+
[zuul@dell-r730-068 data-plane-adoption]$ openstack compute list




[zuul@dell-r730-068 data-plane-adoption]$ openstack secret store --name testSecret --payload 'TestPayload'
+---------------+------------------------------------------------------------------------+
| Field         | Value                                                                  |
+---------------+------------------------------------------------------------------------+
| Secret href   | http://172.21.0.2:9311/v1/secrets/351c9f3c-a509-4372-9dea-252058295667 |
| Name          | testSecret                                                             |
| Created       | None                                                                   |
| Status        | None                                                                   |
| Content types | None                                                                   |
| Algorithm     | aes                                                                    |
| Bit length    | 256                                                                    |
| Secret type   | opaque                                                                 |
| Mode          | cbc                                                                    |
| Expiration    | None                                                                   |
+---------------+------------------------------------------------------------------------+
[zuul@dell-r730-068 data-plane-adoption]$ ssh -i ~/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa root@192.168.122.100 sudo cephadm shell -- rbd -p images ls -l
Inferring fsid 29722081-e996-551e-a067-fdf80a28c1f5
Inferring config /var/lib/ceph/29722081-e996-551e-a067-fdf80a28c1f5/mon.standalone/config
Using ceph image with id '3fd804e38f5b' and tag 'latest' created on 2024-07-31 19:44:24 +0000 UTC
registry.redhat.io/rhceph/rhceph-7-rhel9@sha256:75bd8969ab3f86f2203a1ceb187876f44e54c9ee3b917518c4d696cf6cd88ce3
NAME                                       SIZE     PARENT  FMT  PROT  LOCK
dd251c27-fa46-433d-a436-e07fb55511dc       112 MiB            2            
dd251c27-fa46-433d-a436-e07fb55511dc@snap  112 MiB            2  yes       
[zuul@dell-r730-068 data-plane-adoption]$ 




make openstack

timeout 300s bash -c "while ! (oc get project.v1.project.openshift.io openstack-operators); do sleep 1; done"
NAME                  DISPLAY NAME   STATUS
openstack-operators                  Active
oc project openstack-operators
Now using project "openstack-operators" on server "https://api.crc.testing:6443".
oc apply -f /home/zuul/install_yamls/out/openstack-operators/openstack/op
catalogsource.operators.coreos.com/openstack-operator-index created
operatorgroup.operators.coreos.com/openstack created
subscription.operators.coreos.com/openstack-operator created
[zuul@dell-r730-068 install_yamls]$ 
[zuul@dell-r730-068 install_yamls]$ 
[zuul@dell-r730-068 install_yamls]$ oc get osctlplane
error: the server doesn't have a resource type "osctlplane"
[zuul@dell-r730-068 install_yamls]$ scp -i ~/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa root@192.168.122.100:/root/tripleo-standalone-passwords.yaml ~/
tripleo-standalone-passwords.yaml                                                                                                                                                                           100% 9464     6.8MB/s   00:00    
[zuul@dell-r730-068 install_yamls]$ 




run the test-with-ceph playbook




[zuul@dell-r730-068 tests]$ cp vars.sample.yaml vars.yaml
[zuul@dell-r730-068 tests]$ cp secrets.sample.yaml secrets.yaml
[zuul@dell-r730-068 tests]$ cp inventory.sample-crc-vagrant.yaml inventory.yaml 
[zuul@dell-r730-068 tests]$ cd ..


sudo dnf -y install python-devel
python3 -m venv venv
source venv/bin/activate
pip install openstackclient osc_placement jmespath
ansible-galaxy collection install community.general


make test-with-ceph




/var 100% issue

[zuul@shark20 ci-framework]$ rm -rf ~/ci-framework-data/workload/*
[zuul@shark20 ci-framework]$ sudo reboot
