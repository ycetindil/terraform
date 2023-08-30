module "mssql_database_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/mssql_database"

  name                        = var.mssql_database_xxx.name
  server_id                   = module.mssql_server_xxx.id
  collation                   = var.mssql_database_xxx.collation
  sku_name                    = var.mssql_database_xxx.sku_name
  zone_redundant              = var.mssql_database_xxx.zone_redundant
  storage_account_type        = var.mssql_database_xxx.storage_account_type
  short_term_retention_policy = var.mssql_database_xxx.short_term_retention_policy
}