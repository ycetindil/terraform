output "id" {
  description = "The ID of the MS SQL Database."
  value       = azurerm_mssql_database.mssql_database.id
}

output "name" {
  description = "The Name of the MS SQL Database."
  value       = azurerm_mssql_database.mssql_database.name
}