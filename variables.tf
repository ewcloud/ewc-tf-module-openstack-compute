variable instance_name {}
variable app_name {}
variable instance_index {}
variable image_id {}
variable flavor_id {}
variable keypair_name {}
variable cloudinit_userdata {
  type = string
  default = null
}
variable networks {
  type	= list(string)
  nullable = false
}
variable add_sfs_network {
  type = string
  default = null
}

variable instance_has_fip { 
  type = bool
  default = false
}
variable security_groups {
  type     = list(string)
  default  = ["default"]
  nullable = false
}
variable os_volume {
  type = object({enable = bool, size = number})
  default = {
    enable = false
    size = 50
  }
}
variable extra_volume {
  type = bool
  default = false
}
variable extra_volume_size {
  type = number
  default = 1
}
variable extra_volume2 {
  type = bool
  default = false
}
variable extra_volume2_size {
  type = number
  default = 1
}
variable instance_metadata {
  type = map
  default = null
}
