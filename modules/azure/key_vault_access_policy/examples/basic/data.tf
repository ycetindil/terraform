# Use this data source to access information about an existing Key Vault.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault
data "azurerm_key_vault" "key_vault_xxx" {
  name                = "xxx"
  resource_group_name = "xxx"
}

# Use this data source to access the configuration of the AzureRM provider.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
data "azurerm_client_config" "current" {}

# Gets information about an existing service principal associated with an application within Azure Active Directory.
# https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal.html
data "azuread_service_principal" "MicrosoftWebApp" {
  application_id = "abfa0a7c-a6b6-4736-8310-5855508787cd"
}