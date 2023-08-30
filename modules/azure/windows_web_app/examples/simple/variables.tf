variable "windows_web_app_xxx" {
  name                          = "app-project101-prod-eastus-001"
  location                      = "eastus"
  https_only                    = true
  public_network_access_enabled = false
  connection_strings = {
    connection_string_sql = {
      name = "ConnStrSql"
      type = "SQLAzure"
    }
    connection_string_sa = {
      name = "ConnStrSa"
      type = "Custom"
    }
  }
  logs = {
    detailed_error_messages = true
    failed_request_tracing  = true
    application_logs = {
      file_system_level = "Verbose"
    }
  }
  site_config = {
    vnet_route_all_enabled = true
    application_stack = {
      current_stack  = "dotnet"
      dotnet_version = "v7.0"
    }
  }
}