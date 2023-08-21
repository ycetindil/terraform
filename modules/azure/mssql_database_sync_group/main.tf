# Creates a Microsoft.Sql/servers/databases/syncGroups resource
# https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/databases/syncgroups?pivots=deployment-language-terraform
resource "azapi_resource" "mssql_database_sync_group" {
  type      = var.type
  name      = var.name
  parent_id = var.parent_id
  body      = jsonencode(var.body)
}