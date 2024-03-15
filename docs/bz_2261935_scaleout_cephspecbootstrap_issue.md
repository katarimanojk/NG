
## KCS: https://access.redhat.com/solutions/6965325

other bzs handling ceph_spec_bootstrap: 

- 2257414 and 2226963(where regex in is updated get_deployed_roles_to_hosts method)

       https://review.opendev.org/c/openstack/tripleo-ansible/+/889845/3/tripleo_ansible/ansible_plugins/modules/ceph_spec_bootstrap.py

- for tld feature, printed all data structures and added code to update hostname with tld in get_deployed_roles_to_hosts method



observation:

issue1: module dies as it can't match the <role>+HostnameFormat.
- this can only happen if metal file is not generated correctly as per the roles
no solution


issue2: some ceph services  are missing for a host in the spec
- this can happen if in the metal file, ControllerHostnameFormat: controller-%index%  doesn't match the host with
   HostnameMap:
     oc1-controller-0: oc1-controller-0

   or metal: ComputeHCIHostnameFormat: %stack%-novacomputehci-%index%
   HostnameMap:
    computehci-0: cbbhnd22fs0116r14hci01
sol: can we improve regex ? how ?


try for nova if it the host is not matching

  if reg.match(host) or  reg.match('nova'+host):  cannot do it.




## how metal file get role+'Hostnameformat' :

1. create our custom role:
openstack overcloud roles generate -o /home/stack/composable_roles/roles/roles_data.yaml \
    ControllerStorageNfs \
    CephStorage \
    Compute \

  -  /home/stack/composable_roles/roles/roles_data.yaml present in the node  has
  # Role: ControllerStorageNfs                                                  #
  ###############################################################################
   - name: ControllerStorageNfs
   
     HostnameFormatDefault: "controller-%index%"

  where as
  [mkatari@fedora tripleo-heat-templates]$ grep -i format roles/ControllerStorageNfs.yaml 
  HostnameFormatDefault: '%stackname%-controller-%index%'

   so %stackname% is removed during role generation ?
  
  when i generate it manually i see this
  HostnameFormatDefault: '%stackname%-controller-%index%'


2. create baremetalenv from roles
  openstack overcloud node extract provisioned --stack overcloud --roles-file composable_roles/roles/roles_data.yaml -o my_baremetal_deployment.yaml
 openstack overcloud node extract provisioned --stack overcloud --roles-file /home/stack/templates/roles_data.yaml --output /home/stack/templates/baremetal_deployment.yaml   #didn't work for me, endpoint regionone error

 baremetalenv file has
 - name: ControllerStorageNfs
  count: 3
  hostname_format: controller-%index%



3. create metal file from baremetalenv file
openstack overcloud node provision -o my_metalfile.yaml ./composable_roles/network/baremetal_deployment.yaml

rendedered in metal file as:

   ControllerStorageNfsHostnameformat: controller-%index% 



# doubt: 
 - few roles like DistributedComputeHCI, doesn't even have hostname format, we we saw hosts = 'oc0-distributedcomputehci-0' and 'oc0-distributedcomputehciscaleout-0'
       probably customer generted roles_data from his custom role file with 
       HostnameFormatDefault: '%stackname%-distributedcomputehci-%index%' 


# THT changes as to modify the hostname to update hostnamformat based on role name is wrong, from sealusa we saw


ControllerStorageNfsHostnameformat: controller-%index% 
    controller-0: controller-0
    controller-1: controller-1
    controller-2: controller-2

if i modify hostnamefomat like '%stackname%-controller-%index%'

what can be done ?




i also tried running testcases:

tox -epy36 -- tripleo_ansible.tests.modules.test_ceph_spec_bootstrap
