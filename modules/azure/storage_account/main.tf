resource "azurerm_storage_account" "storage_account" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = var.tags
}

resource "azurerm_storage_container" "storage_containers" {
  for_each = var.containers

  name                  = var.name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = var.container_access_type
}