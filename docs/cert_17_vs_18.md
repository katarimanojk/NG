# Major steps of deployment guide

compare
https://netapp-openstack-dev.github.io/openstack-docs/draft/cinder/configuration/cinder_config_files/section_rhosp17_director_ontap_configuration.html
vs
https://netapp-openstack-dev.github.io/openstack-docs/antelope/cinder/configuration/cinder_config_files/section_rhoso18_configuration.html#overview

17.1 : tripleO
----

## 1. prepare env file

### controllerExtraconfig  
eg: ibm svf: https://www.ibm.com/docs/en/sanvolumecontroller/8.6.0?topic=cocdrhop1i-deploying-storage-driver-svcstorwize-family-backend-configuration-rhosp


### direct env file (if supported)

eg: 
dell powerstore: https://github.com/dell/osp-integration/blob/master/RHOSP-17.1/cinder/README.md
netapp: https://netapp-openstack-dev.github.io/openstack-docs/draft/cinder/configuration/cinder_config_files/section_rhosp17_director_ontap_configuration.html

create a new env file based on /usr/share/openstack-tripleo-heat-templates/environments/cinder-dellemc-powerstore-config.yaml



## 2. deploy overcloud using the env file

opentstack overcloud deploy
.
.
-e /home/stack/templates/cinder_SVC_config.yaml


### deploy with custom container cinder-volume image

https://docs.redhat.com/en/documentation/red_hat_openstack_platform/16.2/html-single/advanced_overcloud_customization/index#deploying-a-vendor-plugin

eg: https://github.com/Infinidat/tripleo-deployment-configs/blob/master/README.md

### multibackend template env file  example


## 3. verify the cinder-vol service with 

cinder volume service list 

or 

/var/lib/containers/cinder/etc/cinder/cinder.conf 

## 4. test the backend

create a volume



18 : RHOSO
---

## 1. prepare the controlplane CR


### use custom container cinder-volume image

oc apply -f openstackverison.yaml 

eg: pure : https://pure-storage-openstack-docs.readthedocs.io/en/latest/cinder/configuration/cinder_config_files/section_rhoso180_flasharray_configuration.html
doc: https://docs.redhat.com/en/documentation/red_hat_openstack_services_on_openshift/18.0/html-single/integrating_partner_content/index#maintaining-partner-container-images-and-image-tags_integrating-rhoso-storage-services

### secrets file creation


### update the controlplane
 edit the CR and configure your cinder backend

## 2. apply the CR to the controlplane

oc apply -f openstack_control_plane.yaml

## 3 verify and test the backend

service list
create a volume

