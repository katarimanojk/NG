#!/bin/env bash
set -euo pipefail

if [[ -e /home/stack/l3_agent_start_ping.sh ]]; then
    source /home/stack/qe-Cloud-0rc
    bash /home/stack/l3_agent_start_ping.sh
fi



source /home/stack/stackrc

set +o pipefail
EXTERNAL_ANSWER=""
if openstack overcloud external-upgrade run --help | grep -qe "--yes"; then
    EXTERNAL_ANSWER="--yes"
fi
set -o pipefail

echo "[$(date)] Major upgrade - Ceph upgrade step"

openstack overcloud external-upgrade run ${EXTERNAL_ANSWER} \
    --stack qe-Cloud-0 \
    --skip-tags "ceph_health,opendev-validation,ceph_ansible_remote_tmp" \
    --tags ceph,facts 2>&1

echo "[$(date)] Major upgrade - finished Ceph upgrade step"

## Install cephadm on the servers

echo "[$(date)] Major upgrade - cephadm-admin user and distribute keyrings step"

ANSIBLE_LOG_PATH=/home/stack/cephadm_enable_user_key.log \
ANSIBLE_HOST_KEY_CHECKING=false \
ansible-playbook -i /home/stack/overcloud-deploy/qe-Cloud-0/config-download/qe-Cloud-0/tripleo-ansible-inventory.yaml \
  -b -e ansible_python_interpreter=/usr/libexec/platform-python /usr/share/ansible/tripleo-playbooks/ceph-admin-user-playbook.yml \
  -e tripleo_admin_user=ceph-admin \
  -e distribute_private_key=true \
  --limit @/home/stack/ceph_host_limit.txt

echo "[$(date)] Major upgrade - finished cephadm-admin user and distribute keyrings step"

echo "[$(date)] Major upgrade - upgrade run setup_packages"

openstack overcloud upgrade run ${EXTERNAL_ANSWER} \
    --stack qe-Cloud-0 \
    --tags setup_packages --limit @/home/stack/ceph_host_limit.txt --playbook /home/stack/overcloud-deploy/qe-Cloud-0/config-download/qe-Cloud-0/upgrade_steps_playbook.yaml 2>&1

echo "[$(date)] Major upgrade - upgrade run setup_packages"

echo "[$(date)] Major upgrade - Cephadm adoption"

openstack overcloud external-upgrade run ${EXTERNAL_ANSWER} \
    --stack qe-Cloud-0 \
    --skip-tags "ceph_health,opendev-validation,ceph_ansible_remote_tmp" \
    --tags cephadm_adopt  2>&1

echo "[$(date)] Major upgrade - finished Cephadm adoption step"


if [[ -e /home/stack/l3_agent_stop_ping.sh ]]; then
    source /home/stack/qe-Cloud-0rc
    bash /home/stack/l3_agent_stop_ping.sh
fi


