module "key_vault_access_policy_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/key_vault_access_policy"

  key_vault_id            = data.azurerm_key_vault.key_vault_xxx.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azuread_service_principal.MicrosoftWebApp.object_id
  certificate_permissions = var.key_vault_access_policy_xxx.certificate_permissions
  secret_permissions      = var.key_vault_access_policy_xxx.secret_permissions
}