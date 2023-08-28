# Manages a virtual network including any configured subnets. Each subnet can optionally be configured with a security group to be associated with the subnet.
# NOTE on Virtual Networks and Subnets: Terraform currently provides both a standalone Subnet resource, and allows for Subnets to be defined in-line within the Virtual Network resource. At this time you cannot use a Virtual Network with in-line Subnets in conjunction with any Subnet resources. Doing so will cause a conflict of Subnet configurations and will overwrite subnets.
# NOTE on Virtual Networks and DNS Servers: Terraform currently provides both a standalone virtual network DNS Servers resource, and allows for DNS servers to be defined in-line within the Virtual Network resource. At this time you cannot use a Virtual Network with in-line DNS servers in conjunction with any Virtual Network DNS Servers resources. Doing so will cause a conflict of Virtual Network DNS Servers configurations and will overwrite virtual networks DNS servers.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.name
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  location            = var.location
}