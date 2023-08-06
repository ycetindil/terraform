###################################################################################################
# CAUTION: 'key_vault_access_policy' module cannot be put inside this 'key_vault' module.         #
# Because, for example, we want to use this 'key_vault' to keep the password of the 'sql_server'. #
# The 'sql_server' will need access to the 'key_vault' to retrieve its password.                  #
# Hence 'sql_server' will depend on this 'key_vault'.                                             #
# At the same time 'key_vault_access_policy' will depend on the 'sql_server' to give access.      #
# This will cause a cycle.                                                                        #
###################################################################################################

# Manages a Key Vault.
# Note: It's possible to define Key Vault Access Policies both within the azurerm_key_vault resource via the access_policy block and by using the azurerm_key_vault_access_policy resource. However it's not possible to use both methods to manage Access Policies within a KeyVault, since there'll be conflicts.
# Note: It's possible to define Key Vault Certificate Contacts both within the azurerm_key_vault resource via the contact block and by using the azurerm_key_vault_certificate_contacts resource. However it's not possible to use both methods to manage Certificate Contacts within a KeyVault, since there'll be conflicts.
# Note: Terraform will automatically recover a soft-deleted Key Vault during Creation if one is found - you can opt out of this using the features block within the Provider block.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault
resource "azurerm_key_vault" "kv" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_name
  tags                = var.tags
}

# Below resource is created to give Terraform access to the key_vault.
# Manages a Key Vault Access Policy.
# NOTE: It's possible to define Key Vault Access Policies both within the azurerm_key_vault resource via the access_policy block and by using the azurerm_key_vault_access_policy resource. However it's not possible to use both methods to manage Access Policies within a KeyVault, since there'll be conflicts.
# NOTE: Azure permits a maximum of 1024 Access Policies per Key Vault - more information can be found at https://docs.microsoft.com/azure/key-vault/key-vault-secure-your-key-vault#data-plane-access-control.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy
resource "azurerm_key_vault_access_policy" "tf_kvap" {
  key_vault_id            = azurerm_key_vault.kv.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
  key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]

  depends_on = [
    azurerm_key_vault.kv,
    data.azurerm_client_config.current
  ]
}

# Generate the 'random_secret' if the user entered the value 'random' for the variable 'secret.value'
module "random_secrets" {
  source = "../random_password"
  for_each = {
    for key, secret in var.secrets : key => secret.value.random
    if secret.value.random != null
  }

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

# Manages a Key Vault Secret.
# Note: All arguments including the secret value will be stored in the raw state as plain-text. Read more about sensitive data in state at https://www.terraform.io/docs/state/sensitive-data.html.
# Note: The Azure Provider includes a Feature Toggle which will purge a Key Vault Secret resource on destroy, rather than the default soft-delete. See purge_soft_deleted_secrets_on_destroy for more information at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block#purge_soft_deleted_secrets_on_destroy.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret
resource "azurerm_key_vault_secret" "kvsS" {
  for_each = var.key_vault_secrets

  name = each.value.name
  value = try(
    module.random_secrets[each.key].result,
    each.value.value.literal,
    "'try' function could not find a valid 'value' for the 'key_vault_secret': ${each.value.name} of the 'key_vault': ${var.name}!"
  )
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_key_vault_access_policy.tf_kvap]
}