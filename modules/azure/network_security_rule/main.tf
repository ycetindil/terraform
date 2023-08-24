# Manages a Network Security Rule.
# NOTE on Network Security Groups and Network Security Rules: Terraform currently provides both a standalone Network Security Rule resource, and allows for Network Security Rules to be defined in-line within the Network Security Group resource. At this time you cannot use a Network Security Group with in-line Network Security Rules in conjunction with any Network Security Rule resources. Doing so will cause a conflict of rule settings and will overwrite rules.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule
resource "azurerm_network_security_rule" "network_security_rule" {
  name                                       = var.name
  description                                = var.description
  protocol                                   = var.protocol
  source_port_range                          = var.source_port_range
  source_port_ranges                         = var.source_port_ranges
  destination_port_range                     = var.destination_port_range
  destination_port_ranges                    = var.destination_port_ranges
  source_address_prefix                      = var.source_address_prefix
  source_address_prefixes                    = var.source_address_prefixes
  source_application_security_group_ids      = var.source_application_security_group_ids
  destination_address_prefix                 = var.destination_address_prefix
  destination_address_prefixes               = var.destination_address_prefixes
  destination_application_security_group_ids = var.destination_application_security_group_ids
  access                                     = var.access
  priority                                   = var.priority
  direction                                  = var.direction
}