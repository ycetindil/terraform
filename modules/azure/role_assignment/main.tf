resource "azurerm_role_assignment" "role_assignment" {
  scope = try(
    data.azurerm_management_group.management_group[0].id,
    data.azurerm_subscription.subscription[0].id,
    data.azurerm_client_config.client_config[0].id,
    data.azurerm_resource_group.resource_group[0].id,
    data.azurerm_resources.scope[0].resources[0].id,
    "'Try' could not find any valid scope id."
  )
  principal_id = try(
    data.azuread_user.user[0].object_id,
    data.azuread_service_principal.service_principal[0].object_id,
    data.azuread_group.group[0].object_id,
    data.azurerm_user_assigned_identity.user_assigned_identity[0].principal_id,
    data.azurerm_linux_web_app.linux_web_app[0].identity[0].principal_id,
    data.azurerm_windows_web_app.windows_web_app[0].identity[0].principal_id,
    data.azurerm_virtual_machine.linux_virtual_machine[0].identity[0].principal_id,
    data.azurerm_virtual_machine.windows_virtual_machine[0].identity[0].principal_id,
    "'Try' could not find any valid principal id."
  )
  role_definition_name = try(
    var.role_definition.built_in.name,
    data.azurerm_role_definition.role_definition[0].name,
    // TODO: New role definitioni en altta ayarladiktan sonra buraya ekle,
    "'Try' could not find any valid role definition name."
  )

  lifecycle {
    ignore_changes = [principal_id, scope]
  }
}

# Scope possibilities
data "azurerm_management_group" "management_group" {
  count = var.scope.type == "management_group" ? 1 : 0

  name = var.scope.name
}

data "azurerm_subscription" "subscription" {
  count = var.scope.type == "subscription" ? 1 : 0
}

data "azurerm_client_config" "client_config" {
  count = var.scope.type == "client_config" ? 1 : 0
}

data "azurerm_resource_group" "resource_group" {
  count = var.scope.type == "resource_group" ? 1 : 0

  name = var.scope.name
}

# This block is going to give us an object.
# We need to access its attribute 'resources's first element when calling.
data "azurerm_resources" "scope" {
  count = var.scope.type == "resource" ? 1 : 0

  name                = try(var.scope.resource.name, null)
  type                = try(var.scope.resource.type, null)
  resource_group_name = try(var.scope.resource.resource_group_name, null)
  required_tags       = try(var.scope.resource.required_tags, null)
}

# Principal possibilities
data "azuread_user" "user" {
  count = var.principal.type == "user" ? 1 : 0

  user_principal_name = var.principal.name
}

data "azuread_service_principal" "service_principal" {
  count = var.principal.type == "service_principal" ? 1 : 0

  display_name = var.principal.name
}

data "azuread_group" "group" {
  count = var.principal.type == "group" ? 1 : 0

  display_name     = var.principal.name
  security_enabled = true
}

data "azurerm_user_assigned_identity" "user_assigned_identity" {
  count = var.principal.type == "user_assigned_identity" ? 1 : 0

  name                = var.principal.user_assigned_identity.name
  resource_group_name = var.principal.user_assigned_identity.resource_group_name
}

data "azurerm_linux_web_app" "linux_web_app" {
  count = (
    lower(var.principal.system_assigned_identity_resource.type) == "microsoft.web/sites" &&
    lower(var.principal.system_assigned_identity_resource.os_type) == "linux"
  ) ? 1 : 0

  name                = var.principal.system_assigned_identity_resource.name
  resource_group_name = var.principal.system_assigned_identity_resource.resource_group_name
}

data "azurerm_windows_web_app" "windows_web_app" {
  count = (
    lower(var.principal.system_assigned_identity_resource.type) == "microsoft.web/sites" &&
    lower(var.principal.system_assigned_identity_resource.os_type) == "windows"
  ) ? 1 : 0

  name                = var.principal.system_assigned_identity_resource.name
  resource_group_name = var.principal.system_assigned_identity_resource.resource_group_name
}

data "azurerm_virtual_machine" "linux_virtual_machine" {
  count = (
    lower(var.principal.system_assigned_identity_resource.type) == "microsoft.compute/virtualmachines" &&
    lower(var.principal.system_assigned_identity_resource.os_type) == "linux"
  ) ? 1 : 0

  name                = var.principal.system_assigned_identity_resource.name
  resource_group_name = var.principal.system_assigned_identity_resource.resource_group_name
}

data "azurerm_virtual_machine" "windows_virtual_machine" {
  count = (
    lower(var.principal.system_assigned_identity_resource.type) == "microsoft.compute/virtualmachines" &&
    lower(var.principal.system_assigned_identity_resource.os_type) == "windows"
  ) ? 1 : 0

  name                = var.principal.system_assigned_identity_resource.name
  resource_group_name = var.principal.system_assigned_identity_resource.resource_group_name
}

# Role definition possibilities
data "azurerm_role_definition" "role_definition" {
  count = try(var.role_definition.custom.existing, null) != null ? 1 : 0

  name = var.role_definition.custom.existing.name
}

// TODO: Role definition modulunu create edip buradan cagir