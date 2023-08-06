data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id            = azurerm_key_vault.key_vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  key_permissions         = ["Get", "List", "Delete", "Create", "Purge"]
  secret_permissions      = ["Get", "List", "Delete", "Set", "Purge"]
  certificate_permissions = ["Get", "List", "Delete", "Create", "Purge"]
}

module "random_secrets" {
  for_each = {
    for key, secret in var.secrets : key => secret.value.random
    if try(secret.value.random, null) != null
  }
  source = "../random_password"

  length           = each.value.length
  lower            = try(each.value.lower, null)
  min_lower        = try(each.value.min_lower, null)
  upper            = try(each.value.upper, null)
  min_upper        = try(each.value.min_upper, null)
  numeric          = try(each.value.numeric, null)
  min_numeric      = try(each.value.min_numeric, null)
  special          = try(each.value.special, null)
  min_special      = try(each.value.min_special, null)
  override_special = try(each.value.override_special, null)
  keepers          = try(each.value.keepers, null)
}
resource "azurerm_key_vault_secret" "key_vault_secret" {
  for_each = var.secrets

  name = each.value.name
  value = coalesce(
    try(module.random_secrets[each.key].result, ""),
    try(each.value.value.literal, ""),
    "Coalesce could not find any values"
  )
  key_vault_id = azurerm_key_vault.key_vault.id

  depends_on = [azurerm_key_vault_access_policy.key_vault_access_policy]
}