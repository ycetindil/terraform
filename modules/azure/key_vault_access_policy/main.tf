resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id = try(
    data.azuread_service_principal.service_principal[0].object_id,
    data.azuread_group.group[0].object_id,
    data.azuread_user.user[0].object_id,
    data.azurerm_linux_web_app.linux_web_app[0].identity[0].principal_id,
    data.azurerm_windows_web_app.windows_web_app[0].identity[0].principal_id,
    "'Try' could not find any valid object_id"
  )
  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions
  certificate_permissions = var.certificate_permissions

  lifecycle {
    ignore_changes = [
      key_vault_id,
      object_id,
      tenant_id
    ]
  }
}

data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault.name
  resource_group_name = var.key_vault.resource_group_name
}

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