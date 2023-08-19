# Manages an App Service certificate.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_certificate
resource "azurerm_app_service_certificate" "app_service_certificate" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  app_service_plan_id = var.app_service_plan_id
  key_vault_secret_id = var.key_vault_secret_id
}