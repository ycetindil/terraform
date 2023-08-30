module "storage_container_xxx" {
  source = "./modules/storage_container"

  name                  = var.storage_container_xxx.name
  storage_account_name  = module.storage_account_xxx.name
  container_access_type = var.storage_container_xxx.container_access_type
}