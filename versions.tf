# Define required providers
terraform {
  required_version = ">= 1.12.12"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "3.4.0"
    }
  }
}
