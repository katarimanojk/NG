https://docs.redhat.com/en/documentation/red_hat_openstack_platform/17.0/html/director_installation_and_usage/assembly_configuring-the-overcloud-with-ansible#assembly_configuring-the-overcloud-with-ansible


# config-download

16.1. Ansible-based overcloud configuration (config-download)
The config-download feature is the method that director uses to configure the overcloud. Director uses config-download in conjunction with OpenStack Orchestration (heat) to generate the software configuration and apply the configuration to each overcloud node. Although heat creates all deployment data from SoftwareDeployment resources to perform the overcloud installation and configuration, heat does not apply any of the configuration. Heat only provides the configuration data through the heat API.

As a result, when you run the openstack overcloud deploy command, the following process occurs:

Director creates a new deployment plan based on openstack-tripleo-heat-templates and includes any environment files and parameters to customize the plan.
Director uses heat to interpret the deployment plan and create the overcloud stack and all descendant resources. This includes provisioning nodes with the OpenStack Bare Metal service (ironic).
Heat also creates the software configuration from the deployment plan. Director compiles the Ansible playbooks from this software configuration.
Director generates a temporary user (tripleo-admin) on the overcloud nodes specifically for Ansible SSH access.
Director downloads the heat software configuration and generates a set of Ansible playbooks using heat outputs.
Director applies the Ansible playbooks to the overcloud nodes using ansible-playboo
