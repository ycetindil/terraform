variable "storage_account_xxx" {
  name                     = "saproject101prodeastus001"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # resource_group_name is provided by the root main.
  public_network_access_enabled = true
  blob_properties = {
    delete_retention_policy = {
      days = 3
    }
    restore_policy = {
      days = 2
    }
    versioning_enabled            = true
    change_feed_enabled           = true
    change_feed_retention_in_days = 3
    container_delete_retention_policy = {
      days = 3
    }
  }
}