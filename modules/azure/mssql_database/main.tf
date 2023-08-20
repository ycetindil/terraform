# Manages a MS SQL Database.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database
resource "azurerm_mssql_database" "mssql_database" {
  name               = var.name
  server_id          = var.server_id
  collation          = var.collation
  geo_backup_enabled = var.geo_backup_enabled

  dynamic "long_term_retention_policy" {
    for_each = var.long_term_retention_policy != null ? [1] : []

    content {
      weekly_retention  = var.long_term_retention_policy.weekly_retention
      monthly_retention = var.long_term_retention_policy.monthly_retention
      yearly_retention  = var.long_term_retention_policy.yearly_retention
      week_of_year      = var.long_term_retention_policy.week_of_year
    }
  }

  max_size_gb  = var.max_size_gb
  min_capacity = var.min_capacity
  read_scale   = var.read_scale

  dynamic "short_term_retention_policy" {
    for_each = var.short_term_retention_policy != null ? [1] : []

    content {
      retention_days           = var.short_term_retention_policy.retention_days
      backup_interval_in_hours = var.short_term_retention_policy.backup_interval_in_hours
    }
  }

  sku_name             = var.sku_name
  storage_account_type = var.storage_account_type
  zone_redundant       = var.zone_redundant
  tags                 = var.tags
}