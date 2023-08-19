data "azurerm_key_vault" "key_vault_xxx" {
  name                = "xxx"
  resource_group_name = "xxx"
}
data "azurerm_key_vault_certificate" "key_vault_certificate_xxx_com" {
  name         = "xxx-com"
  key_vault_id = data.azurerm_key_vault.key_vault_xxx.id
}