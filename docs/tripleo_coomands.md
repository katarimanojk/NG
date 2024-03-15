
# prepare the images mentione in the yml file
openstack tripleo container image prepare -e  containers-prepare-parameter.yaml

# check the generated/downloaded images on undercloud
openstack tripleo container image list -f value | awk -F '//' '/prometheus/ {print $2}'
(undercloud) [stack@undercloud-0 ~]$ openstack tripleo container image list -f value
