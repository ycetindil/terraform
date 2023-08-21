# Creates a Microsoft.Sql/servers/databases/syncGroups/syncMembers resource
# https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/databases/syncgroups/syncmembers?pivots=deployment-language-terraform
resource "azapi_resource" "mssql_database_sync_group_sync_member" {
  for_each = local.sync_group_memberships_memberships

  type      = var.type
  name      = var.name
  parent_id = var.parent_id
  body      = jsonencode(var.body)
}