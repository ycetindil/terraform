output "id" {
  value = azurerm_windows_web_app.windows_web_app.id
}

output "fqdn" {
  value = azurerm_windows_web_app.windows_web_app.default_hostname
}

output "custom_domain_verification_id" {
  value = azurerm_windows_web_app.windows_web_app.custom_domain_verification_id
}

output "name" {
  value = azurerm_windows_web_app.windows_web_app.name
}