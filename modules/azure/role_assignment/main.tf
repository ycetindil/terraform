# Assigns a given Principal (User or Group) to a given Role.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment
resource "azurerm_role_assignment" "role_assignment" {
  name                 = var.name
  scope                = var.scope
  role_definition_id   = var.role_definition_id
  role_definition_name = var.role_definition_name
  principal_id         = var.principal_id
}