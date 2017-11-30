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
-e /usr/share/openstack-tripleo-heat-templates/environments/neutron-opendaylight-dpdk.yaml \
-e /home/stack/odl_registry.yaml \
-e $PWD/network-environment.yaml \
--ntp-server clock.redhat.com

[ $? -eq 0 ] || exit 1
echo "build nodes inventory file"
echo "[computes]" > nodes
nova list | sed -n -r 's/.*compute.*ctlplane=([.0-9]+).*/\1/ p' >> nodes
echo "[controllers]" >> nodes
nova list | sed -n -r 's/.*control.*ctlplane=([.0-9]+).*/\1/ p' >> nodes

