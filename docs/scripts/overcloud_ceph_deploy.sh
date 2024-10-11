(undercloud) [stack@undercloud-0 ~]$ cat overcloud_ceph_deploy.sh
#!/bin/bash

set -x

# Refer RHOSINFRA-5121, workaround for supporting
# NTP server option  by checking the version string of
# tripleclient package.
# Fixme: Switch to install.version in the future.
ntp_args_requires="20230505010953"
tld_args_requires="20230416001030"

# determine tripleo_client RPM version; the below needs to support multiple variation of the NVR of this RPM, e.g.:
# python3-tripleoclient-16.5.1-17.1.20230927000827.f3599d0.el9ost.noarch
# python3-tripleoclient-16.5.1-17.1.20230927000828.el9ost.noarch
# python3-tripleoclient-16.5.1-1.20230505010955...

IFS='.' read -r -a tripleo_client_array <<< "$(rpm -qa python3-tripleoclient)"
tripleo_client_str=$(for f in ${tripleo_client_array[@]}; do if [[ "$f" =~ [0-9]{14} ]] ; then echo "$f"; fi ; done)


NTP_ARGS=""
TLD_ARGS=""

ARGS="-o /home/stack/templates/overcloud-ceph-deployed.yaml"
ARGS="${ARGS} --container-image-prepare /home/stack/containers-prepare-parameter.yaml"
ARGS="${ARGS} --stack overcloud"
ARGS="${ARGS} --network-data /home/stack/composable_roles/network/network_data_v2.yaml"





ARGS="${ARGS} --cluster ceph"

ARGS="${ARGS} --roles-data /home/stack/composable_roles/roles/roles_data.yaml"


NTP_ARGS="--ntp-server clock.corp.redhat.com"


if [ $tripleo_client_str -ge $ntp_args_requires ] ; then
    ARGS="${ARGS} ${NTP_ARGS}"
fi

if [ $tripleo_client_str -ge $tld_args_requires ] ; then
    ARGS="${ARGS} ${TLD_ARGS}"
fi

openstack overcloud ceph deploy ${ARGS} /home/stack/templates/overcloud-baremetal-deployed.yaml
(undercloud) [stack@undercloud-0 ~]$ 

