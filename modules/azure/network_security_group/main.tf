# Manages a network security group that contains a list of network security rules.
# Network security groups enable inbound or outbound traffic to be enabled or denied.
# NOTE on Network Security Groups and Network Security Rules: Terraform currently provides both a standalone Network Security Rule resource, and allows for Network Security Rules to be defined in-line within the Network Security Group resource. At this time you cannot use a Network Security Group with in-line Network Security Rules in conjunction with any Network Security Rule resources. Doing so will cause a conflict of rule settings and will overwrite rules.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "nsg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Manages a Network Security Rule.
# NOTE on Network Security Groups and Network Security Rules: Terraform currently provides both a standalone Network Security Rule resource, and allows for Network Security Rules to be defined in-line within the Network Security Group resource. At this time you cannot use a Network Security Group with in-line Network Security Rules in conjunction with any Network Security Rule resources. Doing so will cause a conflict of rule settings and will overwrite rules.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule
resource "azurerm_network_security_rule" "nsgrS" {
  for_each = var.network_security_rules

  name                                       = each.value.name
  description                                = each.value.description
  protocol                                   = each.value.protocol
  source_port_range                          = each.value.source_port_range
  source_port_ranges                         = each.value.source_port_ranges
  destination_port_range                     = each.value.destination_port_range
  destination_port_ranges                    = each.value.destination_port_ranges
  source_address_prefix                      = each.value.source_address_prefix
  source_address_prefixes                    = each.value.source_address_prefixes
  destination_address_prefix                 = each.value.destination_address_prefix
  destination_address_prefixes               = each.value.destination_address_prefixes
  destination_application_security_group_ids = each.value.destination_application_security_group_ids
  access                                     = each.value.access
  priority                                   = each.value.priority
  direction                                  = each.value.direction
}

# Associates a Network Security Group with a Subnet within a Virtual Network.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "snetnsgassS" {
  for_each = var.subnet_network_security_group_association_subnets

  subnet_id                 = data.azurerm_subnet.subnet_network_security_group_association_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Manages the association between a Network Interface and a Network Security Group.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association
resource "azurerm_network_interface_security_group_association" "nicnsgassS" {
  for_each = var.network_interface_security_group_association_network_interfaces

  network_interface_id      = data.azurerm_network_interface.network_interface_security_group_association_network_interfaces[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}