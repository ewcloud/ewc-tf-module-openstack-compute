output "instance-data" {
  value = {
    "name"        = openstack_compute_instance_v2.instance.name
    "id"          = openstack_compute_instance_v2.instance.id
    "ip"          = openstack_compute_instance_v2.instance.access_ip_v4
    "floatingip"  = var.instance_has_fip ? openstack_networking_floatingip_v2.fip[0].address : null

    # Additional new values
    internal_ip    = openstack_compute_instance_v2.instance.access_ip_v4
    floating_ip    = var.instance_has_fip ? openstack_networking_floatingip_v2.fip[0].address : null
    networks       = openstack_compute_instance_v2.instance.network
    flavor_id      = openstack_compute_instance_v2.instance.flavor_id
    volumes = concat(
      var.extra_volume ? [openstack_blockstorage_volume_v3.instance_volume[0].id] : [],
      var.extra_volume2 ? [openstack_blockstorage_volume_v3.instance_volume2[0].id] : []
    )
    access_address = var.instance_has_fip ? openstack_networking_floatingip_v2.fip[0].address : openstack_compute_instance_v2.instance.access_ip_v4
  }
  description = "Relevant details about the Instance"
}

output "instance" {
  value = {
    name           = openstack_compute_instance_v2.instance.name
    id             = openstack_compute_instance_v2.instance.id
    internal_ip    = openstack_compute_instance_v2.instance.access_ip_v4
    floating_ip    = var.instance_has_fip ? openstack_networking_floatingip_v2.fip[0].address : null
    networks       = openstack_compute_instance_v2.instance.network
    flavor_id      = openstack_compute_instance_v2.instance.flavor_id
    volumes = concat(
      var.extra_volume ? [openstack_blockstorage_volume_v3.instance_volume[0].id] : [],
      var.extra_volume2 ? [openstack_blockstorage_volume_v3.instance_volume2[0].id] : []
    )
    access_address = var.instance_has_fip ? openstack_networking_floatingip_v2.fip[0].address : openstack_compute_instance_v2.instance.access_ip_v4
  }
  description = "Comprehensive information about the created instance"
}

output "volumes" {
  value = {
    primary = var.os_volume.enable ? openstack_compute_instance_v2.instance.block_device[0].uuid : null
    volume_1 = var.extra_volume ? {
      id   = openstack_blockstorage_volume_v3.instance_volume[0].id
      name = openstack_blockstorage_volume_v3.instance_volume[0].name
      size = openstack_blockstorage_volume_v3.instance_volume[0].size
    } : null
    volume_2 = var.extra_volume2 ? {
      id   = openstack_blockstorage_volume_v3.instance_volume2[0].id
      name = openstack_blockstorage_volume_v3.instance_volume2[0].name
      size = openstack_blockstorage_volume_v3.instance_volume2[0].size
    } : null
  }
  description = "Information about the attached volumes"
}
