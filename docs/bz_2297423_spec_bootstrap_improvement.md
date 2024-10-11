
see 2261935 for all the history related to spec bootstrap module


It is confirmed that they are not generating metal file in right way, see my comment in bz.


in a call with yonatan, i see that a role x is mising in metal file (may be they altered it manually)

but in get_deployed_roles_to_hosts method, in the loop for that role x, it is not matching so it skipped the iteration
but assigned the previous matching_hosts to the role x, so patch suggested 


without patch, when i ran the ut using  baremetal mock file which doesn't have hostnameformat for compute role.


#tox -epy36 tests.modules.test_ceph_spec_bootstrap

we actually got this
{'CephStorage': ['oc0-ceph-0', 'oc0-ceph-1', 'oc0-ceph-2'],
 'Compute': ['oc0-controller-0', 'oc0-controller-1', 'oc0-controller-2'],
 'Controller': ['oc0-controller-0', 'oc0-controller-1', 'oc0-controller-2']}



assert expected this
 {'CephStorage': ['oc0-ceph-0', 'oc0-ceph-1', 'oc0-ceph-2'],
 'Compute': ['oc0-compute-0'],
 'Controller': ['oc0-controller-0', 'oc0-controller-1', 'oc0-controller-2']}


ut:
[mkatari@fedora tripleo_ansible]$ tox -epy36 tests.modules.test_ceph_spec_bootstrap



{3} tripleo_ansible.tests.modules.test_ceph_spec_bootstrap.TestCephSpecBootstrap.test_standalone_spec [0.010680s] ... ok
{5} tripleo_ansible.tests.modules.test_ceph_spec_bootstrap.TestCephSpecBootstrap.test_inventory_based_spec [0.006502s] ... ok
{0} tripleo_ansible.tests.modules.test_ceph_spec_bootstrap.TestCephSpecBootstrap.test_metal_roles_based_spec [0.018979s] ... ok
{2} tripleo_ansible.tests.modules.test_ceph_spec_bootstrap.TestCephSpecBootstrap.test_metal_roles_based_spec_edge_site [0.026290s] ... ok
{1} tripleo_ansible.tests.modules.test_ceph_spec_bootstrap.TestCephSpecBootstrap.test_metal_roles_based_spec_with_tld [0.026387s] ... ok
{4} tripleo_ansible.tests.modules.test_ceph_spec_bootstrap.TestCephSpecBootstrap.test_inventory_based_spec_with_tld [0.009811s] ... ok

