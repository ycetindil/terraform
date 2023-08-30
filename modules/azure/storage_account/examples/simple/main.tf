module "storage_account_xxx" {
  source = "github.com/ycetindil/terraform/tree/main/modules/azure/storage_account"

  name                          = var.storage_account_xxx.name
  resource_group_name           = module.resource_group_xxx.name
  location                      = var.storage_account_xxx.location
  account_tier                  = var.storage_account_xxx.account_tier
  account_replication_type      = var.storage_account_xxx.account_replication_type
  public_network_access_enabled = var.storage_account_xxx.public_network_access_enabled
  blob_properties               = var.storage_account_xxx.blob_properties
}