# OpenStack Compute Instance Terraform Module

This Terraform module creates and configures OpenStack compute instances with optional attached storage volumes and networking configurations.

## Features

- Create OpenStack compute instances with customizable configurations
- Optionally boot from volume with configurable size
- Support for attaching additional volumes
- Floating IP assignment for public access
- Security group configuration
- Integration with cloud-init for instance initialization
- Flexible networking options
- Resource tagging support with automatic app_name tagging

## Usage

```hcl
module "web_server" {
  source = "path/to/openstack-compute"

  app_name       = "web"
  instance_name  = "server"
  instance_index = 1
  image_id       = "your-image-id"
  flavor_id      = "your-flavor-id"
  keypair_name   = "your-keypair-name"
  
  networks = ["internal"]
  
  instance_has_fip = true
  
  os_volume = {
    enable = true
    size   = 80
  }
  
  extra_volume      = true
  extra_volume_size = 100
  
  security_groups = ["default", "web"]
  
  instance_metadata = {
    environment = "production"
    role        = "web"
  }
  
  tags = {
    environment = "production"
    project     = "website"
    owner       = "team-alpha"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.0 |
| openstack | ~> 1.53.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app_name | Application name, used as prefix in the full instance name | `string` | n/a | yes |
| instance_name | Name of the instance, used in the full instance name | `string` | n/a | yes |
| instance_index | Index or identifier for the instance, used as suffix in the full instance name | `number` | n/a | yes |
| image_id | ID of the image to use for the instance | `string` | n/a | yes |
| flavor_id | ID of the flavor to use for the instance | `string` | n/a | yes |
| keypair_name | Name of the keypair to use for SSH access to the instance | `string` | n/a | yes |
| networks | List of network names to attach the instance to | `list(string)` | n/a | yes |
| security_groups | List of security group names to apply to the instance | `list(string)` | `["default"]` | no |
| instance_has_fip | Whether to assign a floating IP to the instance | `bool` | `false` | no |
| os_volume | Configuration for the primary OS volume | `object({enable = bool, size = number})` | `{enable = false, size = 50}` | no |
| extra_volume | Whether to attach an additional volume to the instance | `bool` | `false` | no |
| extra_volume_size | Size in GB of the additional volume | `number` | `1` | no |
| extra_volume2 | Whether to attach a second additional volume to the instance | `bool` | `false` | no |
| extra_volume2_size | Size in GB of the second additional volume | `number` | `1` | no |
| cloudinit_userdata | User data for cloud-init to be passed to the instance | `string` | `null` | no |
| instance_metadata | Metadata to associate with the instance (key-value pairs) | `map(string)` | `null` | no |
| add_sfs_network | Shared File System network to add (if needed) | `string` | `null` | no |
| external_network_name | Name of the external network for floating IPs | `string` | `"external"` | no |
| tags | A map of tags to assign to all resources that support it | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance-data | Comprehensive information about the created instance |
| volumes | Information about the attached volumes |

## Instance Output Structure

```hcl
{
  name           = "app-name-instance-name-01"
  id             = "instance-id"
  internal_ip    = "192.168.1.10"
  floating_ip    = "203.0.113.10"
  networks       = [/* Network details */]
  flavor_id      = "flavor-id"
  volumes        = ["volume-id-1", "volume-id-2"]
  access_address = "203.0.113.10"  # or internal IP if no floating IP
}
```

## Volumes Output Structure

```hcl
{
  primary  = "volume-id-primary"  # if os_volume.enable = true
  volume_1 = {
    id   = "volume-id-1"
    name = "app_name_instance_name_01_volume"
    size = 100
  }
  volume_2 = {
    id   = "volume-id-2"
    name = "app_name_instance_name_01_volume2"
    size = 50
  }
}
```

## Resource Tagging

This module supports tagging of OpenStack resources using the `tags` variable. Additionally, the module automatically adds the `app_name` as a tag to all resources that support tagging. This provides consistent identification across your OpenStack environment.

### Tag Implementation Details

- **Compute Instance**: Tags are implemented as metadata key-value pairs
- **Volumes**: Tags are implemented as a list of string tags
- **Floating IPs**: Tags are implemented as a list of string tags

Example of how tags are applied:

```hcl
tags = {
  environment = "production"
  project     = "web-app"
}
```

The above will result in:
- Compute instance metadata containing: `app_name`, `environment`, and `project` keys
- Volumes and floating IPs tagged with: `app_name`, `environment`, and `project` tags

This tagging approach makes it easier to filter, identify, and manage resources in your OpenStack environment.

## Best Practices

1. Always specify appropriate security groups for your instances
2. Use unique and descriptive names for instances to aid in identification
3. Consider using OS volumes for production instances for improved performance and resilience
4. Implement proper key management for your keypair_name
5. Use cloud-init userdata for consistent instance initialization

## License

See LICENSE file for details.
