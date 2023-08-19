# Manages an App Service Certificate Binding.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_certificate_binding
resource "azurerm_app_service_certificate_binding" "app_service_certificate_binding" {
  certificate_id      = var.certificate_id
  hostname_binding_id = var.hostname_binding_id
  ssl_state           = var.ssl_state
}