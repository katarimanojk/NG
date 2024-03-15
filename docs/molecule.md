# install and test 

create the python virtual env

python -m venv <patch to venv>
e.g. mkdir -p ~/VENV/mol python -m venv ~/VENV/mol/

source ~/VENV/mol/bin/activate


install molecule:
(mol) [mkatari@fedora cifmw_cephadm]$ #pip install molecule ansible molecule[docker] docker
or
make molecule 


#see the makefile options 

make setup_molecule
make pre_commit
make ansible_test


## test
- comment the test_deps part in prepare.yaml
iff --git a/roles/cifmw_ceph_spec/molecule/default/prepare.yml b/roles/cifmw_ceph_spec/molecule/default/prepare.yml
index d3594acc..6287f512 100644
--- a/roles/cifmw_ceph_spec/molecule/default/prepare.yml
+++ b/roles/cifmw_ceph_spec/molecule/default/prepare.yml
@@ -17,5 +17,5 @@
 
 - name: Prepare
   hosts: all
-  roles:
-    - role: test_deps
+    #roles:
+    #    - role: test_deps


cd roles/cifmw_ceph_spec
(newmol) [mkatari@fedora cifmw_ceph_spec]$ sudo  molecule -c /home/mkatari/checkouts/NG/ci-framework_myfork_latest/scripts/../.config/molecule/config_local.yml test



# creating the role:

molecule init role <role name> --driver-name=docker

#not mandatory
#pip install ansible-lint
#ansible-lint -L


molecule list

#create instances by downloading the images from docker hub
molecule create   

molecule list



# other info:


#molecule -c /home/mkatari/checkouts/NG/ci-framework_myfork_latest/scripts/../.config/molecule/config_podman.yml --debug test --all

ci uses:
#molecule -c /home/mkatari/checkouts/NG/ci-framework_myfork_latest/scripts/../.config/molecule/config.yml --debug test --all



In your environment do a clean checkout of the main branch and run molecule with make role_molecule. Once it's working switch to your branch for this change so you can reproduce the problem and fix it.

https://github.com/openstack-k8s-operators/ci-framework/blob/main/docs/source/development/02_molecule.md


create a new role

https://ci-framework.readthedocs.io/en/latest/development/01_contributing.html



https://openstack-k8s-operators.github.io/edpm-ansible/testing_roles.html

        
        

