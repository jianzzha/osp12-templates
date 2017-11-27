# osp12-templates

sudo sed -r -i "/^INSECURE_REGISTRY=.*/d" /etc/sysconfig/docker
sudo echo INSECURE_REGISTRY="--insecure-registry 192.168.24.1:8787 --insecure-registry 192.168.24.3:8787 --insecure-registry docker-registry.engineering.redhat.com" >> /etc/sysconfig/docker
sudo systemctl restart docker

openstack overcloud container image prepare --pull-source docker-registry.engineering.redhat.com --push-destination 192.168.24.1:8787 --namespace rhosp12 --prefix openstack --suffix docker --tag 2017-11-14.4 --images-file /home/stack/odl_containers.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/services-docker/neutron-opendaylight.yaml                                       
openstack overcloud container image upload --config-file /home/stack/odl_containers.yaml

openstack overcloud container image prepare --tag 2017-11-14.4 --namespace 192.168.24.1:8787/rhosp12 --prefix openstack --suffix docker --env-file ~/odl_registry.yaml -e /usr/share/openstack-tripleo-heat-templates/environments/services-docker/neutron-opendaylight.yaml -r ~/templates/roles_data.yaml          

echo "  DockerInsecureRegistryAddress: 192.168.24.1:8787" >>   odl_registry.yaml

./overcloud_odl_deploy.sh

