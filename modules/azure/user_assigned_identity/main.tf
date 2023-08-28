# Manages a User Assigned Identity.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity
resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
	tags = var.tags
}