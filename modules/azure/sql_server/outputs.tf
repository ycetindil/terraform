output "host" {
  value = azurerm_mssql_server.mssql_server.fully_qualified_domain_name
}

output "database_username" {
  value = azurerm_mssql_server.mssql_server.administrator_login
}

output "server_id" {
  value = azurerm_mssql_server.mssql_server.id
}