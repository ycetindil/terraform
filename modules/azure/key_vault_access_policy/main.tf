###################################################################################################
# CAUTION: 'key_vault_access_policy' module cannot be put inside this 'key_vault' module.         #
# Because, for example, we want to use this 'key_vault' to keep the password of the 'sql_server'. #
# The 'sql_server' will need access to the 'key_vault' to retrieve its password.                  #
# Hence 'sql_server' will depend on this 'key_vault'.                                             #
# At the same time 'key_vault_access_policy' will depend on the 'sql_server' to give access.      #
# This will cause a cycle.                                                                        #
###################################################################################################

# Manages a Key Vault Access Policy.
# NOTE: It's possible to define Key Vault Access Policies both within the azurerm_key_vault resource via the access_policy block and by using the azurerm_key_vault_access_policy resource. However it's not possible to use both methods to manage Access Policies within a KeyVault, since there'll be conflicts.
# NOTE: Azure permits a maximum of 1024 Access Policies per Key Vault - more information can be found at https://docs.microsoft.com/azure/key-vault/key-vault-secure-your-key-vault#data-plane-access-control.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy
resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id = var.object_id
  certificate_permissions = var.certificate_permissions
  key_permissions         = var.key_permissions
  secret_permissions      = var.secret_permissions
  storage_permissions     = var.storage_permissions
}