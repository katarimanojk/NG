simillar to previous release we have upstream CI being replicated in downstream

for e.g: periodic-internal-adoption-multinode-to-crc-ceph is run upstream


# upstream 
  - github



# downstream
  - gitlab.cee.redhat.com
  - https://gitlab.cee.redhat.com/openstack-midstream/
    - you can see all repos here: https://gitlab.cee.redhat.com/openstack-midstream/podified/config 
  - https://gitlab.cee.redhat.com/ci-framework 
  - downstream repos are not mirror copies of upstream, they are kind of distgit repos 
    - https://gitlab.cee.redhat.com/openstack-midstream/podified/config/cinder-operator
    - source folder is having the code: https://gitlab.cee.redhat.com/openstack-midstream/podified/source/cinder-operator


## backport to downstream
  - cherry-pick to branch 18.0-fr1  (before FR1, cherry-picks were done to 18.0.0-proposed)
     - it will be maintnenace brnach until FR2
  -  rhoso-podified-1.0-trunk-patches get synced when we pull content in from upstream
  -  rhoso-podified-1.0-patches is synced later by delivery team with trunk branch
