# Manages an Azure Storage Account.
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "storage_account" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_kind                  = var.account_kind
  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "blob_properties" {
    for_each = var.blob_properties != null ? [1] : []

    content {
      dynamic "cors_rule" {
        for_each = var.blob_properties.cors_rule != null ? [1] : []

        content {
          allowed_headers    = var.blob_properties.cors_rule.allowed_headers
          allowed_methods    = var.blob_properties.cors_rule.allowed_methods
          allowed_origins    = var.blob_properties.cors_rule.allowed_origins
          exposed_headers    = var.blob_properties.cors_rule.exposed_headers
          max_age_in_seconds = var.blob_properties.cors_rule.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = var.blob_properties.delete_retention_policy != null ? [1] : []

        content {
          days = var.blob_properties.delete_retention_policy.days
        }
      }

      dynamic "restore_policy" {
        for_each = var.blob_properties.restore_policy != null ? [1] : []

        content {
          days = var.blob_properties.restore_policy.days
        }
      }

      versioning_enabled            = var.blob_properties.versioning_enabled
      change_feed_enabled           = var.blob_properties.change_feed_enabled
      change_feed_retention_in_days = var.blob_properties.change_feed_retention_in_days
      default_service_version       = var.blob_properties.default_service_version
      last_access_time_enabled      = var.blob_properties.last_access_time_enabled

      dynamic "container_delete_retention_policy" {
        for_each = var.blob_properties.container_delete_retention_policy != null ? [1] : []

        content {
          days = var.blob_properties.container_delete_retention_policy.days
        }
      }
    }
  }

  tags = var.tags
}