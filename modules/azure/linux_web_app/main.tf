# Manages a Linux Web App.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app
resource "azurerm_linux_web_app" "linux_web_app" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name
  service_plan_id     = data.azurerm_service_plan.service_plan.id

  site_config {
    always_on = var.site_config.always_on

    dynamic "application_stack" {
      for_each = var.site_config.application_stack != null ? [1] : []

      content {
        docker_image_name        = var.site_config.application_stack.docker_image_name
        docker_registry_url      = var.site_config.application_stack.docker_registry_url
        docker_registry_username = var.site_config.application_stack.docker_registry_username
        docker_registry_password = var.site_config.application_stack.docker_registry_password
        dotnet_version           = var.site_config.application_stack.dotnet_version
        go_version               = var.site_config.application_stack.go_version
        java_server              = var.site_config.application_stack.java_server
        java_server_version      = var.site_config.application_stack.java_server_version
        java_version             = var.site_config.application_stack.java_version
        node_version             = var.site_config.application_stack.node_version
        php_version              = var.site_config.application_stack.php_version
        python_version           = var.site_config.application_stack.python_version
        ruby_version             = var.site_config.application_stack.ruby_version
      }
    }

    container_registry_use_managed_identity = var.site_config.container_registry_use_managed_identity
    vnet_route_all_enabled                  = var.site_config.vnet_route_all_enabled
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
      dynamic "application_logs" {
        for_each = var.logs.application_logs != null ? [1] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = var.logs.application_logs.azure_blob_storage != null ? [1] : []

            content {
              level             = var.logs.application_logs.azure_blob_storage.level
              retention_in_days = var.logs.application_logs.azure_blob_storage.retention_in_days
              sas_url           = var.logs.application_logs.azure_blob_storage.sas_url
            }
          }

          file_system_level = var.logs.application_logs.file_system_level
        }
      }

      detailed_error_messages = var.logs.detailed_error_messages
      failed_request_tracing  = var.logs.failed_request_tracing

      dynamic "http_logs" {
        for_each = var.logs.http_logs != null ? [1] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = var.logs.http_logs.azure_blob_storage != null ? [1] : []

            content {
              retention_in_days = var.logs.http_logs.azure_blob_storage.retention_in_days
              sas_url           = var.logs.http_logs.azure_blob_storage.sas_url
            }
          }

          dynamic "file_system" {
            for_each = var.logs.http_logs.file_system != null ? [1] : []

            content {
              retention_in_days = var.logs.http_logs.file_system.retention_in_days
              retention_in_mb   = var.logs.http_logs.file_system.retention_in_mb
            }
          }
        }
      }
    }
  }

  virtual_network_subnet_id = var.virtual_network_subnet_id
  tags                      = var.tags
}