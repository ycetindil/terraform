output "id" {
  description = "the Server ID."
  value       = azurerm_mssql_server.mssql_server.id
}

output "fqdn" {
  description = "The fully qualified domain name of the Server (e.g. myServerName.database.windows.net)"
  value       = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
}

output "administrator_login" {
  description = "The administrator login name for the Server."
  value       = azurerm_mssql_server.mssql_server.administrator_login
}