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
resource "azurerm_key_vault" "key_vault" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  tenant_id           = var.tenant_id
  tags                = var.tags
}

# Below module is to give Terraform access to the key_vault.
module "key_vault_access_policy_terraform" {
  source = "../key_vault_access_policy"

  key_vault_id            = azurerm_key_vault.key_vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azurerm_client_config.current.object_id
  certificate_permissions = ["Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"]
  key_permissions         = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
  secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  storage_permissions     = ["Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"]
}