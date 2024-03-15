resource "openstack_compute_instance_v2" "instance" {
  name            = "${var.app_name}-${var.instance_name}-${var.instance_index}"
  image_id        = var.image_id 
  flavor_id       = var.flavor_id
  key_pair        = var.keypair_name
  security_groups = var.security_groups
  user_data       = var.cloudinit_userdata

  dynamic "block_device" {
    for_each = var.os_volume.enable ? [1] : []
    content {
      uuid                  = var.image_id
      source_type           = "image"
      volume_size           = var.os_volume.size
      boot_index            = 0
      destination_type      = "volume"
      delete_on_termination = true
    }
  }

  dynamic "network" {
    for_each = [for n in var.networks: {
      name   = n
    }]
    content {
      name           = network.value.name
    }
  }



  metadata = var.instance_metadata

  dynamic "network" {
    for_each = [for n in var.networks: {
      name   = n
    }]
    content {
      name           = network.value.name
    }
  }

}

resource "openstack_networking_floatingip_v2" "fip" {
  count = var.instance_has_fip ? 1 : 0
  pool = data.openstack_networking_network_v2.external.name
}
resource "openstack_compute_floatingip_associate_v2" "fip" {
  count = var.instance_has_fip ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.fip[0].address
  instance_id = openstack_compute_instance_v2.instance.id
  fixed_ip    = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
}

resource "openstack_compute_volume_attach_v2" "volume_attachment" {
  count = var.extra_volume["enable"] ? 1 : 0
  instance_id = openstack_compute_instance_v2.instance.id
  volume_id   = openstack_blockstorage_volume_v3.instance_volume[0].id
}
resource "openstack_blockstorage_volume_v3" "instance_volume" {
  count = var.extra_volume["enable"] ? 1 : 0
  name        = "${var.app_name}_${var.instance_name}_${var.instance_index}_volume"
  description = "Volume for ${var.app_name}_${var.instance_name}_${var.instance_index}"
  size        = var.extra_volume["size"]
}
