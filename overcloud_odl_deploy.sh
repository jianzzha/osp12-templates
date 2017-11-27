#!/bin/bash

error ()
{
  echo $* 1>&2
  exit 1
}

source /home/stack/stackrc || error "can't load stackrc"
if openstack stack list | grep overcloud; then
  openstack stack delete overcloud --wait --y
fi

openstack overcloud deploy \
--templates \
-r $PWD/roles_data.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/network-isolation.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/host-config-and-reboot.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/neutron-ovs-dpdk.yaml \
-e /usr/share/openstack-tripleo-heat-templates/environments/services-docker/neutron-opendaylight.yaml \
-e /home/stack/odl_registry.yaml \
-e $PWD/network-environment.yaml \
--ntp-server clock.redhat.com

