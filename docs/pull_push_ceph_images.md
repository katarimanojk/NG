
reef: downstream

cifmw_cephadm_container_ns: "registry-proxy.engineering.redhat.com/rh-osbs"
cifmw_cephadm_container_image: "rhceph"
cifmw_cephadm_container_tag: "7"

reef: upstream

cifmw_cephadm_container_ns: "quay.io/ceph"
cifmw_cephadm_container_image: "ceph"
cifmw_cephadm_container_tag: "v18"  # this tag always points to latest-reef



podman pull registry-proxy.engineering.redhat.com/rh-osbs/rhceph:7

[manoj@shark13 ~]$ podman images
REPOSITORY                                            TAG         IMAGE ID      CREATED      SIZE
registry-proxy.engineering.redhat.com/rh-osbs/rhceph  7           accc76067d7a  5 hours ago  1.07 GB
[manoj@shark13 ~]$ 



[manoj@shark13 ~]$ podman login quay.io/mkatari
Username: ^C[manoj@shark13 ~]$ podman login quay.io
Username: mkatari
Password: 
Login Succeeded!
[manoj@shark13 ~]$ podman push accc76067d7a docker://quay.io/mkatari/ceph:v091123
Getting image source signatures
Copying blob c9ac8ed59ad9 done  
Copying blob ccb0b01fe466 done  
Copying config accc76067d done  
Writing manifest to image destination
Storing signatures
[manoj@shark13 ~]$ 


[manoj@shark13 ~]$ podman pull quay.io/mkatari/ceph:v091123
Trying to pull quay.io/mkatari/ceph:v091123...
Getting image source signatures
Copying blob 9f8f349f5f1e skipped: already exists  
Copying blob 54ef87710521 skipped: already exists  
Copying config accc76067d done  
Writing manifest to image destination
Storing signatures
accc76067d7a9e6163049df9c9bb7d0865e07acaf58aa2ac347f764f3ffc9c80
[manoj@shark13 ~]$ podman images
REPOSITORY                                            TAG         IMAGE ID      CREATED      SIZE
quay.io/mkatari/ceph                                  v091123     accc76067d7a  5 hours ago  1.07 GB
registry-proxy.engineering.redhat.com/rh-osbs/rhceph  7           accc76067d7a  5 hours ago  1.07 GB
[manoj@shark13 ~]$ 


