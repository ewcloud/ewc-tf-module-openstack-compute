variable "instance_name" {
  description = "Name of the instance, used in the full instance name"
  type        = string
  
  validation {
    condition     = length(var.instance_name) > 0
    error_message = "Instance name cannot be empty."
  }
}

variable "app_name" {
  description = "Application name, used as prefix in the full instance name"
  type        = string
  
  validation {
    condition     = length(var.app_name) > 0
    error_message = "Application name cannot be empty."
  }
}

variable "instance_index" {
  description = "Index or identifier for the instance, used as suffix in the full instance name"
  type        = number
  
  validation {
    condition     = var.instance_index >= 0
    error_message = "Instance index must be a non-negative number."
  }
}

variable "image_id" {
  description = "ID of the image to use for the instance"
  type        = string
  
  validation {
    condition     = length(var.image_id) > 0
    error_message = "Image ID cannot be empty."
  }
}

variable "flavor_id" {
  description = "ID of the flavor to use for the instance"
  type        = string
  
  validation {
    condition     = length(var.flavor_id) > 0
    error_message = "Flavor ID cannot be empty."
  }
}

variable "keypair_name" {
  description = "Name of the keypair to use for SSH access to the instance"
  type        = string
}

variable "cloudinit_userdata" {
  description = "User data for cloud-init to be passed to the instance"
  type        = string
  default     = null
}

variable "networks" {
  description = "List of network names to attach the instance to"
  type        = list(string)
  nullable    = false
}

variable "add_sfs_network" {
  description = "Shared File System network to add (if needed)"
  type        = string
  default     = null
}

variable "instance_has_fip" { 
  description = "Whether to assign a floating IP to the instance"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "List of security group names to apply to the instance"
  type        = list(string)
  default     = ["default"]
  nullable    = false
}

variable "os_volume" {
  description = "Configuration for the primary OS volume"
  type        = object({enable = bool, size = number})
  default     = {
    enable = false
    size   = 50
  }
}

variable "extra_volume" {
  description = "Whether to attach an additional volume to the instance"
  type        = bool
  default     = false
}

variable "extra_volume_size" {
  description = "Size in GB of the additional volume"
  type        = number
  default     = 1
  
  validation {
    condition     = var.extra_volume_size > 0
    error_message = "Volume size must be greater than 0."
  }
}

variable "extra_volume2" {
  description = "Whether to attach a second additional volume to the instance"
  type        = bool
  default     = false
}

variable "extra_volume2_size" {
  description = "Size in GB of the second additional volume"
  type        = number
  default     = 1
  
  validation {
    condition     = var.extra_volume2_size > 0
    error_message = "Volume size must be greater than 0."
  }
}

variable "instance_metadata" {
  description = "Metadata to associate with the instance (key-value pairs)"
  type        = map(string)
  default     = null
}

variable "external_network_name" {
  description = "Name of the external network for floating IPs"
  type        = string
  default     = "external"
}

variable "tags" {
  description = "A map of tags to assign to all resources that support it"
  type        = map(string)
  default     = {}
}
