
# greenfield:

 eg command:  ansible-playbook reproducer.yml     -i custom/inventory.yml     -e cifmw_target_host=hypervisor-2     -e @scenarios/reproducers/va-hci.yml     -e @scenarios/reproducers/networking-definition.yml     -e @custom/secrets.yml   -e @custom/hci.yml   -e@custom/default-vars.yml  -e cifmw_deploy_architecture=true

reproducer.yaml (https://github.com/openstack-k8s-operators/ci-framework/blob/main/reproducer.yml) playbook  is does RHOSO, i,e  ocp + architecutre (openstack)
 ocp: - https://github.com/openstack-k8s-operators/ci-framework/blob/main/roles/reproducer/tasks/main.yml#L205 mainly does the complete ocp part 
          - ocp_layout +libvirt_layout tasks in reproducer role
  
 openstack on ocp (rhoso) : - https://github.com/openstack-k8s-operators/ci-framework/blob/main/reproducer.yml#L105
   which runs deploy-edpm.yml (https://github.com/openstack-k8s-operators/ci-framework/blob/main/deploy-edpm.yml)
   here via deploy_architecture script:  https://github.com/openstack-k8s-operators/ci-framework/blob/main/roles/reproducer/tasks/configure_architecture.yml

  deploy-edpm.yml calls all the sequencial playbooks : 
   01
   02
   03
   04
   06-deploy-edpm.yaml (does hci stuff => runs the ceph playbook) 
    or 
    06-deploy architecture (which capturers the automation vars from architecture repo based on the dt) 
     
## 06-deploy-edpm.yml vs cifmw_architecture_scenario ( 06-deploy_architecture)



from what i figured out, looks like unidelta greenfield job runs a command like this
   #ansible-playbook playbooks/06-deploy-architecture.yml -e cifmw_architecture_repo=$HOME/architecture \
                  -e cifmw_architecture_scenario=uni04delta-ipv6

may be not architecutre as i saw this log below
./playbooks/06-deploy-edpm.yml:15:    - name: Early end if architecture deploy

and major stuff is happening here: https://github.com/openstack-k8s-operators/architecture/blob/main/automation/vars/uni04delta-ipv6.yaml
which is captured and executed in cifmw here: https://github.com/openstack-k8s-operators/ci-framework/blob/main/playbooks/06-deploy-architecture.yml#L259



## how reproducer is run in uni04 delta greenfield job

ci-framework-jobs configs using in ci-framework reproducer command 
https://sf.apps.int.gpc.ocp-hub.prod.psi.redhat.com/logs/8cb/components-integration/8cbd2436ee294997817fee9313993b0c/logs/controller/configs/


2025-06-08 17:30:28.875117 | 
2025-06-08 17:30:28.875234 | LOOP [Ensure custom vars files exist in configs directory.]
2025-06-08 17:30:29.476617 | controller | changed:
2025-06-08 17:30:29.476836 | controller | {
2025-06-08 17:30:29.476889 | controller |   "key": "/home/zuul/src/gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/scenarios/uni/uni04delta/01-net-def.yaml",
2025-06-08 17:30:29.476947 | controller |   "value": "/home/zuul/configs/01-net-def.yaml"
2025-06-08 17:30:29.476967 | controller | }
2025-06-08 17:30:29.477010 | controller | ok: All items complete
2025-06-08 17:30:29.477035 | 
2025-06-08 17:30:30.055263 | controller | changed:
2025-06-08 17:30:30.055393 | controller | {
2025-06-08 17:30:30.055424 | controller |   "key": "/home/zuul/src/gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/scenarios/uni/uni04delta/02-host-config.yaml",
2025-06-08 17:30:30.055449 | controller |   "value": "/home/zuul/configs/02-host-config.yaml"
2025-06-08 17:30:30.055473 | controller | }
2025-06-08 17:30:30.642383 | controller | changed:
2025-06-08 17:30:30.642466 | controller | {
2025-06-08 17:30:30.642491 | controller |   "key": "/home/zuul/src/gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/scenarios/uni/uni04delta/03-ocp-config.yaml",
2025-06-08 17:30:30.642510 | controller |   "value": "/home/zuul/configs/03-ocp-config.yaml"
2025-06-08 17:30:30.642549 | controller | }
2025-06-08 17:30:31.199776 | controller | changed:
2025-06-08 17:30:31.199867 | controller | {
2025-06-08 17:30:31.199893 | controller |   "key": "/home/zuul/src/gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/scenarios/uni/uni04delta/04-scenario-vars.yaml",
2025-06-08 17:30:31.199932 | controller |   "value": "/home/zuul/configs/04-scenario-vars.yaml"
2025-06-08 17:30:31.199951 | controller | }
2025-06-08 17:30:31.757942 | controller | changed:
2025-06-08 17:30:31.758061 | controller | {
2025-06-08 17:30:31.758092 | controller |   "key": "/home/zuul/src/gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/scenarios/uni/uni04delta/05-hooks.yaml",
2025-06-08 17:30:31.758116 | controller |   "value": "/home/zuul/configs/05-hooks.yaml"
2025-06-08 17:30:31.758134 | controller | }
2025-06-08 17:30:32.360710 | controller | changed:
2025-06-08 17:30:32.360840 | controller | {
2025-06-08 17:30:32.360876 | controller |   "key": "/home/zuul/src/gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/scenarios/uni/uni04delta/05-tests.yaml",
2025-06-08 17:30:32.360905 | controller |   "value": "/home/zuul/configs/05-tests.yaml"
2025-06-08 17:30:32.360960 | controller | }
2025-06-08 17:30:32.375665 | 
2025-06-08 17:30:32.375779 | TASK [Prepare the command arguments.]
2025-06-08 17:30:32.509026 | controller | ok
2025-06-08 17:30:32.513119 | 
2025-06-08 17:30:32.513217 | TASK [Print final _cmd_args]
2025-06-08 17:30:32.542252 | controller | ok: _cmd_args: -e @/home/zuul/configs/default-vars.yaml -e @/home/zuul/src/gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/scenarios/test/test-tool-versions.yaml -e @/home/zuul/configs/01-net-def.yaml -e @/home/zuul/configs/02-host-config.yaml -e @/home/zuul/configs/03-ocp-config.yaml -e @/home/zuul/configs/04-scenario-vars.yaml -e @/home/zuul/configs/05-hooks.yaml -e @/home/zuul/configs/05-tests.yaml -e @/home/zuul/src/gitlab.cee.redhat.com/ci-framework/ci-framework-jobs/config/releases/uni/rhel9-rhoso18-trunk-uni.yaml -e @/home/zuul/configs/zuul_vars.yaml  -e cifmw_update_containers_tag=2b959d1259c8a2a4379b855b3dd33812
2025-06-08 17:30:32.547153 | 





# brownfield (adoption):

  createinfra:
   - when create_infra cifmw playbook is executed it exepects the net-def, host-def and others 
   - we use ci-fmw-jobs uni scenarios  
     - only for hci we directly use the va-hci and networkdefinition scenarios in cifmw itself.

  17.1 
   - we rely on dataplane adoption scenarios while running deploy-osp-adotion.yml playbook in cifmw


  ocp: deploy-ocp.yaml https://github.com/openstack-k8s-operators/ci-framework/blob/main/deploy-ocp.yml#L60 which calls reproducer role
     ocp+
    
   
     






