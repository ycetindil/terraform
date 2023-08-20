mssql_database_xxx = {
  name = "test"
  # server_id is provided by the root main.
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  sku_name             = "Basic"
  zone_redundant       = false
  storage_account_type = "Local"
  short_term_retention_policy = {
    backup_interval_in_hours = 12
    retention_days           = 35
  }
}