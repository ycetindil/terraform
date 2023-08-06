# Use this data source to access information about an existing Key Vault.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault
data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault.name
  resource_group_name = var.key_vault.resource_group_name
}

# Use this data source to access the configuration of the AzureRM provider.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
data "azurerm_client_config" "current" {}

# Gets information about an Azure Active Directory user.
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user
data "azuread_user" "user" {
  count = var.object.type == "user" ? 1 : 0

  user_principal_name = var.object.user.name
}

# Gets information about an Azure Active Directory group.
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group
data "azuread_group" "group" {
  count = var.object.type == "group" ? 1 : 0

  display_name     = var.object.group.name
  security_enabled = true
}

# Gets information about an existing service principal associated with an application within Azure Active Directory.
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal
data "azuread_service_principal" "service_principal" {
  count = var.object.type == "service_principal" ? 1 : 0

  display_name = var.object.service_principal.name
}

# Use this data source to access information about an existing User Assigned Identity.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity
data "azurerm_user_assigned_identity" "user_assigned_identity" {
  count = var.object.type == "user_assigned_identity" ? 1 : 0

  name                = var.object.user_assigned_identity.name
  resource_group_name = var.object.user_assigned_identity.resource_group_name
}

# Use this data source to access information about an existing Linux Web App.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/linux_web_app
data "azurerm_linux_web_app" "linux_web_app" {
  count = (
    lower(try(var.object.system_assigned_identity.object_type, "")) == "microsoft.web/sites" &&
    lower(try(var.object.system_assigned_identity.object_os_type, "")) == "linux"
  ) ? 1 : 0

  name                = var.object.system_assigned_identity.object_name
  resource_group_name = var.object.system_assigned_identity.object_resource_group_name
}

# Use this data source to access information about an existing Windows Web App.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/windows_web_app
data "azurerm_windows_web_app" "windows_web_app" {
  count = (
    lower(try(var.object.system_assigned_identity.object_type, "")) == "microsoft.web/sites" &&
    lower(try(var.object.system_assigned_identity.object_os_type, "")) == "windows"
  ) ? 1 : 0

  name                = var.object.system_assigned_identity.object_name
  resource_group_name = var.object.system_assigned_identity.object_resource_group_name
}