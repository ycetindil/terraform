# Manages a Windows Web App.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app
resource "azurerm_windows_web_app" "windows_web_app" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id

  site_config {
    application_stack {
      current_stack  = var.site_config.application_stack.current_stack
      dotnet_version = var.site_config.application_stack.dotnet_version
    }
  }

  app_settings = var.app_settings

  dynamic "connection_string" {
    for_each = var.connection_strings

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []

    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  dynamic "logs" {
    for_each = var.logs != null ? [1] : []

    content {
      detailed_error_messages = var.logs.detailed_error_messages
      failed_request_tracing  = var.logs.failed_request_tracing

      dynamic "application_logs" {
        for_each = var.logs.application_logs != null ? [1] : []

        content {
          file_system_level = var.logs.application_logs.file_system_level

          dynamic "azure_blob_storage" {
            for_each = var.logs.application_logs.azure_blob_storage != null ? [1] : []

            content {
              level             = var.logs.application_logs.azure_blob_storage.level
              retention_in_days = var.logs.application_logs.azure_blob_storage.retention_in_days
              sas_url           = var.logs.application_logs.azure_blob_storage.sas_url
            }
          }
        }
      }
    }
  }

  tags                      = var.tags
  virtual_network_subnet_id = var.virtual_network_subnet_id
}