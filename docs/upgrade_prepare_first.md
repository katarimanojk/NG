(undercloud) [stack@undercloud-0 ~]$ cat ./overcloud_upgrade_prepare.sh
#!/bin/env bash
#
# Setup HEAT's output
#
set -eu

PREPARE_ANSWER=""
if openstack overcloud upgrade prepare --help | grep -qe "--yes"; then
    PREPARE_ANSWER="--yes"
fi
set -o pipefail

source /home/stack/stackrc

echo "Running major upgrade prepare step"
openstack overcloud upgrade prepare ${PREPARE_ANSWER} \
    --stack qe-Cloud-0 \
    --templates /usr/share/openstack-tripleo-heat-templates \
    -e /usr/share/openstack-tripleo-heat-templates/environments/cinder-backup.yaml \
    -e /home/stack/virt/internal.yaml \
    -e /home/stack/virt/network/network-environment.yaml \
    -e /home/stack/virt/enable-tls.yaml \
    -e /home/stack/virt/inject-trust-anchor.yaml \
    -e /home/stack/virt/public_vip.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/ssl/tls-endpoints-public-ip.yaml \
    -e /home/stack/virt/hostnames.yml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/ceph-ansible/ceph-ansible.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/services/neutron-ovn-dvr-ha.yaml \
    -e /home/stack/virt/debug.yaml \
    -e /home/stack/virt/ntp_pool.yaml \
    -e /home/stack/virt/config_heat.yaml \
    -e /home/stack/virt/nodes_data.yaml \
    -e /home/stack/virt/firstboot.yaml \
    -e ~/containers-prepare-parameter.yaml \
    -e /home/stack/virt/performance.yaml \
    -e /home/stack/virt/l3_fip_qos.yaml \
    -e /home/stack/virt/ovn-extras.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/ssl/tls-everywhere-endpoints-dns.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/ssl/enable-internal-tls.yaml \
    -e /home/stack/virt/cloud-names.yaml \
    -e /usr/share/openstack-tripleo-heat-templates/environments/services/haproxy-public-tls-certmonger.yaml \
    -e /home/stack/cli_opts_params.yaml \
    -e /home/stack/overcloud-params.yaml -e /home/stack/overcloud-deploy/qe-Cloud-0/qe-Cloud-0-network-environment.yaml -e /home/stack/tmp/qe-Cloud-0-baremetal_deployment.yaml -e /home/stack/tmp/qe-Cloud-0-generated-networks-deployed.yaml -e /home/stack/tmp/qe-Cloud-0-generated-vip-deployed.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/nova-hw-machine-type-upgrade.yaml \
    -e /home/stack/containers-prepare-parameter.yaml \
    --roles-file /home/stack/roles_data.yaml 2>&1
(undercloud) [stack@undercloud-0 ~]$ 
