cat ~/.ssh/id_rsa.pub

copy to ~/.ssh/authorized_keys for both root and zuul



cd checkouts/NG/ci-framework

update the host ip in custom/inventory.yml 
[mkatari@fedora ci-framework]$ ansible-playbook -i custom/inventory.yml                   -e ansible_user=root                   -e cifmw_target_host=hypervisor                   bootstrap-hypervisor.yml


on hypervisor:

sudo yum install -y git make tmux

git clone https://github.com/openstack-k8s-operators/ci-framework.git

git clone https://github.com/openstack-k8s-operators/data-plane-adoption.git

cd ~/ci-framework
make setup_molecule

# prepare releasevars.yaml which points to the right base rhel image for vms

cat > release_vars.yaml<<EOF
---
osp_base_img_url: http://download.devel.redhat.com/rhel-9/rel-eng/RHEL-9/latest-RHEL-9.2/compose/BaseOS/x86_64/images/rhel-guest-image-9.2-20230414.17.x86_64.qcow2
osp_base_img_sha256: d3fb677836ce9f52a8b670c6a781d342b122e855c94baa1d338833110ac762c5
EOF
---

#  create vms for 3 computes, 3 controllers, 1 undercloud, 1 ocp controller(ansible)
ansible-playbook  create-infra.yml -e @scenarios/reproducers/va-hci.yml -e @scenarios/reproducers/networking-definition.yml -e @release_vars.yaml --flush-cache

# check the created vms for osp and ocp
sudo virsh list --all

# osp 17.1 env with 3 computes and 3 controllers
ansible-playbook deploy-osp-adoption.yml -e cifmw_architecture_scenario=hci -e @osp_secrets.yaml -e "cifmw_adoption_source_scenario_path=/home/zuul/data-plane-adoption/scenarios" -e "cifmw_adoption_osp_deploy_ntp_server=clock.redhat.com" --flush-cache

# Deploy ocp cluster
ansible-playbook -v deploy-ocp.yml -e @scenarios/reproducers/va-hci.yml -e @scenarios/reproducers/networking-definition.yml -e @ocp-secrets.yaml --flush-cache



# Post OCP and OSP deployment steps

## Get kube config and kubeadmin-password from dev-scripts install
cd 

cp /home/zuul/src/github.com/openshift-metal3/dev-scripts/ocp/ocp/auth/kubeconfig ~/.kube/config

cp /home/zuul/src/github.com/openshift-metal3/dev-scripts/ocp/ocp/auth/kubeadmin-password ~/.kube/kubeadmin-password


## Merge OSP and OCP inventories into one file 
cat /home/zuul/ci-framework-data/reproducer-inventory/* > /home/zuul/ci-framework-data/artifacts/vms-inventory.yaml

## Remove hypervisors group from invnetory
yq -y -i 'del(.hypervisors)' /home/zuul/ci-framework-data/artifacts/vms-inventory.yaml

ansible-playbook call_net_mapper.yaml -e cifmw_networking_mapper_ifaces_info_path=/home/zuul/ci-framework-data/artifacts/interfaces-info.yml -i ~/ci-framework-data/artifacts/vms-inventory.yaml

ansible-playbook computes-wk.yaml -i /home/zuul/ci-framework-data/artifacts/vms-inventory.yaml


# prepare ocp cluster for openstack

cd ~/ci-framework

ansible-playbook playbooks/02-infra.yml \
-e cifmw_basedir="/home/zuul/ci-framework-data"\
 -e  cifmw_openshift_login_kubeconfig="{{ ansible_user_dir }}/.kube/config"\
 -e cifmw_path="{{ ansible_user_dir }}/bin:{{ ansible_env.PATH }}"\
 -e cifmw_openshift_login_password_file="{{ ansible_user_dir }}/.kube/kubeadmin-password"\
 -e cifmw_openshift_login_user=kubeadmin --flush-cache





# deploy rhoso ctlplane  on ocp 


cd $HOME

git clone https://github.com/openstack-k8s-operators/architecture

cp ~/.ssh/cifmw_reproducer_key ~/.ssh/id_cifw
cp ~/.ssh/cifmw_reproducer_key.pub ~/.ssh/id_cifw.pub

cd ci-framework

cat > ocp-config.yaml<<EOF
cifmw_use_lvms: true
cifmw_lvms_disk_list:
  - /dev/vda
  - /dev/vdb
  - /dev/vdc
EOF

ansible-playbook playbooks/06-deploy-architecture.yml \
-i ../ci-framework-data/artifacts/vms-inventory.yaml \
-e cifmw_basedir="/home/zuul/ci-framework-data" \
-e cifmw_architecture_repo=$HOME/architecture \
-e cifmw_architecture_scenario=hci-adoption \
-e @ocp-config.yaml  \
-e cifmw_path="{{ ansible_user_dir }}/bin:{{ ansible_env.PATH }}" \
-e  cifmw_openshift_kubeconfig="{{ ansible_user_dir }}/.kube/config" \
--skip-tags=openstack_ca,edpm_post --flush-cache


# before adoption i saw barbican failure so is this patch 


--- a/tests/roles/barbican_adoption/tasks/main.yaml
+++ b/tests/roles/barbican_adoption/tasks/main.yaml
@@ -41,7 +41,7 @@
     {{ shell_header }}
     {{ oc_header }}
     alias openstack="oc exec -t openstackclient -- openstack"
-    secret_id=`${BASH_ALIASES[openstack]} secret list | grep testSecret | cut -d'|' -f 2 | xargs`
+    secret_id=`${BASH_ALIASES[openstack]} secret list | grep testSecret | cut -d'|' -f 2 | head -1 | xargs`
     secret_payload=`${BASH_ALIASES[openstack]} secret get $secret_id --payload -f value`
     if [ "$secret_payload" != "TestPayload" ]
     then



# rollback during adoption failure:


 https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.[…]e/adopting_a_red_hat_openstack_platform_17.1_deployment/index
docs.redhat.comdocs.redhat.com


