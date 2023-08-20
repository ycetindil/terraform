# Manages a Key Vault Secret.
# Note: All arguments including the secret value will be stored in the raw state as plain-text. Read more about sensitive data in state at https://www.terraform.io/docs/state/sensitive-data.html.
# Note: The Azure Provider includes a Feature Toggle which will purge a Key Vault Secret resource on destroy, rather than the default soft-delete. See purge_soft_deleted_secrets_on_destroy for more information at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block#purge_soft_deleted_secrets_on_destroy.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret
resource "azurerm_key_vault_secret" "key_vault_secret" {
  name = var.name
  value = var.value
  key_vault_id = var.key_vault_id
}