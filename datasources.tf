data "openstack_networking_network_v2" "external" {
  name = var.external_network_name
}

data "openstack_images_image_v2" "image" {
  name        = var.image_name
  most_recent = true
}

data "openstack_networking_port_v2" "fip_port" {
  count      = var.instance_has_fip ? 1 : 0
  device_id  = openstack_compute_instance_v2.instance.id
  network_id = openstack_compute_instance_v2.instance.network[0].uuid
  fixed_ip   = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
}
