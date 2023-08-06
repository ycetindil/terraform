output "id" {
  description = "The ID of the Application Insights component."
  value       = azurerm_application_insights.appi.id
}

output "instrumentation_key" {
  description = "The Instrumentation Key for this Application Insights component. (Sensitive)"
  value       = azurerm_application_insights.appi.instrumentation_key
}

output "connection_string" {
  description = "The Connection String for this Application Insights component. (Sensitive)"
  value       = azurerm_application_insights.appi.connection_string
}