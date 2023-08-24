# Manages the association between a Network Interface and a Network Security Group.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association
resource "azurerm_network_interface_security_group_association" "network_interface_security_group_association" {
  network_interface_id      = var.network_interface_id
  network_security_group_id = var.network_security_group_id
}