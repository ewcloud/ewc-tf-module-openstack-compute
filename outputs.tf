output "instance-data" {
  value = {
    "name" = openstack_compute_instance_v2.instance.name
    "id" = openstack_compute_instance_v2.instance.id
    "ip"   = openstack_compute_instance_v2.instance.access_ip_v4
    "floatingip" = try(openstack_networking_floatingip_v2.fip[0].address, null) != null ? openstack_networking_floatingip_v2.fip[0].address : null
  }
  description = "Relevant details about the Instance"
}
