module "windows_web_app_xxx" {
  source = "./modules/windows_web_app"

  name                          = var.windows_web_app_xxx.name
  location                      = var.windows_web_app_xxx.location
  resource_group_name           = module.resource_group_xxx.name
  service_plan_id               = module.service_plan_xxx.id
  virtual_network_subnet_id     = module.subnet_xxx.id
  https_only                    = var.windows_web_app_xxx.https_only
  public_network_access_enabled = var.windows_web_app_xxx.public_network_access_enabled
  logs                          = var.windows_web_app_xxx.logs
  site_config                   = var.windows_web_app_xxx.site_config
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = module.application_insights_xxx.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = module.application_insights_xxx.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "STORAGEACCOUNTAZURE_ContainerName"          = module.storage_container_xxx.name
  }
  connection_strings = {
    connection_string_sql = merge(
      var.windows_web_app_xxx.connection_strings.connection_string_sql,
      { value = "Server=tcp:${module.mssql_server_xxx.host},1433;Initial Catalog=${module.mssql_database_xxx.name};Persist Security Info=False;User ID=${module.mssql_server_xxx.database_username};Password=${module.random_password_xxx.result};MultipleActiveResultSets=True;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;" }
    )
    connection_string_sa = merge(
      var.windows_web_app_xxx.connection_strings.connection_string_sa,
      { value = module.storage_account_xxx.connection_string }
    )
  }
}