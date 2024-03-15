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
variable extra_volume {
  type = object({enable = bool, size = number}) 
  default = {
    enable = false
    size = 1
  }
}
variable instance_metadata {
  type = map
  default = null
}
