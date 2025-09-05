resource "openstack_compute_instance_v2" "instance" {
  name            = "${var.app_name}-${var.instance_name}-${var.instance_index}"
  image_id        = var.os_volume.enable ? null : var.image_id
  flavor_id       = var.flavor_id
  image_name      = var.image_id != null ? null : var.image_name
  flavor_name     = var.flavor_name
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

  metadata = merge(
    var.instance_metadata != null ? var.instance_metadata : {},
    var.tags,
    { "app_name" = var.app_name }
  )

  dynamic "network" {
    for_each = [for n in var.networks : {
      name = n
    }]
    content {
      name = network.value.name
    }
  }

  lifecycle {
    ignore_changes = [
      block_device["uuid"],
    ]

    # Input validation to ensure image_id (e.g. the image UUID) is availble when configuring block_device
    precondition {
      condition     = !(var.os_volume.enable && var.image_id == null)
      error_message = "When configuring an OS volume, image id must be set"
    }

    # Input validation to ensure either flavor_id or flavor_name is available
    precondition {
      condition     = (var.flavor_id == null && var.flavor_name != null) || (var.flavor_id != null && var.flavor_name == null)
      error_message = "Either the flavor id or the flavor name must be set"
    }

    # Input validation to ensure either image_id or image_name is available, constrained by os_volume being available as well
    precondition {
      condition     = var.os_volume.enable || (!var.os_volume.enable && (var.image_id == null && var.image_name != null) || (var.image_id != null && var.image_name == null))
      error_message = "Either the image id or the image name must be set if no OS volume is configured"
    }
  }
}

# Floating IP resources
resource "openstack_networking_floatingip_v2" "fip" {
  count = var.instance_has_fip ? 1 : 0
  pool  = data.openstack_networking_network_v2.external.name
  tags  = concat(keys(var.tags), [var.app_name])
}

resource "openstack_compute_floatingip_associate_v2" "fip" {
  count       = var.instance_has_fip ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.fip[0].address
  instance_id = openstack_compute_instance_v2.instance.id
  fixed_ip    = openstack_compute_instance_v2.instance.network[0].fixed_ip_v4
}

# First additional volume resources
resource "openstack_blockstorage_volume_v3" "instance_volume" {
  count                = var.extra_volume ? 1 : 0
  name                 = "${var.app_name}_${var.instance_name}_${var.instance_index}_volume"
  description          = "Volume for ${var.app_name}_${var.instance_name}_${var.instance_index}"
  size                 = var.extra_volume_size
  enable_online_resize = true
  # Modified tags implementation to use the correct format
  metadata = merge(
    var.instance_metadata != null ? var.instance_metadata : {},
    var.tags,
    { "app_name" = var.app_name }
  )
}

resource "openstack_compute_volume_attach_v2" "volume_attachment" {
  count       = var.extra_volume ? 1 : 0
  instance_id = openstack_compute_instance_v2.instance.id
  volume_id   = openstack_blockstorage_volume_v3.instance_volume[0].id
}

# Second additional volume resources
resource "openstack_blockstorage_volume_v3" "instance_volume2" {
  count                = var.extra_volume2 ? 1 : 0
  name                 = "${var.app_name}_${var.instance_name}_${var.instance_index}_volume2"
  description          = "Volume for ${var.app_name}_${var.instance_name}_${var.instance_index}"
  size                 = var.extra_volume2_size
  enable_online_resize = true
  # Modified tags implementation to use the correct format
  metadata = merge(
    var.instance_metadata != null ? var.instance_metadata : {},
    var.tags,
    { "app_name" = var.app_name }
  )
}

resource "openstack_compute_volume_attach_v2" "volume_attachment2" {
  count       = var.extra_volume2 ? 1 : 0
  instance_id = openstack_compute_instance_v2.instance.id
  volume_id   = openstack_blockstorage_volume_v3.instance_volume2[0].id
}
